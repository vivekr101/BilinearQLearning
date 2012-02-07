function model = learnQFunction(samples, params)
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

1. a. Pre-compute: T s.t. [s a 1]T = s' is minimized.
   b. Also pre-compute [s a 1]T
   c. Initialize Winv_i, C_i, V_i
2. For each of nSteps steps:
    a. Calculate Q_d = current Q(s_d, a_d) for all samples.
    b. Calculate Q'_d = max_u Q(s_d',u) for all samples.
    c. Calculate e1i_d = dist([s_d a_d 1]T, C_i) for all samples from each center.
    d. Calculate e2i_d = dist(Q(s_d, a_d), V_i) for all samples from each center.
    e. Update (lR being learningRate, dF being discountFactor):
        * V_i <- V_i + lR*( \sum_{d=1}^D( e1i_d*(r_d + dF*Q'_d) - Q_d) )
        * C_i <- C_i + lR*( \sum_{d=1}^D( e2i_d*[s a 1]T - C_i) ) 
        * inv(Winv_i) <- inv(Winv_i) + lR*( \sum_{d=1}^D( e2i_d*([s a 1]T - C_i)'*([s a 1]T - C_i) ) ) 
3. ???
4. Profit!
%}

model = {};
transformedStates = params.getStateTransformations(samples.states);
transformedNextStates = params.getStateTransformations(samples.nextStates);
transformedActions = params.getActionTransformations(samples.actions);

%1a. Get the transfer matrix
model.T = [transformedStates transformedActions ones(samples.nSamples, 1)] \ samples.nextStates;

%1b. Precompute [s a 1]*T
estNextStates = [transformedStates transformedActions ones(samples.nSamples, 1)]*model.T;
diffsFromCenter = {};
diffsFromV = {};
for i = 1:params.M
    diffsFromCenter{i} = estNextStates;
    diffsFromV{i} = zeros(samples.nSamples, 1);
end

%1c. Initialize!
model.M = params.M;
model.stateDim = samples.stateDim;
model.actionDim = samples.actionDim;
learningRate = 1.0;
decayFactor = 10*params.nSteps;
model.Winv = {};
model.V = zeros(params.M, 1);
model.C = zeros(params.M, samples.stateDim);

Var = samples.states' * samples.states;
VarInv = inv(Var)

minVals = min(samples.states);
diffVals = max(samples.states) - min(samples.states);

model.C = repmat(minVals, params.M, 1) + rand(params.M, samples.stateDim) .* repmat(diffVals, params.M, 1);
model.C

for iModel = 1:params.M
    model.Winv{iModel} = VarInv;
end

fprintf(1, 'Starting Q-Learning for %d steps\n', params.nSteps);
fprintf(1, 'Using: \n');
fprintf(1, '\t# of Models: %d\n', params.M);
fprintf(1, '\tDiscount Factor: %f\n', params.discountFactor);

options = optimset('Display','notify','GradObj','Off','LargeScale','Off');

fprintf(1,'Iteration: %6d', 1);
for iStep = 1:params.nSteps
    fprintf(1,'\b\b\b\b\b\b%6d', iStep);
    %iStep
    
    %%2a - Calculate current estimates
    %size of currentEstimates: nSamples x 1
    currentEstimates = world.calculateQValue(model, transformedStates, transformedActions);
    
    %%2b - Find optimal actions for next states
    %size of nextStateValues, newEstimates and errors: nSamples x 1
    [nextStateValues, optimalActions] = params.getOptimalAction(model, transformedNextStates);
    newEstimates = samples.rewards + params.discountFactor*nextStateValues;
    errors = newEstimates - currentEstimates;
    
    %%2c, 2d
    for iModel = 1:params.M
        %%2c - calculate distances of samples from centers
        %size of diffsFromCenter{iModel}: nSamples x stateDim; size of
        diffsFromCenter{iModel} = estNextStates - repmat(model.C(iModel, :),samples.nSamples, 1);
        %%2d size of diffsFromV{iModel}: nSamples x 1
    end
    %size of distancesFromCenter: nSamples x 1
    distancesFromCenter = world.distanceFunction(diffsFromCenter);
    
    for iModel = 1:params.M
        %%2e - Update!
        %First update V
        model.V(iModel) = model.V(iModel) + learningRate*sum(distancesFromCenter(:, iModel) .* errors);

        %Update C
        centerErrors = mean(repmat(distancesFromCenter(:,iModel), 1, samples.stateDim).*estNextStates)...
            - model.C(iModel, :);
        model.C(iModel, :) = model.C(iModel, :) + learningRate*(centerErrors);
        
        %Update Winv
        centerErrors = repmat(distancesFromCenter(:,iModel), 1, samples.stateDim).*diffsFromCenter{i};
        Werr = centerErrors' * centerErrors;
        model.Winv{iModel} = inv( inv(model.Winv{iModel}) + learningRate*Werr);
    end
    %model.C
    learningRate = 1/(1+decayFactor*iStep);
end
fprintf(1,'\n');


