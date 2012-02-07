function fun = findQValue(model, state)


function qValues = getval(action)
    qValues = 0;
    estNextStates = [state action 1]*model.T;
    for iModel = 1:model.M
        diffFromCenter = estNextStates - model.C(iModel, :);
        exponents = diag(diffFromCenter * model.Winv{iModel} * diffFromCenter');
        qValues = qValues + model.V(iModel)*exp(-exponents);
    end
end

fun =@getval;
end