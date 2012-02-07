function [rewards, actions] = getOptimalActionsQF(model, states)
%{
Returns optimal actions for the specified states and the Q function
estimate.
Args:
    model: sum-of-gaussians model
    states: matrix of transformed states, one per row.

Returns:
    rewards: column vector of rewards.
    actions: matrix of optimal actions to be taken, one per row; each 
        row corresponds to the state in that row.
%}
