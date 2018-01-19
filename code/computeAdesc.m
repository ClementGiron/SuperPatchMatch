function [Adesc, Pixdesc] = computeAdesc(A, L, NumLabels)
% computeAdesc computes the descriptors of each superpixel and each pixel of A, as
% described at section 2.3 of the paper "SuperPixel Based Color Transfer"
% The descriptor is an object, each cell is a matrix containing 5 columns
% and numpixel(i) rows

Adesc = cell(NumLabels, 1);
Pixdesc = zeros(5, size(A,1), size(A,2));

for ch=1:NumLabels
    [row, col] = find(L == ch);
    Adescch = zeros(length(row), 5);
    Adescch(:, 1) = row/size(A,1);
    Adescch(:, 2) = col/size(A,2);
    for k=1:length(row)
        d1 = double(A(row(k), col(k), 1))/255;
        d2 = double(A(row(k), col(k), 2))/255;
        d3 = double(A(row(k), col(k), 3))/255;
        Adescch(k,3) = d1;
        Adescch(k,4) = d2;
        Adescch(k,5) = d3;
        Pixdesc(:, row(k), col(k)) = [(row(k)/size(A,1)), (col(k)/size(A,2)), d1, d2, d3];
    end
    Adesc{ch} = Adescch;
end

end