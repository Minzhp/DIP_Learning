clc;clear;
image = (double(imread('rice.png'))) / 255;
figure(1);imshow(image);



%%
%添加高斯噪声并使用局部平滑法去噪
imageGaussianNoise1 = imnoise(image, 'gaussian');

%M*N邻域平滑
M1 = 3;
N1 = 3;

imageGaussianDenoise1 = imfilter(imageGaussianNoise1, fspecial('average', [M1, N1]));

figure(2);
subplot(1, 2, 1);imshow(imageGaussianNoise1, []); title('加高斯噪声');
subplot(1, 2, 2);imshow(imageGaussianDenoise1, []); title([num2str(M1), '*', num2str(N1), '邻域平滑']);



%%
%添加高斯噪声并使用超限像素平滑

M2 = 3;
N2 = 3;

imageGaussianNoise2 = imnoise(image, 'gaussian');
image_ = imfilter(imageGaussianNoise2, fspecial('average', [M2, N2]));
thresholdGaissian = 0.08;
imageGaussianDenoise2 = (abs(imageGaussianNoise2-image_) > thresholdGaissian) .* image_ + (abs(imageGaussianNoise2-image_) <= thresholdGaissian) .* imageGaussianNoise2;

figure(3);
subplot(1, 2, 1);imshow(imageGaussianNoise2, []); title('加高斯噪声');
subplot(1, 2, 2);imshow(imageGaussianDenoise2, []); title([num2str(M2), '*', num2str(N2), '邻域超限像素平滑（阈值', num2str(thresholdGaissian), ')']);



%%
%添加椒盐噪声并使用局部平滑法去噪
imageSaltpepperNoise1 = imnoise(image, 'salt & pepper');

%M*N邻域平滑
M3 = 3;
N3 = 3;

imagesaltpepperDenoise1 = imfilter(imageSaltpepperNoise1, fspecial('average', [M3, N3]));

figure(4);
subplot(1, 2, 1);imshow(imageSaltpepperNoise1, []); title('加椒盐噪声');
subplot(1, 2, 2);imshow(imagesaltpepperDenoise1, []); title([num2str(M3), '*', num2str(N3), '邻域平滑']);



%%
%添加椒盐噪声并使用超限像素平滑

M4 = 3;
N4 = 3;

imageSaltpepperNoise2 = imnoise(image, 'salt & pepper');
image_ = imfilter(imageSaltpepperNoise2, fspecial('average', [M4, N4]));
thresholdSaltpepper = 0.3;
imageSaltpepperDenoise2 = (abs(imageSaltpepperNoise2-image_) > thresholdSaltpepper) .* image_ + (abs(imageSaltpepperNoise2-image_) <= thresholdSaltpepper) .* imageSaltpepperNoise2;

figure(5);
subplot(1, 2, 1);imshow(imageSaltpepperNoise2, []); title('加椒盐噪声');
subplot(1, 2, 2);imshow(imageSaltpepperDenoise2, []); title([num2str(M4), '*', num2str(N4), '邻域超限像素平滑（阈值', num2str(thresholdSaltpepper), ')']);



%%
%添加椒盐噪声并使用中值去噪
imageSaltpepperNoise3 = imnoise(image, 'salt & pepper');

%M*N窗口
M5 = 3;
N5 = 3;

imageSaltpepperDenoise3 = medfilt2(imageSaltpepperNoise3, [M5, N5]);

figure(6);
subplot(1, 2, 1);imshow(imageSaltpepperNoise3, []); title('加椒盐噪声');
subplot(1, 2, 2);imshow(imageSaltpepperDenoise3, []); title([num2str(M5), '*', num2str(N5), '窗口中值去噪']);



%%
%拉普拉斯算子锐化
a = 1;
laplacianMask = [0, 1 * a, 0;
        1 * a, 1 + (-4) * a, 1 * a;
        0, 1 * a, 0];
image_laplacian = imfilter(image, laplacianMask);
figure(7);imshow(image_laplacian, []);



%%
%水平Prewitt算子和Sobel算子锐化
prewittMask1 = fspecial('prewitt');
sobelMask1 = fspecial('sobel');
image_prewitt1 = imfilter(image, prewittMask1);
image_sobel1 = imfilter(image, sobelMask1);
figure(8);
subplot(1, 2, 1);imshow(image_prewitt1 + image, []);title('prewitt水平边缘模板');
subplot(1, 2, 2);imshow(image_sobel1 + image, []);title('sobel水平边缘模板');



%%
%垂直Prewitt算子和Sobel算子锐化
prewittMask2 = fspecial('prewitt')';
sobelMask2 = fspecial('sobel')';
image_prewitt2 = imfilter(image, prewittMask2);
image_sobel2 = imfilter(image, sobelMask2);
figure(9);
subplot(1, 2, 1);imshow(image_prewitt2 + image, []);title('prewitt垂直边缘模板');
subplot(1, 2, 2);imshow(image_sobel2 + image, []);title('sobel垂直边缘模板');


