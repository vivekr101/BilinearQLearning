function nextStates = getNextState(states, actions)
%{
Function that returns the next states given a matrix of current states
and actions taken.

NOTE: Implemented using Amir Hesami's version, from:
http://webdocs.cs.ualberta.ca/~sutton/software.html

Args:
    states: matrix of current states, one per row.
    actions: matrix of actions taken, one per row.

Returns:
    nextStates: matrix of next states, one per row.
%}

global g Mass_Pole Total_Mass Length PoleMass_Length Tau Fourthirds xMin xMax;

x = states(:,1);
x_dot = states(:,2);
theta = states(:,3);
theta_dot = states(:,4);
nStates = size(states, 1);

temp = (actions + PoleMass_Length *theta_dot .* theta_dot .* sin(theta))/ Total_Mass;

denom = Length * (Fourthirds*ones(nStates,1) - Mass_Pole * cos(theta) .* cos(theta) / Total_Mass);
thetaacc = (g * sin(theta) - cos(theta).* temp) ./ denom;

xacc  = temp - PoleMass_Length * thetaacc .* cos(theta) / Total_Mass;
 
% Update the four state variables, using Euler's method.
new_x = x + Tau * x_dot;
new_x_dot = x_dot + Tau * xacc;
new_theta = theta + Tau * theta_dot;
new_theta_dot = theta_dot + Tau * thetaacc;

new_theta = acos(cos(new_theta));
%{
new_x_dot(new_x<-2.4) = 0;
new_x_dot(new_x>2.4) = 0;
new_x(new_x<-2.4) = -2.4;
new_x(new_x>2.4) = 2.4;
%}
nextStates = [new_x, new_x_dot, new_theta, new_theta_dot];
