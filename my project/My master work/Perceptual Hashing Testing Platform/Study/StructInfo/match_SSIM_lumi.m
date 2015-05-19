function distance = match_SSIM_lumi(h1,h2,param)
C1 = (0.01*255)^2; % 这个东西来自于 ssim_decompose.m
h1_sq = h1.*h1;
h2_sq = h2.*h2;
h1_h2 = h1.*h2;
distance = (2*h1_h2 + C1)./(h1_sq + h2_sq + C1);
distance = sum(distance)/length(distance);