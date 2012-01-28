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

%Define the Receiver-Donor matrix; rows are donors, columns are receivers
%Currently arbitrary matrix (Jan18). Only constraint is each type 
%must donate to itself.
ReceiverDonor_Matrix = [1 1 1 0; 0 1 1 1; 0 0 1 1; 0 0 0 1];

NCombinations = sum(sum(ReceiverDonor_Matrix));
ActionDim = NCombinations * NWeeks;

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

BloodManagement.setupHelperMatrices;