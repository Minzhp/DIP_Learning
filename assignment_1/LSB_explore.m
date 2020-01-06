clear;clc;
C = imread('lena512.bmp');
M = imread('ctgu256.bmp');
[m, n] = size(M);
M_data = reshape(M, 1, m * n);
% C_M = LSB_embed(C, M_data);

%%
%加入椒盐噪声
% C_M_ = imnoise(C_M, 'salt & pepper');
% M_data_ = LSB_extract(C_M_);
% M_ = reshape(M_data_(1:m * n), m, n);
% figure();
% subplot(2, 2, 1);
% imshow(C);
% title('载体图像');
% subplot(2, 2, 2);
% imshow(M);
% title('秘密信息');
% subplot(2, 2, 3);
% imshow(C_M_);
% title('载密图像');
% subplot(2, 2, 4);
% imshow(M_);
% title('提取出的秘密信息');

%%
%加入高斯噪声
% C_M_ = imnoise(C_M, 'gaussian');
% M_data_ = LSB_extract(C_M_);
% M_ = reshape(M_data_(1:m * n), m, n);
% figure();
% subplot(2, 2, 1);
% imshow(C);
% title('载体图像');
% subplot(2, 2, 2);
% imshow(M);
% title('秘密信息');
% subplot(2, 2, 3);
% imshow(C_M_);
% title('载密图像');
% subplot(2, 2, 4);
% imshow(M_);
% title('提取出的秘密信息');

%%
%椒盐噪声与高斯噪声比较
% I = uint8(ones(256)) .* 128;
% I_s = imnoise(I, 'salt & pepper');
% I_g = imnoise(I, 'gaussian');
% subplot(3, 2, 1);imshow(I);
% subplot(3, 2, 2);imhist(I);
% subplot(3, 2, 3);imshow(I_s);
% subplot(3, 2, 4);imhist(I_s);
% subplot(3, 2, 5);imshow(I_g);
% subplot(3, 2, 6);imhist(I_g);

%%
%嵌入到第七位
% B = uint8(ones([1, 256 * 256]) * 7);
% C_M = LSB_explore_embed(C, M_data, B);
% C_M = imnoise(C_M, 'gaussian');
% M_data_ = LSB_explore_extract(C_M, B, 256 * 256);
% M_ = reshape(M_data_, [256, 256]);
% figure();
% subplot(2, 2, 1);
% imshow(C);
% title('载体图像');
% subplot(2, 2, 2);
% imshow(M);
% title('秘密信息');
% subplot(2, 2, 3);
% imshow(C_M);
% title('载密图像');
% subplot(2, 2, 4);
% imshow(M_);
% title('提取出的秘密信息');

%%
%使用平均去噪去高斯噪声
B = uint8(ones([1, 256 * 256]) * 4);
C_M = LSB_explore_embed(C, M_data, B);
C_M_noise = uint8(zeros([512, 512, 100]));
for i = 1:100
    C_M_noise(:, :, i) = imnoise(C_M, 'gaussian');
end
C_M_denoising = uint8(mean(C_M_noise, 3));
M_data_ = LSB_explore_extract(C_M_denoising, B, 256 * 256);
M_ = reshape(M_data_, [256, 256]);
figure();
subplot(2, 2, 1);
imshow(C);
title('载体图像');
subplot(2, 2, 2);
imshow(M);
title('秘密信息');
subplot(2, 2, 3);
imshow(C_M_denoising);
title('100次平均去噪后的载密图像');
subplot(2, 2, 4);
imshow(M_);
title('提取出的秘密信息');

%%
%