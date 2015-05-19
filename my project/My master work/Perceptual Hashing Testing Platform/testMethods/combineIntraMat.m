%% ���intraMat�ļ�������£�ƴ�ӳ�һ����������,�����ļ���
function intraMatCombined = combineIntraMat(workdir,intraMatfiles,ls)
%% test intputs
% workdir = 'E:\outdir\zh_rdd\testForLetter';
% intraMatfiles =  'intraTest-extractBy-mbe_zh_rdd_numdiff4';
%{
ʹ�����������ʱ��Ҫ��֤��������mat�ļ����������Ϣ����һ�µġ�����ֱ�ӶԸ�����Ϣ���д�������һ���Լ�顣
intraClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{},'includeAttacks',{},'includeImages',{});
intraDistance = struct('attMethod',{},'attStrength',{},'Distances',{});
intraClassTest = struct('intraClassTestPlan',{},...
						'intraDistance',struct('attMethod',{},'attStrength',{},'Distances',{}));
%}     
tpIntra = struct('intraClassTestPlan',{},...
						'intraDistance',struct('attMethod',{},'attStrength',{},'Distances',{})); % ���ڱ���ƴ����������ʱ��Ϣ
if ~isempty(ls) % ���ls��empty����ô�Լ���ͼȥѰ�ң��������ָ��������ϲ�ָ���ġ������ṩһ��ָ���ϲ��������ֶ�
    ls = dir(fullfile(workdir,[intraMatfiles,'*.mat']));
    if isempty(ls)
        error('ľ���ҵ���');
    end
end
if ~isempty(dir(fullfile(workdir,[intraMatfiles,'.mat']))) && length(ls) > 1
    warning('�Ѿ���һ���ϲ��汾���ڣ�����ͬ��'); % ���������˵�ϲ��汾�ͷǺϲ��汾ͬʱ����
    % �Ѿ����ھ�ֱ�������
    intraMatCombined = fullfile(workdir,[intraMatfiles,'.mat']);
end

load(fullfile(workdir,ls(1).name));
tpIntra = intraClassTest;
if length(ls) >= 2
    for i = 2:length(ls)
        load(fullfile(workdir,ls(i).name));
        tpIntra.intraClassTestPlan.includeImages = [tpIntra.intraClassTestPlan.includeImages;intraClassTest.intraClassTestPlan.includeImages];
        for j = 1:length(tpIntra.intraDistance)
            tpIntra.intraDistance(j).Distances = [tpIntra.intraDistance(j).Distances; intraClassTest.intraDistance(j).Distances];
        end
    end
end
intraClassTest = tpIntra;
intraMatCombined = fullfile(workdir,intraMatfiles);
save(intraMatCombined,'intraClassTest');

% who
end % end function