function transformedActions = getActionTransformations(actions)
%{
Returns a matrix that transforms the input actions

Args:
    actions: matrix of actions, one action per row

Returns:
    transformedActions: matrix of transformed action vectors, one per row
%}

transformedActions = actions;