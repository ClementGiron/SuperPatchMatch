function [] = colorGoodMatch(A, ANN, LA, R, G, B)
% colorGoodMatch colorizes superPixels where the ANN is right when trying
% to match an image with itself
% Input: image A, its ANN, its superPixel decomposition LA, desired color
% R, G, B

pixToColor = find(ANN(:, 1) == ANN(:, 2))';
U = A;
for p = pixToColor
    U = colorSuperPixel(U, LA, p, R, G, B);
end

imshow(U)

end

