function [imageMark, c] = imKmeans(image, k)
tic;
[m, n] = size(image);
centerCur = unifrnd(min(min(image)), max(max(image)), 1, k);
centerPre = zeros(size(centerCur));
imageMark = zeros([m, n]);
while abs(sum(abs(centerCur - centerPre), 'all')) > 0.005
   for i = 1:m
       for j = 1:n
           dis = abs(centerCur - image(i, j));
           [~, index] = sort(dis);
           imageMark(i, j) = index(1);
       end
   end
   centerPre = centerCur;
    for i = 1:length(centerCur)
        if ~(isempty(image(imageMark == i)))
            centerCur(i) = mean(image(imageMark == i), 'all');
        end
    end
   disp(centerCur);
   drawCluster(1, image, imageMark, centerCur);
end
c = length(unique(imageMark));
toc