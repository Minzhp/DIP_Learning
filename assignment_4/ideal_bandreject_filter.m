function filter = ideal_bandreject_filter(M, N, D0, W)
coordinate = cat(3, repmat((1:M)', 1, N), repmat((1:N), M, 1));%µÃµ½Í¼Ïñ×ø±ê¾ØÕó
D = sqrt((coordinate(:, :, 1) - M / 2) .^ 2 + (coordinate(:, :, 2) - N / 2) .^ 2);
filter = (D < (D0 - W / 2)) | (D > (D0 + W / 2));