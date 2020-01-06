%%
%分水岭算法图像分割
clc;clear;
image1 = (double(imread('I1.tif'))) / 255;
l1 = watershed(image1);
wr1 = l1 == 0;
imageSegmentation1 = image1;
imageSegmentation1(wr1) = 1;
figure(1);
subplot(1, 3, 1);imshow(image1, []);
subplot(1, 3, 2);imshow(l1, []);
subplot(1, 3, 3);imshow(imageSegmentation1, []);

image2 = (double(imread('I2.tif'))) / 255;
l2 = watershed(image2);
wr2 = l2 == 0;
imageSegmentation2 = image2;
imageSegmentation2(wr2) = 1;
figure(2);
subplot(1, 3, 1);imshow(image2, []);
subplot(1, 3, 2);imshow(l2, []);
subplot(1, 3, 3);imshow(imageSegmentation2, []);



%%
%区域生长法图像分割
image3 = (double(imread('coins.png'))) / 255;
[m, n] = size(image3);
figure(3);imshow(image3, []);
[y, x] = getpts;
image3Grow = zeros([m, n]);
for i = 1:length(x)  
    image3Grow(round(x(i)), round(y(i))) = 1;
end
num3 = 1;
threshold3 = 0.05;
figure(4);imshow(image3Grow);
figure(5);
while num3 > 0
    num3 = 0;
    for i = 1:m
        for j = 1:n
            if image3Grow(i, j) == 1
                if i - 1 > 0 
                    a = i - 1; 
                else
                    a = 1; 
                end
                if i + 1 <= m 
                    b = i + 1; 
                else
                    b = m; 
                end
                if j - 1 > 0 
                    c = j - 1; 
                else
                    c = 1;
                end
                if j + 1 <= n 
                    d = j + 1;
                else
                    d = n; 
                end
                for u = a:b
                    for v = c:d
                        if image3Grow(u, v) == 0 && abs(image3(u, v) - image3(i, j)) < threshold3
                            image3Grow(u, v) = 1;
                            num3 = num3 + 1;
                        end
                    end
                end
            end
        end
    end
    imshow(image3Grow);
end
imshow(image3Grow);



