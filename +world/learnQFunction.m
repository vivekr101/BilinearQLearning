function model = learnQFunction(samples, params, currentModel)
%{
Learns a Q-Function for the given data.

General idea:
Divide the state space into M components; each described by a center, size
and value. Each state and transition can be expressed as sum of components,
each component lending weight depending on proximity.

Q(s,a) = \sum_{i=1}^M V_i*exp( -([s a]T - C_i)*W_i*([s a]T - C_i)' )
NOTE: s, a are the *transformed* actions and states when used with T.
Specifically:
    [transformedState transformedAction 1]*T == unTransformedNewState

NOTE(Feb5-2012): Assuming actions don't get transformed. Necessary to find
the optimal action.

Args:
    samples: a struct that contains the following fields:
        - states: state in which the agent was
        - actions: action taken in that state
        - rewards: reward received for that action and state
        - nextStates: state to which the agent transition.
        - nSamples: number of state transitions collected
        - nTrials: number of trials
        - nEpsPerTrial: number of transitions in a trial
        - stateDim: dimension of the state vector
        - actionDim: dimension of the action vector

    params: a struct containing:
        - getStateTransformations: handle to the function that transforms a
        state appropriately.
        - getActionTransformations: handle to the function that transforms
        an action appropriately.
        - getOptimalAction: handle to the function that retrieves the
        optimal action for a given list of states.
        - discountFactor: discount factor for the agent.
        - nSteps: number of steps to be learnt for the Q-Function.
        - M: number of components for the model

Returns:
    model: a struct that contains:
        - M: number of components in the model.
        - V: column vector of M elements, each element is the estimate of the
        value of one component.
        - C: matrix of centers of components. M rows, each row is a center
        of size samples.stateDim
        - T: transfer matrix, s.t. [s a 1]*T is a row-vector of size
        samples.stateDim
        - Winv: array of M matrices, each a square of size
        samples.stateDim. Each Winv is the inverse of the covariance for
        that component.
%}

%{
How to learn:
Q(s,a) = \sum_{i=1}^M V_i*exp( -([s a]T - C_i)*W_i*([s a]T - C_i)' )

%}
createNewModel = 1;
model = {};
if(exist('currentModel','var'))
    createNewModel = 0;
    model = currentModel;
end
transformedStates = params.getStateTransformations(samples.states);
transformedNextStates = params.getStateTransformations(samples.nextStates);
transformedActions = params.getActionTransformations(samples.actions);

%1a. Get the transfer matrix
inputs = [transformedStates transformedActions ones(samples.nSamples, 1)];
if(createNewModel==1)
    model.T = inputs \ samples.nextStates;
end
estNextStates = inputs * model.T;
rmse = utils.rmse(estNextStates, samples.nextStates)
estNextStates(:,1) = cos(estNextStates(:,1));
%Initialize
if(createNewModel==1)
    fprintf(1,'Making new model.\n');
    model.M = params.M;
    
    tdVals = linspace(min(samples.states(:,2)), max(samples.states(:,2)),5);
    tdVals = tdVals(2:end-1)';
    tVals = linspace(-1,1,5)';
    
    %gm1 = gmdistribution.fit(samples.states(:,1), 1);
    %gm2 = gmdistribution.fit(samples.states(:,2), 1);
    %tVals = cos(random(gm1,5));
    %tdVals = random(gm2,3);
    model.C = [repmat(tVals,3,1), repmat(tdVals, 5, 1)];
    
    %{
    minVals = min(samples.states);
    minVals(1,1) = -1;
    diffVals = max(samples.states) - min(samples.states);
    diffVals(1,1) = 2;
    
    model.C = repmat(minVals, model.M, 1)...
        + rand(model.M, samples.stateDim).*repmat(diffVals, model.M, 1);
    model.C(model.M, :) = [1 0];
    model.C
    %}
    
    for iModel = 1:model.M
        model.W(:, :, iModel) = eye(samples.stateDim)*0.01;
    end
    model.V = -2*ones(1, model.M);
    model.stateDim = samples.stateDim;
    model.actionDim = samples.actionDim;
end
contributions = zeros(samples.nSamples, model.M);
currentEstimates = zeros(samples.nSamples, 1);

decayFactor = 100;
diffFromCenter = {};
iStep = 1;
learningRate = 1/(decayFactor + iStep);
oldRMSE = 0;

while(1)
    
    %Calculate future estimates
    [nextStateValues, actions] = params.getOptimalAction(model, transformedNextStates);
    newEstimates = samples.rewards + params.discountFactor*nextStateValues;

    %Calculate current-state gaussian-contributions
    currentEstimates = zeros(samples.nSamples, 1);
    for iModel = 1:model.M
        diffFromCenter{iModel} = estNextStates - repmat(model.C(iModel, :), samples.nSamples, 1);
        exponents = diag(diffFromCenter{iModel} * model.W(:,:,iModel) *diffFromCenter{iModel}');
        contributions(:, iModel) = exp(-exponents);
        currentEstimates = currentEstimates + model.V(iModel) * contributions(:, iModel);
    end
    errors = repmat(newEstimates - currentEstimates, 1, model.M);
    rmse = utils.rmse(newEstimates, currentEstimates);
    contributionError = contributions .* errors;

    vGrad = mean(contributionError);
    model.V = model.V + learningRate * 2 * vGrad;

    for iModel = 1:model.M
        biasedDiffs = model.V(iModel)*repmat(contributionError(:,iModel),1,samples.stateDim) .*...
            (diffFromCenter{iModel}*model.W(:,:,iModel));
        cGrad = mean(biasedDiffs);
        model.C(iModel, :) = model.C(iModel, :) + learningRate * 4 * cGrad;
        
        wGrad = diag(mean(diffFromCenter{iModel}.*biasedDiffs),0);
        model.W(:,:,iModel) = abs(model.W(:,:,iModel) + 2*learningRate * wGrad);
    end
        
    [iStep abs(oldRMSE - rmse) oldRMSE learningRate]
    if(abs(oldRMSE - rmse) < 0.0001)
        break;
    end
    learningRate = 1/(decayFactor + iStep);%
    oldRMSE = rmse;
    iStep = iStep + 1;
    %ezcontourf(@(t,td)CartPole2.getOptimalActionsQF(model,CartPole2.getStateTransformations([t,td])),[0,2*pi,-10,10]);
    %hold on;
    scatter(acos(model.C(:,1)),model.C(:,2),1000*abs(model.V'));
    hold on;
    scatter(2*pi-acos(model.C(:,1)),model.C(:,2),1000*abs(model.V'));
    drawnow;
    hold off;
    fprintf(1,'Plotted.\n');
    %k=waitforbuttonpress;
    
end


%[x,vel,V,A] = CartPole2.plotVCartPole(model);
%surf(vel,x,V);
%k = waitforbuttonpress;
















