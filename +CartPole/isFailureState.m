function out = isFailureState(state)
%{
Function that returns 1 if the state is a goal state, 0 otherwise.

Args:
    state : state to be tested.
%}

x = abs(state(1,1));

%Difficult version: bounded at [-2.4, 2.4];
out = (x > 2.4);

%Easy version
%out = zeros(size(state,1),1);