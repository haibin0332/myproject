function trust=subtrust(subsource,target,train_vec,hop)   
% subsource is the id whose neighbors will be searched.
% n is the generation
%train_vect, source and target is global variants.
FLAG=1;
temp=train_vec(train_vec(:,1)==subsource,:);% neighbor's neighbors
if hop<1 || isempty(temp)
    trust=0;
else
    for j=temp(:,2)'
        if j==target
            trust=temp(temp(:,2)==j,3);
            FLAG=0;
            break;
        end
    end
    if FLAG
        for j=temp(:,2)'
            trust=temp(temp(:,2)==j,3)*subtrust(j,target,train_vec,hop-1);
        end
    end
end
end
