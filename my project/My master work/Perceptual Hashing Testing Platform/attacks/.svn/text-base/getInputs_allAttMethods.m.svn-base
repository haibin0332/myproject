attMethods = struct('attMethod',{},'shortName',{},'attFunction',{},'strength',{},'params',{});

attMethods = setfield(attMethods,{1},'attMethod','JPEG');	% - JPEG
attMethods = setfield(attMethods,{1},'shortName','JPEG');
attMethods = setfield(attMethods,{1},'attFunction',@att_jpeg);
attMethods = setfield(attMethods,{1},'strength',[1,3,5,10:10:90, 95]); % [0.1,0.5,1,5,10:5:95] 曾经试图把这个取值改得更小，但是一方面Matlab帮助说这是个number form 0 - 100.另一方面试验表明0和1对结果是一样的。
attMethods = setfield(attMethods,{1},'params','');

attMethods = setfield(attMethods,{2},'attMethod','Gaussian Noise(mean)');	% - Gaussian Noise(mean)
attMethods = setfield(attMethods,{2},'shortName','GNoiseMean');
attMethods = setfield(attMethods,{2},'attFunction',@att_gaussian_mean);
attMethods = setfield(attMethods,{2},'strength', [0.01,0.05:0.05:0.95]);
attMethods = setfield(attMethods,{2},'params','');

attMethods = setfield(attMethods,{3},'attMethod','Gaussian Noise(variance)');	% - Gaussian Noise(variance)
attMethods = setfield(attMethods,{3},'shortName','GNoiseVar');
attMethods = setfield(attMethods,{3},'attFunction',@att_gaussian_var);
attMethods = setfield(attMethods,{3},'strength', [0.01,0.05:0.05:0.2,0.22:0.02:0.4,0.45:0.05:0.95]);
attMethods = setfield(attMethods,{3},'params','');

attMethods = setfield(attMethods,{4},'attMethod','Median Filtering(neighborhood)');	% - Median Filtering(times)
attMethods = setfield(attMethods,{4},'shortName','MFilter');
attMethods = setfield(attMethods,{4},'attFunction',@att_medianfiltering);
attMethods = setfield(attMethods,{4},'strength', [2:2:20 25:5:80]); % [1 2:1:10]
attMethods = setfield(attMethods,{4},'params','');

attMethods = setfield(attMethods,{5},'attMethod','Blur by disk(Radius)');	% - Blur by Radius 5(times)
attMethods = setfield(attMethods,{5},'shortName','diskBlur');
attMethods = setfield(attMethods,{5},'attFunction',@att_blur_disk);
attMethods = setfield(attMethods,{5},'strength', [2:2:20 25:5:80]);
attMethods = setfield(attMethods,{5},'params','');
% % 
attMethods = setfield(attMethods,{6},'attMethod','Histogram Equalization(discrete gray levels)');	% - Histogram Equalization(discrete gray levels)
attMethods = setfield(attMethods,{6},'shortName','HistEqu');
attMethods = setfield(attMethods,{6},'attFunction',@att_histeq);
attMethods = setfield(attMethods,{6},'strength',[2, 4, 8, 16, 32:32:256] );
attMethods = setfield(attMethods,{6},'params','');

attMethods = setfield(attMethods,{7},'attMethod','Mosaic(Windowsize)');	% - Mosaic with Windowsize
attMethods = setfield(attMethods,{7},'shortName','Mosaic');
attMethods = setfield(attMethods,{7},'attFunction',@att_mosaic);
attMethods = setfield(attMethods,{7},'strength', [2:2:10 15 20:10:60]);		% 马赛克攻击的参数选1的时候，相当于什么也没有做。
attMethods = setfield(attMethods,{7},'params','');

attMethods = setfield(attMethods,{8},'attMethod','Rotation & Cropping');	% - Rotation & Cropping
attMethods = setfield(attMethods,{8},'shortName','RC');
attMethods = setfield(attMethods,{8},'attFunction',@att_rotation_cropping);
attMethods = setfield(attMethods,{8},'strength', [1, 2,3,4,5,6:2:18,20:10:180]);
attMethods = setfield(attMethods,{8},'params',''); 

attMethods = setfield(attMethods,{9},'attMethod','Rotation & Cropping & Resize');	% - Rotation & Cropping & Resize
attMethods = setfield(attMethods,{9},'shortName','RCS');
attMethods = setfield(attMethods,{9},'attFunction',@att_rotation_cropping_resize);
attMethods = setfield(attMethods,{9},'strength', [1, 2,3,4,5,6:2:18,20:10:180]);
attMethods = setfield(attMethods,{9},'params','');

attMethods = setfield(attMethods,{10},'attMethod','Cropping');	% - Cropping
attMethods = setfield(attMethods,{10},'shortName','Cropping');
attMethods = setfield(attMethods,{10},'attFunction',@att_cropping);
attMethods = setfield(attMethods,{10},'strength', [1.2:0.2:6]);
attMethods = setfield(attMethods,{10},'params','');

attMethods = setfield(attMethods,{11},'attMethod','Substitute with Signal Block');	% - Mosaic with Windowsize
attMethods = setfield(attMethods,{11},'shortName','SubSignal');
attMethods = setfield(attMethods,{11},'attFunction',@att_substitute_signal);
attMethods = setfield(attMethods,{11},'strength', [[8 16 24 32 38 46 ]./512 0.1:0.05:0.9]);		% 0-1
attMethods = setfield(attMethods,{11},'params','');

attMethods = setfield(attMethods,{12},'attMethod','Substitute with Perceptual Units');	% - Mosaic with Windowsize
attMethods = setfield(attMethods,{12},'shortName','SubPerceptual');
attMethods = setfield(attMethods,{12},'attFunction',@att_substitute_perceptual);
attMethods = setfield(attMethods,{12},'strength', [[2.^[0:6] 128:64:384]./3969 0.1:0.01:0.2 0.22:0.02:0.5]);		% 0-1
attMethods = setfield(attMethods,{12},'params','');

%% 这两个不列入使用，因为blur可以通过调节param来实现，scaling会改变原图大小，与现有大部分算法不符合
% att_scaling.m
% att_blur_core.m

% attMethods = setfield(attMethods,{4},'attMethod','Scaling');	% - Median Filtering(times)
% attMethods = setfield(attMethods,{4},'attFunction',@att_scaling);
% attMethods = setfield(attMethods,{4},'strength', [1 2:1:10]);
% attMethods = setfield(attMethods,{4},'params','');

