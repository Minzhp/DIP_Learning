clc;clear;
image = (double(imread('lena512.bmp'))) / 255;
[m, n] = size(image);
figure(1);imshow(image, []);title('ԭͼ��')



%%
%��Ӹ�˹��������ԭ
imageNoise1 = imnoise(image, 'gaussian');

%M*N����ƽ��
M1 = 3;
N1 = 3;

%MATLAB�Դ�����ʵ�־�ֵȥ��
imageDenoise1 = imfilter(imageNoise1, fspecial('average', [M1, N1]));

%%����ʵ�־�ֵȥ��
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
subplot(1, 2, 1);imshow(imageNoise1, []); title('�Ӹ�˹����');
subplot(1, 2, 2);imshow(imageDenoise1, []); title([num2str(M1), '*', num2str(N1), '����ƽ��']);

disp(newline);
disp(['�Ӹ�˹������', num2str(M1), '*', num2str(N1), '����ƽ��']);
disp(['PSNR:', num2str(imPSNR(image, imageDenoise1))]);
disp(['SSIM:', num2str(imSSIM(image, imageDenoise1))]);



%%
%��ӽ�����������ԭ
imageNoise2 = imnoise(image, 'salt & pepper');

%M*N������ֵ�˲�
M2 = 3;
N2 = 3;

%MATLAB�Դ�����ʵ����ֵȥ��
imageDenoise2 = medfilt2(imageNoise2, [M2, N2]);

%%����ʵ����ֵȥ��
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
subplot(1, 2, 1);imshow(imageNoise2, []); title('�ӽ�������');
subplot(1, 2, 2);imshow(imageDenoise2, []); title([num2str(M2), '*', num2str(N2), '������ֵȥ��']);

disp(newline);
disp(['�ӽ���������', num2str(M2), '*', num2str(N2), '������ֵȥ��']);
disp(['PSNR:', num2str(imPSNR(image, imageDenoise2))]);
disp(['SSIM:', num2str(imSSIM(image, imageDenoise2))]);



%%
%����˶�ģ������ԭ
blur = fspecial('motion', 25, 11);
imageBlur = imfilter(image, blur, 'circular');

%���˲�
blurFft1 = fft2(blur, m, n);
imageBlurFft1 = fft2(imageBlur);
imageDeblurFft1 = imageBlurFft1 ./ blurFft1;
imageDeblur1 = ifft2(imageDeblurFft1);
figure(4);
subplot(1, 2, 1);imshow(imageBlur, []);title('���˶�ģ��');
subplot(1, 2, 2);imshow(imageDeblur1, []);title('ֱ�����˲�');

disp(newline);
disp('���˶�ģ����ֱ�����˲�');
disp(['PSNR:', num2str(imPSNR(image, imageDeblur1))]);
disp(['SSIM:', num2str(imSSIM(image, imageDeblur1))]);


%������������˲�
imageBlurNoise = imnoise(imageBlur, 'gaussian');
blurFft2 = fft2(blur, m, n);
imageBlurFft2 = fft2(imageBlurNoise);
imageDeblurFft2 = imageBlurFft2 ./ blurFft2;
imageDeblur2 = ifft2(imageDeblurFft2);
figure(5);
subplot(1, 2, 1);imshow(imageBlurNoise, []);title('���˶�ģ������˹����');
subplot(1, 2, 2);imshow(imageDeblur2, []);title('ֱ�����˲�');

disp(newline);
disp('���˶�ģ������˹������ֱ�����˲�');
disp(['PSNR:', num2str(imPSNR(image, imageDeblur2))]);
disp(['SSIM:', num2str(imSSIM(image, imageDeblur2))]);


%ά���˲�
imageDeblur3 = deconvwnr(imageBlur, blur, 0);
figure(6);
subplot(1, 2, 1);imshow(imageBlur, []);title('���˶�ģ��');
subplot(1, 2, 2);imshow(imageDeblur3, []);title('ά���˲�');

disp(newline);
disp('���˶�ģ����ά���˲�������������');
disp(['PSNR:', num2str(imPSNR(image, imageDeblur3))]);
disp(['SSIM:', num2str(imSSIM(image, imageDeblur3))]);


%���������ά���˲������űȣ�
nsr = sum((image - imageBlurNoise) .^ 2, 'all') ./ sum(image .^ 2, 'all');
imageDeblur4 = deconvwnr(imageBlurNoise, blur, nsr);
figure(7);
subplot(1, 2, 1);imshow(imageBlurNoise, []);title('���˶�ģ������˹����');
subplot(1, 2, 2);imshow(imageDeblur4, []);title('�������ű�ά���˲�');

disp(newline);
disp('���˶�ģ������˹������ά���˲������űȣ�');
disp(['PSNR:', num2str(imPSNR(image, imageDeblur4))]);
disp(['SSIM:', num2str(imSSIM(image, imageDeblur4))]);


%���������ά���˲�������غ�����
ncorr = abs(ifft2(abs(fft2((imageBlurNoise - image))) .^ 2));
icorr = abs(ifft2(abs(fft2((image))) .^ 2));
imageDeblur5 = deconvwnr(imageBlurNoise, blur, ncorr, icorr);
figure(8);
subplot(1, 2, 1);imshow(imageBlurNoise, []);title('���˶�ģ������˹����');
subplot(1, 2, 2);imshow(imageDeblur5, []);title('��������غ���ά���˲�');

disp(newline);
disp('���˶�ģ������˹������ά���˲�������غ�����');
disp(['PSNR:', num2str(imPSNR(image, imageDeblur5))]);
disp(['SSIM:', num2str(imSSIM(image, imageDeblur5))]);
