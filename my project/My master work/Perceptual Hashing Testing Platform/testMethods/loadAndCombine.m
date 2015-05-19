%% 多个mat文件的情况下，拼接在一起
function extractedImages = loadAndCombine(workdir,extractedImages)
% 如果有多个文件，组合之，如果只有一个直接载入
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