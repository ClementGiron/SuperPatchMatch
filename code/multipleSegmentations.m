function [CM, CMs, accuracy, precision, recall, f1score] = multipleSegmentations(toSegment, trainData, R, h, sigma1, sigma2, N_iter, alpha, step, bins, alphaLabel, betaLabel, hogBool)
% perform segmentations of toSegment images using K-ANN and trainData
% outputs: classical classification scores

CM = zeros(3,3);
CMs = zeros(3,3,length(toSegment));
i = 1;
for name=toSegment
    lab = kANNLabeling(char(name), trainData, R, h, sigma1, sigma2, N_iter, alpha, step, bins, alphaLabel, betaLabel, hogBool);
    labels = importdata(strcat('./labels/', char(name), '.dat'));
    trueLab = labels(2:size(labels,1))+1;
    CMi = confusionMatrix(lab, trueLab);
    CMs(:,:,i) = CMi;
    i = i+1;
    CM = CM + CMi;
    name
    CMi
end

[accuracy, precision, recall, f1score] = scores(CM);

end

