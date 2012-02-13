function fun = findQValue(model, state)


function qValues = getval(actions)
    qValues = zeros(size(state,1),1);
    input = [state repmat(actions,size(state,1),1).*state(:,5) ones(size(state,1),1)];
    for iModel = 1:model.M
        estNextStates = input*model.T(:,:,iModel);
        estNextStates(:,1) = cos(estNextStates(:,1));
        diffFromCenter = estNextStates - model.C(iModel, :);
        exponents = sum((diffFromCenter.*diffFromCenter)*model.W(iModel),2);
        %exponents = diag(diffFromCenter * model.W(iModel) * diffFromCenter');
        qValues = qValues + model.V(iModel)*exp(-exponents);
    end
end

fun =@getval;
end