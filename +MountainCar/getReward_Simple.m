function reward = getReward_Simple(state, action)

reward = -1*ones(size(state,1), 1);
reward(MountainCar.isGoalState(state)) = 1;