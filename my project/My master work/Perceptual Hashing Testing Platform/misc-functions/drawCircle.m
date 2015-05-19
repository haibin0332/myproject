function Io = drawCircle(I,cx,cy,r,mode)
%% test inputs
% I = 512;
% cx = 256.5;
% cy = 256.5;
% r = 20; % 1 - 256;
% I = 513;
% cx = 257;
% cy = 257;
% r = 256; % 1 - 256;
% mode = 1;
%% function
% mode 1 ���� mode 2 ��Ȧ
% ֻ�������������һ����Բ���ڵ��ϣ�һ����Բ���ڵ��м䣬Ҳ����˵���϶��ǶԳƵ�
% ����512 * 512 ��ͼ��Բ���ڵ��м䣬�뾶Ӧ�õ�ȡֵ��Χ�ǣ�1 - 256
if isscalar(I)
    sizeI = [I,I];
else
    sizeI = size(I);
end    

Io = zeros(sizeI);

rr = r^2;
sr = r/sqrt(2);
% �뾶��ϵ
for i = 0:ceil(sr) % ���Բ���ڵ��ϣ��뾶��Ӧ�ò�������
    y(i + 1) = round(sqrt(rr - i^2));
end
% ����ģ��
if mode == 1
    if cx == ceil(cx) % Բ���ڵ���
        for j = 0:ceil(sr)
%             Io(cx + j,cy + y(j + 1)) = 1;
%             Io(cx + j,cy - y(j + 1)) = 1;
%             Io(cx - j : cx + j,cy - y(j + 1):cy + y(j + 1)) = 1;
            Io(cx - j : cx + j,cy - y(j + 1):cy + y(j + 1)) = 1;
        end  
        for j = 0:ceil(sr)
%             Io(cx - y(j + 1),cy + j) = 1;
%             Io(cx + y(j + 1),cy + j) = 1;
%             Io(cx - y(j + 1):cx + y(j + 1),cy - j:cy + j) = 1;
            Io(cx - y(j + 1):cx + y(j + 1),cy - j:cy + j) = 1;
        end  
    else % Բ���ڵ��м�
        for j = 1:ceil(sr) + 1
%             Io(ceil(cx) + j - 1,floor(cy) + y(j)) = 1;
%             Io(ceil(cx) + j - 1,ceil(cy) - y(j)) = 1;
%             Io(floor(cx) - j + 1:ceil(cx) + j - 1,ceil(cy) - y(j):floor(cy) + y(j)) = 1;
            Io(floor(cx) - j + 1:ceil(cx) + j - 1,ceil(cy) - y(j):floor(cy) + y(j)) = 1;
%             imshow(Io);
        end     
        for j = 1:ceil(sr)+1
%             Io(ceil(cx) - y(j),ceil(cy) + j - 1) = 1;
%             Io(floor(cx) + y(j),floor(cy) + j - 1) = 1;
            Io(ceil(cx) - y(j):floor(cx) + y(j),ceil(cy) - j + 1:ceil(cy) + j - 1) = 1;
            Io(ceil(cx) - y(j):floor(cx) + y(j),floor(cy) - j + 1:floor(cy) + j - 1) = 1;
        end         
    end   
elseif mode == 2
    if cx == ceil(cx) % Բ���ڵ���
        for j = 0:ceil(sr)
            Io(cx + j,cy + y(j + 1)) = 1;
            Io(cx + j,cy - y(j + 1)) = 1;
            Io(cx - j,cy + y(j + 1)) = 1;
            Io(cx - j,cy - y(j + 1)) = 1;
        end  
        for j = 0:ceil(sr)
            Io(cx - y(j + 1),cy + j) = 1;
            Io(cx + y(j + 1),cy + j) = 1;
            Io(cx - y(j + 1),cy - j) = 1;
            Io(cx + y(j + 1),cy - j) = 1;
        end  
    else % Բ���ڵ��м�
        for j = 1:ceil(sr) + 1
            Io(ceil(cx) + j - 1,floor(cy) + y(j)) = 1;
            Io(ceil(cx) + j - 1,ceil(cy) - y(j)) = 1;
            Io(floor(cx) - j + 1,floor(cy) + y(j)) = 1;
            Io(floor(cx) - j + 1,ceil(cy) - y(j)) = 1;
        end     
        for j = 1:ceil(sr)+1
            Io(ceil(cx) - y(j),ceil(cy) + j - 1) = 1;
            Io(floor(cx) + y(j),floor(cy) + j - 1) = 1;
            Io(ceil(cx) - y(j),ceil(cy) - j + 1) = 1;
            Io(floor(cx) + y(j),floor(cy) - j + 1) = 1;
        end         
    end      
end
%   imshow(Io);
%  who

