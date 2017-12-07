function [logw] = superPixelsMatchingLogWeight(Apix, Bpix, ApixCenter, BpixCenter, CA, CB, sigma1, sigma2)
% superPixelMatchingLogWeight Input:
% Apix = label of superPixel evaluated in A
% Bpix = label of superPixel evaluated in B
% ApixCenter = label of superPixel center of patch in A
% BpixCenter = label of superPixel center of patch in B
% CA = centroids of superPixels in image A
% CB = centroids of superPixels in image B
% sigma1, sigma2 = scale parameters
% Output : logw = log of the weight of the matching of the two superpixels

x = CA(Apix, :) - CB(Bpix, :) + CB(BpixCenter, :) - CA(ApixCenter, :);
logw = -sum(x.^2)/(sigma1^2) + superPixelLogWeight(Apix, ApixCenter, CA, sigma2) + superPixelLogWeight(Bpix, BpixCenter, CB, sigma2);

end

