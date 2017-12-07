function [ANN] = randomAssignment(NumLabelsA, NumLabelsB)
% Assign randomly each superpixel of A to a superPixel of B
% Input: number of superPixels in image A (NumLabelsA) and image B
% (NumLabelsB)
% Output: (NumLabelsA x 2)-Matrix (ANN) where first column is superPixel in
% A and column 2 is the corresponding superLabel in B

ANN = zeros(NumLabelsA, 2);
ANN(:, 1) = 1:NumLabelsA;
ANN(:, 2) = datasample(1:NumLabelsB, NumLabelsA, 'Replace', true);

end

