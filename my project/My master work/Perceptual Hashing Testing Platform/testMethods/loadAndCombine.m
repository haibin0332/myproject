%% ���mat�ļ�������£�ƴ����һ��
function extractedImages = loadAndCombine(workdir,extractedImages)
% ����ж���ļ������֮�����ֻ��һ��ֱ������
ls = dir(fullfile(workdir,[extractedImages,'_*.mat']));
loadSt = load(fullfile(workdir,ls(1).name)); % extractedImages = 
extractedImages = loadSt.extractedImages;
if length(ls) >= 2
    for i = 1:length(ls)
        loadSt = load(fullfile(workdir,ls(i).name));
        i
        extractedImages = [extractedImages,loadSt.extractedImages];
    end
end
who
end % end function