clc;clear;
I = imread('cameraman.tif');
I = imbinarize(I, graythresh(I));
figure();imshow(I);title('cameraman��ֵ��ͼ��');
I = ~I;
figure();imshow(I);title('cameraman��ֵ��ͼ��ȡ��');
%����ʵ�ֱ߽���ȡ
[m, n] = size(I);
Ie1 = zeros([m, n]);
for i = 2:m - 1
    for j = 2:n - 1
        Ie1(i, j) = sum(I(i - 1:i + 1, j - 1:j + 1), 'all') == 9;
    end
end
Ib1 = abs(I - Ie1);
figure();imshow(Ie1);title('����ʵ�ָ�ʴ���');
figure();imshow(Ib1);title('����ʵ�ֱ߽���ȡ');
%����ʵ�ֱ߽���ȡ
se = strel('square', 3);
Ie2 = imerode(I, se);
Ib2 = abs(I - Ie2);
figure();imshow(Ie2);title('����ʵ�ָ�ʴ���');
figure();imshow(Ib2);title('����ʵ�ֱ߽���ȡ');