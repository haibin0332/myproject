%% 随机置乱多次差分
%{
输入序列，随机置乱，置乱前后取差
对于目前差分算法而言，这个的输入是规则选块的随机序列，所以需要随机置乱过程
inputs:
    inputVector：输入序列
    key: 密钥
    numdiffTimes: 差分的次数，就是相当于置乱的次数
%}
function diffvector = randpermDiff(inputVector,key,numdiffTimes)
rand('state',key);
numrects = length(inputVector);
iA = [1:numrects];
diffvector = zeros(1,numrects * numdiffTimes);
for i  = 1:numdiffTimes
    iB = randperm(numrects);
    tphash = inputVector(iA) - inputVector(iB);
    if i == 1
        diffvector = tphash;
    else
        diffvector = [diffvector; tphash];
    end
end  
end % end function