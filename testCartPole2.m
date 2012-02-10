
clc;
CartPole2.setupParameters();


params = {};
params.getInitialState = @CartPole2.getInitialState;
params.getExploreAction = @CartPole2.getExploreAction;
params.getNextState = @CartPole2.getNextState;
params.getReward = @CartPole2.getReward;
params.isGoalState = @CartPole2.isGoalState;
params.isFailureState = @CartPole2.isFailureState;
params.getStateTransformations = @CartPole2.getStateTransformations;
params.getActionTransformations = @CartPole2.getActionTransformations;
params.getOptimalAction = @CartPole2.getOptimalActionsQF;
params.getGoalState = @CartPole2.getGoalState;
params.hintToGoal = 0.02;
params.M = 10;
params.discountFactor = 0.99;
params.nSteps = 100;

nTrials = 10;
nEpsPerTrial = 200;
samples = world.createSamplesWFailure(nTrials, nEpsPerTrial, params);
model = world.learnQFunction(samples, params);

i = 4;
while(i<4)
    [r,a] = CartPole2.getOptimalActionsQF(model,CartPole2.getStateTransformations([0 0]))
    samples = world.createSamplesWFailure(nTrials, nEpsPerTrial, params, model);
    model = world.learnQFunction(samples, params, model);
    i = i+1;
    %CartPole2.showSteps(model);
    %k = waitforbuttonpress;
end
