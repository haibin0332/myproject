%{
use��
    H = mbe_bian(imagefile, param) % Ϊ�˵õ�³���Ĺ�ϣ
method 3 ��Ҫ������ƥ���㷨
    match_zh_rdd_method3.m
method 8 ��ƥ���㷨
    match_zh_rdd_method8.m
%}
function [hashvector] = mbe_zh_rdd(imagefile,param)
%% test: input
  imagefile = 'E:\PH1\1.bmp'; % 'F:\imDatabase\TestImages\Substitute with Signal Block\lena-SubSignal-0.2.bmp', % 
  nargin = 1;
%% check input
if nargin == 1
	numrects = 256; % ����ֿ�ĸ���
    numdiffTimes = 4; % ÿ�����ֵĴ�����
    numdiffOrders = 1;% ��ֵļ����������ʹ���������ά���ϵ����飬�����Ƕ༶��֣���ֻ����ϵĲ�֣�������һ�����ʱ��һ���������鷢����ϵ��
    n_key = 0; % n_key * n_key Ϊ������Կʹ�õĿ��� ���Ϊ 0 ��ʾʹ�ù̶�����Կ
    method = 1;
else
	numrects = param{1}; 
    numdiffTimes = param{2}; 
    numdiffOrders = param{3};
    n_key = param{4};
    method = param{5};
end

I = imread(imagefile);
dim = size(I);
if length(dim) > 2 % ���ǻҶ�ͼ 
	I = rgb2gray(I);
end
%% ��Կ���ƣ���Ҫʱ��ʹ��³����ϣ��Ϊ��Կ
% ��ʵ�ϣ�³��������Ϊ��Կ���ǲ�̫���еġ���������ʹ����Կ�Ĵ���ֻ���ڲ���һЩС�뷨ʱ��һ�¡�
if n_key == 0 % ʹ�ù̶�����Կ��ȥ��³����ϣ��һ��һ�ܵ�����
    key = 101;
else
%    �����֧����³����ϣ����Ϊ��Կ�����ƺ����������̡�Ŀǰֻ֧��method 1.����ԭ���϶Ժ������еĶ�֧�֣�����û��ʲô��ֵ��
    keyvector = regularDiff(I,n_key,1);
    %{
    ����ʹ�ú�С����bian�ķ���������key����³���Ժ������Զ��ϲ��ϲ�ֵķ�����ûʲô���塣
    ����Ըĳɴ���ֵķ���
    %}
    key = 0; % ת����һ��������Ϊkey������������룬�� keyvector ���������Ƶı���
    if length(keyvector) > 28 
        lenkey = 30;
    else
        lenkey = length(keyvector);
    end
    for i = 1:lenkey
        key = key + keyvector(i) * i;
    end
%     key
    %{
    ���ʹ�õķ����ǣ��� keyvector ���������Ƶı��롣����������У���һ��̫�������³�����rand����ķ�Χ������û�б�Ҫ����Ϊkeyֻ��Ҫ����ͬ��ͼһ��
    ֱ�����Ҳ���У���Ϊ�������ܻᵼ��ͳ��ЧӦ�����ܶ�ͼƬ��key����һ���ġ���Ȼ�����ֹ��̿��Խ���������⣬���ǡ�����
    ����������key�����key����ͬͼ������һ���ģ����б仯��ͼû�б�Ҫ�Ա仯���ԣ���Ϊ�����������������keyΪ���룬һ���key�Ĳ�ͬ���ᵼ����ȫ��ͬ�������
    If method is set to 'state' or 'twister', then s must be either a scalar integer value from 0 to 2^32-1 or the output of rand(method). 
    If method is set to 'seed', then s must be either a scalar integer value from 0 to 2^31-2 or the output of rand(method).
    %}
end  
    rand('state',key);
%% ���ַ���
if method == 1  % numdiffTimes ��Ч���򵥵Ķ�ֵ��ֱ��룬ֻ��¼��ת��Ϣ
    %% method 1
    % �����Ŀ���ͨ��ѭ���������������ƣ�һ��������ԭʼ�ģ���һ��������ѭ�����Ʋ��������ƵĴ�����������ɢ�ĳ̶�
    meanBlocks = randomBlockMean(I,key,numrects);
    
    iA = [1:numrects];
    hashvector = zeros(1,numrects * numdiffTimes);
    for i = 1:numdiffTimes
        for j = 1:numrects
            if i + j <= numrects
                iB(j) = iA(i+j);
            else
                iB(j) = iA(mod(j + i,numrects));
            end
        end
        % ���
        hashvector((i-1)*numrects+1:(i*numrects)) = meanBlocks(iA) >= meanBlocks(iB);
    end
elseif method == 2 % numdiffOrders ��Ч���߽ײ�������
    %% method 2
    % ���ڶ༶��ֵ������ÿ�ζ�ֻ����һ��
    meanBlocks = randomBlockMean(I,key,numrects);
    
%     hashvector = zeros(1,sum(numrects - numdiffOrders:numrects - 1));
    hashtp1 = meanBlocks;
    for i = 1:numdiffOrders
        iA = [1:length(hashtp1)];
        iB = [2:length(hashtp1),1];
        hashtp2 = hashtp1(iA) - hashtp1(iB);
        hashtp1 = hashtp2;
%         if i == 1
            hashvector = hashtp1;   % ����������ֶ༶��ֵ����岢����
%         else
%             hashvector = [hashvector;hashtp1];  % �����֧��ͼͬʱ��¼��ף����Թ۲����
%         end
        % �۲켶������ʱ��������ݵı仯����
%          figure;plot(hashvector, 'DisplayName', 'hashvector', 'YDataSource', 'hashvector');
%          title(['numdiffOrders = ',num2str(i)]);
    end 

    % �������ֵ
    hashvector(hashvector >= 0) = 1;
    hashvector(hashvector < 0) = 0;
elseif method == 3 % numdiffTimes ��Ч���Բ��ֵ������Ӧ��������ȡ4�������ȼ����м������ȼ���ʾû�б仯�����������ȼ���ʾ�����˷�ת
    %% method 3
    % ����ķ�����ֱ�ӽ����������Ϊ���룬ƥ��ʱ�����ľ���ֵ����Ҫר�ŵ�ƥ�亯�� match_zh_rdd_method3.m
    meanBlocks = randomBlockMean(I,key,numrects);
    iA = [1:numrects];
    hashvector = zeros(1,numrects * numdiffTimes);
    for i = 1:numdiffTimes
        for j = 1:numrects
            if i + j <= numrects
                iB(j) = iA(i+j);
            else
                iB(j) = iA(mod(j + i,numrects));
            end
        end
        % ���
        hashvector((i-1)*numrects+1:(i*numrects)) = meanBlocks(iA) - meanBlocks(iB);
    end
    % ����Ϊ4���ȼ��������м������ȼ�С�����ߵĴ�
%     hashvector = Quantize2fourlevels(hashvector,1/4);

elseif method == 4 % ��ͣ�ԽС�Ĳ��ռ��Խ�صķ�����Խ��Ĳ��ռ��Խ��ķ��� 
    %% method 4 
    % sum = 1/(1/x + 1/y)�����ʹ�õĲ��ֵ����Խ�࣬ÿ����ֵ�Ӱ��ԽС������Ӱ��ķ�ΧԽ��
    meanBlocks = randomBlockMean(I,key,numrects);
    iA = [1:numrects];
    tphash1 = meanBlocks;
    for i = 1:numdiffTimes
        for j = 1:numrects
            if i + j <= numrects
                iB(j) = iA(i+j);
            else
                iB(j) = iA(mod(j + i,numrects));
            end
        end
        % ���
        tphash1 = meanBlocks(iA) - meanBlocks(iB);
        if i == 1
            tphash2 = tphash1;
        else
            tphash2 = [tphash2;tphash1];
        end            
    end
    beta = 1;
    hashvector = 1./(sum(((1./tphash2)).^beta));   
elseif method == 5 % numdiffOrders ��Ч���߽׷�����
    %% method 5
    % ���ڶ༶��ֵ������ÿ�ζ�ֻ����һ��
    % ���鳤����ʱ�̶�Ϊ 8
    meanBlocks = randomBlockMean(I,key,numrects);
    lenGroup = 8;
    numGroup = numrects/lenGroup;
    hashtp1 = meanBlocks;
    
    for i = 1:numdiffOrders
        for j = 1:numGroup
            tpmb = hashtp1((j-1) * lenGroup + 1 : (j) * lenGroup);
            iA = [1:length(tpmb)];
            iB = [2:length(tpmb),1];
            md1 = tpmb(iA) - tpmb(iB);
            
            if j == 1
                md2 = md1;
            else
                md2 = [md2 md1];
            end
        end
        hashtp1 = md2;
        if i == 1
            hashvector = hashtp1;   % ����������ֶ༶��ֵ����岢����
        else
            hashvector = [hashvector;hashtp1];  % �����֧��ͼͬʱ��¼��ף����Թ۲����
        end
        % �۲켶������ʱ��������ݵı仯����
%          figure;plot(hashvector, 'DisplayName', 'hashvector', 'YDataSource', 'hashvector');
%          title(['numdiffOrders = ',num2str(i)]);
    end 

    % �������ֵ
%     hashvector(hashvector >= 0) = 1;
%     hashvector(hashvector < 0) = 0;    
elseif method == 6 % ʹ�ù���ֿ飬Ȼ��ʹ����Կ���Ƶ����ң�Ȼ������������������������֣��۲��� method 1 �����ܲ���
    %% method 6
    % [meanBlocks,rectcoors] = regularBlockMean(I,numrects);
    % ֱ�ӽ�meanBlocks���ң�Ȼ�������ҵ����к�ԭ���н��в��
    % һ��38��ͼ�Ĳ���֤�� method 6 �� 1 Ч������
    [meanBlocks,rectcoors] = regularBlockMean(I,numrects);
    
    iA = [1:numrects];
%     rand('state',key);
    for i = 1:numdiffTimes % numdiffTimes �����ʾ�����Ҷ��ٴ�
    	iB = randperm(numrects);
        tphash = meanBlocks(iA) >= meanBlocks(iB);
        if i == 1
            hashvector = tphash;
        else
            hashvector = [hashvector; tphash];
        end
    end        
elseif method == 7 % ���ǽ�������������
    %% method 7
    %{
    ��ȡ���Ĳ�ֽ���������Ȼ������Ȼ�󿴾��룬
    С�Ĳ�֣���������С����ʾ���ڿ飬�������ܴ󣬱�ʾ��Զ�飻��Ĳ�֣���������С����ʾ�仯���������ܴ󣬱�ʾ�������ɴ˿��Բ���һ��2*2�Ĺ�ϵ��
    ���Թ۲죺
    1���������֮�󣬾���ķֲ�����
    2����������֮�󣬲�ֵķֲ�����
    ����Ǿ��ȵģ������������룬�������ƫ�ģ�����������ʾ����
    
    �������ʹ�ù̶��ķֿ�
    
    �ڹ۲�������ֵĹ�ϵ�Ļ����ϣ�
    ������Դ���һ�ֳ߶���Ϣ����ֱ�ʾ������߶���ͼ���Ƶ�ʣ��仯�����ԡ���ô��������ν��С�����߶�ֱ��ʷ�����˼�룬���һ���µ�ͼ��ṹ��Ϣ�ļ�¼��ʽ��
    ��������Ժ�����
    %}
    % [meanBlocks,rectcoors] = regularBlockMean(I,numrects);
    [meanBlocks,rectcoors] = regularBlockMean(I,numrects);
    
    iA = [1:numrects];
    
    iB = randperm(numrects);
    diffvector = abs(meanBlocks(iA) - meanBlocks(iB));
    distvector = sqrt((rectcoors(iA,1) - rectcoors(iB,1)).^2 + (rectcoors(iA,2) - rectcoors(iB,2)).^2 );
    
    [srtF,iF] = sort(diffvector);   % �������
    [srtD,iD] = sort(distvector);   % ��������
    srtFD = distvector(iF);         % �������֮��ľ���
    srtDF = diffvector(iD);         % ��������֮��Ĳ��
elseif method == 8 % ������ֲ��������룬�ֲ��������ڶ�λtamper����Ҫר�ŵ�ƥ�䷽��
    %% method 8
    hashvector = robustHashWithTamperDetect(I,key,numrects,numdiffTimes);
end    
end % function

%% ����ֿ�ľ�ֵ����
function [meanBlocks] = randomBlockMean(I,key, numrects)
%% [meanBlocks] = randomBlockMean(I,key, numrects)
% ���������һ������ߴ��ͼ������У��������һЩ�飬��ȡ��Щ��ľ�ֵ�����������
xsz = size(I,1);    % �еĴ�С
ysz = size(I,2);    % �еĴ�С

% ��������������أ�һ���ǳߴ磬һ�����е����ꡣ����ÿ���鶼�������ġ�
% ʹ�þ��ȷֲ������������������Ҫ��þ��ȷֲ��ķ�Χ��
% ��ǰ��������Ʒ�ʽ�������⣺����С�Ŀ����̫С����ֱ�ӡ�
% �޸�һ�£�minlength ��ʾ��С��ֱ����С��maxlength��ʾ������ֱ��
ratio1 = 1/16; ratio2 = 1/32; % ��������������ͼ��ֿ�ռԭͼ����Դ�С����СΪ1/16�����Ϊ1/4
% ratio1 = 1/2;ratio2 = 1/4;
minlength1 = round(ratio2*xsz); % ������������Сֱ��
maxlength1 = round(ratio1*xsz);	% ����������ֱ���ı仯��Χ
minlength2 = round(ratio2*ysz); % ������������Сֱ��
maxlength2 = round(ratio1*ysz);	% ����������ֱ���ı仯��Χ

% rand('state',key); % ���ò���������ķ���������
rectlengths1 = ceil(rand(numrects,1)*(maxlength1))  + minlength1; % [minlength,minlength + maxlength]
rectlengths2 = ceil(rand(numrects,1)*(maxlength2))  + minlength2;
rectcoors = ceil(rand(numrects,2).*[ xsz-rectlengths1+1 ysz-rectlengths2+1]); % ������������꣬���Ͻǵĵ�

% ��һ�δ�������ʾ����������ֿ�
%{
tI = zeros(size(I));
for i = 1:numrects
    I(rectcoors(i,1),rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1) = 256;
    I(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2)) = 256;
    I(rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1) = 256;
    I(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2)+rectlengths2(i) - 1) = 256;
end
figure;
imshow(I);
%}
meanBlocks = zeros(1,numrects);
% T = zeros(size(I));
for i = 1:numrects
    T = zeros(size(I));
    T(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1) = 1;
    meanBlocks(i) = sum(sum(I(T == 1)))/sum(sum(T));
%   figure;imshow(T);
end
% delta = 100;
% meanI = round(avgI/delta)*delta;  % ����100 �ٳ���100 �������Ϊ��ʲô��
return;
end % function
%% ����ȡ��ľ�ֵ����
function [meanBlocks,rectcoors] = regularBlockMean(I,numrects)
%% [meanBlocks,rectcoors] = regularBlockMean(I,numrects)
% �ֳ� n*n ����Ŀ飬ÿ��ȡƽ������¼��������
n = sqrt(numrects);
% ���´��뿽���� mbe_bian 
if fix(size(I,1)/n) == size(I,1)/n
	r = fix(size(I,1)/n);%����282����282/16 = 17.6�����ֱ��ʹ��17�����������ıߣ���һ���ͻ���Ϊblkproc��ԭ���·ֿ���
else
	r = fix(size(I,1)/n) + 1;
end
if fix(size(I,2)/n) == size(I,2)/n
	c = fix(size(I,2)/n);
else
	c = fix(size(I,2)/n) + 1;
end

r_d4 = fix(r/4);
c_d4 = fix(r/4);
fun_avg = @avgblock;	% �Կ���ƽ��
% ֱ�ӷֿ�
B = blkproc(I,[r,c],fun_avg); % �ֿ鴦��
% ��������
% B = blkproc(I,[r,c],[r_d4,c_d4],fun_avg);	%overlapped, Note: Padding with zero on the boundary
meanBlocks = B(:);

% �õ������ֿ�Ķ�������
for i = 1:n
    for j = 1:n
        rectcoorsC(i,j) = (i - 1) * c + 1;
        rectcoorsR(i,j) = (j - 1) * r + 1;        
    end 
end
rectcoors = [rectcoorsC(:) rectcoorsR(:)];
% �ã������������ǶԵģ�����û�����⡣���к��У������Ͽ�ʼ��
end % function
%% ����Ϊ4���ȼ�
function binaryHash = Quantize2fourlevels(featureVector,radio)
%% binaryHash = Quantize2fourlevels(featureVector,radio)
% �޸��� adaptiveQuantizer
% һЩ���ڲ���
levelsNumber = 4;
% radio�����м������ȼ��Ŀ��
% Sort
fv = sort(featureVector);
lfv = length(fv);
% �ȷ�
halfpoint = fix(length(featureVector)/2);
levels = [halfpoint - floor(halfpoint * radio), halfpoint, halfpoint + fix(halfpoint * radio)];
% levels�����һ������Ҫ�ǣ�����levels(end - 1)�ľ������һ��
levels = fv(levels);
%% ʹ��levels������һ�ѵȼ�
q = zeros(1,length(featureVector));
for i = 1:length(featureVector)
    for j = 1:length(levels) - 1
        if featureVector(i) <= levels(j + 1) && featureVector(i) > levels(j)
            q(i) = j;
        end
    end
    if featureVector(i) <= levels(1)
        q(i) = 0;
    end
    if featureVector(i) > levels(end)
        q(i) = length(levels);
    end
end    
%% �������ֱ����Ϊ����
binaryHash = q;
return;
end % end function
%% ����ֿ����Ҳ��
function hash = regularDiff(I,n,numdiffTimes)
%% hash = regularDiff(I,n,numdiffTimes)
if fix(size(I,1)/n) == size(I,1)/n
	r = fix(size(I,1)/n);%����282����282/16 = 17.6�����ֱ��ʹ��17�����������ıߣ���һ���ͻ���Ϊblkproc��ԭ���·ֿ���
else
	r = fix(size(I,1)/n) + 1;
end
if fix(size(I,2)/n) == size(I,2)/n
	c = fix(size(I,2)/n);
else
	c = fix(size(I,2)/n) + 1;
end

r_d4 = fix(r/4);
c_d4 = fix(r/4);
fun_avg = @avgblock;	% �Կ���ƽ��
% fun_median = @medianblock;
% B = blkproc(I,[r,c],fun_avg); % �ֿ鴦��
B = blkproc(I,[r,c],[r_d4,c_d4],fun_avg);

numrects = length(B(:));
% ����һ�£���������������֪����ֵķ���Ҫ����ǿ�С��
% Ϊ�˱�֤randpermÿ�ζ���һ����˳������ֻ��Ҫ�ڵ���ǰ���ϣ�
% rand('state',101);
index1 = randperm(numrects);

% iA = [1:numrects];
hashvector = zeros(1,numrects);

hashvector = B([1:numrects]) >= B(index1);
hash = hashvector;
end % end function

%% method 8 function
function hashvector = robustHashWithTamperDetect(I,key,numrects,numdiffTimes)
%% hashvector = robustHashWithTamperDetect(I,key,numrects)
    %{
    ʹ���������룺
    ��һ��ʹ������ֿ飬��ֱ��롣�ڶ���ʹ�ù���ֿ飬���Ҳ�ֱ��롣
    ��һ��³����ϣ���ڶ����ڵ�һ���Ļ����Ͼ�ȷ��λtamper��λ�ã���ȷ��tamper��Ӧ��˵���ڶ���Ҳ��³����ϣ��������Ϊ�������ע����ϸ�ڣ����Ա�����С���滻������Ӱ�첻������⡣
    %}
    %% �����趨
    numLocal = 3; % numLocal * numLocal ���ڴ���л��ֵ�С��ĸ�����
    ratio1 = 1/16; ratio2 = 1/32; % ���ռԭͼ����Դ�С����СΪ1/16�����Ϊ1/32
    numdiffTimesLocal = 1;
    numdiffTimesGlobal = numdiffTimes;
    %% ����λ��
    xsz = size(I,1);    % �еĴ�С
    ysz = size(I,2);    % �еĴ�С
    minlength1 = round(ratio2*xsz); % ������������Сֱ��
    maxlength1 = round(ratio1*xsz);	% ����������ֱ���ı仯��Χ
    minlength2 = round(ratio2*ysz); % ������������Сֱ��
    maxlength2 = round(ratio1*ysz);	% ����������ֱ���ı仯��Χ

%     rand('state',key); % ���ò���������ķ���������
    rectlengths1 = ceil(rand(numrects,1)*(maxlength1))  + minlength1; % [minlength,minlength + maxlength]
    rectlengths2 = ceil(rand(numrects,1)*(maxlength2))  + minlength2;
    rectcoors = ceil(rand(numrects,2).*[ xsz-rectlengths1+1 ysz-rectlengths2+1]); % ������������꣬���Ͻǵĵ�
    % ��һ�δ�������ʾ����������ֿ�
    %{
    tI = zeros(size(I));
    for i = 1:numrects
        I(rectcoors(i,1),rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1) = 256;
        I(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2)) = 256;
        I(rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1) = 256;
        I(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2)+rectlengths2(i) - 1) = 256;
    end
    figure;
    imshow(I);
    %}
    %% ���ľ�ֵ
    meanBlocks = zeros(1,numrects);
    localhash = zeros(numrects,numdiffTimesLocal * numLocal * numLocal);
    for i = 1:numrects
        T = zeros(size(I));
        T(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1) = 1;
        meanBlocks(i) = sum(sum(I(T == 1)))/sum(sum(T));
        %% �ڴ���ÿһ������ͬʱ�� �������Լ���local��ϣ
        Il = I(rectcoors(i,1):rectcoors(i,1)+rectlengths1(i) - 1,rectcoors(i,2):rectcoors(i,2)+rectlengths2(i) - 1);
        localhash(i,:) = localhashForTamperDetect(Il,numLocal,numdiffTimesLocal); % ÿһ�ж�Ӧһ��
        clear Tl;
        %   figure;imshow(T);
    end    
    %% ���ڴ��õ��Ĳ�ֱ���
    iA = [1:numrects];
    globalhash = zeros(1,numrects * numdiffTimesGlobal);
    for i = 1:numdiffTimesGlobal
        for j = 1:numrects
            if i + j <= numrects
                iB(j) = iA(i+j);
            else
                iB(j) = iA(mod(j + i,numrects));
            end
        end
        % ���
        globalhash((i-1)*numrects+1:(i*numrects)) = meanBlocks(iA) >= meanBlocks(iB);
    end
    %% ���õ���ϵ�hash����,�Ǹ��ṹ����Ϊ���ܲ����롣
    hashvector.globalhash = globalhash;
    hashvector.localhash = localhash;
end % end function
%% ����ֿ����Ҳ�� for method 8
function localhash = localhashForTamperDetect(Il,numLocal,numdiffTimesLocal)
%% localhash = localhashForTamperDetect(Il,numLocal,numdiffTimesLocal)
n = numLocal;
I = Il;
% ������зַ��������һЩû�а취�����ı߽�
if fix(size(I,1)/n) == size(I,1)/n
	r = fix(size(I,1)/n);%����282����282/16 = 17.6�����ֱ��ʹ��17�����������ıߣ���һ���ͻ���Ϊblkproc��ԭ���·ֿ���
else
	r = fix(size(I,1)/n) + 1;
end
if fix(size(I,2)/n) == size(I,2)/n
	c = fix(size(I,2)/n);
else
	c = fix(size(I,2)/n) + 1;
end

r_d4 = fix(r/4);
c_d4 = fix(r/4);
fun_avg = @avgblock;	% �Կ���ƽ��
% fun_median = @medianblock;
% B = blkproc(I,[r,c],fun_avg); % �ֿ鴦��
B = blkproc(I,[r,c],[r_d4,c_d4],fun_avg); % overlap ����

numrects = length(B(:));
% ����һ�£���������������֪����ֵķ���Ҫ����ǿ�С��
% Ϊ�˱�֤randpermÿ�ζ���һ����˳������ֻ��Ҫ�ڵ���ǰ���ϣ�
% rand('state',101); % ������ﲻ��Ҫ����Ϊ�����������Ѿ��ù��ˡ�
hashtp = zeros(1,numrects);
for i = 1:numdiffTimesLocal
    index1 = randperm(numrects);
    hashtp = B(1:numrects) >= B(index1);
    if i == 1
        hashvector = hashtp;
    else
        hashvector = [hashvector,hashtp];
    end
end
localhash = hashvector;
end % function
