%{
Unit tests for the blood management tasks. Sets up its own parameters
%}
clc;

global NTypes NWeeks ReceiverDonor_Matrix ...
    InitialDistribution InitialTotalVolume_Range ...
    PeriodicSupply_Distribution PeriodicTotalSupply_Range  ...
    PeriodicDemand_Distribution PeriodicTotalDemand_Range ...
    nTrials nEpsPerTrial ...
    SupplyAggregator SuppliedFrom;

%How many blood types and weeks?
NTypes = 2;
NWeeks = 2;

%Define the Receiver-Donor matrix; rows are donors, columns are receivers
%Only constraint is each type must donate to itself.
ReceiverDonor_Matrix = [1 1; 0 1];

NCombinations = sum(sum(ReceiverDonor_Matrix));
ActionDim = NCombinations * NWeeks;

%Define the Initial Distribution for 2 types 1 weeks
InitialDistribution = [0.3 0.3 0.2 0.2];
%Define the range of starting volume of blood
InitialTotalVolume_Range = [1000 1100];
%Define the distribution of blood supplied per week
PeriodicSupply_Distribution = [0.4 0.6];
%Define the range of weekly supply
PeriodicTotalSupply_Range = [400 400];
%Define the distribution of blood demanded per week
PeriodicDemand_Distribution = [0.5 0.5];
%Define the range of weekly supply
PeriodicTotalDemand_Range = [300 300];

BloodManagement.setupHelperMatrices;

%%%%
%Test initial state
state = BloodManagement.getInitialState();
if ~(sum(state(1:NTypes*NWeeks))<=InitialTotalVolume_Range(2)...
        && sum(state(1:NTypes*NWeeks))>=InitialTotalVolume_Range(1) ...
        && sum(state(NTypes*NWeeks+1:end)) <= PeriodicTotalDemand_Range(2)...
        && sum(state(NTypes*NWeeks+1:end)) >= PeriodicTotalDemand_Range(1)...
    )
    fprintf(1,'Error in getInitialState : total supply invalid.\n');
end
fractions = state(1:NTypes*NWeeks)/sum(state(1:NTypes*NWeeks));
demandFractions = state(NTypes*NWeeks+1:end)/sum(state(NTypes*NWeeks+1:end));
if utils.compare(fractions, InitialDistribution) == 0 || ...
        utils.compare(demandFractions, PeriodicDemand_Distribution) ==0
    fprintf(1,'Error in getInitialState : distribution mismatch.\n');
end

%Test the explore action
inventory = InitialDistribution*InitialTotalVolume_Range(1,1);
demand = PeriodicTotalDemand_Range(1)*PeriodicDemand_Distribution;
state = [inventory demand];
action = BloodManagement.getExploreAction(state);
if(sum(action)-sum(demand)>1e-4)
    fprintf(1,'Error in getExploreAction: demand not met, should have been.\n');
    state
    action
end
if ~(action(1)+action(2) < state(1) ...
        && action(3) < state(2) ...
        && action(4)+action(5) < state(3) ...
        && action(6) < state(4) ...
    )
   fprintf(1,'Error in getExploreAction: supply more than inventory.\n'); 
   state
   action
end
if ~( action(1)+action(4)-demand(1) < 1e-4 ...
        && action(2)+action(3)+action(5)+action(6)-demand(2) < 1e-4...
    )
   fprintf(1,'Error in getExploreAction: supply should have met demand.\n'); 
   state
   action
end

%Test getNextState
nextState = BloodManagement.getNextState(state, action);
%the demand and supply are essentially fixed, so we know what to expect.
supply = PeriodicTotalSupply_Range(1)*PeriodicSupply_Distribution;
leftinv = inventory;
leftinv(1) = leftinv(1) - action(1) - action(2);
leftinv(2) = leftinv(2) - action(3);
nextStateExpected = [supply leftinv(1:2) demand];
if utils.compare(nextState, nextStateExpected, 1e-4) == 0
    fprintf(1,'Error in getNextState.\n');
    nextState
    nextStateExpected
end








