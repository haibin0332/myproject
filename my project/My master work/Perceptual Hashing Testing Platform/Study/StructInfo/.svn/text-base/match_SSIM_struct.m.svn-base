function distance = match_SSIM_struct(h1,h2,param)
% C1 = (0.01*255)^2; % 这个东西来自于 ssim_decompose.m
% 下面的过程就是求两个序列之间的相关系数，但是加上了1/N 和 1/(N-1)这样权
h1_avg = sum(h1)/length(h1);
h2_avg = sum(h2)/length(h2);

h1_var = sum((h1 - h1_avg).^2)/(length(h1) - 1);
h2_var = sum((h2 - h2_avg).^2)/(length(h2) - 1);

h1_h2_cov = sum((h1 - h1_avg) .* (h2 - h2_avg)) /(length(h1) - 1);
distance = h1_h2_cov / sqrt(h1_var * h2_var);

% h1_avg = sum(h1)/length(h1);
% h2_avg = sum(h2)/length(h2);
% 
% distance = 2 * h1_avg * h2_avg / (h1_avg^2 + h2_avg^2);