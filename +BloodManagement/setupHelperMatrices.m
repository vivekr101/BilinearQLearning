global ReceiverDonor_Matrix SupplyAggregator SuppliedFrom;


%%Define matrices that help specify the action vector

%Specifies week-relative indices for a donor-receiver pair in the action
%vector, goes row-wise, i.e., specifies everything for one donor first.
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