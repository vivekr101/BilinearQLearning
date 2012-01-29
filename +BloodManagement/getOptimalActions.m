function [actions, rewards] = getOptimalActions(states, W)
%{
Returns optimal actions for the specified states and the Q function
estimate.

Args:
    * states : _transformed_ state vectors, one per row
    * W : estimate of the Q function such that r(s,a) = sWa'
%}

global SupplyAggregator SuppliedFrom;
options = optimset('Display','off');
Constraints = [SuppliedFrom SupplyAggregator];

actionDim = size(W, 2);
actions = zeros(size(states, 1), actionDim);
rewards = zeros(size(states, 1), 1);
LB = zeros(actionDim, 1);

for iSample = 1:size(states,1)
    SW = states(iSample, :) * W;
    ObjFunc = -1 * SW;
    [x, val, exitflag] = linprog(ObjFunc', Constraints', states(iSample, :)', [], [], LB', [], [], options);
    if(exitflag ~= 0 && exitflag ~=1)
        fprintf(1,'\nCould not reach a solution.\n');
        W
        states(iSample, :)
        actions = [];
        rewards = [];
        return;
    end
    actions(iSample, :) = x';
    rewards(iSample, 1) = SW*x;
end
