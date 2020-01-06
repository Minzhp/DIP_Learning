clc;clear;
image = (double(imread('rice.png'))) / 255;
figure(1);imshow(image);



%%
%��Ӹ�˹������ʹ�þֲ�ƽ����ȥ��
imageGaussianNoise1 = imnoise(image, 'gaussian');

%M*N����ƽ��
M1 = 3;
N1 = 3;

imageGaussianDenoise1 = imfilter(imageGaussianNoise1, fspecial('average', [M1, N1]));

figure(2);
subplot(1, 2, 1);imshow(imageGaussianNoise1, []); title('�Ӹ�˹����');
subplot(1, 2, 2);imshow(imageGaussianDenoise1, []); title([num2str(M1), '*', num2str(N1), '����ƽ��']);



%%
%��Ӹ�˹������ʹ�ó�������ƽ��

M2 = 3;
N2 = 3;

imageGaussianNoise2 = imnoise(image, 'gaussian');
image_ = imfilter(imageGaussianNoise2, fspecial('average', [M2, N2]));
thresholdGaissian = 0.08;
imageGaussianDenoise2 = (abs(imageGaussianNoise2-image_) > thresholdGaissian) .* image_ + (abs(imageGaussianNoise2-image_) <= thresholdGaissian) .* imageGaussianNoise2;

figure(3);
subplot(1, 2, 1);imshow(imageGaussianNoise2, []); title('�Ӹ�˹����');
subplot(1, 2, 2);imshow(imageGaussianDenoise2, []); title([num2str(M2), '*', num2str(N2), '����������ƽ������ֵ', num2str(thresholdGaissian), ')']);



%%
%��ӽ���������ʹ�þֲ�ƽ����ȥ��
imageSaltpepperNoise1 = imnoise(image, 'salt & pepper');

%M*N����ƽ��
M3 = 3;
N3 = 3;

imagesaltpepperDenoise1 = imfilter(imageSaltpepperNoise1, fspecial('average', [M3, N3]));

figure(4);
subplot(1, 2, 1);imshow(imageSaltpepperNoise1, []); title('�ӽ�������');
subplot(1, 2, 2);imshow(imagesaltpepperDenoise1, []); title([num2str(M3), '*', num2str(N3), '����ƽ��']);



%%
%��ӽ���������ʹ�ó�������ƽ��

M4 = 3;
N4 = 3;

imageSaltpepperNoise2 = imnoise(image, 'salt & pepper');
image_ = imfilter(imageSaltpepperNoise2, fspecial('average', [M4, N4]));
thresholdSaltpepper = 0.3;
imageSaltpepperDenoise2 = (abs(imageSaltpepperNoise2-image_) > thresholdSaltpepper) .* image_ + (abs(imageSaltpepperNoise2-image_) <= thresholdSaltpepper) .* imageSaltpepperNoise2;

figure(5);
subplot(1, 2, 1);imshow(imageSaltpepperNoise2, []); title('�ӽ�������');
subplot(1, 2, 2);imshow(imageSaltpepperDenoise2, []); title([num2str(M4), '*', num2str(N4), '����������ƽ������ֵ', num2str(thresholdSaltpepper), ')']);



%%
%��ӽ���������ʹ����ֵȥ��
imageSaltpepperNoise3 = imnoise(image, 'salt & pepper');

%M*N����
M5 = 3;
N5 = 3;

imageSaltpepperDenoise3 = medfilt2(imageSaltpepperNoise3, [M5, N5]);

figure(6);
subplot(1, 2, 1);imshow(imageSaltpepperNoise3, []); title('�ӽ�������');
subplot(1, 2, 2);imshow(imageSaltpepperDenoise3, []); title([num2str(M5), '*', num2str(N5), '������ֵȥ��']);



%%
%������˹������
a = 1;
laplacianMask = [0, 1 * a, 0;
        1 * a, 1 + (-4) * a, 1 * a;
        0, 1 * a, 0];
image_laplacian = imfilter(image, laplacianMask);
figure(7);imshow(image_laplacian, []);



%%
%ˮƽPrewitt���Ӻ�Sobel������
prewittMask1 = fspecial('prewitt');
sobelMask1 = fspecial('sobel');
image_prewitt1 = imfilter(image, prewittMask1);
image_sobel1 = imfilter(image, sobelMask1);
figure(8);
subplot(1, 2, 1);imshow(image_prewitt1 + image, []);title('prewittˮƽ��Եģ��');
subplot(1, 2, 2);imshow(image_sobel1 + image, []);title('sobelˮƽ��Եģ��');



%%
%��ֱPrewitt���Ӻ�Sobel������
prewittMask2 = fspecial('prewitt')';
sobelMask2 = fspecial('sobel')';
image_prewitt2 = imfilter(image, prewittMask2);
image_sobel2 = imfilter(image, sobelMask2);
figure(9);
subplot(1, 2, 1);imshow(image_prewitt2 + image, []);title('prewitt��ֱ��Եģ��');
subplot(1, 2, 2);imshow(image_sobel2 + image, []);title('sobel��ֱ��Եģ��');


