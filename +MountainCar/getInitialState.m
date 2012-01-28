function state = getInitialState()
%{
Function that returns an initial state from which the agent should start.

Returns:
    state: initial state from which the agent can start.
%}

global xMean xMin xMax vMean vMin vMax;

state = [xMean + (xMax-xMin)*(rand(1,1)-0.5), vMean + (vMax-vMin)*(rand(1,1)-0.5)];