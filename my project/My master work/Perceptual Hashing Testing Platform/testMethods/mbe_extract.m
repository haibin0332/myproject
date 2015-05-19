%{
ר�Ŵ�����ȡ�߼��ĺ���������ȡ�㷨��Ӧ�ĺ�����Ϊһ����������
������ר�Ÿ�������ȡ���߼������ĵ����������
	1�����ĸ��㷨��ȡ
	2����ȡ֮�����Ϣ�������Ķ�
	3��ͼ�񣬹�����ǿ�ȣ���ȡ�㷨�����Hashֵ����α���

input:
	extractPlan
		extractPlan = struct('imdir',{},'testImages',{},'outdir',{},'customedOutName',{},'algfun',{},'params',{},'includeAttacks',{},'includeImages',{});
			imdir
				����testImages��·�������·�����汣�����й���������ͼƬ��������Ϣ��testImages��
			testImages
				mat�ļ����ļ�����һ���ǡ�testImages.mat������Ҳ���ܲ��ǡ�
			outdir
				ָ�����·��������extract���̲�����mat�ļ� extractedImages ��·��
				���·���������Ϊ��ĳ���㷨���й�����һ������·����������еķ�������ͼ���Ʊ����������Ŀ¼��չ��
			customedOutName
				һ���㷨��ͬ��������ͬ����Ŀ�Ŀ��ܻ���������ͬ�� extractedImages �ṹ������������ڱ�ʶ���ֲ�ͬ��
				���û������Ҫ�������������Ϊ�ա���Ϊextract���̻��Զ�������ȡ��ʽ����һ�� ���ơ�
			algfun
				��ȡ�㷨�ĺ���
			params
				�㷨����������Ҫ�Ĳ���
			includeAttacks
				ָ����ȡ����ԵĹ���
			includeImages
				��Ե�ͼ��
output:
	savemat: �����������Ӧ���Ǳ��������Ϣ��mat�ļ�

���ù��������
	getInputs_mbe_extract
	savemat = MBE_extract(extractPlan);
%}
function [savemat] = mbe_extract(extractPlan)
%% test inputs
   getInputs_mbe_extract

%% get inputs
if ~isempty(extractPlan)
	imdir = extractPlan(1).imdir;
	testImages = extractPlan(1).testImages;
	outdir = extractPlan(1).outdir;
	customedOutName = extractPlan(1).customedOutName;
	algfun = extractPlan(1).algfun;
	params = extractPlan(1).params;
	includeAttacks = extractPlan(1).includeAttacks;
	includeImages = extractPlan(1).includeImages;
else
	error('����');
end
% testImages�����Ǹ�������Ҳ�����Ǹ�mat�ļ�
if isstruct(testImages) ~= 1
	testImages = fullfile(imdir,testImages);
	load(testImages);
end

%% build a struct to store data will be generated
hashAttacked = struct('attMethod',{},'attStrength',{},'imagefile',{},'hashVector',{});
extractedImages = struct('imOriginal',{},'extractMethod',{},'hashOriginal',{},'hashAttacked',struct('imagefile',{},'hashVector',{},'attMethod',{},'attStrength',{}));

%% extract hashes according to testImages  
% ����һ��������Ҫ������Ǵ洢�����ݽṹ��hash��ȡ�����߼����⣬��hash��ȡ�޹ء� hash��ȡ�� extractby �С�
% ȡ���� includeImages ��ָ��ͼƬ��index
[tBe, indexInclude, indexImages] = intersect(includeImages, {testImages.imOriginal});
iCounter = 0;
for i = sort(indexImages)
    i
		iCounter = iCounter + 1;	% print i to show the rate of progress
	imOriginal = fullfile(imdir,testImages(i).imOriginal);
	extractedImages = setfield(extractedImages, { uint16(iCounter) }, 'imOriginal',testImages(i).imOriginal);
	extractedImages = setfield(extractedImages, { uint16(iCounter) }, 'extractMethod',func2str(algfun));	% ��¼��������
	
	hashVector = extractby(algfun,imOriginal,params);
	extractedImages = setfield(extractedImages,{ uint16(iCounter)},'hashOriginal',hashVector);
	clear hashVector;
	
	imAttacked = testImages(i).imAttacked;
	% ȡ���� includeAttacks ��ָ���Ĺ�����������index
	% ��Ϊÿ��ͼƬ�Ĵ���ʽ����һ���ġ�
	[tBe, indexInclude, indexImAttacked] = intersect(includeAttacks, {imAttacked.attMethod});
% 	if isempty(attBe);
% 		error('û��ָ����Ч�Ĺ�����ʽ');
% 	end
	jCounter = 0;
	for j = sort(indexImAttacked)	
% 		[i j] % print j to show the rate of progress
		jCounter = jCounter + 1;
		hashAttacked = setfield(hashAttacked,{uint16( jCounter )},'attMethod',imAttacked(j).attMethod);
		hashAttacked = setfield(hashAttacked,{uint16( jCounter )},'attStrength',imAttacked(j).attStrength);			
		hashAttacked = setfield(hashAttacked,{uint16( jCounter )},'imagefile',imAttacked(j).imSaved);
		% ʹ��Cell������ hashvector ����Ӧ���ֿ��ܵ����
		hashVector = cell(length(imAttacked(j).attStrength),1);
		for k = [1:length(imAttacked(j).attStrength)]
% 			k
			imSaved = fullfile(imdir,cell2mat(imAttacked(j).imSaved{k}));
			hashVector(k,1) = {extractby(algfun,imSaved,params)};
		end
		hashAttacked = setfield(hashAttacked,{uint16( jCounter )},'hashVector',hashVector);
	end
	extractedImages = setfield(extractedImages,{ uint16(iCounter)},'hashAttacked',hashAttacked);
    % ÿ n_save ��ͼƬ����һ��
    n_save = 50;
    if mod(i,n_save) == 0
        %  ���沢�ҽ�֮ǰ����0
        % �ڼ���
        nFinished = floor(i/n_save);
        if ~isempty(customedOutName)
            savemat = fullfile(outdir,['extractBy-',func2str(algfun),'_',customedOutName,'_',num2str(nFinished)]);
        else
            savemat = fullfile(outdir,['extractBy-',func2str(algfun),'_',num2str(nFinished)]);
        end
        if isdir(outdir) ~= 1
            mkdir(outdir);
        end
        if exist(savemat,'file') ~= 0
            movefile(savemat, [savemat, '.bak']);
        end 
        save(savemat,'extractedImages');
        clear('extractedImages');
        extractedImages = struct('imOriginal',{},'extractMethod',{},'hashOriginal',{},'hashAttacked',struct('imagefile',{},'hashVector',{},'attMethod',{},'attStrength',{}));
        iCounter = 0;
    end        

end % end i
%% Save into a mat file 
% ���û�б���Ϊ��ݵĻ��������Ψһ��һ�ݣ����������һ��
if ~isempty(extractedImages)
    if ~isempty(customedOutName)
        savemat = fullfile(outdir,['extractBy-',func2str(algfun),'_',customedOutName]);
    else
        savemat = fullfile(outdir,['extractBy-',func2str(algfun)]);
    end
    if isdir(outdir) ~= 1
        mkdir(outdir);
    end
    if exist(savemat,'file') ~= 0
        movefile(savemat, [savemat, '.bak']);
    end 
    save(savemat,'extractedImages');
end
end % end function

%% extract by algfun
function [H] = extractby(fun,imfilename,params)
% ���ܽ��յ�params���ݽ�ȥ������ᵼ�´���������һ����������ƣ�����ʡ�˺ö�����
	if isempty(params) ~= 1
		H = feval(fun,imfilename,params); 
	else
		H = feval(fun,imfilename); % 
	end
end
