BloodManagement.setupParameters;
nTrials = 5;
nEpsPerTrial = 20;

options = {};
options.getInitialState = @BloodManagement.getInitialState;
options.getExploreAction = @BloodManagement.getExploreAction;
options.getNextState = @BloodManagement.getNextState;
options.getReward = @BloodManagement.getReward_Simple;
options.isGoalState = @BloodManagement.isGoalState;

samples = world.createSamples(nTrials, nEpsPerTrial, options);

samples.nSamples
samples.stateDim
samples.actionDim