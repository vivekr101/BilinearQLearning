function out = isGoalState(state)
%{
Function that returns 1 if the state is a goal state, 0 otherwise.

Args:
    state : state to be tested.
%}

t = (cos(state(1,1)));
tdot = abs(state(1,2));

%Difficult version: x-position at center!
out = (t >= 0.99);% && tdot<0.05;
