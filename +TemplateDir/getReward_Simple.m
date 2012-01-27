function reward = getReward_Simple(state, action)

%Simplistic reward function, just allocates points for each unit of demand
%fulfilled, and subtracts points for each unit of blood wasted.

global NTypes SupplyAggregator SuppliedFrom;

demand = state(1, end-NTypes+1:end);
inventory = state(1, 1:end-NTypes);

totalSupplied = action*SupplyAggregator;
if(min(demand - totalSupplied) < -1.0e-4)
    fprintf(1,'Total blood supplied exceeded demand.\n');
    totalSupplied
    demand
    demand - totalSupplied
    return;
end

totalUsed = action*SuppliedFrom; %at a type-week level.

if(min(inventory - totalUsed) < -1.0e-4)
    fprintf(1,'Total blood supplied exceeded supply.\n');
    return;
end
totalWasted = inventory(1, end-NTypes+1:end) - totalUsed(1, end-NTypes+1:end);

reward = sum(totalSupplied) - sum(totalWasted);