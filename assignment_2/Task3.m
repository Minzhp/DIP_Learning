clc;clear;
I = imread('lena512.bmp');
[m, n] = size(I);
I_noise = uint8(zeros([m, n, 100]));
for i = 1:100
    I_noise(:, :, i) = imnoise(I, 'gaussian');%100�Ÿ�˹����ͼ��
end

I_denoising = uint8(zeros([m, n, 100]));
MSE = zeros([1, 100]);
PSNR = zeros([1, 100]);
for i = 1:100
    I_denoising(:, :, i) = uint8(mean(I_noise(:, :, 1:i), 3));%��ǰi������ͼ��ƽ��ȥ��
    MSE(i) = sum(sum((double(I_denoising(:, :, i)) - double(I)) .^ 2)) / (m * n);%��i��ƽ��ȥ������ԭͼ��MSE
    PSNR(i) = 20 * log10(255 / (sqrt(MSE(i))));%��i��ƽ��ȥ������ԭͼ��PSNR
end

figure();
subplot(2, 1, 1);
plot(PSNR);
title('PSNR');
subplot(2, 1, 2);
plot(MSE);
title('MSE');

figure();
subplot(2, 2, 1);
imshow(I_noise(:, :, 1));
title('����ͼ��')
subplot(2, 2, 2);
imshow(I_denoising(:, :, 5));
title('���ƽ��ȥ��');
subplot(2, 2, 3);
imshow(I_denoising(:, :, 25));
title('25��ƽ��ȥ��');
subplot(2, 2, 4);
imshow(I_denoising(:, :, 100));
title('100��ƽ��ȥ��');