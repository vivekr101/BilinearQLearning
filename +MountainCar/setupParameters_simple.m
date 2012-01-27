function setupParameters_simple()

global NTypes NWeeks ReceiverDonor_Matrix ...
    InitialDistribution InitialTotalVolume_Range ...
    PeriodicSupply_Distribution PeriodicTotalSupply_Range  ...
    PeriodicDemand_Distribution PeriodicTotalDemand_Range ...
    nTrials nEpsPerTrial ...
    SupplyAggregator SuppliedFrom;

%How many blood types and weeks?
NTypes = 2;
NWeeks = 1;

%Define the Receiver-Donor matrix; rows are donors, columns are receivers
%Only constraint is each type must donate to itself.
ReceiverDonor_Matrix = eye(2);

NCombinations = sum(sum(ReceiverDonor_Matrix));
ActionDim = NCombinations * NWeeks;

%Define the Initial Distribution for 2 types 1 weeks; generated randomly.
InitialDistribution = [0.5 0.5];

%Define the range of starting volume of blood
InitialTotalVolume_Range = [1000 1100];

%Define the distribution of blood supplied per week
PeriodicSupply_Distribution = [0.55 0.45];

%Define the range of weekly supply
PeriodicTotalSupply_Range = [300 400];

%Define the distribution of blood demanded per week
PeriodicDemand_Distribution = [0.45 0.55];

%Define the range of weekly supply
PeriodicTotalDemand_Range = [300 500];

%%Define matrices that help specify the action vector

%Specifies week-relative indices for a donor-receiver pair in the action
%vector
ActionVector_Inds = zeros(size(ReceiverDonor_Matrix));
loc = 1;
for i = 1:NTypes
    for j = 1:NTypes
        if(ReceiverDonor_Matrix(i, j) == 1)
            ActionVector_Inds(i, j) = loc;
            loc = loc + 1;
        end
    end
end
clear loc;

%Calculates total supply to each types when multiplied with an action vector
% Supplies_To_Types = ActionVector*SupplyAggregator 
SupplyAggregator = zeros(ActionDim, NTypes);
for type = 1:NTypes
    num_suppliers = sum(ReceiverDonor_Matrix(:, type));
    w_inds = reshape(repmat([0:NWeeks-1], num_suppliers, 1), NWeeks*num_suppliers, 1)*NCombinations;
    type_inds = ActionVector_Inds( find(ActionVector_Inds(:,type)), type);
    all_inds = w_inds + repmat(type_inds, NWeeks, 1);
    SupplyAggregator(all_inds, type) = 1;
end

%Calculates the supply _from_ a blood type for a given week
% TotalSuppliedFrom = ActionVector * SuppliedFrom
SuppliedFrom = zeros(ActionDim, NTypes*NWeeks);
for type = 1:NTypes
    for week = 1:NWeeks
        type_inds = ActionVector_Inds(type, find(ActionVector_Inds(type,:)));
        all_inds = (week-1)*NCombinations + type_inds';
        SuppliedFrom(all_inds, (week-1)*NTypes + type) = 1;
    end
end
