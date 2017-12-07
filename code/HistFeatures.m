function [Features] = HoGFeatures(A, L, NumLabels)
% HistFeatures takes as arguments image A, superPixels L, NumLabels
% Returns a matrix where each line i is the empirical distribution function
% of the pixels in the superPixel i

Features = zeros(NumLabels, 81, 3);
A = double(A);

for ch = 1:3
    for i = 1:NumLabels
        hog = HOG(double(A(:,:,ch)) .* (L == i));
        Features(i, :, ch) = hog';
    end
end

end

