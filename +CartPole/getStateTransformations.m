function transformedStates = getStateTransformations(states)
%{
Function that returns the transformed states.

Args:
    states: matrix of states, one per row.
    one un-transformed state is [x, x_dot, t, t_dot].

Returns:
    transformedStates: matrix of transformed state vectors, one per row.
%}
global g Mass_Pole Total_Mass Length PoleMass_Length Tau Fourthirds;

nStates = size(states, 1);
x = states(:, 1);
x_dot = states(:, 2);
t = states(:, 3);
t_dot = states(:, 4);

denom = Length * (Fourthirds*ones(nStates,1) - Mass_Pole * cos(t) .* cos(t) / Total_Mass);

transformedStates = [x, x_dot, ...
    sin(t) .* t_dot .* t_dot, ...
    sin(t) ./ denom, ...
    cos(t) ./ denom, ...
    sin(t) .* cos(t) .* t_dot .* t_dot ./ denom, ...
    sin(t) .* cos(t) ./ denom, ...
    cos(t) .* cos(t) ./denom, ...
    sin(t) .* cos(t) .* t_dot .* t_dot .* cos(t) ./ denom
    ];
