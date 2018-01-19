function [ANN, PatchDistMatrix] = SuperPatchMatchRestricted(A, LA, NumLabelsA, NumLabelsB, CA, CB, PreviousA, NextA, NeighborsB, FA, FB, SPA, SPB, sigma1, sigma2, h, N_iter, alpha, eps)
% The SuperPatchMatch algorithm

scanOrderA = scanOrder(LA, NumLabelsA);
flipScanOrderA = fliplr(scanOrderA);
ANN = randomAssignment(NumLabelsA, NumLabelsB);
PatchDistMatrix = - ones(NumLabelsA, NumLabelsB);
countANN = zeros(NumLabelsB, 1);

for i=1:NumLabelsB
    countANN(i) = sum(ANN(:,2)==i);
end

for i = 1:N_iter
    i
    if mod(i,2)
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
                    if countANN(sPixC) < eps
                        ANN(sPixA, 2) = sPixC;
                        currentDist = newDist;
                        countANN(sPixB) = countANN(sPixB)-1;
                        countANN(sPixC) = countANN(sPixC)+1;
                    else
                        alreadyMatched = find(ANN(:,2)==sPixC)';
                        for AM = alreadyMatched
                            k = 1;
                            Costs = zeros(size(AM));
                            if PatchDistMatrix(AM, sPixB) == -1
                                PatchDistMatrix(AM, sPixB) = superPatchDistance(AM, sPixB, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
                            end
                            if PatchDistMatrix(AM, sPixC) == -1
                                PatchDistMatrix(AM, sPixC) = superPatchDistance(AM, sPixC, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
                            end
                            Costs(k) = newDist - currentDist + PatchDistMatrix(AM, sPixB) - PatchDistMatrix(AM, sPixC);
                            k = k+1;
                        end
                        [argmin, valmin] = min(Costs);
                        if valmin < 0
                            sPixChange = alreadyMatched(argmin);
                            ANN(sPixChange, 2) = sPixB;
                            ANN(sPixA, 2) = sPixC;
                            currentDist = newDist;
                        end
                    end
                end
            end
            sampleCandidates = randomCandidates(ANN(sPixA,2), CB, h, alpha);
            for sPixC = sampleCandidates
                if PatchDistMatrix(sPixA, sPixC) == -1
                    PatchDistMatrix(sPixA, sPixC) = superPatchDistance(sPixA, sPixC, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
                end
                newDist = PatchDistMatrix(sPixA, sPixC);
                if newDist < currentDist
                    if countANN(sPixC) < eps
                        ANN(sPixA, 2) = sPixC;
                        currentDist = newDist;
                        countANN(sPixB) = countANN(sPixB)-1;
                        countANN(sPixC) = countANN(sPixC)+1;
                    else
                        alreadyMatched = find(ANN(:,2)==sPixC)';
                        for AM = alreadyMatched
                            k = 1;
                            Costs = zeros(size(AM));
                            if PatchDistMatrix(AM, sPixB) == -1
                                PatchDistMatrix(AM, sPixB) = superPatchDistance(AM, sPixB, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
                            end
                            if PatchDistMatrix(AM, sPixC) == -1
                                PatchDistMatrix(AM, sPixC) = superPatchDistance(AM, sPixC, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
                            end
                            Costs(k) = newDist - currentDist + PatchDistMatrix(AM, sPixB) - PatchDistMatrix(AM, sPixC);
                            k = k+1;
                        end
                        [argmin, valmin] = min(Costs);
                        if valmin < 0
                            sPixChange = alreadyMatched(argmin);
                            ANN(sPixChange, 2) = sPixB;
                            ANN(sPixA, 2) = sPixC;
                            currentDist = newDist;
                        end
                    end
                end
            end
        end
    else
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
                    if countANN(sPixC) < eps
                        ANN(sPixA, 2) = sPixC;
                        currentDist = newDist;
                        countANN(sPixB) = countANN(sPixB)-1;
                        countANN(sPixC) = countANN(sPixC)+1;
                    else
                        alreadyMatched = find(ANN(:,2)==sPixC)';
                        for AM = alreadyMatched
                            k = 1;
                            Costs = zeros(size(AM));
                            if PatchDistMatrix(AM, sPixB) == -1
                                PatchDistMatrix(AM, sPixB) = superPatchDistance(AM, sPixB, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
                            end
                            if PatchDistMatrix(AM, sPixC) == -1
                                PatchDistMatrix(AM, sPixC) = superPatchDistance(AM, sPixC, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
                            end
                            Costs(k) = newDist - currentDist + PatchDistMatrix(AM, sPixB) - PatchDistMatrix(AM, sPixC);
                            k = k+1;
                        end
                        [argmin, valmin] = min(Costs);
                        if valmin < 0
                            sPixChange = alreadyMatched(argmin);
                            ANN(sPixChange, 2) = sPixB;
                            ANN(sPixA, 2) = sPixC;
                            currentDist = newDist;
                        end
                    end
                end
            end
            sampleCandidates = randomCandidates(ANN(sPixA,2), CB, h, alpha);
            for sPixC = sampleCandidates
                if PatchDistMatrix(sPixA, sPixC) == -1
                    PatchDistMatrix(sPixA, sPixC) = superPatchDistance(sPixA, sPixC, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
                end
                newDist = PatchDistMatrix(sPixA, sPixC);
                if newDist < currentDist
                    if countANN(sPixC) < eps
                        ANN(sPixA, 2) = sPixC;
                        currentDist = newDist;
                        countANN(sPixB) = countANN(sPixB)-1;
                        countANN(sPixC) = countANN(sPixC)+1;
                    else
                        alreadyMatched = find(ANN(:,2)==sPixC)';
                        for AM = alreadyMatched
                            k = 1;
                            Costs = zeros(size(AM));
                            if PatchDistMatrix(AM, sPixB) == -1
                                PatchDistMatrix(AM, sPixB) = superPatchDistance(AM, sPixB, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
                            end
                            if PatchDistMatrix(AM, sPixC) == -1
                                PatchDistMatrix(AM, sPixC) = superPatchDistance(AM, sPixC, SPA, SPB, FA, FB, CA, CB, sigma1, sigma2);
                            end
                            Costs(k) = newDist - currentDist + PatchDistMatrix(AM, sPixB) - PatchDistMatrix(AM, sPixC);
                            k = k+1;
                        end
                        [argmin, valmin] = min(Costs);
                        if valmin < 0
                            sPixChange = alreadyMatched(argmin);
                            ANN(sPixChange, 2) = sPixB;
                            ANN(sPixA, 2) = sPixC;
                            currentDist = newDist;
                        end
                    end
                end
            end
        end
    end
end
end

