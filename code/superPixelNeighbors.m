function [MapPrevious, MapNext] = superPixelNeighbors(L, NumLabels, scanOrder)
% superPixelNeighbors take as argument L and NumLabels, and scan order
% Returns two matrices
% The first one contains ones in line i column j if superPixel i
% has j as a previous neighbor (up and left)
% The second makes the same with next neighbors (right and down)

MapPrevious = zeros(NumLabels);

for i = 1:(size(L, 1)-1)
    for j = 1:(size(L, 2)-1)
        if L(i,j) ~= L(i, j+1)
            so = find(scanOrder == L(i,j));
            so2 = find(scanOrder == L(i,j+1));
            if so < so2
                MapPrevious(L(i,j+1), L(i,j)) = 1;
            else
                MapPrevious(L(i,j), L(i,j+1)) = 1;
            end
        end
        if L(i,j) ~= L(i+1, j)
            so = find(scanOrder == L(i,j));
            so2 = find(scanOrder == L(i+1,j));
            if so < so2
                MapPrevious(L(i+1,j), L(i,j)) = 1;
            else
                MapPrevious(L(i,j), L(i+1,j)) = 1;
            end
        end
    end
end

MapNext = transpose(MapPrevious);
end

