function setupParameters()
%{
Function that should define all global parameters that will be used to
simulate the world.
Any parameters that other functions like getNextState, getOptimalActions
etc. are needed should be defined here, preferably as global variables.
%}

global g Mass_Cart Mass_Pole Total_Mass Length PoleMass_Length Force_Mag ...
    Tau Fourthirds xMin xMax;

%Simulation parameters.
g=9.8;              %Gravity
Mass_Cart=1.0;      %Mass of the cart is assumed to be 1Kg
Mass_Pole=0.1;      %Mass of the pole is assumed to be 0.1Kg
Total_Mass=Mass_Cart+Mass_Pole;
Length=0.5;         %Half of the length of the pole 
PoleMass_Length=Mass_Pole*Length;
Force_Mag=10.0;
Tau=0.02;           %Time interval for updating the values
Fourthirds=1.3333333;
xMin = -2.4;
xMax = 2.4;