function setupParameters()
%{
Function that should define all global parameters that will be used to
simulate the world.
Any parameters that other functions like getNextState, getOptimalActions
etc. are needed should be defined here, preferably as global variables.
%}

global xMin xMax xMean vMin vMax vMean goalState acc gravity;

xMin = -1.2;
xMax = 0.6;
vMin = -0.07;
vMax = 0.07;
xMean = 0.5*(xMin + xMax); 
vMean = 0.5*(vMin + vMax); 
goalState = 0.5;
acc = 0.001;
gravity = -0.0025;