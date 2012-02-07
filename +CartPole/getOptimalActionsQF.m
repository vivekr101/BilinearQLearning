function [rewards, actions] = getOptimalActionsQF(model, states)
%{
Returns optimal actions for the specified states and the Q function
estimate.
Args:
    model: sum-of-gaussians model
    states: matrix of transformed states, one per row.

Returns:
    rewards: column vector of rewards.
    actions: matrix of optimal actions to be taken, one per row; each 
        row corresponds to the state in that row.
%}

global Force_Mag;
nStates = size(states,1);
optimalActions = zeros(nStates, model.actionDim);
nextStateValues = zeros(nStates, 1);

estNextStates = zeros(nStates, model.stateDim, 3);
estNextStates(:, :, 1) = [states -Force_Mag*ones(nStates, 1) ones(nStates, 1)]*model.T;
estNextStates(:, :, 2) = [states zeros(nStates, 1) ones(nStates, 1)]*model.T;
estNextStates(:, :, 3) = [states Force_Mag*ones(nStates, 1) ones(nStates, 1)]*model.T;
modelCenters = zeros(nStates, model.stateDim, model.M);
qValues = zeros(nStates, 3);

for iModel = 1:model.M
    modelCenters(:, :, iModel) = repmat(model.C(iModel, :), nStates, 1);
end

for iAction = 1:3
    for iModel = 1:model.M
        diffsFromCenter = estNextStates(:, :, iAction) - modelCenters(:, :, iModel);
        exponents = diag(diffsFromCenter * model.Winv{iModel} * diffsFromCenter');
        qValues(:, iAction) = qValues(:, iAction) + model.V(iModel)*exp(-exponents);
    end
end

[nextStateValues, optimalActions] = max(qValues, [], 2);
optimalActions = (optimalActions-2)*Force_Mag;