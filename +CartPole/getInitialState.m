function state = getInitialState()
%{
Function that returns an initial state from which the agent should start.

Returns:
    state: initial state from which the agent can start.
        [x,v,theta,theta_dot]
%}

state = [0 0 pi 0];
