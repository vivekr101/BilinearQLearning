function [xvals, vvals, V, A] = plotVCartPole(model)

xvals = [0:0.05:2*pi];
vvals = [-10:0.05:10];
options = optimset('Display','notify','GradObj','Off','LargeScale','Off');
V = zeros(size(xvals,2), size(vvals,2));
A = zeros(size(xvals,2), size(vvals,2));

for x = 1:size(xvals,2)
    for v = 1:size(vvals,2)
        state = CartPole.getStateTransformations([0 0 xvals(x) vvals(v)]);
        [val,ac] = CartPole.getOptimalActionsQF(model, state);
        V(x, v) = val;
        A(x, v) = ac;
    end
end
