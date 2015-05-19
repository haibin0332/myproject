%% Comments and References
%{ 
	���㷨��������ɣ�����һ��ͨ����Watsonģ�ͽ��н�ά��ʵ��PH����ķ�����
    ���㷨��Ȼ�� Vishal Monga �� wavelet ����Ϊ�����ϣ��������öԱȶ��ڱΡ����Ǳ���ķ�����˼�붼��ͬ��
	�ο����ף�
		ROBUST IMAGE HASHING
		����Ϣ���ؼ���ʵ��̡̳��ڰ���
	
	Դ���������ԣ�
		mbe_VishalMonga_wavelet
		wavelethash

	use:
		contrastMask
		luminanceMask
		Qa_watson
	    wavelethash.m

	����ͼ�� ��Ϊ�õ�8*8��DCT��������Ҫ������ȣ���СΪ16���������� �Ҷ�  ͼ 

	params��
		numrects	'Number of random rectangles'
			default: 150
		key			'secret key'
			default: 101 ���ָ��һ��
���Ӳ�����
		method		'���ַ�����һ��ֱ�ӷֿ飬һ������Կ��������ֿ飨Vishal Monga��'
			default: 1
	
	hash��ʽ�� 
		���ض����hash��������Ҫר�ŵ�ƥ�䷽���� match_zh_descendingDimensionOfWatson
%}
function [hashVector] = mbe_zh_descendingDimensionOfWatson(imagefile,param)
% ���ڲ��� param��Ϊ�˱��ֲ��Գ���Ľӿ�һ�£����е��㷨�����Ĳ�������Ϊparam���ں����ڲ��ٸ�����Ҫ��������
%% test: input
%  imagefile = '2.bmp';
%  nargin = 1;
%% check input
if nargin == 1
	numrects = 256;
	key = 101;
    method = 1;
else
% 	numrects = param(4);
% 	key = param(5);
	numrects = 256;
	key = 101;
    method = param(1);
end

I = imread(imagefile);
dim = size(I);
if length(dim) > 2 % ���ǻҶ�ͼ 
	I = rgb2gray(I);
end
%{
�뷨��
    ����Watson��һ��������PH�㷨����������Qa��Ϊhash���뷴ӳ����õ��Ӿ����ԡ���ô���ο�����PH�㷨��������Watsonһ�����Ӿ�Ч����
    ����Watson�ļ�����ͬʱ����ԭͼ�Ͳο�ͼ�ģ�d = |(DCTcoefIo - DCTcoefIt)|/T(Io) ����PH����ȴҪ���롣
    ��ˣ���ά���Ӿ����Եı�������һ��ì�ܣ�����һ�����е����⡣
������
    ��ά�ķ�����
        ��Ϊ�ڱα�����ͼ�����ܹ���֪����С�仯������Ȩֵ֮�󣬱�����ܹ����̵����仯��
        ���������ǿ��Կ���ʹ��һ���ֿ�����С���ڱλ����������޴���������ڱλ����ޡ�
        �ڽ�һ��������Ҳ���Կ���ʹ��һ���ֿ��е�DCϵ������������DCϵ��������DCϵ����ֵ�����������ԭͼ������
        ����������ѡ��ֱ��ʹ��ÿ��������DCϵ����DCϵ����Ӧλ�õ��ڱ�������ֿ��ԭͼ�������ڱ�������Ȼ��ʹ��Watsonһ���Ĺ�ʽ���о�����㡣
    �ֿ�ķ�����
        ��Ϊ��Ȩ���߼����ڱεĹ�������DCT����ɵģ���DCT�任ʹ��8*8�Ŀ飬Ҳ��Ϊ���жȱ���8*8�ġ����ԣ�Hash����ʹ�õķֿ���ڱμ����õķֿ���ܲ�һ����
        ��Ͼ�����㷨���Ƿֿ�Ĵ������ǻ����й��ɿ��ԡ�
        ���ɾ��Ǿ���ʹ�þ���Ĳ����������С���ܲ�һ�������Ƿֿ��߼�����ʽȴ������һ���ġ�
    �Ľ��㷨��
        1��ֱ��ʹ�ý�ά����Ϣ��Ϊ����
            ÿ��8*8�ֿ��ﶼѡȡDCϵ��������Ӧ���ڱΣ�
            ��ÿ��hash�ֿ�����ѡȡ��DCϵ�����ڱηֱ�ȡƽ����
            �����Watson�ķ����ϲ���
        2�������л�������Ҷ���Ϣ���㷨�ĸĽ������� Vishal Monga ��
            ����ֱ�ӽ�ά�ķ������õ���ά֮���DCϵ��������ڱξ���
            Ȼ����һ�����߼�����ԭ���ķ���������Ҫע��ԭ�������и�ά����ص�����ҲҪ����Ӧ�ĵ�����
%}
I = double(I);
DCTcoefI = blkproc(I,[8,8],@dct2);
contrastThreshold = contrastMask(I,DCTcoefI);
% �ֱ�ѡȡDCϵ������Ӧ���ڱ�
descending = @(x)x(1,1);
dDCTcoefI = blkproc(DCTcoefI,[8,8],descending);
dcontrastThreshold = blkproc(contrastThreshold,[8,8],descending);

if method == 1
%% method1
    % ����16*16���ֿ黮�֣��õ�256�ı���
    r = size(I,1)/16;
    c = size(I,2)/16;
    avgfun = @avgblock;
    hashDCTcoef = blkproc(dDCTcoefI,[r/8,c/8],avgfun);
    hashcontrastThreshold = blkproc(dcontrastThreshold,[r/8,c/8],avgfun);
    % hashֵΪһ���ṹ
    hashVector.hashDCTcoef = hashDCTcoef;
    hashVector.hashcontrastThreshold = hashcontrastThreshold;
elseif method == 2
    [hashDCTcoef,hashcontrastThreshold] = randomBlockMean(dDCTcoefI, dcontrastThreshold, key, numrects);
end
% hashֵΪһ���ṹ
hashVector.hashDCTcoef = hashDCTcoef;
hashVector.hashcontrastThreshold = hashcontrastThreshold;
    
function [meandDCTcoefI,meandcontrastThreshold] = randomBlockMean(dDCTcoefI, dcontrastThreshold, key, numrects)
% numrects ����������Կ������hashֵ�ĳ���
%% Initialization of default parameters
ratio1 = 1/4; ratio2 = 1/8;

xsz = size(dDCTcoefI,2);
ysz = size(dDCTcoefI,1);

totallength = xsz*ysz;
meanlength = round(ratio1*ysz); % Round to nearest integer
varlength = round(ratio2*ysz);	% ratio1 ratio2 �Ǹ�ʲô�ģ� ������������Ʒ����С��

hostvecdDCTcoefI = dDCTcoefI(:);
hostvecdcontrastThreshold = dcontrastThreshold(:);

rand('state',key); % ���ò���������ķ���������
rectlengths = ceil(rand(numrects,1)*(2*varlength+1))  + meanlength - varlength - 1;
rectcoors = ceil(rand(numrects,2).*[ysz-rectlengths+1 xsz-rectlengths+1]); % ������Щ����ķ���

%preparing the random linear transformation matrix
T = zeros(numrects,totallength);

%uniform weights in the formation of the transform matrix at this point
for i=1:1:numrects,   
   dummat = zeros(ysz,xsz);
   dummat(rectcoors(i,1):(rectcoors(i,1)+rectlengths(i)-1),rectcoors(i,2):(rectcoors(i,2)+rectlengths(i)-1)) = 1;
   dummat = dummat / sum(sum(dummat)); % ���շ������һ����ģ �������ģ������Ӧλ�õ�ϵ�����󣬵õ�����ϵ����ֵ
   T(i,:) = (dummat(:))'; % T ��ÿһ������ϵ������ά���ã�������T ��������һ����ģ��ÿһ�п������һ����ϵ����ֵ�ļ���
end;
meandcontrastThreshold = T*hostvecdcontrastThreshold; % ʹ����ģ����ÿһ�������ֵ
meandDCTcoefI = T*hostvecdDCTcoefI;
% delta = 100;
% meandDCTcoefI = round(avgdDCTcoefI/delta)*delta;  % ����100 �ٳ���100 �������Ϊ��ʲô��
% meandcontrastThreshold = round(avgdcontrastThreshold/delta)*delta;
return;


