function [C_M] = LSB_embed(C, M)
%C ����ͼ�����
%M ������Ϣ����
%C_M ����ͼ�����
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

