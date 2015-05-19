function mean = avgblock(A)
[m,n] = size(A);
mean = sum(A(:))/(m*n);  % A(:)可以用来降维