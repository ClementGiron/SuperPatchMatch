function [U] = SuperPixelColorTransfer(A, B, L, NumLabels, ANN, Adesc, Pdesc, Qinv, meanColors)
% SuperPixelColorTransfer computes the SCT of image A given its ANN with an
% image B

U = zeros(size(A));
meanColorsANN = zeros(NumLabels, 3);
for i=1:NumLabels
    meanColorsANN(i, :) = meanColors(ANN(i,2), :);
end

for px=1:size(A, 1)
    for py=1:size(A, 2)
        spix = L(px,py);
        logwVec = logw(px, py, spix, Pdesc, Adesc, Qinv, NumLabels);
        w = exp(logwVec);
        
        color = sum(meanColorsANN.*w)/sum(w)/255;
        U(px, py, 1) = color(1);
        U(px, py, 2) = color(2);
        U(px, py, 3) = color(3);
    end
    px
end

Ad = double(A)/255;
Bd = double(B)/255;
figure(1);
subplot(1,4,1);
imshow(Ad);
title('Target')
subplot(1,4,2);
imshow(Bd);
title('Source')
subplot(1,4,3);
imshow(U);
title('Color transfer')
subplot(1,4,4);
regU = regrain(Ad, U);
imshow(regU);
title('Color transfer + regrain')

end

