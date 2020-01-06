clc;clear;
I = imread('lena512.bmp');
[m, n] = size(I);
I_g = imnoise(I, 'gaussian');
I_s = imnoise(I, 'salt & pepper');
I_gf = I_g;
I_sf = I_s;
M = 3;
N = 3;
%M*N邻域平滑
for i = (M + 1) / 2:m - (M - 1)
    for j = (N + 1) / 2:n - (N - 1)
        I_gf(i, j) = mean(I_g(i - (M - 1) / 2:i + (M - 1) / 2,...
            j - (N - 1) / 2:j + (N - 1) / 2), 'all');
        I_sf(i, j) = mean(I_s(i - (M - 1) / 2:i + (M - 1) / 2,...
            j - (N - 1) / 2:j + (N - 1) / 2), 'all');
    end
end

I_g_PSNR = imPSNR(I, I_gf);
I_g_SSIM = imSSIM(I, I_gf);
I_s_PSNR = imPSNR(I, I_sf);
I_s_SSIM = imSSIM(I, I_sf);

figure();
subplot(2, 2, 1);
imshow(I);
title('原图');
subplot(2, 2, 2);
imshow(I_g);
title('加入高斯噪声');
subplot(2, 2, 3);
imshow(I_gf);
title('去噪结果');
subplot(2, 2, 4);
text(.5, .5, {['PSNR:  ', num2str(I_g_PSNR)];['SSIM:  ', num2str(I_g_SSIM)]}, 'FontSize',14,'HorizontalAlignment','center');

figure();
subplot(2, 2, 1);
imshow(I);
title('原图');
subplot(2, 2, 2);
imshow(I_s);
title('加入椒盐噪声');
subplot(2, 2, 3);
imshow(I_sf);
title('去噪结果');
subplot(2, 2, 4);
text(.5, .5, {['PSNR:  ', num2str(I_s_PSNR)];['SSIM:  ', num2str(I_s_SSIM)]}, 'FontSize',14,'HorizontalAlignment','center');

