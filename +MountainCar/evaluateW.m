function [avg_cycles, successCount]=evaluateW(W,nTests)
global xMean vMean xMin vMin xMax vMax;

maxSteps = 500;

totalSteps = 0;
successCount = 0;
steps = ones(nTests,1)*maxSteps;

fprintf(1,'Test: %6d', 1);

for iTest = 1:nTests
    fprintf(1,'\b\b\b\b\b\b%6d',iTest);
    state=[(rand(1,1)-0.5)*1e-5+xMean 0];
    for iStep = 1:maxSteps
        if(MountainCar.isGoalState(state)==1)
            totalSteps = totalSteps + iStep;
            successCount = successCount + 1;
            steps(iTest, 1) = iStep;
            break;
        end
        [action, est] = MountainCar.getOptimalActions(MountainCar.getStateTransformations(state), W);
        state = MountainCar.getNextState(state, action);
    end
end
fprintf(1,'\n');
avg_cycles=mean(steps);