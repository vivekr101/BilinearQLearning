clc;
BloodManagement.setupParameters();
nTrials = 2;
nEpsPerTrial = 10;

options = {};
options.getInitialState = @BloodManagement.getInitialState;
options.getExploreAction = @BloodManagement.getExploreAction;
options.getNextState = @BloodManagement.getNextState;
options.getReward = @BloodManagement.getReward_Simple;
options.isGoalState = @BloodManagement.isGoalState;
options.getStateTransformations = @BloodManagement.getStateTransformations;
options.getActionTransformations = @BloodManagement.getActionTransformations;
options.getOptimalActions = @BloodManagement.getOptimalActions;

samples = world.createSamples(nTrials, nEpsPerTrial, options);

[W, inputs, targets] = world.getWFunction(samples, options, 0.9, 100);