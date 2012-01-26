function nextState = getNextState(state, action)

global NTypes PeriodicSupply_Distribution PeriodicTotalSupply_Range  ...
    PeriodicDemand_Distribution PeriodicTotalDemand_Range ...
    SuppliedFrom;

%%Define supply and demand distributions
minSupply = PeriodicTotalSupply_Range(1);
maxSupply = PeriodicTotalSupply_Range(2);
minDemand = PeriodicTotalDemand_Range(1);
maxDemand = PeriodicTotalDemand_Range(2);

%%Remove this week's allocation, and update the inventory
%Get the new supply
supply = ((maxSupply - minSupply)*rand(1,1) + minSupply)*PeriodicSupply_Distribution;
%Last NTypes values in the state vector describe the demand.
oldInventory = state(1, 1:end-NTypes);
newInventory = oldInventory - action*SuppliedFrom;
newInventory = [supply newInventory(1,1:end-NTypes)];

%Get the new demand
demand = ((maxDemand - minDemand)*rand(1,1) + minDemand)*PeriodicDemand_Distribution;

%Return the next state, which is the new inventory and the new demand.
nextState = [newInventory demand];