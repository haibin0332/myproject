%% 计算两幅图像的哈希值之间的距离，输入参数是这两幅图像的哈希值，输出参数是它们之间的距离
function r = match_luomin_modifyVMWaveletWithLumimask_Euclidean(hashReference,hashTest,params)
cmp_hash = normlize(hashReference, hashTest);
v = (hashReference(:,1) - cmp_hash(:,1))/(2*sqrt(norm(hashReference(:,1))*norm(hashTest(:,1))));
r = norm(v);

%% normlize这个函数利用原始图像亮度掩蔽的容差信息来对待测图像的哈希序列进行归整化
function t = normlize(hashReference, hashTest)
s = size(hashReference,1);
for i = 1:s
    if hashReference(i,3) >= hashReference(i,2)
        low = hashReference(i,2);
        high = hashReference(i,3);
    else
        low = hashReference(i,3);
        high = hashReference(i,2);
    end
    % 如果受攻击图像的哈希值介于容差范围内，则把原始图像这个位置的哈希值赋给它。
    if ( hashTest(i,1) >= low ) && ( hashTest(i,1) <= high )
        hashTest(i,1) = hashReference(i,1);
    end
end
t = hashTest;