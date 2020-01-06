clc;clear;
image = double(imread('test2.png')) / 255;
image = imresize(image, [50, 50]);

[imageMark, c] = imKmeansPPlus(image);

figure();
subplot(1, 2, 1);imshow(image);title('ԭͼ');
subplot(1, 2, 2);imshow(imageMark, []);title(['C=', num2str(c)]);
