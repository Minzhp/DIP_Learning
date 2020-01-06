clc;clear;
I = imread('cameraman.tif');
I = double(I);
[M, N] = size(I);
coordinate = cat(3, repmat((1:M)', 1, N), repmat((1:N), M, 1));%得到图像坐标矩阵
P = I + 20 * sin(coordinate(:, :, 1) * 20) + 20 * sin(coordinate(:, :, 2) * 20);%添加周期噪声
IF = fftshift(fft2(I));
IFV = log(1 + abs(IF));
PF = fftshift(fft2(P));
PFV = log(1 + abs(PF));
figure();
subplot(2, 2, 1);imshow(I, []);title('原图');
subplot(2, 2, 2);imshow(IFV, []);title('原图频谱');
subplot(2, 2, 3);imshow(P, []);title('加正弦噪声');
subplot(2, 2, 4);imshow(PFV, []);title('含噪声频谱');
figure();
subplot(2, 1, 1);mesh(IFV);title('原图频谱三维图');
subplot(2, 1, 2);mesh(PFV);title('含噪声频谱三维图');

%%
%理想带阻滤波器
D0 = 48;
W = 5;
filter1 = ideal_bandreject_filter(M, N, D0, W);
figure();mesh(abs(filter1));title('理想带阻滤波器')
I_F = PF .* filter1;
I_FV = log(1 + abs(I_F));
I_ = abs(ifft2(ifftshift(I_F)));
figure();
subplot(2, 2, 1);imshow(I_, []);title('滤波后')
subplot(2, 2, 2);imshow(I_FV, []);title('滤波后频谱')
subplot(2, 2, [3, 4]);mesh(I_FV);title('滤波后频谱三维图')

%%
%巴特沃斯带阻滤波器
D0 = 48;
W = 5;
n = 1;
filter2 = butterworth_bandreject_filter(M, N, D0, W, n);
figure();mesh(abs(filter2));title('巴特沃斯带阻滤波器（阶数为1）')
I_F = PF .* filter2;
I_FV = log(1 + abs(I_F));
I_ = abs(ifft2(ifftshift(I_F)));
figure();
subplot(2, 2, 1);imshow(I_, []);title('滤波后')
subplot(2, 2, 2);imshow(I_FV, []);title('滤波后频谱')
subplot(2, 2, [3, 4]);mesh(I_FV);title('滤波后频谱三维图')

%%
%高斯带阻滤波器
D0 = 48;
W = 5;
filter3 = gaussian_bandreject_filter(M, N, D0, W);
figure();mesh(abs(filter3));title('高斯带阻滤波器')
I_F = PF .* filter3;
I_FV = log(1 + abs(I_F));
I_ = abs(ifft2(ifftshift(I_F)));
figure();
subplot(2, 2, 1);imshow(I_, []);title('滤波后')
subplot(2, 2, 2);imshow(I_FV, []);title('滤波后频谱')
subplot(2, 2, [3, 4]);mesh(I_FV);title('滤波后频谱三维图')
