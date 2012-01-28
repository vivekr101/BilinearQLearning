%{
Test the next state calculations.
%}
global acc gravity;
clc;

MountainCar.setupParameters();
states = [0 0; -1.19 -0.06; -0.4 0.07; 0.49 0.02; 0.51 -0.03];
actions = [0.001; -0.001; 0.001; -0.001; -0.001];
expectedNS = [0 actions(1,1)+gravity*cos(3*0); 
                -1.2 0;
                -0.33 0.07+actions(3,1)+gravity*cos(-3*0.4);
                0.51 0.02+actions(4,1)+gravity*cos(3*0.49);
                0.48 -.03+actions(5,1)+gravity*cos(3*0.51)];
expectedRewards = [-1; -1; -1; -1; 1];
expectedTS = [0.3333         0    0.1111         0         0    0.0370
   -0.9889   -0.8571    0.9779    0.8476    0.7347   -0.9670
   -0.1111    1.0000    0.0123   -0.1111    1.0000   -0.0014
    0.8778    0.2857    0.7705    0.2508    0.0816    0.6763
    0.9000   -0.4286    0.8100   -0.3857    0.1837    0.7290];
goalstates = [0;0;0;0;1];

            
ns = MountainCar.getNextState(states, actions);
if(utils.compare(ns,expectedNS,1e-4)==0)
    fprintf(1,'MountainCar.getNextState() fails.\n');
    states
    actions
    expectedNS
    ns
end

rewards = MountainCar.getReward_Simple(states, actions);
if(utils.compare(rewards,expectedRewards,1e-6)==0)
    fprintf(1,'MountainCar.getReward_Simple() fails.\n');
    states
    actions
    expectedRewards
    rewards
end


ts = MountainCar.getStateTransformations(states);
if(utils.compare(ts,expectedTS,1e-4)==0)
    fprintf(1,'MountainCar.getStateTransfomrations() fails.\n');
    states
    actions
    expectedTS
    ts
end

gs = MountainCar.isGoalState(states);
if(utils.compare(gs,goalstates,1e-4)==0)
    fprintf(1,'MountainCar.isGoalState() fails.\n');
    states
    actions
    goalstates
    gs
end
