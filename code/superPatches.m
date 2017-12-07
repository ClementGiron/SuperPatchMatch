function [P] = superPatches(C, R)
% Compute superPatches
% Input: centroids C, radius R
% Ouput: matrix P, P[i,j] = 1 if j superpixel j belongs to superPatch
% centered in i, 0 otherwise

P = zeros(size(C,1), size(C,1));

for i = 1:(size(C,1))
    P(i, :) = (transpose(sum((C - C(i,:)).^2, 2)) < R^2);
end

end

