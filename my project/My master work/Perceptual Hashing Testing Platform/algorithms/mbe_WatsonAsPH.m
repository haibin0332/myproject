%% Comments and References
%{ 
	将Watson的HVS模型看作PH算法，执行与PH完全相同的测试过程，以得到一个可供参照的视角。
    忽略编码的过程，Watson模型可以直接作为一个PH算法来看待，因为PH和HVS最终都有一个表示距离的结果。
    在本程序中，将Watson的间隙和图像的DCT系数看作编码保存。

    参考文献：
        源自《信息隐藏技术实验教程》第八章
        Watson: 感知质量度量
    整理自 & use：
    	luminanceThreshold = luminanceMask(img) 
        contrastThreshold = contrastMask(img)
        qaValue = Qa_watson(imgRef,imgTest)
    match函数：
        match_WatsonAsPH

	!!! 事实上，这两个函数只能够用来示意而已，因为要在内存里面将两被图像大小的矩阵作为hash编码，加上图像这么多，必然对内存要求很高。
	实验中，第七张图片的时候就会out of memory。

	另外：mbp_QS 事实上就相当于执行extract+interclasstest的过程，所以，只需要另外编一个 mbp_intraQa 就可以了。
	在 mbp_intraQa 里面，执行intra test，并且画相应的直方图
%}
function [hashvector] = mbe_WatsonAsPH(imagefile,param)
%% test input
%imagefile = '1.bmp';

%% get input
I = imread(imagefile);
I = im2double(I);
%% 分块DCT变换求错误图像

DCTcoefI=blkproc(I,[8 8],@dct2); 
%% 求间隙
contrastThreshold = contrastMask(I,DCTcoefI);
%% 将间隙和DCT系数作为hash保存
hashvector.DCTcoef = DCTcoefI;
hashvector.ContrastThreshold = contrastThreshold;
