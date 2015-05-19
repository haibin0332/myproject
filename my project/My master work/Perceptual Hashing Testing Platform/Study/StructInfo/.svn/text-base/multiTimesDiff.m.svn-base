%% 随机序列多次差分
%{
输入随机序列，相邻一定步长取差，输出为差值序列
对于目前差分算法而言，这个的输入是随机选块均值序列，所以不需要置乱
inputs:
    inputVector：输入序列
    numdiffTimes: 差分的次数，就是相当于差分的步长
%}
function diffvector = multiTimesDiff(inputVector,numdiffTimes)
numrects = length(inputVector);
iA = [1:numrects];
diffvector = zeros(1,numrects * numdiffTimes);
for i  = 1:numdiffTimes
    for j = 1:numrects
        if i + j <= numrects
            iB(j) = iA(i+j);
        else
            iB(j) = iA(mod(j + i,numrects));
        end
    end
    % 差分
    diffvector((i-1)*numrects+1:(i*numrects)) = inputVector(iA) - inputVector(iB);
end
end % end function