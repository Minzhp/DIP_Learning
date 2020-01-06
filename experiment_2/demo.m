%%
clc;clear;
image = imread('cameraman.tif');
[m, n] = size(image);
figure(1);imshow(image);title('原图像')



%%
%图像的缩放
imageZoom1 = imresize(image, 2);
figure(2);imshow(imageZoom1);title('放大两倍的图像（比例缩放）');

imageZoom2 = imresize(image, [m * 2, n]);
figure(3);imshow(imageZoom2);title('高放大两倍的图像（非比例缩放）');

imageZoom3 = imresize(image, 2, 'nearest');
figure(4);imshow(imageZoom3);title('放大两倍的图像（最近邻法）');

imageZoom4 = imresize(image, 2, 'bilinear');
figure(5);imshow(imageZoom4);title('放大两倍的图像（双线性插值）');

imageZoom5 = imresize(image, 2, 'bicubic');
figure(6);imshow(imageZoom5);title('放大两倍的图像（双三次插值）');



%%
%图像的旋转
imageRotate1 = imrotate(image, 30, 'crop');
figure(7);imshow(imageRotate1);title('旋转30度后剪裁');

imageRotate2 = imrotate(image, 30, 'loose');
figure(8);imshow(imageRotate2);title('旋转30度后不剪裁');
