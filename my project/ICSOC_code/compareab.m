function [comp_i,comp_f]=compareab(temp_i,temp_f)
%%compare two array, 
%%and give out the index of mutual elements
%%% 
k=0;
for i=1:length(temp_i)
    for j=1:length(temp_f)
        if temp_i(i)==temp_f(j)
            k=k+1;
            comp_i(k)=i;
            comp_f(k)=j;
            continue;
        end
    end
end
if length(unique(temp_i))~=length(temp_i) || length(unique(temp_f))~=length(temp_f)
    fprintf(2,'Warning: 数据错误. ratings 出现两次\n');
end
if k==0
    comp_i=0;
    comp_f=0;
end