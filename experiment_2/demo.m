%%
clc;clear;
image = imread('cameraman.tif');
[m, n] = size(image);
figure(1);imshow(image);title('ԭͼ��')



%%
%ͼ�������
imageZoom1 = imresize(image, 2);
figure(2);imshow(imageZoom1);title('�Ŵ�������ͼ�񣨱������ţ�');

imageZoom2 = imresize(image, [m * 2, n]);
figure(3);imshow(imageZoom2);title('�߷Ŵ�������ͼ�񣨷Ǳ������ţ�');

imageZoom3 = imresize(image, 2, 'nearest');
figure(4);imshow(imageZoom3);title('�Ŵ�������ͼ������ڷ���');

imageZoom4 = imresize(image, 2, 'bilinear');
figure(5);imshow(imageZoom4);title('�Ŵ�������ͼ��˫���Բ�ֵ��');

imageZoom5 = imresize(image, 2, 'bicubic');
figure(6);imshow(imageZoom5);title('�Ŵ�������ͼ��˫���β�ֵ��');



%%
%ͼ�����ת
imageRotate1 = imrotate(image, 30, 'crop');
figure(7);imshow(imageRotate1);title('��ת30�Ⱥ����');

imageRotate2 = imrotate(image, 30, 'loose');
figure(8);imshow(imageRotate2);title('��ת30�Ⱥ󲻼���');
