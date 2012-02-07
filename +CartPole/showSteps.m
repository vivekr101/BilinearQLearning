function showSteps(model)

state = CartPole.getInitialState();

%state = CartPole.getGoalState();
i = 0;
while(i<10000) %CartPole.isGoalState(state) == 0 && i<1000)
    [rew, action] = CartPole.getOptimalActionsQF(model, ...
        CartPole.getStateTransformations(state));
    CartPole.plot_Cart_Pole(state(:,1), state(:,3),action,state(:,2), state(:,4));
    state = CartPole.getNextState(state, action);
    i = i+1;
end