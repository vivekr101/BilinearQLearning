function action = getExploreAction(state)

global NWeeks ReceiverDonor_Matrix ...
    SupplyAggregator SuppliedFrom;

NCombinations = sum(sum(ReceiverDonor_Matrix));
ActionDim = NCombinations * NWeeks;
options = optimset('Display','off');

%Decide action using greedy policy of maximizing total units supplied
ObjFunc = -1*ones(ActionDim, 1);

%Lower bound for the action vector, no upper bounds needed - handled by 
%constraints
LB = zeros(ActionDim, 1);
%Constraints' LHS for the action vector
Constraints = [SuppliedFrom SupplyAggregator];
%Constraints' RHS for the action vector
ConstraintUpperBounds = state;
[x, val, exitflag] = linprog(ObjFunc', Constraints', ConstraintUpperBounds', [], [], LB', [], [], options);
action = x';