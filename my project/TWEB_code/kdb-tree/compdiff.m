function  [node2, same]=compdiff(node, rating1, rating2, rating3, rating4, rating5, item) %num2时间， num1 钱
%%%%%%%%%%%%%%%%%%%
%%%%%%%此部分被kdbtree调用
%%%%%%%%%%%%%%%%%%%%%%%%%%

k=1;
same=0;

node_num=size(node,2); 
record=node(node_num).maxtime;
for  j=1:1:node_num
    if  node(j).maxtime==record
        w(k)=j;
        k=k+1;
    end
end

for p=1:1:size(w,2)
vector(p)=node(w(p)); 
end

if size(w,2)==1     
        for u=1:1:size(node(node_num).leaf, 2)
            if strcmp(node(node_num).leaf(u).item, item)==1
                  node(node_num).leaf(u).sum_num=node(node_num).leaf(u).sum_num+1;
                  node(node_num).leaf(u).sum_rating(1)=node(node_num).leaf(u).sum_rating(1)+str2double(rating1);
                  node(node_num).leaf(u).sum_rating(2)=node(node_num).leaf(u).sum_rating(2)+str2double(rating2);
                  node(node_num).leaf(u).sum_rating(3)=node(node_num).leaf(u).sum_rating(3)+str2double(rating3);
                  node(node_num).leaf(u).sum_rating(4)=node(node_num).leaf(u).sum_rating(4)+str2double(rating4);
                  node(node_num).leaf(u).sum_rating(5)=node(node_num).leaf(u).sum_rating(5)+str2double(rating5);
                  same=1;                  
            end
            %%%直接返回
        end
        if same==1            
            node2=node;
        end
                  
elseif size(w,2)>1
    for  v=1:1:size(w, 2)
        for u=1:1:size(vector(v).leaf, 2)
            if strcmp(vector(v).leaf(u).item, item)==1
                  vector(v).leaf(u).sum_num=vector(v).leaf(u).sum_num+1;
                  vector(v).leaf(u).sum_rating(1)=vector(v).leaf(u).sum_rating(1)+str2double(rating1);
                  vector(v).leaf(u).sum_rating(2)=vector(v).leaf(u).sum_rating(2)+str2double(rating2);
                  vector(v).leaf(u).sum_rating(3)=vector(v).leaf(u).sum_rating(3)+str2double(rating3);
                  vector(v).leaf(u).sum_rating(4)=vector(v).leaf(u).sum_rating(4)+str2double(rating4);
                  vector(v).leaf(u).sum_rating(5)=vector(v).leaf(u).sum_rating(5)+str2double(rating5);
                  same=1;                  
            end
            %%%直接返回
        end
        if same==1            
           if  w(1)==1
             node2=vector;             
           elseif w(1)>1
            for r=1:1:(w(1)-1)                
                node2(r)=node(r);
            end
            for r=1:1:size(vector, 2)
                node2(w(1)-1+r)=vector(r);        
            end              
           end                         
        end
    end
end
if same==0
    node2=struct();
end

end

         