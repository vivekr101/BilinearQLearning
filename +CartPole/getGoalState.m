function state = getGoalState()
%{
Function that returns 1 if the state is a goal state, 0 otherwise.

Args:
    state : state to be tested.
%}

state = [(rand(1,1)-0.5)*0.05, (rand(1,1)-0.5)*0.1, ...
    (rand(1,1)-0.5)*0.05, (rand(1,1)-0.5)*0.05];
if(state(1,3)<0)
    state(1,3) = state(1,3)+2*pi;
end