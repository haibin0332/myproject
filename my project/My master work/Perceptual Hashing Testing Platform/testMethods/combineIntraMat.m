%% 多个intraMat文件的情况下，拼接成一个，并保存,返回文件名
function intraMatCombined = combineIntraMat(workdir,intraMatfiles,ls)
%% test intputs
% workdir = 'E:\outdir\zh_rdd\testForLetter';
% intraMatfiles =  'intraTest-extractBy-mbe_zh_rdd_numdiff4';
%{
使用这个函数的时候，要保证各个输入mat文件所保存的信息都是一致的。函数直接对各个信息进行处理，不做一致性检查。
intraClassTestPlan = struct('workdir',{},'extractedImages',{},'customedOutName',...
						{},'algfun',{},'matchfun',{},'params',{},'normalizedDistRange',{},'includeAttacks',{},'includeImages',{});
intraDistance = struct('attMethod',{},'attStrength',{},'Distances',{});
intraClassTest = struct('intraClassTestPlan',{},...
						'intraDistance',struct('attMethod',{},'attStrength',{},'Distances',{}));
%}     
tpIntra = struct('intraClassTestPlan',{},...
						'intraDistance',struct('attMethod',{},'attStrength',{},'Distances',{})); % 用于保存拼接起来的临时信息
if ~isempty(ls) % 如果ls是empty，那么自己试图去寻找，如果已有指定，这仅合并指定的。这是提供一种指定合并个数的手段
    ls = dir(fullfile(workdir,[intraMatfiles,'*.mat']));
    if isempty(ls)
        error('木有找到！');
    end
end
if ~isempty(dir(fullfile(workdir,[intraMatfiles,'.mat']))) && length(ls) > 1
    warning('已经有一个合并版本存在，或者同名'); % 这种情况是说合并版本和非合并版本同时存在
    % 已经存在就直接用这个
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