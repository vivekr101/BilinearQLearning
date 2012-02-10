function showSteps(model)

state = CartPole2.getInitialState();
%state = [2*pi 0];
%state = CartPole2.getGoalState();
i = 0;
while(i<10000);% && CartPole2.isFailureState(state) == 0)
    [rew, action] = CartPole2.getOptimalActionsQF(model, ...
        CartPole2.getStateTransformations(state));
    CartPole2.plot_Cart_Pole(0, state(:,1),action, 0, state(:,2));
    state = CartPole2.getNextState(state, action);
    %pause(0.05);
    i = i+1;
end