function [nameSeg, lab] = randomCompareSegment(N, R, h, sigma1, sigma2, N_iter, alpha, step, bins, alphaLabel, betaLabel, hogBool)
% segment a random choosen image using N random other images where
% segmentation is known

listNames = ls('labels/');
listNames = listNames(3:length(listNames), :);
pick = randsample(1:length(listNames), N+1, false);

for i=1:(N+1)
    spl = strsplit(listNames(pick(i), :), '.');
    name = spl(1);
    nameStr = name{1};
    clearNames(i) =  string(nameStr);
end

nameSeg = clearNames(1);
bench = clearNames(2:N+1);
lab = kANNLabeling(char(nameSeg), bench, R, h, sigma1, sigma2, N_iter, alpha, step, bins, alphaLabel, betaLabel, hogBool);
end

