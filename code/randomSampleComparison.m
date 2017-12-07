function [sampleANN] = randomSampleComparison(A, B, LA, LB, NumLabelsA, ANN, N)
% Compares a random sample of N superPixels of A with their ANN in B by
% plotting a colorization of these ANNs
% Input: image A, image B, superPixel decompositions LA and LB, number of 
% superPixels in A, ANN, and number of samples to color N

sample = datasample(1:NumLabelsA, N, 'Replace', false);

figure();
subplot(2,2,1);
imshow(A);
subplot(2,2,2);
imshow(B);
U = A;
V = B;

for i = 1:N
    colors = randi([0 255], 1, 3);
    R = colors(1); G = colors(2); B = colors(3);
    U = colorSuperPixel(U, LA, sample(i), R, G, B);
    V = colorSuperPixel(V, LB, ANN(sample(i),2), R, G, B);
end

subplot(2,2,3);
imshow(U);
subplot(2,2,4);
imshow(V);

sampleANN = ANN(sample,:);
end

