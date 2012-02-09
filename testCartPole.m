clc;
CartPole.setupParameters();


params = {};
params.getInitialState = @CartPole.getInitialState;
params.getExploreAction = @CartPole.getExploreAction;
params.getNextState = @CartPole.getNextState;
params.getReward = @CartPole.getReward;
params.isGoalState = @CartPole.isGoalState;
params.isFailureState = @CartPole.isFailureState;
params.getStateTransformations = @CartPole.getStateTransformations;
params.getActionTransformations = @CartPole.getActionTransformations;
params.getOptimalAction = @CartPole.getOptimalActionsQF;
params.getGoalState = @CartPole.getGoalState;
params.hintToGoal = 0.05;
params.M = 20;
params.discountFactor = 0.9;
params.nSteps = 100;

nTrials = 1;
nEpsPerTrial = 200;
samples = world.createSamplesWFailure(nTrials, nEpsPerTrial, params);

i = 1;
while(i<=3)
    model = world.learnQFunction(samples, params, model);
    [r,a] = CartPole.getOptimalActionsQF(model,CartPole.getStateTransformations([0 0 0 0]));
    a
    samples = world.createSamplesWFailure(nTrials, nEpsPerTrial, params, model);
    i = i+1;
    %CartPole.showSteps(model);
    %k = waitforbuttonpress;
end
