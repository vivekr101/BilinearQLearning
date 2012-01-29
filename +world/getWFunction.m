function W = getWFunction(samples, params, ...
    discountFactor, nSteps, learningRate)
%{
Returns a W function that approximates the Q function.

Args:
    samples: a struct containing the following:
        * stateDim : dimension of state vector (row vector)
        * actionDim : dimension of action vector (row vector)
        * nTrials: number of trials to create
        * nEpsPerTrial: number of episodes per trial
        * nSamples : number of samples
            (may not be equal to NTrials * NEpsPerTrial in case some of 
             the trials reached the goal.)
        * states : matrix containing the states, one per row
        * actions : matrix containing the actions, one per row
        * rewards : column vector for the rewards
        * nextStates : matrix containing the next states, one per row.
    
    params: a struct containing (at least) the following:
        * getStateTransformations : function that takes as argument one or
        many state vectors, and returns the transformation for the states.
        * getActionTransformations : function that takes as argument one or
        many action vectors, and returns the transformation for the
        actions.
        * getOptimalActions : function that takes as argument s and W,
        where s is a matrix whose rows are state vectors and W is the
        current estimate of the W matrix.
        The function should return:
            - a matrix of optimal actions, one row for each state in s
            - a column vector of rewards such that r(i) = s(i)*W*a(i)'
    
        OPTIONAL:
        * useIntercept: should the W function use an intercept of its own?
            False by default.
        * regularize : use regularization? True by default.

    discountFactor: discount factor for the Q-function

    nSteps : how many iterations/steps to look ahead

    learningRate : learning rate to decide how much weight is given to
        latest information. 0 means the agent learns nothing, 1 means the
        agent remembers just the most recent information.
        If not specified, learningRate = 1.

Returns:
    W: a matrix that approximates the Q-function, such that Q(s,a) = sWa'.
%}


if(~exist('learningRate','var'))
    learningRate = 1;
end;

nSamples = samples.nSamples;
try
    params.regularize;
catch err
    params.regularize = 1;
end;
try
    params.useIntercept;
catch err
    params.useIntercept = 0;
end;

fprintf(1,'Using:\n');
fprintf(1,'\tLearning Rate: %f\n', learningRate);
fprintf(1,'\tDiscount Factor: %f\n', discountFactor);
fprintf(1,'\t# of steps: %d\n', nSteps);
fprintf(1,'\t# of samples: %d\n', nSamples);

transformedStates = params.getStateTransformations(samples.states);
transformedNextStates = params.getStateTransformations(samples.nextStates);
transformedActions = params.getActionTransformations(samples.actions);
immediateRewards = samples.rewards;

transformedStateDim = size(transformedStates, 2);
transformedActionDim = size(transformedActions, 2);

transformedInputs = zeros(nSamples, transformedStateDim * transformedActionDim);

for i=1:nSamples
    transformedInputs(i,:) = reshape(transformedStates(i,:)'*transformedActions(i,:),...
        1, transformedStateDim * transformedActionDim);
end

if params.useIntercept == 1
    %Add a column of 1s for the intercept.
    linRegInputs = [transformedInputs ones(nSamples, 1)];
else
    linRegInputs = transformedInputs;
end

if params.regularize == 1
    B = eye(size(transformedInputs,2));
    zTargets = zeros(size(B,1), 1); %useful later on.
    if params.useIntercept ~= 1
        %Not using an intercept, just tack on the regularization equations
        linRegInputs = [linRegInputs; B];
    else
        %This means we're using an intercept - add a column of zeros to B.
        linRegInputs = [linRegInputs; B zTargets];
    end
end

W = rand(transformedStateDim, transformedActionDim);
intercept = 0;

fprintf(1,'Iteration: %6d', 1);
targetValues = zeros(size(linRegInputs,1), 1);
maxWs = zeros(nSteps, 1);
for iStep = 1:nSteps
    fprintf(1,'\b\b\b\b\b\b%6d',iStep);
    [optimalActions, nextStateRewards] = params.getOptimalActions(transformedNextStates, W);
    if(size(nextStateRewards,1) ~= size(transformedNextStates, 1) ...
            || size(optimalActions,1) ~= size(transformedNextStates, 1))
        fprintf(1,'Invalid optimal actions, quitting.\n');
        maxWs(iStep, 1) = max(max(W));
        maxWs(1,1)
        maxWs(2)
        maxWs(3)
        maxWs(4:iStep,1)
        W = W*0;
        return;
    end
    newEstimate = immediateRewards + discountFactor*(nextStateRewards + intercept);
    oldEstimate = diag(transformedStates * W * transformedActions');
    targetValues(1:nSamples, 1) = (1 - learningRate)*oldEstimate + learningRate * newEstimate;
    %{
    if params.regularize == 1
        targetValues = [targetValues; zTargets];
    end
    %}
    X = linRegInputs \ targetValues;
    if params.useIntercept == 1
        W = reshape(X(1:end-1), transformedStateDim, transformedActionDim);
        intercept = X(end);
    else
        W = reshape(X, transformedStateDim, transformedActionDim);
    end
    maxWs(iStep, 1) = max(max(W));
end
fprintf(1,'\n');




