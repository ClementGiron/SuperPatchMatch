function [accuracy, precision, recall, f1score] = scores(confMat)
% Scores computes classification scores (accuracy, precision, recall,
% f1-score) given a 3x3 confusion matrix

accuracy = (confMat(1, 1) + confMat(2,2) + confMat(3,3))/sum(sum(confMat));
precision = zeros(3, 1);
recall = zeros(3, 1);

for i=1:3
    precision(i) = confMat(i, i)/sum(confMat(:, i));
    recall(i) = confMat(i, i)/sum(confMat(i, :));
end

f1score = 2*(precision .* recall)./(precision + recall);

end

