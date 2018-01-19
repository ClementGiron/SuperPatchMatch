function [logwVec] = logw(px, py, SPix, Pixdesc, Adesc, Qinv, NumLabels)
% logw returns a vector where element i is the log of the weight w(p, A_i)
% as it is described in the section 2.3 of the color transfer paper

logwVec = zeros(NumLabels, 1);
Qiinv = Qinv(:, :, SPix);
p = Pixdesc(:, px, py);

for i=1:NumLabels
    Ajmean = mean(Adesc{i})';
    logwVec(i) = -(p - Ajmean)'*Qiinv*(p - Ajmean);
end

logwVec = logwVec + min(-logwVec);

end

