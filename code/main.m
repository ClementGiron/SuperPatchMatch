nomIm1 = 'Aaron_Peirsol_0002';
nomIm2 = 'Aaron_Peirsol_0002';
A = imread(strcat('./faces/', nomIm1, '.jpg'));
LabelsA = importdata(strcat('./labels/', nomIm1, '.dat'));
trueLab = LabelsA(2:size(LabelsA,1))+1;
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
saveas(gcf, 'superpixeldecomp.jpg');
R = 50;
step = 1;
h = size(A, 2);
CA = superPixelCentroid(LA, NumLabelsA);
CB = superPixelCentroid(LB, NumLabelsB);
% hold on
% subplot(1, 2, 1);
% scatter(CA(:,1), CA(:,2), 50, 'r.');
% subplot(1, 2, 2);
% scatter(CB(:,1), CB(:,2), 50, 'r.');
% hold off
scanOrderA = scanOrder(LA, NumLabelsA);
scanOrderB = scanOrder(LB, NumLabelsB);
[PreviousA, NextA] = superPixelNeighbors(LA, NumLabelsA, scanOrderA);
NeighborsA = NextA + PreviousA;
[PreviousB, NextB] = superPixelNeighbors(LB, NumLabelsB, scanOrderB);
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
bins = 12;
hogBool = true;
%[ANN, PatchDistMatrix] = SuperPatchMatch(A, LA, NumLabelsA, NumLabelsB, CA, CB, PreviousA, NextA, NeighborsB, FA, FB, SPA, SPB, sigma1, sigma2, h, N_iter, alpha);

lab = kANNLabeling(nomIm1, ["Aaron_Peirsol_0001", "Aaron_Peirsol_0003", "Aaron_Sorkin_0002", "Ahmed_Lopez_0001", "Aidan_Quinn_0001", "Adrian_Nastase_0002", "Ahmed_Chalabi_0004", "Adolfo_Aguilar_Zinser_0003", "Abdullah_0004", "George_W_Bush_0353"], R, h, sigma1, sigma2, N_iter, alpha, step, bins, alphaLabel, betaLabel, hogBool);
CM = confusionMatrix(lab, trueLab)
[accuracy, precision, recall, f1score] = scores(CM)
Utrue = colorizeSegments(A, LA, NumLabelsA, trueLab);
Upred = colorizeSegments(A, LA, NumLabelsA, lab);
figure(4);
subplot(1,2,1);
imshow(Utrue);
subplot(1,2,2);
imshow(Upred);

[name, lab] = randomCompareSegment(10, R, h, sigma1, sigma2, N_iter, alpha, step, bins, alphaLabel, betaLabel, hogBool)
labels = importdata(strcat('./labels/', name, '.dat'));
trueLab = LabelsA(2:size(LabelsA,1))+1
Nbseg = 20;
K = 10;
[CM, accuracy, precision, recall, f1score] = multipleSegmentations(Nbseg, K, R, h, sigma1, sigma2, N_iter, alpha, step, bins, alphaLabel, betaLabel, hogBool)