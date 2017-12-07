function [U] = colorSuperPixel(A, L, label, R, G, B)
% color a superPixel with given color
% Input: image A, decompoisition L, label of superPixel, color (R,G,B)
% Output: colored image U

U1 = A(:,:,1);
U1(L==label) = R;
U2 = A(:,:,2);
U2(L==label) = G;
U3 = A(:,:,3);
U3(L==label) = B;
U(:,:,1) = U1;
U(:,:,2) = U2;
U(:,:,3) = U3;

end

