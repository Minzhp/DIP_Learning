function [M] = LSB_extract(C_M)
C_M = uint8(C_M);
[m, n] = size(C_M);
M = zeros([1, m * n]);
for i = 1:m
    for j = 1:n
        M((i - 1) * n + j) = mod(C_M(i, j), 2);
    end
end