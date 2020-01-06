clc;clear;
I = imread('cameraman.tif');
I = double(I);
[M, N] = size(I);
coordinate = cat(3, repmat((1:M)', 1, N), repmat((1:N), M, 1));%�õ�ͼ���������
P = I + 20 * sin(coordinate(:, :, 1) * 20) + 20 * sin(coordinate(:, :, 2) * 20);%�����������
IF = fftshift(fft2(I));
IFV = log(1 + abs(IF));
PF = fftshift(fft2(P));
PFV = log(1 + abs(PF));
figure();
subplot(2, 2, 1);imshow(I, []);title('ԭͼ');
subplot(2, 2, 2);imshow(IFV, []);title('ԭͼƵ��');
subplot(2, 2, 3);imshow(P, []);title('����������');
subplot(2, 2, 4);imshow(PFV, []);title('������Ƶ��');
figure();
subplot(2, 1, 1);mesh(IFV);title('ԭͼƵ����άͼ');
subplot(2, 1, 2);mesh(PFV);title('������Ƶ����άͼ');

%%
%��������˲���
D0 = 48;
W = 5;
filter1 = ideal_bandreject_filter(M, N, D0, W);
figure();mesh(abs(filter1));title('��������˲���')
I_F = PF .* filter1;
I_FV = log(1 + abs(I_F));
I_ = abs(ifft2(ifftshift(I_F)));
figure();
subplot(2, 2, 1);imshow(I_, []);title('�˲���')
subplot(2, 2, 2);imshow(I_FV, []);title('�˲���Ƶ��')
subplot(2, 2, [3, 4]);mesh(I_FV);title('�˲���Ƶ����άͼ')

%%
%������˹�����˲���
D0 = 48;
W = 5;
n = 1;
filter2 = butterworth_bandreject_filter(M, N, D0, W, n);
figure();mesh(abs(filter2));title('������˹�����˲���������Ϊ1��')
I_F = PF .* filter2;
I_FV = log(1 + abs(I_F));
I_ = abs(ifft2(ifftshift(I_F)));
figure();
subplot(2, 2, 1);imshow(I_, []);title('�˲���')
subplot(2, 2, 2);imshow(I_FV, []);title('�˲���Ƶ��')
subplot(2, 2, [3, 4]);mesh(I_FV);title('�˲���Ƶ����άͼ')

%%
%��˹�����˲���
D0 = 48;
W = 5;
filter3 = gaussian_bandreject_filter(M, N, D0, W);
figure();mesh(abs(filter3));title('��˹�����˲���')
I_F = PF .* filter3;
I_FV = log(1 + abs(I_F));
I_ = abs(ifft2(ifftshift(I_F)));
figure();
subplot(2, 2, 1);imshow(I_, []);title('�˲���')
subplot(2, 2, 2);imshow(I_FV, []);title('�˲���Ƶ��')
subplot(2, 2, [3, 4]);mesh(I_FV);title('�˲���Ƶ����άͼ')
