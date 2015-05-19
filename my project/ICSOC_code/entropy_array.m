function H = entropy_array(v)
% ENTROPY Entropy log base 2
% H = entropy(v)

tem=unique(v);
temp=zeros(length(tem),1);
for i=1:length(tem)
    temp(i)=sum(v==tem(i));
end
v=temp/sum(temp);
H = -1 * sum(v .* log2(v), 1); % sum the rows


