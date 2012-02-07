function [actions, rewards] = getOptimalActions(states, W)
%{
Returns optimal actions for the specified states and the Q function
estimate.

Args:
    * states : _transformed_ state vectors, one per row
    * W : estimate of the Q function such that r(s,a) = sWa'

Returns:
    actions: matrix of optimal actions to be taken, one per row; each 
        row corresponds to the state in that row.
    rewards: column vector of rewards.
%}
