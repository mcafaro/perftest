function out = matrix_sum(M)
% CQ's library for matrix operation

out = 0;
nrow = size(M,1);
ncol = size(M,2);
for i = 1:nrow
    for j = 1:ncol
        out = out + M(i,j);
    end
end

end