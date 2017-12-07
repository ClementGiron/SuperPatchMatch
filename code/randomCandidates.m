function [idxCandidates] = randomCandidates(idB, CB, R, alpha)
% randomCandidate searches candidates for the ANN of Ai on a square
% centered on B(i) and with side length R. At each iteration, sample
% another candidate by reducing the length of the square.
% Input: index/label of Ai's ANN B(i) (idB), centroids CB, side of the
% square (R)
% Output: randomly sampled candidate; 0 if none possible

CBbis = abs(CB - CB(idB, :));
centroidsL1Dist = max(CBbis, [], 2);
k = 1;
continuing = true;
while continuing
    candidates = find((centroidsL1Dist <= R) & (centroidsL1Dist > 0));
    if not(isempty(candidates))
        idxCandidates(k) = randsample(candidates, 1);
        k = k+1;
        R = alpha*R;
    else
        continuing = false;
    end
end

