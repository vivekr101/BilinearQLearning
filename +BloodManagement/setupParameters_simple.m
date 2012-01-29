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

BloodManagement.setupHelperMatrices;