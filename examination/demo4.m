clc, clear;
a1 = normrnd(1, 0.3, 1, 100);
b1 = normrnd(1, 0.3, 1, 100);
a2 = normrnd(1, 0.3, 1, 100);
b2 = normrnd(6, 0.3, 1, 100);
a3 = normrnd(6, 0.3, 1, 100);
b3 = normrnd(4, 0.3, 1, 100);
a4 = normrnd(6, 0.3, 1, 100);
b4 = normrnd(8, 0.3, 1, 100);
figure();
scatter([a1, a2, a3, a4], [b1, b2, b3, b4], '*');

%%
imageU = [[a1, a2, a3, a4];[b1, b2, b3, b4]]';
imageUL = 400;
sigma = zeros([1, imageUL]);
rho = zeros([1, imageUL]);
k0 = round(0.04 * imageUL);
dis = zeros([1, imageUL]);
for i = 1:imageUL
    for j = 1:imageUL
        dis(j) = sum((imageU(j, :) - imageU(i, :)) .^ 2) .^ 0.5;
    end
    disSort = sort(reshape(dis, 1, imageUL));
    rho(i) = exp(1 / (sum(disSort(1:k0)) + 0.000001));
end
for i = 1:imageUL
    for j = 1:imageUL
        dis(j) = sum((imageU(j, :) - imageU(i, :)) .^ 2) .^ 0.5;
    end
    if (rho(i) == max(rho))
        sigma(i) = max(dis);
    else
        sigma(i) = min(dis(rho > rho(i)));
    end
end
a_0 = -0.2;
a_1 = 0.001;
sigmaF = a_0 + a_1 .* (1 ./ rho);
sigma0 = sigmaF - sigma;
sigma0 = sigma0 - mean(sigma0);
centerCur = imageU(repmat((abs(sigma0') > 2), 1, 2));
k = length(centerCur') / 2;
centerCur = reshape(centerCur, k, 2);
figure();stem(rho,sigma);
figure();stem(sigma0);

%%
a = [a1, a2, a3, a4];
b = [b1, b2, b3, b4];
% k = 4;
l = length(a);
x0 = unidrnd(l, 1, k);
y0 = unidrnd(l, 1, k);
centerPre = zeros(size(centerCur));
mark = zeros([1, l]);
while abs(sum(abs(centerCur - centerPre), 'all')) > 0.005
    for i = 1:l
       dis = ((centerCur(:, 1) - a(i)) .^ 2 + (centerCur(:, 2) - b(i)) .^ 2) .^ 0.5;
       [~, index] = sort(dis);
       mark(i) = index(1);
    end
    centerPre = centerCur;
    for i = 1:length(centerCur(:, 1))
        centerCur(i, :) = [mean(a(mark == i), 'all'), mean(b(mark == i), 'all')];
    end
    drawCluster(2, [a;b]', mark, centerCur);
    
    disp(centerCur);
end