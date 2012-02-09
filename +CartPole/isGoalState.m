function out = isGoalState(state)
%{
Function that returns 1 if the state is a goal state, 0 otherwise.

Args:
    state : state to be tested.
%}

x = abs(state(1,1));
v = abs(state(1,2));
t = (cos(state(1,3)));
tdot = abs(state(1,4));

%Difficult version: x-position at center!
out = (x < 0.05) && (t >= 0.9);
