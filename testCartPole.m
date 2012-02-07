clc;
CartPole.setupParameters();
nTrials = 3;
nEpsPerTrial = 1000;


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
params.M = 50;
params.discountFactor = 0.9;
params.nSteps = 300;
samples = world.createSamplesWFailure(nTrials, nEpsPerTrial, params);

model = world.learnQFunction(samples, params);
