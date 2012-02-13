function [nextStateValues, optimalActions] = getOptimalActionsQF(model, states)
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

for i = 1:nStates
    optfun = CartPole2.findQValue(model, states(i, :));
    [x,v] = fminbnd(@(a) -1*optfun(a), -Force_Mag, Force_Mag);
    optimalActions(i,:) = x;
    nextStateValues(i,:) = -v;
end


%{
estNextStates = zeros(nStates, model.stateDim, 3);
modelCenters = zeros(nStates, model.stateDim, model.M);
qValues = zeros(nStates, 3);

for iModel = 1:model.M
    modelCenters(:, :, iModel) = repmat(model.C(iModel, :), nStates, 1);
end

for iAction = 1:3
    inps = [states (iAction-2)*Force_Mag*ones(nStates, 1) ones(nStates, 1)];
    for iModel = 1:model.M
        estNextStates(:, :, iAction) = inps*model.T(:,:,iModel);
        diffsFromCenter = estNextStates(:, :, iAction) - modelCenters(:, :, iModel);
        exponents = diag(diffsFromCenter * model.W(:,:,iModel) * diffsFromCenter');
        qValues(:, iAction) = qValues(:, iAction) + model.V(iModel)*exp(-exponents);
    end
end

[nextStateValues, optimalActions] = max(qValues, [], 2);
optimalActions = (optimalActions-2)*Force_Mag;
%}
