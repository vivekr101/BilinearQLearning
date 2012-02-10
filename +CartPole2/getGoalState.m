function state = getGoalState()
%{
Function that returns 1 if the state is a goal state, 0 otherwise.

Args:
    state : state to be tested.
%}

state = [(rand(1,1)-0.5)*0.005, 0];
if(state(1,1)<0)
    state(1,1) = state(1,1)+2*pi;
end