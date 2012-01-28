function [actions, q_estimates] = getOptimalActions(states, W)
%{
Returns optimal actions (not transformed) for the specified states and 
the Q function estimates.

Args:
    * states : _transformed_ state vectors, one per row
    * W : estimate of the Q function such that r(s,a) = sWa'

Returns:
    actions: matrix of optimal actions to be taken, one per row; each 
        row corresponds to the state in that row.
    q_estimates: column vector of rewards.
%}

global acc;

SW = states * W;
actions = acc*SW(:,1)./abs(SW(:,1));
actions(isnan(actions)) = 0;

q_estimates = diag(SW * [actions/0.001 ones(size(actions))]');
