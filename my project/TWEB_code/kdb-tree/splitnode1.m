function  [node2, mark]=splitnode1(node1, num1, num2, rating1, rating2, rating3, rating4, rating5, item) %num2时间， num1 钱
%%%%%%%%%%%%%%%%%
%%%%%%%%此部分被kdbtree调用
%%%%%%%%%%%
n_leaf=51;
k=1;
t=1;
k1=1;
k11=1;
k2=1;
k3=1;
max=100000;
pot=0;
sameitem=0;

%test='splitnode.m 没编呢';
%%md原跟来的应该一样哦， 把dimR和leaf全拿出来单独再形成dimR 调用mergeleafandnode.m
node1_num=size(node1,2);
node_num=size(node1(node1_num).node,2);

if  (num2==node1(node1_num).node(node_num).maxtime)&&(node1(1).dimark==0)

record=node1(node1_num).node(node_num).maxtime;


for  j=1:1:node_num
    if  node1(node1_num).node(j).mintime==record
        w(k)=j;
        k=k+1;
    end
end

%%%%b编到这里
%%%pot前的全是node(1)


for p=1:1:size(w,2)
    tempnode(k1).sum_num=node1(node1_num).node(w(p)).sum_num;
    tempnode(k1).sum_rating(1)=node1(node1_num).node(w(p)).sum_rating(1);
    tempnode(k1).sum_rating(2)=node1(node1_num).node(w(p)).sum_rating(2);
    tempnode(k1).sum_rating(3)=node1(node1_num).node(w(p)).sum_rating(3);
    tempnode(k1).sum_rating(4)=node1(node1_num).node(w(p)).sum_rating(4);
    tempnode(k1).sum_rating(5)=node1(node1_num).node(w(p)).sum_rating(5);
    tempnode(k1).onedimR=node1(node1_num).node(w(p)).onedimR;
    k1=k1+1;
end

if size(w,2)==1
    mark=1;
node_1(1).level=1;
node_1(1).mintime=node1(node1_num).node(1).mintime;
node_1(1).maxtime=node1(node1_num).node(w(1)-1).maxtime;
node_1(1).minprice=0;
node_1(1).maxprice=max;
node_1(1).sum_num=0;
node_1(1).sum_num=node1(node1_num).sum_num;
node_1(1).sum_rating(1)=node1(node1_num).sum_rating(1);
node_1(1).sum_rating(2)=node1(node1_num).sum_rating(2);
node_1(1).sum_rating(3)=node1(node1_num).sum_rating(3);
node_1(1).sum_rating(4)=node1(node1_num).sum_rating(4);
node_1(1).sum_rating(5)=node1(node1_num).sum_rating(5);

 for j=1:1:(w(1)-1)    
 node_1(1).node(j)=node1(node1_num).node(j);                    
 end

 
node_1(2).level=1;
node_1(2).mintime=node1(node1_num).node(w(1)).mintime;
node_1(2).maxtime=max;%%新结点时间
node_1(2).minprice=0;
node_1(2).maxprice=max;
    
temptwonode=smallsplitnode(node1(node1_num).node(node_num), num1, num2, rating1, rating2, rating3, rating4, rating5, item);

[node_1(2).sum_num, node_1(2).sum_rating(1), node_1(2).sum_rating(2), node_1(2).sum_rating(3), node_1(2).sum_rating(4), node_1(2).sum_rating(5)]=smallsizemerge(tempnode);

 for j=w(1):1:(node_num-1)   
 node_1(2).node(j-w(1)+1)=node1(node1_num).node(j);                    
 end 
 nonum=size(node_1(2).node ,2);
 node_1(2).node(nonum+1)=temptwonode(1);
 node_1(2).node(nonum+2)=temptwonode(2);
 
node1(node1_num)=node_1(1);
node1(node1_num+1)=node_1(2);

record=node1(size(node1,2)).mintime;

node2(1).level=1;
node2(1).dimark=0;
node2(1).mintime=node1(1).mintime;

for  j=1:1:size(node1,2)
    if  node1(j).mintime==record 
        z(k2)=j;
        k2=k2+1;
    end
end


%%%pot前的全是node(1)
node2(1).maxtime=node1(z(1)-1).maxtime;
node2(1).minprice=0;
node2(1).maxprice=max;
node2(1).sum_num=0;
node2(1).sum_rating(1)=0;
node2(1).sum_rating(2)=0;
node2(1).sum_rating(3)=0;
node2(1).sum_rating(4)=0;
node2(1).sum_rating(5)=0;
 for j=1:1:(z(1)-1)    
 node2(1).node1(j)=node1(j);                    
 end

node2(2).level=1;
node2(2).mintime=node1(size(node1,2)).mintime;
node2(2).maxtime=max;%%新结点时间
node2(2).minprice=0;
node2(2).maxprice=max;

for p=1:1:size(z,2)
    ttempnode(k11).sum_num=node1(z(p)).sum_num;
    ttempnode(k11).sum_rating(1)=node1(z(p)).sum_rating(1);
    ttempnode(k11).sum_rating(2)=node1(z(p)).sum_rating(2);
    ttempnode(k11).sum_rating(3)=node1(z(p)).sum_rating(3);
    ttempnode(k11).sum_rating(4)=node1(z(p)).sum_rating(4);
    ttempnode(k11).sum_rating(5)=node1(z(p)).sum_rating(5);
    k11=k11+1;
end

[node2(2).sum_num, node2(2).sum_rating(1), node2(2).sum_rating(2), node2(2).sum_rating(3), node2(2).sum_rating(4), node2(2).sum_rating(5)]=smallsizemerge(ttempnode);

 for j=z(1):1:(node_num+1)   
 node2(2).node1(j-z(1)+1)=node1(j);
 end 
 
 %[node1(2).sum_num, node1(2).sum_rating(1), node1(2).sum_rating(2), node1(2).sum_rating(3), node1(2).sum_rating(4), node1(2).sum_rating(5), node1(2).onedimR]=smallsizemerge(tempnode);
elseif size(w,2)>1
    %%%%%%挑选插入
    for  v=1:1:size(w, 2)
      vector(v)=node1(node1_num).node(w(v));              
    end
    for  v=1:1:size(w, 2)
        if num1<vector(v).maxprice
        for u=1:1:size(vector(v).leaf, 2)
            if strcmp(vector(v).leaf(u).item, item)==1
                  vector(v).leaf(u).sum_num=vector(v).leaf(u).sum_num+1;
                  vector(v).leaf(u).sum_rating(1)=vector(v).leaf(u).sum_rating(1)+str2double(rating1);
                  vector(v).leaf(u).sum_rating(2)=vector(v).leaf(u).sum_rating(2)+str2double(rating2);
                  vector(v).leaf(u).sum_rating(3)=vector(v).leaf(u).sum_rating(3)+str2double(rating3);
                  vector(v).leaf(u).sum_rating(4)=vector(v).leaf(u).sum_rating(4)+str2double(rating4);
                  vector(v).leaf(u).sum_rating(5)=vector(v).leaf(u).sum_rating(5)+str2double(rating5);
                  sameitem=1;                  
            end
            %%%直接返回
        end
        if sameitem==1
            
            for r=1:1:(w(1)-1)                
                node1(node1_num).node(r)=node1(node1_num).node(r);
            end
            for r=1:1:size(vector, 2)
               node1(node1_num).node(w(1)-1+r)=vector(r);        
            end
            mark=0; %%没有分裂
            
            node2=node1;
        end
        if  ((size(vector(v).leaf, 2)+1)<= n_leaf)&&(sameitem==0)  %#ok<ALIGN>  
            u=size(vector(v).leaf, 2);
          vector(v).leaf(u+1).item=item; %%maxkey
          vector(v).leaf(u+1).price=num1;
          vector(v).leaf(u+1).time=num2;%%maxtime;        
          vector(v).leaf(u+1).sum_num=1;
          vector(v).leaf(u+1).sum_rating(1)=str2double(rating1);
          vector(v).leaf(u+1).sum_rating(2)=str2double(rating2);
          vector(v).leaf(u+1).sum_rating(3)=str2double(rating3);
          vector(v).leaf(u+1).sum_rating(4)=str2double(rating4);
          vector(v).leaf(u+1).sum_rating(5)=str2double(rating5);                      %#ok<NASGU>
          %%%直接返回
            for r=1:1:(w(1)-1)                
                node1(node1_num).node(r)=node1(node1_num).node(r);
            end
            for r=1:1:size(vector, 2)
               node1(node1_num).node(w(1)-1+r)=vector(r);        
            end   
          mark=0; %%没有分解
              node2=node1;
              break;
        end
        
       if ((size(vector(v).leaf, 2)+1)> n_leaf)&&(sameitem==0) %%叶子分裂同时伴随key分解 
           %%%分裂%%%%
           temptwonode=smallsplitnode(vector(v), num1, num2, rating1, rating2, rating3, rating4, rating5, item);
           if  v==1
               vector1(1)=temptwonode(1);
               vector1(2)=temptwonode(2);
               for u=2:1:size(vector, 2)                 
                vector1(u+1)=vector(u);   
               end               
           elseif v==size(vector, 2)
               for u=1:1:(size(vector, 2)-1)               
                vector1(u)=vector(u);   
               end 
               vector1(u+1)=temptwonode(1); 
               vector1(u+2)=temptwonode(2);  %#ok<NASGU>
             
           elseif (v>1)&&(v<size(vector, 2))
               for u=1:1:(v-1)                
                vector1(u)=vector(u);   
               end     
               vector1(v)=temptwonode(1);
               vector1(v+1)=temptwonode(2);
               for u=(v+1):1:size(vector, 2)                
                vector1(u+1)=vector(u);   
               end          
           end
            for r=1:1:(w(1)-1)                
                node1(node1_num).node(r)=node1(node1_num).node(r);
            end
            for r=1:1:size(vector1, 2)
               node1(node1_num).node(w(1)-1+r)=vector1(r);        
            end
           mark=1;
           %%需要分裂
node_1(1).level=1;
node_1(1).dimark=1;
node_1(1).mintime=node1(node1_num).node(1).mintime;
node_1(1).maxtime=node1(node1_num).node(w(1)-1).maxtime;
node_1(1).minprice=0;
node_1(1).maxprice=max;
node_1(1).sum_num=0;
node_1(1).sum_num=node1(node1_num).sum_num;
node_1(1).sum_rating(1)=node1(node1_num).sum_rating(1);
node_1(1).sum_rating(2)=node1(node1_num).sum_rating(2);
node_1(1).sum_rating(3)=node1(node1_num).sum_rating(3);
node_1(1).sum_rating(4)=node1(node1_num).sum_rating(4);
node_1(1).sum_rating(5)=node1(node1_num).sum_rating(5);


 for j=1:1:(w(1)-1)    
 node_1(1).node(j)=node1(node1_num).node(j);                    
 end

 
node_1(2).level=1;
node_1(2).dimark=1;
node_1(2).mintime=node1(node1_num).node(w(1)).mintime;
node_1(2).maxtime=max;%%新结点时间
node_1(2).minprice=0;
node_1(2).maxprice=max;
for  j=w(1):1:size(node1(node1_num).node, 2)
    if  node1(node1_num).node(j).mintime==record
        v(t)=j;
        t=t+1;
    end
end


for p=1:1:size(v,2)
    vtempnode(k3).sum_num=node1(node1_num).node(v(p)).sum_num;
    vtempnode(k3).sum_rating(1)=node1(node1_num).node(v(p)).sum_rating(1);
    vtempnode(k3).sum_rating(2)=node1(node1_num).node(v(p)).sum_rating(2);
    vtempnode(k3).sum_rating(3)=node1(node1_num).node(v(p)).sum_rating(3);
    vtempnode(k3).sum_rating(4)=node1(node1_num).node(v(p)).sum_rating(4);
    vtempnode(k3).sum_rating(5)=node1(node1_num).node(v(p)).sum_rating(5);
    vtempnode(k3).onedimR=node1(node1_num).node(v(p)).onedimR;
    k3=k3+1;
end

[node_1(2).sum_num, node_1(2).sum_rating(1), node_1(2).sum_rating(2), node_1(2).sum_rating(3), node_1(2).sum_rating(4), node_1(2).sum_rating(5)]=smallsizemerge(vtempnode);

 for j=w(1):1:size(node1(node1_num).node, 2)  
 node_1(2).node(j-w(1)+1)=node1(node1_num).node(j);                    
 end 

 node1(node1_num)=node_1(1);
node1(node1_num+1)=node_1(2);

 %%%%
record=node1(size(node1,2)).mintime;

node2(1).level=1;
node2(1).dimark=0;
node2(1).mintime=node1(1).mintime;

for  j=1:1:size(node1,2)
    if  node1(j).mintime==record 
        z(k2)=j;
        k2=k2+1;
    end
end


%%%pot前的全是node(1)
node2(1).maxtime=node1(z(1)-1).maxtime;
node2(1).minprice=0;
node2(1).maxprice=max;
node2(1).sum_num=0;
node2(1).sum_rating(1)=0;
node2(1).sum_rating(2)=0;
node2(1).sum_rating(3)=0;
node2(1).sum_rating(4)=0;
node2(1).sum_rating(5)=0;
 for j=1:1:(z(1)-1)    
 node2(1).node1(j)=node1(j);                    
 end

node2(2).level=1;
node2(2).dimark=1;
node2(2).mintime=node1(size(node1,2)).mintime;
node2(2).maxtime=max;%%新结点时间
node2(2).minprice=0;
node2(2).maxprice=max;

for p=1:1:size(z,2)
    ttempnode(k11).sum_num=node1(z(p)).sum_num;
    ttempnode(k11).sum_rating(1)=node1(z(p)).sum_rating(1);
    ttempnode(k11).sum_rating(2)=node1(z(p)).sum_rating(2);
    ttempnode(k11).sum_rating(3)=node1(z(p)).sum_rating(3);
    ttempnode(k11).sum_rating(4)=node1(z(p)).sum_rating(4);
    ttempnode(k11).sum_rating(5)=node1(z(p)).sum_rating(5);
    k11=k11+1;
end

[node2(2).sum_num, node2(2).sum_rating(1), node2(2).sum_rating(2), node2(2).sum_rating(3), node2(2).sum_rating(4), node2(2).sum_rating(5)]=smallsizemerge(ttempnode);

 for j=z(1):1:(node_num+1)   
 node2(2).node1(j-z(1)+1)=node1(j);
 end 
       break;   
      end 
            break;      
        end
        
          sameitem=0;  
    end
    
%    test='1';
end
    
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif (num2>node1(node1_num).node(node_num).maxtime)&&(node1(1).dimark==0)
%%%%%
mark=1;
rtemp.level=0;
rtemp.dimark=1;
rtemp.mintime=num2;
rtemp.maxtime=num2;
rtemp.minprice=0;
rtemp.maxprice=max;
[rtemp.sum_num, rtemp.sum_rating(1), rtemp.sum_rating(2), rtemp.sum_rating(3), rtemp.sum_rating(4), rtemp.sum_rating(5), rtemp.onedimR]=mergebackup(node1(node1_num).node);                             
rtemp.leaf(1).item=item; %%新结点初始化
rtemp.leaf(1).price=num1;
rtemp.leaf(1).time=num2;%%maxtime;        
rtemp.leaf(1).sum_num=1;
rtemp.leaf(1).sum_rating(1)=str2double(rating1);
rtemp.leaf(1).sum_rating(2)=str2double(rating2);
rtemp.leaf(1).sum_rating(3)=str2double(rating3);
rtemp.leaf(1).sum_rating(4)=str2double(rating4);
rtemp.leaf(1).sum_rating(5)=str2double(rating5); 

% mid=ceil(node_num/2);
% record=node1(node1_num).node(mid).maxtime;

%    test=1;再单独建一个结点
node_1(1).level=1;
node_1(1).mintime=node1(node1_num).node(1).mintime;
node_1(1).maxtime=node1(node1_num).node(node_num).maxtime;
node_1(1).minprice=0;
node_1(1).maxprice=max;
node_1(1).sum_num=node1(node1_num).sum_num;
node_1(1).sum_rating(1)=node1(node1_num).sum_rating(1);
node_1(1).sum_rating(2)=node1(node1_num).sum_rating(2);
node_1(1).sum_rating(3)=node1(node1_num).sum_rating(3);
node_1(1).sum_rating(4)=node1(node1_num).sum_rating(4);
node_1(1).sum_rating(5)=node1(node1_num).sum_rating(5);

 for j=1:1:node_num    
 node_1(1).node(j)=node1(node1_num).node(j);                    
 end
 
node_1(2).level=1;
node_1(2).mintime=num2;
node_1(2).maxtime=max;%%新结点时间
node_1(2).minprice=0;
node_1(2).maxprice=max;
node_1(2).sum_num=rtemp.sum_num;
node_1(2).sum_rating(1)=rtemp.sum_rating(1);
node_1(2).sum_rating(2)=rtemp.sum_rating(2);
node_1(2).sum_rating(3)=rtemp.sum_rating(3);
node_1(2).sum_rating(4)=rtemp.sum_rating(4);
node_1(2).sum_rating(5)=rtemp.sum_rating(5);


node_1(2).node(1)=rtemp; %#ok<NASGU>
 
node1(node1_num)=node_1(1);
node1(node1_num+1)=node_1(2);

 %%%%

node2(1).level=1;
node2(1).mintime=node1(1).mintime;
node2(1).maxtime=node1(node1_num).maxtime;
node2(1).minprice=0;
node2(1).maxprice=max;
node2(1).sum_num=0;
node2(1).sum_rating(1)=0;
node2(1).sum_rating(2)=0;
node2(1).sum_rating(3)=0;
node2(1).sum_rating(4)=0;
node2(1).sum_rating(5)=0;
 for j=1:1:node1_num  
 node2(1).node1(j)=node1(j);                    
 end

node2(2).level=1;
node2(2).mintime=num2;
node2(2).maxtime=max;%%新结点时间
node2(2).minprice=0;
node2(2).maxprice=max;
node2(2).sum_num=rtemp.sum_num;
node2(2).sum_rating(1)=rtemp.sum_rating(1);
node2(2).sum_rating(2)=rtemp.sum_rating(2);
node2(2).sum_rating(3)=rtemp.sum_rating(3);
node2(2).sum_rating(4)=rtemp.sum_rating(4);
node2(2).sum_rating(5)=rtemp.sum_rating(5);
   
 node2(2).node1(1)=node1(node1_num+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif (num2==node1(node1_num).node(node_num).maxtime)&&(node1(1).dimark==1)

record=node1(node1_num).node(node_num).maxtime;


for  j=1:1:node_num
    if  node1(node1_num).node(j).mintime==record
        w(k)=j;
        k=k+1;
    end
end

%%%%b编到这里
%%%pot前的全是node(1)


for p=1:1:size(w,2)
    tempnode(k1).sum_num=node1(node1_num).node(w(p)).sum_num;
    tempnode(k1).sum_rating(1)=node1(node1_num).node(w(p)).sum_rating(1);
    tempnode(k1).sum_rating(2)=node1(node1_num).node(w(p)).sum_rating(2);
    tempnode(k1).sum_rating(3)=node1(node1_num).node(w(p)).sum_rating(3);
    tempnode(k1).sum_rating(4)=node1(node1_num).node(w(p)).sum_rating(4);
    tempnode(k1).sum_rating(5)=node1(node1_num).node(w(p)).sum_rating(5);
    tempnode(k1).onedimR=node1(node1_num).node(w(p)).onedimR;
    k1=k1+1;
end

if size(w,2)==1
    mark=1;
node_1(1).level=1;
node_1(1).dimark=1;
node_1(1).mintime=node1(node1_num).node(1).mintime;
node_1(1).maxtime=node1(node1_num).node(w(1)-1).maxtime;
node_1(1).minprice=0;
node_1(1).maxprice=max;
node_1(1).sum_num=0;
node_1(1).sum_num=node1(node1_num).sum_num;
node_1(1).sum_rating(1)=node1(node1_num).sum_rating(1);
node_1(1).sum_rating(2)=node1(node1_num).sum_rating(2);
node_1(1).sum_rating(3)=node1(node1_num).sum_rating(3);
node_1(1).sum_rating(4)=node1(node1_num).sum_rating(4);
node_1(1).sum_rating(5)=node1(node1_num).sum_rating(5);
 for j=1:1:(w(1)-1)    
 node_1(1).node(j)=node1(node1_num).node(j);                    
 end

 
node_1(2).level=1;
node_1(2).dimark=1;
node_1(2).mintime=node1(node1_num).node(w(1)).mintime;
node_1(2).maxtime=max;%%新结点时间
node_1(2).minprice=0;
node_1(2).maxprice=max;
    
temptwonode=smallsplitnode(node1(node1_num).node(node_num), num1, num2, rating1, rating2, rating3, rating4, rating5, item);

[node_1(2).sum_num, node_1(2).sum_rating(1), node_1(2).sum_rating(2), node_1(2).sum_rating(3), node_1(2).sum_rating(4), node_1(2).sum_rating(5)]=smallsizemerge(tempnode);

 for j=w(1):1:(node_num-1)   
 node_1(2).node(j-w(1)+1)=node1(node1_num).node(j);                    
 end 
 nonum=size(node_1(2).node ,2);
 node_1(2).node(nonum+1)=temptwonode(1);
 node_1(2).node(nonum+2)=temptwonode(2);
 
node1(node1_num)=node_1(1);
node1(node1_num+1)=node_1(2);

record=node1(size(node1,2)).mintime;

node2(1).level=1;
node2(1).dimark=0;
node2(1).mintime=node1(1).mintime;

for  j=1:1:size(node1,2)
    if  node1(j).mintime==record 
        z(k2)=j;
        k2=k2+1;
    end
end


%%%pot前的全是node(1)
node2(1).maxtime=node1(z(1)-1).maxtime;
node2(1).minprice=0;
node2(1).maxprice=max;
node2(1).sum_num=0;
node2(1).sum_rating(1)=0;
node2(1).sum_rating(2)=0;
node2(1).sum_rating(3)=0;
node2(1).sum_rating(4)=0;
node2(1).sum_rating(5)=0;
 for j=1:1:(z(1)-1)    
 node2(1).node1(j)=node1(j);                    
 end

node2(2).level=1;
node2(2).dimark=1;
node2(2).mintime=node1(size(node1,2)).mintime;
node2(2).maxtime=max;%%新结点时间
node2(2).minprice=0;
node2(2).maxprice=max;

for p=1:1:size(z,2)
    ttempnode(k11).sum_num=node1(z(p)).sum_num;
    ttempnode(k11).sum_rating(1)=node1(z(p)).sum_rating(1);
    ttempnode(k11).sum_rating(2)=node1(z(p)).sum_rating(2);
    ttempnode(k11).sum_rating(3)=node1(z(p)).sum_rating(3);
    ttempnode(k11).sum_rating(4)=node1(z(p)).sum_rating(4);
    ttempnode(k11).sum_rating(5)=node1(z(p)).sum_rating(5);
    k11=k11+1;
end

[node2(2).sum_num, node2(2).sum_rating(1), node2(2).sum_rating(2), node2(2).sum_rating(3), node2(2).sum_rating(4), node2(2).sum_rating(5)]=smallsizemerge(ttempnode);

 for j=z(1):1:(node_num+1)   
 node2(2).node1(j-z(1)+1)=node1(j);
 end 
 
 %[node1(2).sum_num, node1(2).sum_rating(1), node1(2).sum_rating(2), node1(2).sum_rating(3), node1(2).sum_rating(4), node1(2).sum_rating(5), node1(2).onedimR]=smallsizemerge(tempnode);
elseif size(w,2)>1
    %%%%%%挑选插入
    for  v=1:1:size(w, 2)
      vector(v)=node1(node1_num).node(w(v));              
    end
    for  v=1:1:size(w, 2)
        if num1<vector(v).maxprice
        for u=1:1:size(vector(v).leaf, 2)
            if strcmp(vector(v).leaf(u).item, item)==1
                  vector(v).leaf(u).sum_num=vector(v).leaf(u).sum_num+1;
                  vector(v).leaf(u).sum_rating(1)=vector(v).leaf(u).sum_rating(1)+str2double(rating1);
                  vector(v).leaf(u).sum_rating(2)=vector(v).leaf(u).sum_rating(2)+str2double(rating2);
                  vector(v).leaf(u).sum_rating(3)=vector(v).leaf(u).sum_rating(3)+str2double(rating3);
                  vector(v).leaf(u).sum_rating(4)=vector(v).leaf(u).sum_rating(4)+str2double(rating4);
                  vector(v).leaf(u).sum_rating(5)=vector(v).leaf(u).sum_rating(5)+str2double(rating5);
                  sameitem=1;                  
            end
            %%%直接返回
        end
        if sameitem==1
            
            for r=1:1:(w(1)-1)                
                node1(node1_num).node(r)=node1(node1_num).node(r);
            end
            for r=1:1:size(vector, 2)
               node1(node1_num).node(w(1)-1+r)=vector(r);        
            end
            mark=0; %%没有分裂
            
            node2=node1;
        end
        if  ((size(vector(v).leaf, 2)+1)<= n_leaf)&&(sameitem==0)  %#ok<ALIGN>    
          u=size(vector(v).leaf, 2);
            vector(v).leaf(u+1).item=item; %%maxkey
          vector(v).leaf(u+1).price=num1;
          vector(v).leaf(u+1).time=num2;%%maxtime;        
          vector(v).leaf(u+1).sum_num=1;
          vector(v).leaf(u+1).sum_rating(1)=str2double(rating1);
          vector(v).leaf(u+1).sum_rating(2)=str2double(rating2);
          vector(v).leaf(u+1).sum_rating(3)=str2double(rating3);
          vector(v).leaf(u+1).sum_rating(4)=str2double(rating4);
          vector(v).leaf(u+1).sum_rating(5)=str2double(rating5);                      %#ok<NASGU>
          %%%直接返回
            for r=1:1:(w(1)-1)                
                node1(node1_num).node(r)=node1(node1_num).node(r);
            end
            for r=1:1:size(vector, 2)
               node1(node1_num).node(w(1)-1+r)=vector(r);        
            end   
          mark=0; %%没有分解
              node2=node1;
              break;
        end
        
       if ((size(vector(v).leaf, 2)+1)> n_leaf)&&(sameitem==0) %%叶子分裂同时伴随key分解 
           %%%分裂%%%%
           temptwonode=smallsplitnode(vector(v), num1, num2, rating1, rating2, rating3, rating4, rating5, item);
           if  v==1
               vector1(1)=temptwonode(1);
               vector1(2)=temptwonode(2);
               for u=2:1:size(vector, 2)                 
                vector1(u+1)=vector(u);   
               end               
           elseif v==size(vector, 2)
               for u=1:1:(size(vector, 2)-1)               
                vector1(u)=vector(u);   
               end 
               vector1(u+1)=temptwonode(1); 
               vector1(u+2)=temptwonode(2);  %#ok<NASGU>
             
           elseif (v>1)&&(v<size(vector, 2))
               for u=1:1:(v-1)                
                vector1(u)=vector(u);   
               end     
               vector1(v)=temptwonode(1);
               vector1(v+1)=temptwonode(2);
               for u=(v+1):1:size(vector, 2)                
                vector1(u+1)=vector(u);   
               end          
           end
            for r=1:1:(w(1)-1)                
                node1(node1_num).node(r)=node1(node1_num).node(r);
            end
            for r=1:1:size(vector1, 2)
               node1(node1_num).node(w(1)-1+r)=vector1(r);        
            end
           mark=1;
           %%需要分裂
node_1(1).level=1;
node_1(1).dimark=1;
node_1(1).mintime=node1(node1_num).node(1).mintime;
node_1(1).maxtime=node1(node1_num).node(w(1)-1).maxtime;
node_1(1).minprice=0;
node_1(1).maxprice=max;
node_1(1).sum_num=0;
node_1(1).sum_num=node1(node1_num).sum_num;
node_1(1).sum_rating(1)=node1(node1_num).sum_rating(1);
node_1(1).sum_rating(2)=node1(node1_num).sum_rating(2);
node_1(1).sum_rating(3)=node1(node1_num).sum_rating(3);
node_1(1).sum_rating(4)=node1(node1_num).sum_rating(4);
node_1(1).sum_rating(5)=node1(node1_num).sum_rating(5);

 for j=1:1:(w(1)-1)    
 node_1(1).node(j)=node1(node1_num).node(j);                    
 end

 
node_1(2).level=1;
node_1(2).dimark=1;
node_1(2).mintime=node1(node1_num).node(w(1)).mintime;
node_1(2).maxtime=max;%%新结点时间
node_1(2).minprice=0;
node_1(2).maxprice=max;
for  j=w(1):1:size(node1(node1_num).node, 2)
    if  node1(node1_num).node(j).mintime==record
        v(t)=j;
        t=t+1;
    end
end


for p=1:1:size(v,2)
    vtempnode(k3).sum_num=node1(node1_num).node(v(p)).sum_num;
    vtempnode(k3).sum_rating(1)=node1(node1_num).node(v(p)).sum_rating(1);
    vtempnode(k3).sum_rating(2)=node1(node1_num).node(v(p)).sum_rating(2);
    vtempnode(k3).sum_rating(3)=node1(node1_num).node(v(p)).sum_rating(3);
    vtempnode(k3).sum_rating(4)=node1(node1_num).node(v(p)).sum_rating(4);
    vtempnode(k3).sum_rating(5)=node1(node1_num).node(v(p)).sum_rating(5);
    vtempnode(k3).onedimR=node1(node1_num).node(v(p)).onedimR;
    k3=k3+1;
end

[node_1(2).sum_num, node_1(2).sum_rating(1), node_1(2).sum_rating(2), node_1(2).sum_rating(3), node_1(2).sum_rating(4), node_1(2).sum_rating(5)]=smallsizemerge(vtempnode);

 for j=w(1):1:size(node1(node1_num).node, 2)  
 node_1(2).node(j-w(1)+1)=node1(node1_num).node(j);                    
 end 

 node1(node1_num)=node_1(1);
node1(node1_num+1)=node_1(2);

 %%%%
record=node1(size(node1,2)).mintime;

node2(1).level=1;
node2(1).dimark=1;
node2(1).mintime=node1(1).mintime;

for  j=1:1:size(node1,2)
    if  node1(j).mintime==record 
        z(k2)=j;
        k2=k2+1;
    end
end


%%%pot前的全是node(1)
node2(1).maxtime=node1(z(1)-1).maxtime;
node2(1).minprice=0;
node2(1).maxprice=max;
node2(1).sum_num=0;
node2(1).sum_rating(1)=0;
node2(1).sum_rating(2)=0;
node2(1).sum_rating(3)=0;
node2(1).sum_rating(4)=0;
node2(1).sum_rating(5)=0;
 for j=1:1:(z(1)-1)    
 node2(1).node1(j)=node1(j);                    
 end

node2(2).level=1;
node2(2).dimark=1;
node2(2).mintime=node1(size(node1,2)).mintime;
node2(2).maxtime=max;%%新结点时间
node2(2).minprice=0;
node2(2).maxprice=max;

for p=1:1:size(z,2)
    ttempnode(k11).sum_num=node1(z(p)).sum_num;
    ttempnode(k11).sum_rating(1)=node1(z(p)).sum_rating(1);
    ttempnode(k11).sum_rating(2)=node1(z(p)).sum_rating(2);
    ttempnode(k11).sum_rating(3)=node1(z(p)).sum_rating(3);
    ttempnode(k11).sum_rating(4)=node1(z(p)).sum_rating(4);
    ttempnode(k11).sum_rating(5)=node1(z(p)).sum_rating(5);
    k11=k11+1;
end

[node2(2).sum_num, node2(2).sum_rating(1), node2(2).sum_rating(2), node2(2).sum_rating(3), node2(2).sum_rating(4), node2(2).sum_rating(5)]=smallsizemerge(ttempnode);

 for j=z(1):1:(node_num+1)   
 node2(2).node1(j-z(1)+1)=node1(j);
 end 
        break;   
      end 
        break;         
        end
        
          sameitem=0;  
    end
    
%    test='1';
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif (num2>node1(node1_num).node(node_num).maxtime)&&(node1(1).dimark==1)
mark=1;
rtemp.level=0;
rtemp.dimark=1;
rtemp.mintime=num2;
rtemp.maxtime=num2;
rtemp.minprice=0;
rtemp.maxprice=max;
[rtemp.sum_num, rtemp.sum_rating(1), rtemp.sum_rating(2), rtemp.sum_rating(3), rtemp.sum_rating(4), rtemp.sum_rating(5), rtemp.onedimR]=mergebackup(node1(node1_num).node);                             
rtemp.leaf(1).item=item; %%新结点初始化
rtemp.leaf(1).price=num1;
rtemp.leaf(1).time=num2;%%maxtime;        
rtemp.leaf(1).sum_num=1;
rtemp.leaf(1).sum_rating(1)=str2double(rating1);
rtemp.leaf(1).sum_rating(2)=str2double(rating2);
rtemp.leaf(1).sum_rating(3)=str2double(rating3);
rtemp.leaf(1).sum_rating(4)=str2double(rating4);
rtemp.leaf(1).sum_rating(5)=str2double(rating5); 

% mid=ceil(node_num/2);
% record=node1(node1_num).node(mid).maxtime;

%    test=1;再单独建一个结点
node_1(1).level=1;
node_1(1).mintime=node1(node1_num).node(1).mintime;
node_1(1).maxtime=node1(node1_num).node(node_num).maxtime;
node_1(1).minprice=0;
node_1(1).maxprice=max;
node_1(1).sum_num=node1(node1_num).sum_num;
node_1(1).sum_rating(1)=node1(node1_num).sum_rating(1);
node_1(1).sum_rating(2)=node1(node1_num).sum_rating(2);
node_1(1).sum_rating(3)=node1(node1_num).sum_rating(3);
node_1(1).sum_rating(4)=node1(node1_num).sum_rating(4);
node_1(1).sum_rating(5)=node1(node1_num).sum_rating(5);
 for j=1:1:node_num    
 node_1(1).node(j)=node1(node1_num).node(j);                    
 end
 
node_1(2).level=1;
node_1(2).mintime=num2;
node_1(2).maxtime=max;%%新结点时间
node_1(2).minprice=0;
node_1(2).maxprice=max;
node_1(2).sum_num=rtemp.sum_num;
node_1(2).sum_rating(1)=rtemp.sum_rating(1);
node_1(2).sum_rating(2)=rtemp.sum_rating(2);
node_1(2).sum_rating(3)=rtemp.sum_rating(3);
node_1(2).sum_rating(4)=rtemp.sum_rating(4);
node_1(2).sum_rating(5)=rtemp.sum_rating(5);

node_1(2).node(1)=rtemp; %#ok<NASGU>
 
node1(node1_num)=node_1(1);
node1(node1_num+1)=node_1(2);

 %%%%

node2(1).level=1;
node2(1).dimark=1;
node2(1).mintime=node1(1).mintime;
node2(1).maxtime=node1(node1_num).maxtime;
node2(1).minprice=0;
node2(1).maxprice=max;
node2(1).sum_num=0;
node2(1).sum_rating(1)=0;
node2(1).sum_rating(2)=0;
node2(1).sum_rating(3)=0;
node2(1).sum_rating(4)=0;
node2(1).sum_rating(5)=0;
 for j=1:1:node1_num  
 node2(1).node1(j)=node1(j);                    
 end

node2(2).level=1;
node2(2).mintime=num2;
node2(2).maxtime=max;%%新结点时间
node2(2).minprice=0;
node2(2).maxprice=max;
node2(2).sum_num=rtemp.sum_num;
node2(2).sum_rating(1)=rtemp.sum_rating(1);
node2(2).sum_rating(2)=rtemp.sum_rating(2);
node2(2).sum_rating(3)=rtemp.sum_rating(3);
node2(2).sum_rating(4)=rtemp.sum_rating(4);
node2(2).sum_rating(5)=rtemp.sum_rating(5);

   
 node2(2).node1(1)=node1(node1_num+1);  
    

end
 
 
 