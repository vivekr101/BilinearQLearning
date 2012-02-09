function ff = cVal(model, estNextStates, currentEstimates, iModel)
v_vals = repmat(model.V', size(estNextStates, 1), 1);
diffs = currentEstimates(:, 1) - sum(v_vals.*currentEstimates(:, 2:end),2) + model.V(iModel).*currentEstimates(:,1+iModel);

function val = getError(c)
    diffsFromCenter = estNextStates - repmat(c,size(estNextStates,1), 1);
    exponents = diag(diffsFromCenter * model.Winv{iModel} * diffsFromCenter');
    val = diffs - model.V(iModel)*exp(-exponents);
end

ff= @getError;
end