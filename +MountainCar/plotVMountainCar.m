function [xvals, vvals, V, A] = plotVMountainCar(model)

xvals = [-1.2:0.05:0.6];
vvals = [-0.07:0.005:0.07];
options = optimset('Display','notify','GradObj','Off','LargeScale','Off');
V = zeros(size(xvals,2), size(vvals,2));
A = zeros(size(xvals,2), size(vvals,2));

for x = 1:size(xvals,2)
    for v = 1:size(vvals,2)
        state = MountainCar.getStateTransformations([xvals(x) vvals(v)]);
        [val,ac] = MountainCar.getOptimalAction(model, state);
        V(x, v) = val;
        A(x, v) = ac;
    end
end