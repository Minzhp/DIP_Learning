function [imageMark, c] = imKmeansPPlus(image)
tic;
imageSize = size(image);
if (length(imageSize) == 2)
    imageSize = [imageSize, 1];
end
m = imageSize(1);
n = imageSize(2);
q = imageSize(3);

imageU = zeros([m * n, q]);
imageU(1, :) = image(1, 1, :);
imageUL = 1;
for i = 1:m
    for j = 1:n
        for i1 = 1:imageUL
            if (sum(abs(imageU(i1, :) - image(i, j, :)), 'all') == 0)
                break;
            end
        end
        if i1 == imageUL
            imageU(imageUL + 1, :) = image(i, j, :);
            imageUL = imageUL + 1;
            disp([i, j, imageUL]);
        end
    end
end
imageU = imageU(1:imageUL, :);
sigma = zeros([1, imageUL]);
rho = zeros([1, imageUL]);
k0 = round(0.04 * imageUL);
dis = zeros([1, imageUL]);
for i = 1:imageUL
    for j = 1:imageUL
        dis(j) = sum((imageU(j, :) - imageU(i, :)) .^ 2) .^ 0.5;
    end
    disSort = sort(reshape(dis, 1, imageUL));
    rho(i) = exp(1 / (sum(disSort(1:k0)) + 0.000001));
end
for i = 1:imageUL
    for j = 1:imageUL
        dis(j) = sum((imageU(j, :) - imageU(i, :)) .^ 2) .^ 0.5;
    end
    if (rho(i) == max(rho))
        sigma(i) = max(dis);
    else
        sigma(i) = min(dis(rho > rho(i)));
    end
end
a0 = 0;
a1 = 0.001;
sigmaF = a0 + a1 .* (1 ./ rho);
sigma0 = sigmaF - sigma;
sigma0 = sigma0 - mean(sigma0);
centerCur = imageU(repmat((abs(sigma0') > 0.3), 1, q));
k = length(centerCur') / q;
centerCur = reshape(centerCur, k, q);
figure();stem(sigma0);

centerPre = zeros(size(centerCur));
imageMark = zeros([m, n]);
dis = zeros([k, 1]);
while abs(sum(abs(centerCur - centerPre), 'all')) > 0.005
    for i = 1:m
        for j = 1:n
            for l = 1:k
                dis(l, 1) = sum((centerCur(l, :) - reshape(image(i, j, :), [1, q])) .^ 2, 'all') ^ 0.5;
            end
            [~, index] = sort(dis(:, 1));
            imageMark(i, j) = index(1);
        end
    end
    centerPre = centerCur;
    for i = 1:k
        for l = 1:q
            imageTemp = image(:, :, l);
            if ~(isempty(image(imageMark == i)))
                centerCur(i, l) = mean(imageTemp(imageMark == i), 'all');
            end
        end
    end
   disp(centerCur);
   drawCluster(3, image, imageMark, centerCur);
end
c = length(unique(imageMark));
toc