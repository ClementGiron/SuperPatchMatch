function [meanColors] = superPixelMeanColor(A, L, NumLabels)
% superPixelMeanColor computes the mean of the color of each superpixel
% the result is a NumLabels*3 matrix where the i-th row contains the mean
% color of the i-th superpixel

meanColors = zeros(NumLabels, 3);
A1 = A(:, :, 1);
A2 = A(:, :, 2);
A3 = A(:, :, 3);

for i=1:NumLabels
    mask = (L == i);
    meanColors(i, :) = [mean(A1(mask)), mean(A2(mask)), mean(A3(mask))];
end

end

