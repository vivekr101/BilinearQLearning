clc;
MountainCar.setupParameters();
nTrials = 800;
nEpsPerTrial = 1;

%{
options = {};
options.getInitialState = @MountainCar.getInitialState;
options.getExploreAction = @MountainCar.getExploreAction;
options.getNextState = @MountainCar.getNextState;
options.getReward = @MountainCar.getReward_Simple;
options.isGoalState = @MountainCar.isGoalState;
options.getStateTransformations = @MountainCar.getStateTransformations;
options.getActionTransformations = @MountainCar.getActionTransformations;
options.getOptimalActions = @MountainCar.getOptimalActions;
options.regularize = 100;
options.useIntercept = 1;


%Create samples, get W, evaluate W...
nEvals = 1;

stats = zeros(nEvals, 2);
for iEval = 1:nEvals
    samples = world.createSamples(nTrials, nEpsPerTrial, options);
    W = world.getWFunction(samples, options, 0.9, 150);
    stats(iEval, :) = MountainCar.evaluateW(W, 100);
end

mean(stats)
%}


params = {};
params.getInitialState = @MountainCar.getInitialState;
params.getExploreAction = @MountainCar.getExploreAction;
params.getNextState = @MountainCar.getNextState;
params.getReward = @MountainCar.getReward_Simple;
params.isGoalState = @MountainCar.isGoalState;
params.getStateTransformations = @MountainCar.getStateTransformations;
params.getActionTransformations = @MountainCar.getActionTransformations;
params.getOptimalAction = @MountainCar.getOptimalAction;
params.M = 10;
params.discountFactor = 0.9;
params.nSteps = 70;
samples = world.createSamples(nTrials, nEpsPerTrial, params);

model = world.learnQFunction(samples, params);
[avg_cycles, successCount, output]=MountainCar.evaluateQF(model,100);
