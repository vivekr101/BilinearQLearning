function setupParameters()

global NTypes NWeeks ReceiverDonor_Matrix ...
    InitialDistribution InitialTotalVolume_Range ...
    PeriodicSupply_Distribution PeriodicTotalSupply_Range  ...
    PeriodicDemand_Distribution PeriodicTotalDemand_Range ...
    nTrials nEpsPerTrial ...
    SupplyAggregator SuppliedFrom;

%How many blood types and weeks?
NTypes = 4;
NWeeks = 3;

NCombinations = sum(sum(ReceiverDonor_Matrix));
ActionDim = NCombinations * NWeeks;

%Define the Receiver-Donor matrix; rows are donors, columns are receivers
%Currently arbitrary matrix (Jan18). Only constraint is each type 
%must donate to itself.
ReceiverDonor_Matrix = [1 1 1 0; 0 1 1 1; 0 0 1 1; 0 0 0 1];

%Define the Initial Distribution for 4 types
%4 types, 3 weeks; generated randomly.
InitialDistribution = [0.1204 0.0611 0.1007 0.0179 0.0531 0.1152 0.0997 0.1207 0.0825 0.0045 0.1068 0.1175];

%Define the range of starting volume of blood
InitialTotalVolume_Range = [1000 1200];

%Define the distribution of blood supplied per week
PeriodicSupply_Distribution = [0.2639 0.2946 0.2890 0.1525];

%Define the range of weekly supply
PeriodicTotalSupply_Range = [300 400];

%Define the distribution of blood demanded per week
PeriodicDemand_Distribution = [0.1843 0.1603 0.3215 0.3340];

%Define the range of weekly supply
PeriodicTotalDemand_Range = [300 400];

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
