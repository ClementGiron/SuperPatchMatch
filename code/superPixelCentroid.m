function [MapCentroid] = superPixelCentroid(L, NumLabels)
% SuperPixelCentroid takes as argument the results of SuperPixels decomp.
% Returns a Numlabels*2 matrix where each line i are centroid coordinates
% of superpixel i

for i = 1:NumLabels
    superPix = L==i;
    c = regionprops(true(size(superPix)), superPix,  'WeightedCentroid');
    MapCentroid(i, 1) = round(c.WeightedCentroid(1));
    MapCentroid(i, 2) = round(c.WeightedCentroid(2));
end

end

