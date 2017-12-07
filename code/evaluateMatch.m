function [m] = evaluateMatch(ANN, C)
% evaluateMatch evaluates the ANN by computing the mean distance between the
% superPixels in A and their ANNs in B, and plots the histogram of
% distance between expected ANNs and observed ANNs

distances = C(ANN(:, 1), :) - C(ANN(:, 2), :);
size(distances)
m = sqrt(sum(sum(distances.^2)))/size(C,1);
hist(sqrt(sum(distances.^2,2)));
end

