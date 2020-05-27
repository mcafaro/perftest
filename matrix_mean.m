function out = matrix_mean(M)
% CQ's library for matrix operation

sum = matrix_sum(M);
nrow = size(M, 1);
ncol = size(M, 2);
out = sum/(nrow*ncol);

end