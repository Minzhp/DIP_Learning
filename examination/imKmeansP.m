function [imageMark, c] = imKmeansP(image, k)
tic;
[m, n, q] = size(image);
centerCur = zeros([k, q]);
minTemp = reshape(min(min(image)), [1, q]);
maxTemp = reshape(max(max(image)), [1, q]);
for i = 1:q
    centerCur(:, i) = unifrnd(minTemp(i), maxTemp(i), k, 1);
end
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
end
c = length(unique(imageMark));
toc