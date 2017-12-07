function [ANN, PatchDistMatrix] = SuperPatchMatch(A, LA, NumLabelsA, NumLabelsB, CA, CB, PreviousA, NextA, NeighborsB, FA, FB, SPA, SPB, sigma1, sigma2, h, N_iter, alpha)
% The SuperPatchMatch algorithm

% initialize
scanOrderA = scanOrder(LA, NumLabelsA);
flipScanOrderA = fliplr(scanOrderA);
ANN = randomAssignment(NumLabelsA, NumLabelsB);
PatchDistMatrix = - ones(NumLabelsA, NumLabelsB);

for i = 1:N_iter
    i
    figure(2);
    colorGoodMatch(A, ANN, LA, 0, 191, 255);
    if mod(i,2)
        % even iteration: search candidates nearby previous neighbors
        for sPixA = scanOrderA
            prevNeighborsA = find(PreviousA(sPixA, :)==1);
            sPixB = ANN(sPixA, 2);
            if PatchDistMatrix(sPixA, sPixB) == -1
                PatchDistMatrix(sPixA, sPixB) = superPatchDistance(sPixA, sPixB, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
            end
            currentDist = PatchDistMatrix(sPixA, sPixB);
            for pnA = prevNeighborsA
                pnB = ANN(pnA, 2);
                sPixC = candidate(sPixA, pnA, pnB, CA, CB, NeighborsB);
                if PatchDistMatrix(sPixA, sPixC) == -1
                    PatchDistMatrix(sPixA, sPixC) = superPatchDistance(sPixA, sPixC, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
                end
                newDist = PatchDistMatrix(sPixA, sPixC);
                if newDist < currentDist
                    ANN(sPixA, 2) = sPixC;
                    currentDist = newDist;
                end
            end
            % random search
            sampleCandidates = randomCandidates(ANN(sPixA,2), CB, h, alpha);
            for sPixC = sampleCandidates
                if PatchDistMatrix(sPixA, sPixC) == -1
                    PatchDistMatrix(sPixA, sPixC) = superPatchDistance(sPixA, sPixC, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
                end
                newDist = PatchDistMatrix(sPixA, sPixC);
                if newDist < currentDist
                    ANN(sPixA, 2) = sPixC;
                    currentDist = newDist;
                end
            end
        end
    else
        % odd iterations: search candidate nearby next neighbors
        for sPixA = flipScanOrderA
            nextNeighborsA = find(NextA(sPixA, :)==1);
            sPixB = ANN(sPixA, 2);
            if PatchDistMatrix(sPixA, sPixB) == -1
               PatchDistMatrix(sPixA, sPixB) = superPatchDistance(sPixA, sPixB, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
            end
            currentDist = PatchDistMatrix(sPixA, sPixB);
            for pnA = nextNeighborsA
                pnB = ANN(pnA, 2);
                sPixC = candidate(sPixA, pnA, pnB, CA, CB, NeighborsB);
                if PatchDistMatrix(sPixA, sPixC) == -1
                    PatchDistMatrix(sPixA, sPixC) = superPatchDistance(sPixA, sPixC, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
                end
                newDist = PatchDistMatrix(sPixA, sPixC);
                if newDist < currentDist
                    ANN(sPixA, 2) = sPixC;
                    currentDist = newDist;
                end
            end
            % random search
            sampleCandidates = randomCandidates(ANN(sPixA,2), CB, h, alpha);
            for sPixC = sampleCandidates
                if PatchDistMatrix(sPixA, sPixC) == -1
                    PatchDistMatrix(sPixA, sPixC) = superPatchDistance(sPixA, sPixC, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
                end
                newDist = PatchDistMatrix(sPixA, sPixC);
                if newDist < currentDist
                    ANN(sPixA, 2) = sPixC;
                    currentDist = newDist;
                end
            end
        end
    end
end
end

