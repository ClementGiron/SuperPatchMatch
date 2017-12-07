function [learnedLabels] = kANNLabeling(nameA, namesT, R, h, sigma1, sigma2, N_iter, alpha, step, alphaLabel, betaLabel)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

A = imread(strcat('./faces/', nameA, '.jpg'));
LA = importdata(strcat('./pixels/', nameA, '.dat')) + 1;
LabelsA = importdata(strcat('./labels/', nameA, '.dat'));
NumLabelsA = LabelsA(1);
figure(1); imshow(A);
CA = superPixelCentroid(LA, NumLabelsA);
[PreviousA, NextA] = superPixelNeighbors(LA, NumLabelsA, CA);
NeighborsA = NextA + PreviousA;
FA = HoGFeatures(A, LA, NumLabelsA, step);
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
    [PreviousB, NextB] = superPixelNeighbors(LB, NumLabelsB, CB);
    NeighborsB = NextB + PreviousB;
    FB = HoGFeatures(B, LB, NumLabelsB, step);
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

