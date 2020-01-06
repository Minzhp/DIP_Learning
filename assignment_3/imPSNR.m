function [PSNR] = imPSNR(I1, I2)
I1 = double(I1);
I2 = double(I2);
MSE = mean((I1 - I2) .^ 2, 'all');
PSNR = 20 * log10(255 / (sqrt(MSE)));