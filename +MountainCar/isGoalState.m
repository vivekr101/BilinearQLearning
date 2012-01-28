function out = isGoalState(states)
%{
Function that returns 1 if the state is a goal state, 0 otherwise.

Args:
    states : states to be tested.
%}

global goalState;

out = states(:,1)>=goalState;