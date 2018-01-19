function [confMat] = confusionMatrix(labPred, labTrue)
% confusionMatrix computes the confusion matrix, given a vector of
% predicted labels and a ground truth vector

confMat = zeros(3, 3);

for i=1:length(labPred)
    confMat(labPred(i), labTrue(i)) = confMat(labPred(i), labTrue(i)) + 1;
end

end

