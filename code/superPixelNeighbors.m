function [MapPrevious, MapNext] = superPixelNeighbors(L, NumLabels, C)
% superPixelNeighbors take as argument L and NumLabels, and centroids C
% Returns two matrices
% The first one contains ones in line i column j if superPixel i
% has j as a previous neighbor (up and left)
% The second makes the same with next neighbors (right and down)

MapPrevious = zeros(NumLabels);

for i = 1:(size(L, 1)-1)
    for j = 1:(size(L, 2)-1)
        if (L(i,j) ~= L(i, j+1)) && (C(L(i,j), 1) < C(L(i,j+1), 1)) && (MapPrevious(L(i,j), L(i,j+1)) == 0)
            MapPrevious(L(i,j+1), L(i,j)) = 1;
        end
        if L(i,j) ~= L(i+1, j) && (C(L(i,j), 2) < C(L(i+1,j), 2)) && (MapPrevious(L(i,j), L(i+1,j)) == 0)
            MapPrevious(L(i+1,j), L(i,j)) = 1;
        end
    end
end

% handle last column
for i = 1:(size(L, 1)-1)
    j = size(L, 2);
    if L(i,j) ~= L(i+1, j) && (C(L(i,j), 2) < C(L(i+1,j), 2)) && (MapPrevious(L(i,j), L(i+1,j)) == 0)
        MapPrevious(L(i+1,j), L(i,j)) = 1;
    end
end

% handle last row
for j = 1:(size(L, 2)-1)
    i = size(L, 1);
    if L(i,j) ~= L(i, j+1) && (C(L(i,j), 1) < C(L(i,j+1), 1)) && (MapPrevious(L(i,j+1), L(i,j)) == 0)
        MapPrevious(L(i,j+1), L(i,j)) = 1;
    end
end
MapNext = transpose(MapPrevious);
end

