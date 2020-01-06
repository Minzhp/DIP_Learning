function [C_M] = LSB_explore_embed(C, M, B)
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
        C_M(i, j) = C(i, j) - mod(C(i, j), 2 ^ B((i - 1) * n + j)) + M((i - 1) * n + j) * (2 ^ (B((i - 1) * n + j) - 1)) + mod(C(i, j), 2 ^ (B((i - 1) * n + j) - 1));
    end
end

