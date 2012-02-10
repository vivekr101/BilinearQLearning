function out = isFailureState(state)
%{
Function that returns 1 if the state is a goal state, 0 otherwise.

Args:
    state : state to be tested.
%}


%Difficult version: bounded at [-2.4, 2.4];
out = (abs(state(:,2)) >= 10);

%Easy version
%out = zeros(size(state,1),1);