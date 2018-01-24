%% Cell 1: Parameters
% Superpixel radius
R = 50;
% Iterations of SPM
N_iter = 6;
% Random search decay parameter
alpha = 0.5;
% alpha parameter in segmentation
alphaLabel = 2;
% beta parameter in segmentation
betaLabel = 4;
% Use "myGradient" or HOG features
hogBool = true;
% step in HOG calculation
step = 1;
% Number of bins in "myGradient" features
bins = 12;


%% Cell 2: Compute ANN between 2 images

% images
nomIm1 = 'Aaron_Peirsol_0001';
nomIm2 = 'Aaron_Peirsol_0002';

% Load images, superpixels, labels
A = imread(strcat('./faces/', nomIm1, '.jpg'));
LabelsA = importdata(strcat('./labels/', nomIm1, '.dat'));
B = imread(strcat('./faces/', nomIm2, '.jpg'));
LA = importdata(strcat('./pixels/', nomIm1, '.dat')) + 1;
NumLabelsA = max(max(LA));
LB = importdata(strcat('./pixels/', nomIm2, '.dat')) + 1;
NumLabelsB = max(max(LB));

% Display images and superpixels decomposition
figure(1);
BWA = boundarymask(LA);
BWB = boundarymask(LB);
subplot(1,2,1);
imshow(imoverlay(A,BWA,'green'),'InitialMagnification',100);
subplot(1,2,2);
imshow(imoverlay(B,BWB,'green'),'InitialMagnification',100);

% compute centroids, features, neighbors, patches...
CA = superPixelCentroid(LA, NumLabelsA);
CB = superPixelCentroid(LB, NumLabelsB);
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

% Parameters
h = size(A, 2);
sigma1 = 1/2*sqrt(size(A,1)*size(A,2)/NumLabelsA);
sigma2 = sqrt(2)*R;

% Compute the ANN
[ANN, PatchDistMatrix] = SuperPatchMatch(A, LA, NumLabelsA, NumLabelsB, CA, CB, PreviousA, NextA, NeighborsB, FA, FB, SPA, SPB, sigma1, sigma2, h, N_iter, alpha);

% Compare a random sample of 8 superpixels and their ANN
randomSampleComparison(A, B, LA, LB, NumLabelsA, ANN, 8);


%% Cell 3: Compute K-ANN of an image with a choosen set of images and segment this image

% image
nomIm1 = 'Aaron_Peirsol_0002';
A = imread(strcat('./faces/', nomIm1, '.jpg'));
LabelsA = importdata(strcat('./labels/', nomIm1, '.dat'));
trueLab = LabelsA(2:size(LabelsA,1))+1;
LA = importdata(strcat('./pixels/', nomIm1, '.dat')) + 1;
NumLabelsA = max(max(LA));

% Parameters
h = size(A, 2);
sigma1 = 1/2*sqrt(size(A,1)*size(A,2)/NumLabelsA);
sigma2 = sqrt(2)*R;
hogBool = true;

% Compute the K-ANN and segmentation
trainData = ["Aaron_Peirsol_0001", "Aaron_Peirsol_0003", "Ahmet_Demir_0001",...
    "Aaron_Sorkin_0002", "Ahmed_Lopez_0001", "Aidan_Quinn_0001",...
    "Adrian_Nastase_0002", "Ahmed_Chalabi_0004", "Adolfo_Aguilar_Zinser_0003",...
    "George_W_Bush_0353"];
lab = kANNLabeling(nomIm1, trainData, R, h, sigma1, sigma2, N_iter, alpha, step, bins, alphaLabel, betaLabel, hogBool);

% Evaluate the segmentation
CM = confusionMatrix(lab, trueLab)
[accuracy, precision, recall, f1score] = scores(CM)
Utrue = colorizeSegments(A, LA, NumLabelsA, trueLab);
Upred = colorizeSegments(A, LA, NumLabelsA, lab);
figure(3);
subplot(1,2,1);
imshow(Utrue);
subplot(1,2,2);
imshow(Upred);


%% Cell 4: Compute segmentations of a given set of images using K-ANN with a given training set

% Parameters
h = 250;
sigma1 = 1/2*sqrt(250*250/NumLabelsA);
sigma2 = sqrt(2)*R;
hogBool = false;

% datasets
toSegment = ["Abdullah_0003", "Abel_Pacheco_0003", "Adam_Sandler_0001",...
    "Adam_Scott_0002", "Adolfo_Rodriguez_Saa_0001", "Ai_Sugiyama_0002", "Aicha_El_Ouafi_0001",...
    "Akbar_Al_Baker_0001", "Al_Gore_0006", "Alan_Ball_0001", "Alan_Trammell_0001",...
    "Alberto_Fujimori_0001", "Alec_Baldwin_0002", "Alec_Baldwin_0003","Alejandro_Lopez_0001",...
    "Alex_Barros_0001", "Alex_King_0001", "Alex_Sink_0002", "Alex_Wallau_0001", "Alexa_Loren_0001"];
trainData = ["Aaron_Peirsol_0001", "Aaron_Peirsol_0003", "Ahmet_Demir_0001",...
    "Aaron_Sorkin_0002", "Ahmed_Lopez_0001", "Aidan_Quinn_0001",...
    "Adrian_Nastase_0002", "Ahmed_Chalabi_0004", "Adolfo_Aguilar_Zinser_0003",...
    "George_W_Bush_0353"];

% Compute segmentations and evaluate
[CM, CMs, accuracy, precision, recall, f1score] = multipleSegmentations(toSegment, trainData, R, h, sigma1, sigma2, N_iter, alpha, step, bins, alphaLabel, betaLabel, hogBool)


%% Cell 5: Compute segmentations of several random images using K-ANN with random sets of images

% Parameters
Nbseg = 1;
K = 8;
h = size(A, 2);
sigma1 = 1/2*sqrt(size(A,1)*size(A,2)/NumLabelsA);
sigma2 = sqrt(2)*R;

% Compute segmentations and evaluate
[CM, accuracy, precision, recall, f1score] = randomMultipleSegmentations(Nbseg, K, R, h, sigma1, sigma2, N_iter, alpha, step, bins, alphaLabel, betaLabel, hogBool)


%% Cell 6: Color transfer

% images: A is the target, B is the source
A = imresize(imread('bois.jpg'), [256 256]);  % resize to reduce computational time
B = imresize(imread('galaxy.jpg'), [256 256]);

% Superpixel decomposition
[LA,NumLabelsA] = superpixels(A,130);
[LB,NumLabelsB] = superpixels(B,130);

% Parameters
R = 50;
h = size(A, 2);
sigma1 = 1/2*sqrt(size(A,1)*size(A,2)/NumLabelsA);
sigma2 = sqrt(2)*R;
N_iter = 20;
alpha = 0.5;
eps = 3;
delta_s = 10;
delta_c = 0.1;

% Utils
CA = superPixelCentroid(LA, NumLabelsA);
CB = superPixelCentroid(LB, NumLabelsB);
scanOrderA = scanOrder(LA, NumLabelsA);
scanOrderB = scanOrder(LB, NumLabelsB);
[PreviousA, NextA] = superPixelNeighbors(LA, NumLabelsA, scanOrderA);
NeighborsA = NextA + PreviousA;
[PreviousB, NextB] = superPixelNeighbors(LB, NumLabelsB, scanOrderB);
NeighborsB = NextB + PreviousB;
FA = ColorHistFeatures(A, LA, NumLabelsA);
FB = ColorHistFeatures(B, LB, NumLabelsB);
SPA = superPatches(CA, R);
SPB = superPatches(CB, R);

% SuperPatchMatch: compute the eps-ANN
[ANN, PatchDistMatrix] = SuperPatchMatchRestricted(A, LA, NumLabelsA, NumLabelsB, CA, CB, PreviousA, NextA, NeighborsB, FA, FB, SPA, SPB, sigma1, sigma2, h, N_iter, alpha, eps);
% Compute descriptors matrices for pixels and superpixels
[Adesc, Pixdesc] = computeAdesc(A, LA, NumLabelsA);
% Compute mean color of the superpixels of the source
[meanColorsB] = superPixelMeanColor(B, LB, NumLabelsB);
% Compute Q matrices (for Mahalanobis distance)
[Q, Qinv] = Qmatrices(Adesc, NumLabelsA, delta_s, delta_c);
% Perform color transfer
U = SuperPixelColorTransfer(A, B, LA, NumLabelsA, ANN, Adesc, Pixdesc, Qinv, meanColorsB);