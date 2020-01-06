clc;clear;
I = imread('cameraman.tif');
I = imbinarize(I, graythresh(I));
figure();imshow(I);title('cameraman二值化图像');
I = ~I;
figure();imshow(I);title('cameraman二值化图像取反');
%代码实现边界提取
[m, n] = size(I);
Ie1 = zeros([m, n]);
for i = 2:m - 1
    for j = 2:n - 1
        Ie1(i, j) = sum(I(i - 1:i + 1, j - 1:j + 1), 'all') == 9;
    end
end
Ib1 = abs(I - Ie1);
figure();imshow(Ie1);title('代码实现腐蚀结果');
figure();imshow(Ib1);title('代码实现边界提取');
%函数实现边界提取
se = strel('square', 3);
Ie2 = imerode(I, se);
Ib2 = abs(I - Ie2);
figure();imshow(Ie2);title('函数实现腐蚀结果');
figure();imshow(Ib2);title('函数实现边界提取');