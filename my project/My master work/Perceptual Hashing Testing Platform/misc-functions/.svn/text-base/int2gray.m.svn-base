% 这个函数将一个整数向量的输入转化为gray码，如果输入长度为n，则输出为 n * quantizelevels
% gray码的生成很简单，可以参考：http://www.vckbase.com/document/viewdoc/?id=1305
%{
自然二进制码转换成二进制格雷码，其法则是保留自然二进制码的最高位作为格雷码的最高位，
而次高位格雷码为二进制码的高位与次高位相异或，而格雷码其余各位与次高位的求法相类似。
%}
function graycode = int2gray(intvector,quantizelevels)
%% test inputs
% intvector = [15, 14, 4,8,3,2,1];
% quantizelevels = 4;
%% function
graycode = zeros(1,quantizelevels * length(intvector));
for i = 1:length(intvector)
   if intvector(i) >= 2^quantizelevels
       error('输入整数向量数据太大，或者量化级数太小');       
   end
   codetp = zeros(1,quantizelevels);
   % 得到自然二进制的编码 
   intcode = intvector(i);
   for j = quantizelevels:-1:1
       if intcode >= 2^(j-1)
           codetp(quantizelevels - j + 1) = 1;
       else
           codetp(quantizelevels - j + 1) = 0;
       end
       intcode = mod(intcode,2^(j-1));
   end
   % 转换为二进制的编码
   graytp = zeros(1,quantizelevels);
   graytp(1) = codetp(1);
   for j = 2:quantizelevels
        graytp(j) = xor(codetp(j - 1),codetp(j));
   end
   % 存起来
   graycode(quantizelevels * (i-1) + 1 : quantizelevels * (i-1) + quantizelevels) = graytp;
end

