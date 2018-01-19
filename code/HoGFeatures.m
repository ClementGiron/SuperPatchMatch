function [F] = HoGFeatures(A, L, NumLabels, step)
% HoGFeatures takes as arguments image A, superPixels L, NumLabels, step
% Returns a matrix where each line i is the mean of HOGs
% of the pixels in the superPixel i

[Lx, Ly] = size(A);
nx = floor((Lx-1)/step)+1;
ny = floor((Ly-1)/step)+1;
points = zeros(nx*ny, 2);
k = 1;
for i=1:step:Lx
    for j=1:step:Ly
        points(k, 1) = i;
        points(k, 2) = j;
        k = k+1;
    end
end

[hogFeatures, effectivePoints] = extractHOGFeatures(A, points, 'CellSize', [5 5], 'NumBins', 27);
F = zeros(NumLabels, size(hogFeatures, 2));
countPoints = zeros(NumLabels, 1);

for i=1:size(effectivePoints, 1)
    pixelLabel = L(effectivePoints(i, 2), effectivePoints(i, 1));
    F(pixelLabel, :) = F(pixelLabel, :) + hogFeatures(i, :);
    countPoints(pixelLabel) = countPoints(pixelLabel) + 1;
end

countPoints = max(countPoints, 1);
F = F./countPoints;

% for ch = 1:3
%     for i = 1:NumLabels
%         hog = HOG(double(A(:,:,ch)) .* (L == i));
%         Features(i, :, ch) = hog';
%     end
% end

end

