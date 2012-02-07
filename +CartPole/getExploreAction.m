function action = getExploreAction(state)
%{
Function that is used for getting exploratory actions, used to create
training samples.

Args:
    state: state from which to take action, row vector

Returns:
    action: action to be taken, row vector.
%}

global Force_Mag;

nStates = size(states, 1);

dec = rand(nStates,1);
%Equal chance of going left, right or no acceleration.
action = Force_Mag*((dec>0.66) - (dec<0.33));
