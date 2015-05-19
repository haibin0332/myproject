%%
%{
用于处理结构信息所需要的基本函数
1、规则分块 ：        [blocksInfo,rectcoors] = regularBlockInfo(I,numrects,varargin)
2、随机分块 ：        [blocksInfo,rectcoors] = randomBlockInfo(I,numrects,varargin)
3、SSIM亮度：         lumiI = ssimLuminance(I)
4、SSIM对比度：       contrastI = ssimContrast(I)
5、SSIM结构：         structI = ssimStructure(I)
6、序列多次差分:       diffvector = multiTimesDiff(inputVector,numdiffTimes)
7、随机置乱多次差分：  diffvector = randpermDiff(inputVector,key,numdiffTimes)
8、SSIM亮度、对比度的match公式： 
    distance = match_SSIM_lumi(h1,h2,param)
    match_SSIM_sumlumi 
    match_SSIM_struct
        这个东西不知道如何解释，试验结果表明它并不能用于计算距离，事实上，它在SSIM中也只是对Struct进行加权而已
        在SSIM中，结构信息的距离是通过相关系数得到的，而在每一个点上，通过这个公式得到的亮度和对比度的差对结构的相关系数进行加权。
        这就是SSIM最后的那个公式，最后的ssim_index是通过对加权之后的结构距离取平均值得到的。

%}
function readme_StructInfo()
I = imread('1.bmp');
numrects = 64;
key = 101;
numdiffTimes = 4;
% 最基本的调用：
% 随机分块，原图均值
[blocksInfo,rectcoors] = randomBlockInfo(I,numrects,key,1/8,1/16,'',@avgblock);
% 差分序列
diffvector = multiTimesDiff(inputVector,numdiffTimes);
% 匹配


end % end function





