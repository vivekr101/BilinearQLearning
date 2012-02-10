function fun = findQValue(model, state)


function qValues = getval(action)
    qValues = 0;
    for iModel = 1:model.M
        estNextStates = [state action 1]*model.T(:,:,iModel);
        estNextStates(:,1) = cos(estNextStates(:,1));
        diffFromCenter = estNextStates - model.C(iModel, :);
        exponents = diag(diffFromCenter * model.W(iModel) * diffFromCenter');
        qValues = qValues + model.V(iModel)*exp(-exponents);
    end
end

fun =@getval;
end