%实现图像熵的计算
clc;clear;
I = imread('lena512.bmp');
I = double(I);
[m, n] = size(I);
I = reshape(I, [1, m * n]);
per = hist(I, unique(I)) ./ (m * n);
% tab = tabulate(I);per = tab(:, 3);

H = -sum(per .* log(per));
disp(H);