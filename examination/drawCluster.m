function drawCluster(n, clu, mark, cen)
figure();
if n == 1
    [count, x] = imhist(clu);
    for i = 1:length(cen)
        cluMin = min(clu(mark == i));
        cluMax = max(clu(mark == i));
        index = x > cluMin & x < cluMax;
        stem(x(index), count(index), '.');
        hold on;
        [~, index] = sort(abs(x - cen(i)));
        stem(x(index(1)), count(index(1)), 'k', 'filled');
    end
elseif n == 2
    for i = 1:length(cen(:, 1))
        a = clu(:, 1);
        b = clu(:, 2);
        scatter(a(mark == i), b(mark == i), '*');
        hold on;
        scatter(cen(i, 1), cen(i, 2), 'k', 'filled');
    end
elseif n == 3
    for i = 1:length(cen(:, 1))
        a = clu(:, :, 1);
        b = clu(:, :, 2);
        c = clu(:, :, 3);
        scatter3(a(mark == i), b(mark == i), c(mark == i), '*');
        hold on;
        scatter3(cen(i, 1), cen(i, 2), cen(i, 3), 'k', 'filled');
    end
end