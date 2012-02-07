function showSteps(model)

state = CartPole.getInitialState();
while(CartPole.isGoalState(state) == 0)
    [rew, action] = CartPole.getOptimalActionsQF(model, ...
        CartPole.getStateTransformations(state));
    CartPole.plot_Cart_Pole(state(:,1), state(:,3));
    state = CartPole.getNextState(state, action)
end