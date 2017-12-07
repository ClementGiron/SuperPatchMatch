function [D] = FeaturesDist(FA, FB)
% FeatureDist Input: FA: features vector of a superpixel
% FB: features vector of a superpixel
% Output: D: euclidian distance beetween features vectors

%D = pdist2(FA, FB);
D = norm(FA-FB);
end

