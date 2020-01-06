function filter = gaussian_bandreject_filter(M, N, D0, W)
coordinate = cat(3, repmat((1:M)', 1, N), repmat((1:N), M, 1));%µÃµ½Í¼Ïñ×ø±ê¾ØÕó
D = sqrt((coordinate(:, :, 1) - M / 2) .^ 2 + (coordinate(:, :, 2) - N / 2) .^ 2);
filter = 1 - exp(-1 / 2 * ((D .^ 2 - D0 .^ 2) ./ (D .* W)) .^ 2);