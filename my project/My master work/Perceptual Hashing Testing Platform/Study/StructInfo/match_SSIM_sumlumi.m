function distance = match_SSIM_sumlumi(h1,h2,param)
h1_avg = sum(h1)/length(h1);
h2_avg = sum(h2)/length(h2);

distance = 2 * h1_avg * h2_avg / (h1_avg^2 + h2_avg^2);