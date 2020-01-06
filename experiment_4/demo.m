clc;clear;
image = (double(imread('lena512.bmp'))) / 255;
[m, n] = size(image);
figure(1);imshow(image, []);title('原图像')



%%
%添加高斯噪声并复原
imageNoise1 = imnoise(image, 'gaussian');

%M*N邻域平滑
M1 = 3;
N1 = 3;

%MATLAB自带函数实现均值去噪
imageDenoise1 = imfilter(imageNoise1, fspecial('average', [M1, N1]));

%%代码实现均值去噪
% imageDenoise1 = image;
% for i = (M1 + 1) / 2:m - (M1 - 1)
%     for j = (N1 + 1) / 2:n - (N1 - 1)
%         imageDenoise1(i, j) = mean(imageNoise1(i - (M1 - 1) / 2:i + (M1 - 1) / 2,...
%             j - (N1 - 1) / 2:j + (N1 - 1) / 2), 'all');
%         imageDenoise1(i, j) = mean(imageNoise1(i - (M1 - 1) / 2:i + (M1 - 1) / 2,...
%             j - (N1 - 1) / 2:j + (N1 - 1) / 2), 'all');
%     end
% end

figure(2);
subplot(1, 2, 1);imshow(imageNoise1, []); title('加高斯噪声');
subplot(1, 2, 2);imshow(imageDenoise1, []); title([num2str(M1), '*', num2str(N1), '邻域平滑']);

disp(newline);
disp(['加高斯噪声后', num2str(M1), '*', num2str(N1), '邻域平滑']);
disp(['PSNR:', num2str(imPSNR(image, imageDenoise1))]);
disp(['SSIM:', num2str(imSSIM(image, imageDenoise1))]);



%%
%添加椒盐噪声并复原
imageNoise2 = imnoise(image, 'salt & pepper');

%M*N窗口中值滤波
M2 = 3;
N2 = 3;

%MATLAB自带函数实现中值去噪
imageDenoise2 = medfilt2(imageNoise2, [M2, N2]);

%%代码实现中值去噪
% imageDenoise2 = image;
% for i = (M2 + 1) / 2:m - (M2 - 1)
%     for j = (N2 + 1) / 2:n - (N2 - 1)
%         imageDenoise2(i, j) = median(imageNoise2(i - (M2 - 1) / 2:i + (M2 - 1) / 2,...
%             j - (N2 - 1) / 2:j + (N2 - 1) / 2), 'all');
%         imageDenoise2(i, j) = median(imageNoise2(i - (M2 - 1) / 2:i + (M2 - 1) / 2,...
%             j - (N2 - 1) / 2:j + (N2 - 1) / 2), 'all');
%     end
% end

figure(3);
subplot(1, 2, 1);imshow(imageNoise2, []); title('加椒盐噪声');
subplot(1, 2, 2);imshow(imageDenoise2, []); title([num2str(M2), '*', num2str(N2), '窗口中值去噪']);

disp(newline);
disp(['加椒盐噪声后', num2str(M2), '*', num2str(N2), '窗口中值去噪']);
disp(['PSNR:', num2str(imPSNR(image, imageDenoise2))]);
disp(['SSIM:', num2str(imSSIM(image, imageDenoise2))]);



%%
%添加运动模糊并复原
blur = fspecial('motion', 25, 11);
imageBlur = imfilter(image, blur, 'circular');

%逆滤波
blurFft1 = fft2(blur, m, n);
imageBlurFft1 = fft2(imageBlur);
imageDeblurFft1 = imageBlurFft1 ./ blurFft1;
imageDeblur1 = ifft2(imageDeblurFft1);
figure(4);
subplot(1, 2, 1);imshow(imageBlur, []);title('加运动模糊');
subplot(1, 2, 2);imshow(imageDeblur1, []);title('直接逆滤波');

disp(newline);
disp('加运动模糊后直接逆滤波');
disp(['PSNR:', num2str(imPSNR(image, imageDeblur1))]);
disp(['SSIM:', num2str(imSSIM(image, imageDeblur1))]);


%添加噪声后逆滤波
imageBlurNoise = imnoise(imageBlur, 'gaussian');
blurFft2 = fft2(blur, m, n);
imageBlurFft2 = fft2(imageBlurNoise);
imageDeblurFft2 = imageBlurFft2 ./ blurFft2;
imageDeblur2 = ifft2(imageDeblurFft2);
figure(5);
subplot(1, 2, 1);imshow(imageBlurNoise, []);title('加运动模糊及高斯噪声');
subplot(1, 2, 2);imshow(imageDeblur2, []);title('直接逆滤波');

disp(newline);
disp('加运动模糊及高斯噪声后直接逆滤波');
disp(['PSNR:', num2str(imPSNR(image, imageDeblur2))]);
disp(['SSIM:', num2str(imSSIM(image, imageDeblur2))]);


%维纳滤波
imageDeblur3 = deconvwnr(imageBlur, blur, 0);
figure(6);
subplot(1, 2, 1);imshow(imageBlur, []);title('加运动模糊');
subplot(1, 2, 2);imshow(imageDeblur3, []);title('维纳滤波');

disp(newline);
disp('加运动模糊后维纳滤波（不带参数）');
disp(['PSNR:', num2str(imPSNR(image, imageDeblur3))]);
disp(['SSIM:', num2str(imSSIM(image, imageDeblur3))]);


%添加噪声后维纳滤波（噪信比）
nsr = sum((image - imageBlurNoise) .^ 2, 'all') ./ sum(image .^ 2, 'all');
imageDeblur4 = deconvwnr(imageBlurNoise, blur, nsr);
figure(7);
subplot(1, 2, 1);imshow(imageBlurNoise, []);title('加运动模糊及高斯噪声');
subplot(1, 2, 2);imshow(imageDeblur4, []);title('加入噪信比维纳滤波');

disp(newline);
disp('加运动模糊及高斯噪声后维纳滤波（噪信比）');
disp(['PSNR:', num2str(imPSNR(image, imageDeblur4))]);
disp(['SSIM:', num2str(imSSIM(image, imageDeblur4))]);


%添加噪声后维纳滤波（自相关函数）
ncorr = abs(ifft2(abs(fft2((imageBlurNoise - image))) .^ 2));
icorr = abs(ifft2(abs(fft2((image))) .^ 2));
imageDeblur5 = deconvwnr(imageBlurNoise, blur, ncorr, icorr);
figure(8);
subplot(1, 2, 1);imshow(imageBlurNoise, []);title('加运动模糊及高斯噪声');
subplot(1, 2, 2);imshow(imageDeblur5, []);title('加入自相关函数维纳滤波');

disp(newline);
disp('加运动模糊及高斯噪声后维纳滤波（自相关函数）');
disp(['PSNR:', num2str(imPSNR(image, imageDeblur5))]);
disp(['SSIM:', num2str(imSSIM(image, imageDeblur5))]);
