function [U] = colorizeSegments(A, LA, NumLabelsA, LabelsA)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

U = A;

for i=1:NumLabelsA
    label = LabelsA(i);
    Umod = U(:,:,label);
    Umod(LA==i) = 255;
    U(:,:,label) = Umod;
end

end

