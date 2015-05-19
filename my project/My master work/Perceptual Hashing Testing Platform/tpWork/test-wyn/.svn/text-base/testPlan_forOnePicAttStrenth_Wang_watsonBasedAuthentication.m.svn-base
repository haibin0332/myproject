function h = testPlan_forOnePicAttStrenth_Wang_watsonBasedAuthentication();
for i = 256:32:1024
	h1 = mbe_wang_AuthenticationPHBasedWaston('1.bmp', [3, 1010, i]);
	h2 = mbe_wang_AuthenticationPHBasedWaston('3.bmp', [3, 1010, i]);
	h(i/32 - 7) = double(sum(abs(h1-h2)))/double(i);
end