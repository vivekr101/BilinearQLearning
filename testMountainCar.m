clc;
MountainCar.setupParameters();
nTrials = 800;
nEpsPerTrial = 1;

options = {};
options.getInitialState = @MountainCar.getInitialState;
options.getExploreAction = @MountainCar.getExploreAction;
options.getNextState = @MountainCar.getNextState;
options.getReward = @MountainCar.getReward_Simple;
options.isGoalState = @MountainCar.isGoalState;
options.getStateTransformations = @MountainCar.getStateTransformations;
options.getActionTransformations = @MountainCar.getActionTransformations;
options.getOptimalActions = @MountainCar.getOptimalActions;
options.regularize = 1;
options.useIntercept = 1;


%Create samples, get W, evaluate W...
nEvals = 10;

stats = zeros(nEvals, 2);
for iEval = 1:nEvals
    samples = world.createSamples(nTrials, nEpsPerTrial, options);
    W = world.getWFunction(samples, options, 0.9, 150);
    stats(iEval, :) = MountainCar.evaluateW(W, 100);
end

mean(stats)
stdev(stats)