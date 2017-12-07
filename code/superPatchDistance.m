function [D] = superPatchDistance(patchA, patchB, superPatchesA, superPatchesB, FA, FB, CA, CB, sigma1, sigma2)
% Compute the distance between patchA and patchB
% Input: indexes of superPatch in A (patchA) and in B (patchB),
% superPatches matrices (superPatchesA, superPathesB), features matrices
% (FA, FB), centroids (CA, CB), normalization constants (sigma1, sigma2)

num = 0;
denom = 0;
patchAPixels = find(superPatchesA(patchA, :) == 1);
patchBPixels = find(superPatchesB(patchB, :) == 1);
%patchAPixels = [patchA];
%patchBPixels = [patchB];
for i = patchAPixels
     %possibleNum = ones(1,length(patchBPixels));
     %possibleDenom = ones(1,length(patchBPixels));
    for j = patchBPixels
       w = exp(superPixelsMatchingLogWeight(i, j, patchA, patchB, CA, CB, sigma1, sigma2));
       num = num + w*FeaturesDist(FA(i,:), FB(j,:));
            %possibleNum(j) = w*FeaturesDist(FA(i,:,ch), FB(j,:,ch));
       denom = denom + w;
       %possibleDenom(j) = w;
    end
     %[m, idx] = min(possibleNum);
     %num = num + m;
     %denom = denom + possibleDenom(idx);
end
D = num/denom;
D = D/(length(patchBPixels)*length(patchAPixels));

end
