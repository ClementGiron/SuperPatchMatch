nomIm1 = 'Aaron_Peirsol_0002';
nomIm2 = 'Aaron_Peirsol_0002';
A = imread(strcat('./faces/', nomIm1, '.jpg'));
B = imread(strcat('./faces/', nomIm2, '.jpg'));
LA = importdata(strcat('./pixels/', nomIm1, '.dat')) + 1;
NumLabelsA = max(max(LA));
LB = importdata(strcat('./pixels/', nomIm2, '.dat')) + 1;
NumLabelsB = max(max(LB));
figure(1);
BWA = boundarymask(LA);
BWB = boundarymask(LB);
subplot(1,2,1);
imshow(imoverlay(A,BWA,'green'),'InitialMagnification',100);
subplot(1,2,2);
imshow(imoverlay(B,BWB,'green'),'InitialMagnification',100);
R = 50;
step = 3;
h = size(A, 2);
CA = superPixelCentroid(LA, NumLabelsA);
CB = superPixelCentroid(LB, NumLabelsB);
% hold on
% subplot(1, 2, 1);
% scatter(CA(:,1), CA(:,2), 50, 'r.');
% subplot(1, 2, 2);
% scatter(CB(:,1), CB(:,2), 50, 'r.');
% hold off
[PreviousA, NextA] = superPixelNeighbors(LA, NumLabelsA, CA);
NeighborsA = NextA + PreviousA;
[PreviousB, NextB] = superPixelNeighbors(LB, NumLabelsB, CB);
NeighborsB = NextB + PreviousB;
FA = HoGFeatures(A, LA, NumLabelsA, step);
FB = HoGFeatures(B, LB, NumLabelsB, step);
SPA = superPatches(CA, R);
SPB = superPatches(CB, R);
sigma1 = 1/2*sqrt(size(A,1)*size(A,2)/NumLabelsA);
sigma2 = sqrt(2)*R;


N_iter = 6;
alpha = 0.5;
alphaLabel = 2;
betaLabel = 4;
%[ANN, PatchDistMatrix] = SuperPatchMatch(A, LA, NumLabelsA, NumLabelsB, CA, CB, PreviousA, NextA, NeighborsB, FA, FB, SPA, SPB, sigma1, sigma2, h, N_iter, alpha);
lab = kANNLabeling(nomIm1, ["Aaron_Peirsol_0001", "Aaron_Peirsol_0003", "Aaron_Sorkin_0002", "Ahmed_Lopez_0001", "Aidan_Quinn_0001", "Adrian_Nastase_0002", "Ahmed_Chalabi_0004"], R, h, sigma1, sigma2, N_iter, alpha, step, alphaLabel, betaLabel)