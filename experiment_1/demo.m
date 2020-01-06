clc;clear;

I = double(imread('I.bmp'));
[m, n] = size(I);

I4 = uint8(I((1:4:m), (1:4:n)));
figure();imshow(I4);
imwrite(I4, 'I4.bmp');

I16 = uint8(I((1:16:m), (1:16:n)));
figure();imshow(I16);
imwrite(I16, 'I16.bmp');

I256 = uint8(I);
figure();imshow(I256);
imwrite(I256, 'I256.bmp');

I64 = uint8(floor(I ./ 4) .* 4);
figure();imshow(I64);
imwrite(I64, 'I64.bmp');

I32 = uint8(floor(I ./ 8) .* 8);
figure();imshow(I32);
imwrite(I32, 'I32.bmp');

I8 = uint8(floor(I ./ 32) .* 32);
figure();imshow(I8);
imwrite(I8, 'I8.bmp');

I2 = uint8(floor(I ./ 128) .* 128);
figure();imshow(I2);
imwrite(I2, 'I2.bmp');
