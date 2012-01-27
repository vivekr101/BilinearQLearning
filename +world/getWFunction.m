function [W, transformedInputs, targetValues] = getWFunction(samples, params, ...
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
    
    params: a struct containing the following:
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

W = zeros(transformedStateDim, transformedActionDim);

fprintf(1,'Iteration: %6d', 1);
for iStep = 1:nSteps
    fprintf(1,'\b\b\b\b\b\b%6d',iStep);
    [optimalActions, nextStateRewards] = params.getOptimalActions(transformedNextStates, W);
    newEstimate = immediateRewards + nextStateRewards;
    oldEstimate = diag(transformedStates * W * transformedActions');
    targetValues = (1 - learningRate)*oldEstimate + learningRate * newEstimate;
    %X = double(transformedInputs) \ double(targetValues);
    X = linsolve(double(transformedInputs), double(targetValues));
    W = reshape(X, transformedStateDim, transformedActionDim)
    %k = waitforbuttonpress
end
fprintf(1,'\n');

