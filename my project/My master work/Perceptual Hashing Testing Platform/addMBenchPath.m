function [] = addMBenchPath(path,ignorelist)
ignore = ignorelist;

lst = dir(path);
for k = 1:length(lst)
	if lst(k).isdir 
		if sum(strcmp(lst(k).name, ignore)) == 0
			path1 = fullfile(path,lst(k).name)
			addpath(path1);
			addMBenchPath(path1,ignore);	% �ݹ����
		end
	end
end % end for
