function [CM, accuracy, precision, recall, f1score] = randomMultipleSegmentations(Nbseg, K, R, h, sigma1, sigma2, N_iter, alpha, step, bins, alphaLabel, betaLabel, hogBool)
% perform Nbseg segmentations using K-ANN
% outputs: classical classification scores

CM = zeros(3,3);

for i=1:Nbseg
    [name, lab] = randomCompareSegment(K, R, h, sigma1, sigma2, N_iter, alpha, step, bins, alphaLabel, betaLabel, hogBool);
    labels = importdata(strcat('./labels/', name, '.dat'));
    trueLab = labels(2:size(labels,1))+1;
    CM = CM + confusionMatrix(lab, trueLab);
end

[accuracy, precision, recall, f1score] = scores(CM);

end

