function [logw] = superPixelLogWeight(pixelLabel, patchPixelLabel, C, sigma)
% superPixelWeight takes as argument the label of the superPixel, the 
% label of the superPixel which is the center of the SuperPatch, the
% centroids and the scale constraints
% it returns the log of the associated weight w

logw = - norm(C(pixelLabel,:) - C(patchPixelLabel,:))^2/(sigma^2);

end

