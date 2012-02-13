function reward = getReward(state, action)
%{
Return the reward for a particular action taken in a particular state.
%}

reward = 0 * ones(size(state,1), 1);
reward(find(CartPole2.isGoalState(state))) = 1;
reward(find(CartPole2.isFailureState(state))) = -1000;
%reward = -sum(abs(state),2);