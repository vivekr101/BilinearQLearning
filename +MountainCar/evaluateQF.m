function [avg_cycles, successCount, output]=evaluateQF(model,nTests)
global xMean vMean xMin vMin xMax vMax;

maxSteps = 500;

totalSteps = 0;
successCount = 0;
steps = ones(nTests,1)*maxSteps;
output = ones(nTests, 4)*maxSteps;

fprintf(1,'Test: %6d', 1);

%Start off with the worst state: at the bottom, go from there
state=[-acos(0)/3 0];

for iTest = 1:nTests
    fprintf(1,'\b\b\b\b\b\b%6d',iTest);
    state=[(rand(1,1)-0.5)*(xMax-xMin)+xMean 0];
    output(iTest,1:2) = state;
    output(iTest, 4) = 0;
    oldAction = 0;
    for iStep = 1:maxSteps
        if(MountainCar.isGoalState(state)==1)
            totalSteps = totalSteps + iStep;
            successCount = successCount + 1;
            steps(iTest, 1) = iStep;
            output(iTest, 3) = iStep;
            break;
        end
        [rew, action] = MountainCar.getOptimalAction(model, MountainCar.getStateTransformations(state));
        if(oldAction ~= action)
            output(iTest, 4) = output(iTest, 4) + 1;
        end
        oldAction = action;
        state = MountainCar.getNextState(state, action);
    end
end
fprintf(1,'\n');
avg_cycles=mean(steps);