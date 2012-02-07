function qValues = calculateQValue(model, transformedStates, transformedActions)
qValues = zeros(size(transformedStates, 1), 1);
estNextStates = [transformedStates transformedActions ones(size(qValues,1), 1)]*model.T;
for iModel = 1:model.M
    diffFromCenter = estNextStates - repmat(model.C(iModel, :), size(qValues, 1), 1);
    exponents = diag(diffFromCenter * model.Winv{iModel} * diffFromCenter');
    qValues = qValues + model.V(iModel)*exp(-exponents);
end