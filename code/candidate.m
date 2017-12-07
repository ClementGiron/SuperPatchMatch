function [pixC] = candidate(pixACenter, pixA, pixB, CA, CB, NeighborsB)
% For an ANN A'_i <=> B(i'), compute the best candidate C(i') adjacent to
% B(i') relatively to the angle
% Input: center of the superPatch (pixACenter), neighbor (pixA), ANN of the neighbor (pixB),
% centroids (CA, CB), adjacency matrices (NeighborsB)
% Output: label of the best candidate C(i')

refVect = CA(pixA, :) - CA(pixACenter, :);
refAngle = atan2d(refVect(2), refVect(1))*pi/180;
candidates = find(NeighborsB(pixB, :)==1);
candidatesCenters = CB(NeighborsB(pixB, :)==1, :);
candidatesCentered = candidatesCenters - CB(pixB,:);
angles = atan2d(candidatesCentered(:, 2), candidatesCentered(:, 1))*pi/180;
%testAngles = [abs(refAngle + pi - angles); 2*pi - abs(refAngle + pi - angles)];
testAngles = [mod((refAngle + pi - angles), 2*pi); mod(-(refAngle + pi - angles), 2*pi)];
[m, bestIdx] = min(testAngles);
if bestIdx > size(candidates,2)
    bestIdx = bestIdx - size(candidates,2);
end
pixC = candidates(bestIdx);
end

