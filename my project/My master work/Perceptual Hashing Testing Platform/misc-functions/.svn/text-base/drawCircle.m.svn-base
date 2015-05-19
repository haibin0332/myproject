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
% mode 1 画饼 mode 2 画圈
% 只处理两种情况，一种是圆心在点上，一种是圆心在点中间，也就是说，肯定是对称的
% 对于512 * 512 的图，圆心在点中间，半径应该的取值范围是：1 - 256
if isscalar(I)
    sizeI = [I,I];
else
    sizeI = size(I);
end    

Io = zeros(sizeI);

rr = r^2;
sr = r/sqrt(2);
% 半径关系
for i = 0:ceil(sr) % 如果圆心在点上，半径就应该不是整数
    y(i + 1) = round(sqrt(rr - i^2));
end
% 制作模板
if mode == 1
    if cx == ceil(cx) % 圆心在点上
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
    else % 圆心在点中间
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
    if cx == ceil(cx) % 圆心在点上
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
    else % 圆心在点中间
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

