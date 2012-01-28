function [equal,maxErr] = compare(src, dest, eps)
%{
Compares for equality of 1 or 2D matrices
%}
if(~exist('eps','var'))
    eps = 1e-4;
end
maxErr = max(max(abs(src-dest)));
equal = 1-(maxErr>eps);