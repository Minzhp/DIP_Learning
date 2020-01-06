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
a = [a1, a2, a3, a4];
b = [b1, b2, b3, b4];
k = 4;
l = length(a);
x0 = unidrnd(l, 1, k);
y0 = unidrnd(l, 1, k);
centerCur = [a(x0);b(y0)]';
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