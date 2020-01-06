function [C_M] = LSB_embed(C, M)
%C ÔØÌåÍ¼Ïñ¾ØÕó
%M ÃØÃÜĞÅÏ¢ĞòÁĞ
%C_M ÔØÃÜÍ¼Ïñ¾ØÕó
C = uint8(C);
M = uint8(M);
[m, n] = size(C);
l = length(M);
C_M = C;
for i = 1:m
    for j = 1:n
        if (i - 1) * n + j > l
            break;
        end
        C_M(i, j) = C(i, j) - mod(C(i, j), 2) + M((i - 1) * n + j);
    end
end

