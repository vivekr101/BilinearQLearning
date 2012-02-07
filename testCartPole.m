clc;
CartPole.setupParameters();
nTrials = 30;
nEpsPerTrial = 100;


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
params.M = 10;
params.discountFactor = 0.9;
params.nSteps = 150;
samples = world.createSamples(nTrials, nEpsPerTrial, params);

model = world.learnQFunction(samples, params);
