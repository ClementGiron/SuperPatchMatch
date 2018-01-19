function [learnedLabels] = kANNLabeling(nameA, namesT, R, h, sigma1, sigma2, N_iter, alpha, step, bins, alphaLabel, betaLabel, hogBool)
% kANNLabeling gives labels to the superpixels of an image using k-ANN
% hogBool : 1 if hog features, 0 if myGradientFeatures

A = imread(strcat('./faces/', nameA, '.jpg'));
LA = importdata(strcat('./pixels/', nameA, '.dat')) + 1;
LabelsA = importdata(strcat('./labels/', nameA, '.dat'));
NumLabelsA = LabelsA(1);
figure(1); imshow(A);
CA = superPixelCentroid(LA, NumLabelsA);
scanOrderA = scanOrder(LA, NumLabelsA);
[PreviousA, NextA] = superPixelNeighbors(LA, NumLabelsA, scanOrderA);
NeighborsA = NextA + PreviousA;

if hogBool
    FA = HoGFeatures(A, LA, NumLabelsA, step);
else
    FA = myGradientFeatures(A, LA, NumLabelsA, bins);
end
SPA = superPatches(CA, R);

distMat = zeros(NumLabelsA, length(namesT));
labelMat = zeros(NumLabelsA, length(namesT));
weightLabels = zeros(NumLabelsA, 3);
learnedLabels = zeros(NumLabelsA, 1);
nname = 0;
ANNTs = zeros(NumLabelsA, 2, length(namesT));
for name = namesT
    nname = nname+1;
    fprintf(strcat('Processing image  ', name, '...\n'));
    B = imread(char(strcat('./faces/', name, '.jpg')));
    LB = importdata(strcat('./pixels/', name, '.dat')) + 1;
    LabelsB = importdata(strcat('./labels/', name, '.dat'));
    NumLabelsB = LabelsB(1);
    LabelsB = LabelsB(2:size(LabelsB, 1))+1;
    figure(1); imshow(B);
    CB = superPixelCentroid(LB, NumLabelsB);
    CTs{nname} = CB;
    scanOrderB = scanOrder(LB, NumLabelsB);
    [PreviousB, NextB] = superPixelNeighbors(LB, NumLabelsB, scanOrderB);
    NeighborsB = NextB + PreviousB;
    if hogBool
        FB = HoGFeatures(B, LB, NumLabelsB, step);
    else
        FB = myGradientFeatures(B, LB, NumLabelsB, bins);
    end
    SPB = superPatches(CB, R);
    [ANN, PatchDistMatrix] = SuperPatchMatch(A, LA, NumLabelsA, NumLabelsB, CA, CB, PreviousA, NextA, NeighborsB, FA, FB, SPA, SPB, sigma1, sigma2, h, N_iter, alpha);
    ANNTs(:, :, nname) = ANN;
    for j = 1:NumLabelsA
        l = LabelsB(ANN(j,2));
        labelMat(j, nname) = l;
        distMat(j, nname) = PatchDistMatrix(j, ANN(j,2));
    end
end

for i=1:(size(distMat,1))
    hA = min(distMat(i,:));
    for j=1:(length(namesT))
        l = labelMat(i, j);
        weightLabels(i, l) = weightLabels(i, l) + exp(1 - (distMat(i,j)/(alphaLabel^2*hA) + norm(CA(i,:) - CTs{j}(ANNTs(i,2),:))/betaLabel^2));
    end
end


for j=1:NumLabelsA
    labs = find(weightLabels(j,:) == max(weightLabels(j,:)));
    learnedLabels(j) = labs(1);
end

end

