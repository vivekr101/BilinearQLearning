function [nextStateValues, optimalActions] = getOptimalAction(model, states)
%{
Returns the optimal actions and Q-function values for a list of states.

Args:
    model : the model that will be used to calculate the Q-values
    states : a matrix of transformed states, one per row.

Returns:
    nextStateValues : Q-values for the optimal actions
    optimalActions : optimal actions for the state, one per row.
%}
nStates = size(states,1);
optimalActions = zeros(nStates, model.actionDim);
nextStateValues = zeros(nStates, 1);

estNextStates = zeros(nStates, model.stateDim, 3);
estNextStates(:, :, 1) = [states -0.001*ones(nStates, 1) ones(nStates, 1)]*model.T;
estNextStates(:, :, 2) = [states zeros(nStates, 1) ones(nStates, 1)]*model.T;
estNextStates(:, :, 3) = [states 0.001*ones(nStates, 1) ones(nStates, 1)]*model.T;
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
optimalActions = (optimalActions-2)*0.001;
