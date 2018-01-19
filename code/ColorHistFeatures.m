function [Features] = ColorHistFeatures(A, L, NumLabels)
% HistFeatures takes as arguments image A, superPixels L, NumLabels
% Returns a matrix where each line i is the empirical distribution function
% of the pixels in the superPixel i

Features = zeros(NumLabels, 256, 3);
A = double(A);
A1 = A(:, :, 1);
A2 = A(:, :, 2);
A3 = A(:, :, 3);

for i = 1:NumLabels
    hc1 = histcounts(A1(L==i), 0:256);
    hc2 = histcounts(A2(L==i), 0:256);
    hc3 = histcounts(A3(L==i), 0:256);
    Features(i, :, 1) = cumsum(hc1)/sum(hc1);
    Features(i, :, 2) = cumsum(hc2)/sum(hc2);
    Features(i, :, 3) = cumsum(hc3)/sum(hc3);
end


end

