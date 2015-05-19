function trustM=trustAB(train_vec,num_u,beta)
%Compute trust within n hops
%First hop;
trustM=zeros(num_u,num_u);
for source=1:num_u
    temp=train_vec(train_vec(:,1)==source,:);
    for target=temp(:,2)'
        trustM(source,target)=temp(temp(:,2)==target,3);
    end
    % Second hop:
    for subsource=temp(:,2)'
        temp=train_vec(train_vec(:,1)==subsource,:);
        for target=temp(:,2)'
            if trustM(source,target)==0
                trustM(source,target)=beta*trustM(source,subsource)*temp(temp(:,2)==target,3);
            end
        end
        
    end
end
end



