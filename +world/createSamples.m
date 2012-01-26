function samples = createSamples(...
nTrials, ...
nEpsPerTrial, ...
options)
%{
Creates samples for the world being simulated. It creates
nTrials*nEpsPerTrial samples by running 'nTrials' trials.
Each trial is run for nEpsPerTrial episodes, or is terminated earlier if
the goal state is reached.

***It is assumed all actions and states are row vectors.***

nTrials: number of trials to create
nEpsPerTrial: number of episodes per trial
options: struct containing the following fields:
    * getInitialState: function handle that takes no arguments, and
    returns an initial state for a trial.
    * getAction : function handle that takes as argument a
    state, and returns the action to be taken.
    * getNextState : function handle that takes as arguments a
    state and action taken, and returns the next state.
    * getReward : function handle that takes as argument a
    state and action, and returns a scalar reward.
    * isGoalState : function handle that takes as argument a state and
    returns True if the state is a goal state. This function will be used
    to determine whether the current trial can be continued.
%}

%Get handles for necessary functions
getInitialState = options.getInitialState;
getAction = options.getAction;
getNextState = options.getNextState;
getReward = options.getReward;
isGoalState = options.isGoalState;

%Get dimensions
initialState = getInitialState();
stateDim = size(initialState, 2);
actionDim = size(getAction(initialState), 2);
clear initialState;

%Create struct to hold the samples
samples = {}
samples.stateDim = stateDim;
samples.actionDim = actionDim;
samples.nSamples = 0;
samples.states = zeros(nTrials * nEpsPerTrial, stateDim);
samples.actions = zeros(nTrials * nEpsPerTrial, actionDim);
samples.rewards = zeros(nTrials * nEpsPerTrial, 1);
samples.nextStates = zeros(nTrials * nEpsPerTrial, stateDim);

%Create the samples
nSamples = 0;
for iTrial = 1:nTrials
    currentState = getInitialState();
    for iEp = 1:nEpsPerTrial
        nSamples = nSamples + 1;
        samples.states(nSamples, :) = currentState;
        %Get the action, reward, next state
        action = getAction(currentState);
        samples.actions(nSamples, :) = action;
        samples.rewards(nSamples, 1) = getReward(currentState, action);
        samples.nextStates(nSamples, :) = getNextState(currentState, action);
        %Should we end this trial?
        if isGoalState(samples.nextStates(nSamples, :))==1
            break;
        end
    end
end

samples.nSamples = nSamples;