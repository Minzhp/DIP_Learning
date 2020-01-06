clc;clear;
I = imread('cameraman.tif');
imshow(I);

%%
%（1）人工选择法
T1 = 78;
[ht, t] = imhist(I);
figure();
stem(t, ht, 'LineStyle', '-', 'Marker', 'none');
xlim([min(t), max(t)]);
hold on;
stem(T1, ht(T1), 'Marker', 'o');
xticks(T1);
hold off;
I1 = I > T1;
figure();imshow(I1);

%%
%（2）迭代式阈值选择法
[ht, t] = imhist(I);
T2_pre = round(mean([min(t), (max(t))]));
while 1
    u1 = sum(ht(t <= T2_pre) .* t(t <= T2_pre)) / sum(ht(t <= T2_pre));
    u2 = sum(ht(t > T2_pre) .* t(t > T2_pre)) / sum(ht(t > T2_pre));
    T2 = round(mean([u1, u2]));
    if abs(T2 - T2_pre) <= 1
        break;
    end
    T2_pre = T2;
end
I2 = I > T2;
figure();imshow(I2);

%%
%（3）最大类间方差阈值选择法
%代码实现
[ht, t] = imhist(I);
N = sum(ht);
L = length(ht);
p = ht / N;
sigma2 = zeros([1, L]);
for i = 1:L
    k = t(i);
    omega0 = sum(p(t < k));
    omega1 = sum(p(t >= k));
    if omega0 == 0 || omega1 == 0
        sigma2(i) = 0;
    else
        mu0 = sum(p(t < k) .* t(t < k)) / omega0;
        mu1 = sum(p(t >= k) .* t(t >= k)) / omega1;
        sigma2(i) = omega0 * omega1 * (mu0 - mu1) ^ 2;
        disp([k, omega0, omega1, mu0, mu1, sigma2(i)]);
    end
end
[~, index] = max(sigma2);
T3 = t(index);
I3 = I > T3;
figure();imshow(I3);
%graythresh函数实现
T4 = graythresh(I) * 255;
I4 = I > T4;
figure();imshow(I4);
