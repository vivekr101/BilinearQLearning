function state = getInitialState()

global InitialDistribution InitialTotalVolume_Range ...
    PeriodicDemand_Distribution PeriodicTotalDemand_Range;

minInitial = InitialTotalVolume_Range(1);
maxInitial = InitialTotalVolume_Range(2);
minDemand = PeriodicTotalDemand_Range(1);
maxDemand = PeriodicTotalDemand_Range(2);

%Get the demand
demand = ((maxDemand - minDemand)*rand(1,1) + minDemand)*PeriodicDemand_Distribution;
%Get the inventory
inventory = ((maxInitial - minInitial)*rand(1,1) + minInitial)*InitialDistribution;

state = [inventory demand];