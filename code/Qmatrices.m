function [Q, Qinv] = Qmatrices(Adesc, NumLabels, delta_s, delta_c)
% Qmatrices returns a 3 dimensions tensor where each channel is the Q matrix
% corresponding to superpixel i (as descibed in section 2.3 of the color
% transfer article) and a 3 dimensions tensor where each channel is the
% inverse of the corresponding channel in the other tensor

Q = zeros(5, 5, NumLabels);
Qinv = zeros(5, 5, NumLabels);

for i=1:NumLabels
    covX = cov(Adesc{i}(:, 1:2));
    covC = cov(Adesc{i}(:, 3:5));
    Q(:, :, i) = blkdiag(delta_s^2*covX, delta_c^2*covC);
    Qinv(:, :, i) = inv(Q(:, :, i));
end

end

