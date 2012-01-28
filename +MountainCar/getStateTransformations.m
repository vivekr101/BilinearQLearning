function transformedStates = getStateTransformations(states)
%{
Function that returns the transformed states.

Args:
    states: matrix of states, one per row.

Returns:
    transformedStates: matrix of transformed state vectors, one per row.
%}

global xMin xMax vMin vMax xMean vMean;

x = states(:,1);
v = states(:,2);
xNorm = (x-xMean)/(xMax-xMean);
vNorm = (v-vMean)/(vMax-vMean);
transformedStates =[xNorm vNorm xNorm.^2 xNorm.*vNorm vNorm.^2 xNorm.^3];