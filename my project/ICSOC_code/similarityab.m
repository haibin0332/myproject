
function S1=similarityab(train_vec,num_u)
%º∆À„ Pearson Correlation Coefficient matrix %
%condition data: train_vec

S1=zeros(num_u,num_u);
for i=1:num_u
    temp_i=train_vec(train_vec(:,1)==i,:); %U_i ratings
    for f=1:size(temp_i,1)
        temp_f=train_vec(train_vec(:,1)==temp_i(f,2),:);% U_f ratings. the ratings of users who have been rated by i
        [index_i,index_f]=compareab(temp_i(:,2),temp_f(:,2)); %index_i,index_f are the index of mutual elements separately
        if index_i(1)==0||index_f(1)==0
            S1(i,f)=0;
            continue;
        end
        xi=temp_i(index_i,3);
        xf=temp_f(index_f,3);
        S1_temp=sum(xi.*xf)/(sqrt(sum(xi.^2))*sqrt(sum(xf.^2)));
        S1(i,f)=S1_temp;
    end
end