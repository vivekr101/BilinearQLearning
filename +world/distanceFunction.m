function distances = distanceFunction(diffVectors)
%{
Converts vector differences into scalar distances.

Given vector differences of a sample X from M centers, returns for each
center i:
normdiff(x,i) = norm(diff(x,i))/( \sum_{j = 1 to n} diff(x,j) )
d(x,i) = exp(-normdiff(x,i))/(\sum_{j=1 to n} exp(-normdiff(x,j)) )

Args:
    diffVectors: a struct of M matrices. Each row in a matrix represents
    the difference of that sample from the center for that matrix.

Returns:
    distances: a matrix which has one row per sample, and M columns, each column being
    the distance of that sample from that center.
%}
diffs = zeros(size(diffVectors{1},1), size(diffVectors, 2));
for i = 1:size(diffs,2)
    diffs(:, i) = sum(diffVectors{i}.^2, 2);
end
%{
denoms = sum(diffs, 2);
ratios = diffs./repmat(denoms, 1, size(diffs,2));
distances = exp(-ratios);
denoms = sum(distances, 2);
distances = distances./repmat(denoms, 1, size(diffs,2));
%}


% delta function
eps = 1;
exponents = exp( -diffs/(eps*eps));
distances = exponents / (sqrt(pi)*eps);


%{
exponents = exp(-diffs);
denoms = sum(exponents, 2);
distances = exponents./repmat(denoms, 1, size(diffs,2));
%}