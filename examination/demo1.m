image = double(imread('test3.png')) / 255;
image = imresize(image, [100, 100]);

k = 3;
[imageMark, c] = imKmeans(image, k);

figure();
subplot(1, 2, 1);imshow(image);title('ԭͼ');
subplot(1, 2, 2);imshow(imageMark, []);title(['K=', num2str(k), '    C=', num2str(c)]);

% figure();
% scatter3(reshape(image(:, :, 1), [40000, 1]), reshape(image(:, :, 2), [40000, 1]), reshape(image(:, :, 3), [40000, 1]))