clc;clear;
I = imread('lena512.bmp');
[m, n] = size(I);
[hr, ~] = imhist(I);
pr = hr / (m * n);
s = cumsum(pr) * 255;
I_ = I;
for i = 1:m
    for j = 1:n
        I_(i, j) = uint8(s(I(i, j) + 1));
    end
end

figure();
subplot(2, 2, 1);
imshow(I);
title('原图');
subplot(2, 2, 2);
imhist(I);
title('灰度直方图');
subplot(2, 2, 3);
imshow(I_);
title('直方图均衡化后');
subplot(2, 2, 4);
imhist(I_);
title('灰度直方图');




