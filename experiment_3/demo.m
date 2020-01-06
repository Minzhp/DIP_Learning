clc;clear;
image = zeros([256, 256]);


%%
image1 = image;
for i = 1:256
    for j = 1:256
        if ((i - 80) ^ 2 + (j - 80) ^ 2) <= 400
            image1(i, j) = 1;
        end
    end
end
IF1 = fftshift(fft2(image1));
IFV1 = log(1 + abs(IF1));
IFP1 = angle(IF1);
figure(1);
subplot(1, 3, 1);imshow(image1, []);title('ͼ��');
subplot(1, 3, 2);imshow(IFV1, []);title('������');
subplot(1, 3, 3);imshow(IFP1, []);title('��λ��');


%%
image2 = image;
for i = 1:256
    for j = 1:256
        if ((i - 80) ^ 2 + (j - 200) ^ 2) <= 400
            image2(i, j) = 1;
        end
    end
end
IF2 = fftshift(fft2(image2));
IFV2 = log(1 + abs(IF2));
IFP2 = angle(IF2);
figure(2);
subplot(1, 3, 1);imshow(image2, []);title('ͼ��');
subplot(1, 3, 2);imshow(IFV2, []);title('������');
subplot(1, 3, 3);imshow(IFP2, []);title('��λ��');


%%
image3 = image;
for i = 1:256
    for j = 1:256
        if ((i - 200) ^ 2 + (j - 80) ^ 2) <= 400
            image3(i, j) = 1;
        end
    end
end
IF3 = fftshift(fft2(image3));
IFV3 = log(1 + abs(IF3));
IFP3 = angle(IF3);
figure(3);
subplot(1, 3, 1);imshow(image3, []);title('ͼ��');
subplot(1, 3, 2);imshow(IFV3, []);title('������');
subplot(1, 3, 3);imshow(IFP3, []);title('��λ��');


%%
figure(4);
subplot(3, 2, 1);imshow(abs(IFV2 - IFV1), []);title('ͼ��21�����ײ���');
subplot(3, 2, 2);imshow(abs(IFP2 - IFP1), []);title('ͼ��21��λ�ײ���');
subplot(3, 2, 3);imshow(abs(IFV3 - IFV1), []);title('ͼ��31�����ײ���');
subplot(3, 2, 4);imshow(abs(IFP3 - IFP1), []);title('ͼ��31�����ײ���');
subplot(3, 2, 5);imshow(abs(IFV3 - IFV2), []);title('ͼ��32�����ײ���');
subplot(3, 2, 6);imshow(abs(IFP3 - IFP2), []);title('ͼ��32�����ײ���');


%%
a = abs(fft2(image1));
b = angle(fft2(image2));
image4 = abs(ifft2(a .* cos(b) + 1i .* a .* sin(b)));
figure(5);
imshow(image4, []);
