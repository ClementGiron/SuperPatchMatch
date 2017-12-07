function [S] = scanOrder(L, NumLabels)
% Compute the scan order of the superpixels of image decomposition
% input: image superpixel decomposition L, NumLabels
% output: scan order (list S)

visited = zeros(1, NumLabels);
S = zeros(1, NumLabels);
k = 1;

for i = 1:size(L,1)
    for j = 1:size(L,2)
        if (visited(L(i,j)) == 0)
            visited(L(i,j)) = 1;
            S(k) = L(i,j);
            k = k + 1;
        end
    end
end

end

