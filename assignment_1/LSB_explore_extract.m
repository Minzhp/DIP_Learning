function [M] = LSB_explore_extract(C_M, B, len)
C_M = uint8(C_M);
B = uint8(B);
[m, n] = size(C_M);
M = zeros([1, len]);
for i = 1:m
    for j = 1:n
        if (i - 1) * n + j > len
            break;
        end
        M((i - 1) * n + j) = idivide(mod(C_M(i, j), 2 ^ (B((i - 1) * n + j))), 2 ^ (B((i - 1) * n + j) - 1), 'floor');
    end
end