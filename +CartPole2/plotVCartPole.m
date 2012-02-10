function [xvals, vvals, V, A] = plotVCartPole(model)

xvals = [0:0.5:2*pi];
vvals = [-10:0.5:10];
options = optimset('Display','notify','GradObj','Off','LargeScale','Off');
V = zeros(size(xvals,2), size(vvals,2));
A = zeros(size(xvals,2), size(vvals,2));

for x = 1:size(xvals,2)
    for v = 1:size(vvals,2)
        state = CartPole2.getStateTransformations([xvals(x) vvals(v)]);
        [val,ac] = CartPole2.getOptimalActionsQF(model, state);
        V(x, v) = val;
        A(x, v) = ac;
    end
end
