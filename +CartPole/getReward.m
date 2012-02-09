function reward = getReward(state, action)
%{
Return the reward for a particular action taken in a particular state.
%}

reward = -1 * ones(size(state,1), 1);
reward(find(CartPole.isGoalState(state))) = 0;
reward(find(CartPole.isFailureState(state))) = -1000;