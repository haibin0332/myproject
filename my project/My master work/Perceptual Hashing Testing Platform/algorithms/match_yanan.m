function [hammingDistance] = match_yanan(hash1, hash2, param)
% ѭ��ƥ�䣬������HASHֵ�Ƿ�����
%% ˵��
% hash1       : [input] the first hash
% hash2       : [input] the second hash
% correlation : [output] correlation
% Note : hash1 and hash2 have the same dimension
% %% Ԥ����
% if nargin == 2
% 	method = 1;
% 	n = 64;
% 	r2 = 0.71;
% 	r1 = 1/4;
% else
% 	length(param) == 4
% 	method = param(1);
% 	n = param(2);
% 	r2 = param(3);
% 	r1 = param(4);
% end	

% hash1 = MBE_yanan(picture1, r1, r2, n, method);
% hash2 = MBE_yanan(picture2, r1, r2, n, method);
% hash1 = MBE_bian(picture1, 1);
% hash2 = MBE_bian(picture2, 1);

% %% ���㺺������
% if method == 1  || method ==3
% %% method 1 ��ʹ����һ�α��룬û�г�ʼ�ǶȲ������������
%     n = size(hash1, 2);     % compute the length of hash value
% 
%     for j = 0: (n - 1)
%         for i = 1: n
%             if mod(i + j, n + 1) == 0
%                 tempHash(i) = hash2(1);
%             else
%                 tempHash(i) = hash2(mod(i + j, n + 1));
%             end
%         end
%         h = hash1 - tempHash;
%         hammingD(j + 1) = sum(abs(h));
%     end
%     hammingDistance = min(hammingD)/length(h);		%��һ��
% elseif method == 2 || method ==5
% %% ����2ʹ���˳�ʼ�Ƕȣ�������һ�����������ġ�
% 	for j = 0: (n - 1)
%         for i = 1: n
%             if mod(i + j, n + 1) == 0
%                 tempHash(i) = hash2(1);
%             else
%                 tempHash(i) = hash2(mod(i + j, n + 1));
%             end
%         end
%         h = hash1(1:n) - tempHash;
%         hammingD(j + 1) = sum(abs(h));
%     end
%     
%     for j = n: (2*n - 1)
%         for i = (n+1): 2*n
%             if mod(i + j, 2*n + 1) == 0
%                 tempHash(i) = hash2(1);
%             else
%                 tempHash(i) = hash2(mod(i + j, 2*n + 1));
%             end
%         end
%         h = hash1((n+1):2*n) - tempHash((n+1):2*n);
%         hammingD(j + 1) = sum(abs(h));
%     end
%     hammingDistance = min(min(hammingD(1:n)), min(hammingD((n+1):2*n)))/length(h);
% elseif method ==4   % ֻȡ����2�ĺ���HASH
% %%
%     for j = 0: (n - 1)
%         for i = 1: n
%             if mod(i + j, n + 1) == 0
%                 tempHash(i) = hash2(1);
%             else
%                 tempHash(i) = hash2(mod(i + j, n + 1));
%             end
%         end
%         h = hash1 - tempHash;
%         hammingD(j + 1) = sum(abs(h));
%     end
%     hammingDistance = min(hammingD)/length(h);
% end
h = hash1 - hash2;
hammingDistance = sum(abs(h))/length(h);