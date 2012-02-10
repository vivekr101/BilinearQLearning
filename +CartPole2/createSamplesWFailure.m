function samples = createSamples(...
nTrials, ...
nEpsPerTrial, ...
params)
%{
Creates samples for the world being simulated. It creates
nTrials*nEpsPerTrial samples by running 'nTrials' trials.
Each trial is run for nEpsPerTrial episodes, or is terminated earlier if
the goal state is reached.
If a failure is reached, the agent restarts.

***It is assumed all actions and states are row vectors.***


args: 
    nTrials: number of trials to create

    nEpsPerTrial: number of episodes per trial

    params: struct containing the following fields:
        * getInitialState: function handle that takes no arguments, and
        returns an initial state for a trial.
        * getExploreAction : function handle that takes as argument a
        state, and returns the action to be taken.
        * getNextState : function handle that takes as arguments a
        state and action taken, and returns the next state.
        * getReward : function handle that takes as argument a
        state and action, and returns a scalar reward.
        * isGoalState : function handle that takes as argument a state and
        returns True if the state is a goal state. This function will be used
        to determine whether the current trial can be continued.
        * isFailureState: function handle that takes as argument a state and
        returns True if the state is a failure state. The current trial
        will quit if this is true.

returns:
    samples: a struct containing the following:
        * stateDim : dimension of state vector (row vector)
        * actionDim : dimension of action vector (row vector)
        * nTrials: number of trials to create
        * nEpsPerTrial: number of episodes per trial
        * nSamples : number of samples
            (may not be equal to NTrials * NEpsPerTrial in case some of 
             the trials reached the goal.)
        * states : matrix containing the states, one per row
        * actions : matrix containing the actions, one per row
        * rewards : column vector for the rewards
        * nextStates : matrix containing the next states, one per row.

        The last for fields can be used to form tuples of (s, a, r, s').
%}

%Get handles for necessary functions
getInitialState = params.getInitialState;
getExploreAction = params.getExploreAction;
getNextState = params.getNextState;
getReward = params.getReward;
isGoalState = params.isGoalState;
isFailureState = params.isFailureState;

%Get dimensions
initialState = getInitialState();
stateDim = size(initialState, 2);
actionDim = size(getExploreAction(initialState), 2);
clear initialState;

%Create struct to hold the samples
samples = {};
samples.nTrials = nTrials;
samples.nEpsPerTrial = nEpsPerTrial;
samples.stateDim = stateDim;
samples.actionDim = actionDim;
samples.nSamples = 0;
samples.states = zeros(nTrials * nEpsPerTrial, stateDim);
samples.actions = zeros(nTrials * nEpsPerTrial, actionDim);
samples.rewards = zeros(nTrials * nEpsPerTrial, 1);
samples.nextStates = zeros(nTrials * nEpsPerTrial, stateDim);

fprintf(1,'Creating samples...');

%Create the samples
nSamples = 0;
while(1)
    currentState = getInitialState();
    for iEp = 1:nEpsPerTrial
        if(nSamples >= nTrials*nEpsPerTrial)
            break;
        end
        nSamples = nSamples + 1;
        samples.states(nSamples, :) = currentState;
        %Get the action, reward, next state
        action = getExploreAction(currentState);
        samples.actions(nSamples, :) = action;
        samples.rewards(nSamples, 1) = getReward(currentState, action);
        samples.nextStates(nSamples, :) = getNextState(currentState, action);
        %Should we end this trial?
        if isGoalState(samples.nextStates(nSamples, :))==1
            break;
        end
        if isFailureState(samples.nextStates(nSamples, :))==1
            break;
        end
        currentState = samples.nextStates(nSamples, :);
    end
    if(nSamples >= nTrials*nEpsPerTrial)
            break;
    end
end

samples.nSamples = nSamples;

fprintf(1,' finished creating %d samples.\n', nSamples);