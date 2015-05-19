function [hashData] = extractedData()

%% Extracting
% hashData
load('E:\DoctorThesis\MBench\Plan\outdir\mbe_Wyn2_watsonBased\Method3\withoutHVS_corrected(38)\extractBy-mbe_wang_AuthenticationPHBasedWaston.mat')
fp = fopen('data_withoutHVS.txt','w');

% for imageID = 1:38
% 	for attackID = 1:size(extractedImages(1,imageID).hashAttacked, 2)
% 		for hashID = 1:size(extractedImages(1,imageID).hashAttacked(1, attackID).hashVector, 1)
% 			hashData = extractedImages(1,imageID).hashAttacked(1,attackID).hashVector{hashID,1};
% 			fprintf(fp, '%d ', hashData);
% 		end
% 	end
% end

for imageID = 1:38
	hashData = extractedImages(1,imageID).hashOriginal
	fprintf(fp, '%d', hashData);
end
fclose(fp);

