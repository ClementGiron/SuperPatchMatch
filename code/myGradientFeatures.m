function [F] = myGradientFeatures(A, L, NumLabels, bins)
% myGradientFeatures takes as arguments image A, superPixels L, NumLabels,
% number of desired bins
% Returns a matrix where each line i is the normalized sum of gradient
% intensities with respect to gradient orientations

F = zeros(NumLabels, bins);

[Gmag1, Gdir1] = imgradient(A(:,:,1));
[Gmag2, Gdir2] = imgradient(A(:,:,2));
[Gmag3, Gdir3] = imgradient(A(:,:,3));
GdirRad1 = Gdir1*(pi/180)+pi;
GdirRad2 = Gdir2*(pi/180)+pi;
GdirRad3 = Gdir3*(pi/180)+pi;
GmagMax = max(Gmag1, max(Gmag2, Gmag3));
mask1 = (Gmag1 == GmagMax);
mask2 = (Gmag2 == GmagMax).*(1 - mask1);
mask3 = (Gmag3 == GmagMax).*(1 - mask1).*(1 - mask2);
GdirMax = GdirRad1.*mask1 + GdirRad2.*mask2 + GdirRad3.*mask3;
Gbin = floor(GdirMax*bins/(2*pi)) + 1;

for i=(1:size(A,1))
    for j=(1:size(A,2))
        spix = L(i,j);
        F(spix, Gbin(i,j)) = GdirMax(i,j);
    end
end


end

