function state = getInitialState()
%{
Function that returns an initial state from which the agent should start.

Returns:
    state: initial state from which the agent can start.
        [x,v,theta,theta_dot]
%}

global xMin xMax;

state = [pi 0];
%state = [pi+(rand(1,1)-0.5)*0.2, 0];