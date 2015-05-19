%{
测试计划：
测试目的：考虑Fridrich的算法中N的取值提高是否对算法精度有所帮助
测试方法：
	图像：整幅图像
	N：取各种不同的数值
	比较：对于一个分块，N不同的时候，对各种攻击的鉴别能力
%}
function testPlan_Fridrich_Nbits()
%% 取图像
imdir = 'E:\DoctorThesis\MBench\Plan\outdir\imAttacked';
testImages = 'testImages';
load(fullfile(imdir,testImages));
allAttacks = {testImages(1).imAttacked.attMethod};
allImages = {testImages.imOriginal};
imgOrg = allImages(1);
attMethod = allAttacks(3);
testImages = 'testImages';
% 攻击强度可以看这个： getInputs_allAttMethods.m

%%
N = 50;
%{ 
% test 2
iCounter = 1;
for i = [1:38]
	imgOrg = allImages(i);
	imgOrgFull = fullfile(imdir,imgOrg{1});
	OrgNbits = extractNbits(imgOrgFull,N);
	i
	for j = [i+1:38]
		imgOrg1 = allImages(j);
		imgOrgFul1 = fullfile(imdir,imgOrg1{1});
		im1Nbits = extractNbits(imgOrgFul1,N);
		Distance(iCounter) = sum(abs(OrgNbits -im1Nbits))/N;
		iCounter = iCounter+1
	end
end
%}
% 
% test 1
Ni = 0;
for N = [1:4, 20:10:40, 60:20:80]
% for N = [5, 10]
	Ni = Ni + 1;
	for i = 1:38
		imgOrg = allImages(i);
		imgOrgFull = fullfile(imdir,imgOrg{1});
		OrgNbits = extractNbits(imgOrgFull,N);
		i
		iCounter = 0;
		for attStrength = [0.01,0.05:0.05:0.95]
			iCounter = iCounter + 1
			attStrength
			imgAtt = findAttackedImg(imdir,testImages,imgOrg,attMethod,attStrength);
			imgAttFull = fullfile(imdir,imgAtt{1});
			AttNbits = extractNbits(imgAttFull,N);
			Distance(Ni, i, iCounter) = sum(abs(OrgNbits - AttNbits))/N;
		end
	end
end
%}

%% save results
%
load('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results-N-tests.mat', 'str');
sizeOfMat = size(str,2);
str = padarray(str,[0 1],'replicate','post');
str(1,sizeOfMat+1).imgOrg = imgOrg;
str(1,sizeOfMat+1).attMethod = attMethod;
str(1,sizeOfMat+1).Distance = Distance;
str(1,sizeOfMat+1).N = N;

delete('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results-N-tests.mat'); 
save('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results-N-tests.mat','str'); 
%}
%{
% initial
str.imgOrg = imgOrg;
str.attMethod = attMethod;
str.N = N;
str.Distance = Distance;
save('E:\DoctorThesis\MBench\Plan\algorithms\test-wyn\results-N-tests.mat', 'str');
%}


% why;

function Nbits = extractNbits(img,N)
I = imread(img);
sizeI = size(I,1);
if sizeI ~= 512 
	I = double(imresize(I,[512,512])); % resize以满足DCT变换，并且简化图像大小不同带来的处理过程
end 
I = blkproc(I,[8 8],@dct2);
M = size(I,1);
key = 101;
rand('seed',key);
P = zeros(M,M);
for i = 1:N
	P = rand(M);
	P = P - sum(sum(P))/(M*M);
	H(i) = sum(sum(I.*P));
end
H(H>=0) = 1;
H(H<0) = 0;
Nbits = H;