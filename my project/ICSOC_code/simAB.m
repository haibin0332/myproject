function S2=simAB(train_vec,num_u)
%º∆À„ Pearson Correlation Coefficient matrix
%condition data: train_vec
Uf=zeros(num_u,6);
S2=zeros(num_u,num_u);

%%calculate the credibility:
for i=1:num_u
    temp_i=train_vec(train_vec(:,1)==i,:); %U_i ratings as a trustor
    if isempty(temp_i)
        continue;
    end
    temp=0;
    for j=1:size(temp_i,1)
        temp_j=train_vec(train_vec(:,2)==temp_i(j,2),:);% U_f ratings. the ratings of users who have been rated by i
        temp=temp+abs(temp_i(j,3)-mean(temp_j(:,3)));
    end
    Uf(i,1)=temp/j;% Put in credibility
    Uf(i,2)=entropy_array(temp_i(:,3)); %Put in Entropy
    Uf(i,3)=mean(temp_i(:,3)); %Put in Trustor bias
    temp_ii=train_vec(train_vec(:,2)==i,:);  %ratings as a trustee
    
    if isempty(temp_ii)
        Uf(i,4)=0;
    else
        Uf(i,4)=mean(temp_ii(:,3)); %Put in trustee bias
    end
    
    Uf(i,5)=size(temp_ii,1); %Put in Indegree
    Uf(i,6)=size(temp_i,1); %Put in Outdegree
end

if sum(sum(Uf<0))
    fprintf(2,'errer Õ£÷π~~~!\n');
end

for i=1:6
    Uf(:,i)=(Uf(:,i)-min(Uf(:,i)))/(max(Uf(:,i))-min(Uf(:,i)));
end
for i=1:num_u
    for j=1:num_u
        denominator=(sqrt(sum(Uf(i,:).^2))*sqrt(sum(Uf(i,:).^2)));
        if denominator==0
            S2(i,j)=0;
        else
            S2(i,j)=sum(Uf(i,:).*Uf(j,:))/denominator;
        end
    end
end
for i=1:6
    S2(i,:)=(S2(i,:)-min(S2(i,:)))/(max(S2(i,:))-min(S2(i,:)));
end