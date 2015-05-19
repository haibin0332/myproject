function  [node1, mark]=splitnode(node, num1, num2, rating1, rating2, rating3, rating4, rating5, item) %num2时间， num1 钱
%%%%%%%%%%%%%%%%%
%%%%%%%%此部分被kdbtree调用
%%%%%%%%%%%
n_leaf=51;
k=1;
% t=1;
t=1;
k1=1;
k2=1;
max=100000;
%pot=0;
sameitem=1;
%test='splitnode.m 没编呢';
%%md原跟来的应该一样哦， 把dimR和leaf全拿出来单独再形成dimR 调用mergeleafandnode.m
node_num=size(node,2);
if  (num2==node(node_num).maxtime)&&(node(1).dimark==0)

record=node(node_num).maxtime;

for  j=1:1:node_num
    if  node(j).maxtime==record
        w(k)=j;
        k=k+1;
    end
end


for p=1:1:size(w,2)
    tempnode(k1).sum_num=node(w(p)).sum_num;
    tempnode(k1).sum_rating(1)=node(w(p)).sum_rating(1);
    tempnode(k1).sum_rating(2)=node(w(p)).sum_rating(2);
    tempnode(k1).sum_rating(3)=node(w(p)).sum_rating(3);
    tempnode(k1).sum_rating(4)=node(w(p)).sum_rating(4);
    tempnode(k1).sum_rating(5)=node(w(p)).sum_rating(5);
    tempnode(k1).onedimR=node(w(p)).onedimR;
    k1=k1+1;
end

if size(w,2)==1
    mark=1;
node1(1).level=1;
node1(1).mintime=node(1).mintime;
node1(1).maxtime=node(w(1)-1).maxtime;
node1(1).minprice=0;
node1(1).maxprice=max;
node1(1).sum_num=0;
node1(1).sum_rating(1)=0;
node1(1).sum_rating(2)=0;
node1(1).sum_rating(3)=0;
node1(1).sum_rating(4)=0;
node1(1).sum_rating(5)=0;
 for j=1:1:(w(1)-1)    
 node1(1).node(j)=node(j);                    
 end

 
node1(2).level=1;
node1(2).mintime=node(w(1)).mintime;
node1(2).maxtime=max;%%新结点时间
node1(2).minprice=0;
node1(2).maxprice=max;
    
temptwonode=smallsplitnode(node(node_num), num1, num2, rating1, rating2, rating3, rating4, rating5, item);

[node1(2).sum_num, node1(2).sum_rating(1), node1(2).sum_rating(2), node1(2).sum_rating(3), node1(2).sum_rating(4), node1(2).sum_rating(5)]=smallsizemerge(tempnode);

 for j=w(1):1:(node_num-1)   
 node1(2).node(j-w(1)+1)=node(j);                    
 end 
 nonum=size(node1(2).node ,2);
 node1(2).node(nonum+1)=temptwonode(1);
 node1(2).node(nonum+2)=temptwonode(2);
 
elseif size(w,2)>1

    for  v=1:1:size(w, 2)
      vector(v)=node(w(v));              
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
                node(r)=node(r);
            end
            for r=1:1:size(vector, 2)
               node(w(1)-1+r)=vector(r);        
            end
            mark=0; %%没有分裂
            
            node1=node;
            
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
                node(r)=node(r);
            end
            for r=1:1:size(vector, 2)
                node(w(1)-1+r)=vector(r);        
            end   
          mark=0; %%没有分解
              node1=node;
              break;
        elseif ((size(vector(v).leaf, 2)+1)> n_leaf)&&(sameitem==0) %%叶子分裂同时伴随key分解
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
                node(r)=node(r);
            end
            for r=1:1:size(vector1, 2)
                node(w(1)-1+r)=vector1(r);        
            end
           mark=1;
           %%需要分裂
node1(1).level=1;
node1(1).mintime=node(1).mintime;
node1(1).maxtime=node(w(1)-1).maxtime;
node1(1).minprice=0;
node1(1).maxprice=max;
node1(1).sum_num=0;
node1(1).sum_rating(1)=0;
node1(1).sum_rating(2)=0;
node1(1).sum_rating(3)=0;
node1(1).sum_rating(4)=0;
node1(1).sum_rating(5)=0;
 for j=1:1:(w(1)-1)    
 node1(1).node(j)=node(j);                    
 end

 
node1(2).level=1;
node1(2).mintime=node(w(1)).mintime;
node1(2).maxtime=max;%%新结点时间
node1(2).minprice=0;
node1(2).maxprice=max;

for  j=w(1):1:size(node, 2)
    if  node(j).mintime==record
        v(t)=j;
        t=t+1;
    end
end

% if  (pot==0) && (pot==node_num)
%     test='line 22 splitnode.m';
% end
%%%pot前的全是node(1)

for p=1:1:size(v,2)
    vtempnode(k2).sum_num=node(v(p)).sum_num;
    vtempnode(k2).sum_rating(1)=node(v(p)).sum_rating(1);
    vtempnode(k2).sum_rating(2)=node(v(p)).sum_rating(2);
    vtempnode(k2).sum_rating(3)=node(v(p)).sum_rating(3);
    vtempnode(k2).sum_rating(4)=node(v(p)).sum_rating(4);
    vtempnode(k2).sum_rating(5)=node(v(p)).sum_rating(5);
    vtempnode(k2).onedimR=node(v(p)).onedimR;
    k2=k2+1;
end



[node1(2).sum_num, node1(2).sum_rating(1), node1(2).sum_rating(2), node1(2).sum_rating(3), node1(2).sum_rating(4), node1(2).sum_rating(5)]=smallsizemerge(vtempnode);

 for j=w(1):1:size(node, 2)  
 node1(2).node(j-w(1)+1)=node(j);                    
 end 
           break;             
            
        end
        

           break;     
        end
        
          sameitem=0;  
    end
     
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif num2>node(node_num).maxtime&&(node(1).dimark==0)
%%%%%
mark=1;
rtemp.level=0;
rtemp.dimark=1;
rtemp.mintime=num2;
rtemp.maxtime=max;
rtemp.minprice=0;
rtemp.maxprice=max;
[rtemp.sum_num, rtemp.sum_rating(1), rtemp.sum_rating(2), rtemp.sum_rating(3), rtemp.sum_rating(4), rtemp.sum_rating(5), rtemp.onedimR]=mergebackup(node);                             
rtemp.leaf(1).item=item; %%新结点初始化
rtemp.leaf(1).price=num1;
rtemp.leaf(1).time=num2;%%maxtime;        
rtemp.leaf(1).sum_num=1;
rtemp.leaf(1).sum_rating(1)=str2double(rating1);
rtemp.leaf(1).sum_rating(2)=str2double(rating2);
rtemp.leaf(1).sum_rating(3)=str2double(rating3);
rtemp.leaf(1).sum_rating(4)=str2double(rating4);
rtemp.leaf(1).sum_rating(5)=str2double(rating5); 

node1(1).level=1;
node1(1).mintime=node(1).mintime;
%%%pot前的全是node(1)
node1(1).maxtime=node(node_num).maxtime;
node1(1).minprice=0;
node1(1).maxprice=max;
node1(1).sum_num=0;
node1(1).sum_rating(1)=0;
node1(1).sum_rating(2)=0;
node1(1).sum_rating(3)=0;
node1(1).sum_rating(4)=0;
node1(1).sum_rating(5)=0;
 for j=1:1:node_num   
 node1(1).node(j)=node(j);                    
 end
 
node1(2).level=1;
node1(2).mintime=num2;
node1(2).maxtime=max;%%新结点时间
node1(2).minprice=0;
node1(2).maxprice=max;
node1(2).sum_num=rtemp.sum_num;
node1(2).sum_rating(1)=rtemp.sum_rating(1);
node1(2).sum_rating(2)=rtemp.sum_rating(2);
node1(2).sum_rating(3)=rtemp.sum_rating(3);
node1(2).sum_rating(4)=rtemp.sum_rating(4);
node1(2).sum_rating(5)=rtemp.sum_rating(5);

 node1(2).node(1)=rtemp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif num2==node(node_num).maxtime&&(node(1).dimark==1)
%test='情况3';
record=node(node_num).maxtime;

for  j=1:1:node_num
    if  node(j).maxtime==record
        w(k)=j;
        k=k+1;
    end
end


for p=1:1:size(w,2)
    tempnode(k1).sum_num=node(w(p)).sum_num;
    tempnode(k1).sum_rating(1)=node(w(p)).sum_rating(1);
    tempnode(k1).sum_rating(2)=node(w(p)).sum_rating(2);
    tempnode(k1).sum_rating(3)=node(w(p)).sum_rating(3);
    tempnode(k1).sum_rating(4)=node(w(p)).sum_rating(4);
    tempnode(k1).sum_rating(5)=node(w(p)).sum_rating(5);
    tempnode(k1).onedimR=node(w(p)).onedimR;
    k1=k1+1;
end
if size(w,2)==1
    mark=1;
node1(1).level=1;
node1(1).mintime=node(1).mintime;   
node1(1).maxtime=node(w(1)-1).maxtime;
node1(1).minprice=0;
node1(1).maxprice=max;
node1(1).sum_num=0;
node1(1).sum_rating(1)=0;
node1(1).sum_rating(2)=0;
node1(1).sum_rating(3)=0;
node1(1).sum_rating(4)=0;
node1(1).sum_rating(5)=0;
 for j=1:1:(w(1)-1)    
 node1(1).node(j)=node(j);                    
 end

node1(2).level=1;
node1(2).mintime=node(w(1)).mintime;
node1(2).maxtime=max;%%新结点时间
node1(2).minprice=0;
node1(2).maxprice=max;


temptwonode=smallsplitnode(node(node_num), num1, num2, rating1, rating2, rating3, rating4, rating5, item);

[node1(2).sum_num, node1(2).sum_rating(1), node1(2).sum_rating(2), node1(2).sum_rating(3), node1(2).sum_rating(4), node1(2).sum_rating(5)]=smallsizemerge(tempnode);

 for j=w(1):1:(node_num-1)   
 node1(2).node(j-w(1)+1)=node(j);                    
 end 
 nonum=size(node1(2).node ,2);
 node1(2).node(nonum+1)=temptwonode(1);
 node1(2).node(nonum+2)=temptwonode(2);

elseif size(w,2)>1

    for  v=1:1:size(w, 2)
      vector(v)=node(w(v));              
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
                node(r)=node(r);
            end
            for r=1:1:size(vector, 2)
               node(w(1)-1+r)=vector(r);        
            end
            mark=0; %%没有分裂
            
            node1=node;
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
                node(r)=node(r);
            end
            for r=1:1:size(vector, 2)
                node(w(1)-1+r)=vector(r);        
            end   
          mark=0; %%没有分解
              node1=node;
              break;
        elseif  ((size(vector(v).leaf, 2)+1)> n_leaf)&&(sameitem==0) %%叶子分裂同时伴随key分解   
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
                node(r)=node(r);
            end
            for r=1:1:size(vector1, 2)
                node(w(1)-1+r)=vector1(r);        
            end
           mark=1;
           %%需要分裂
node1(1).level=1;
node1(1).mintime=node(1).mintime;
node1(1).maxtime=node(node_num-1).maxtime;
node1(1).minprice=0;
node1(1).maxprice=max;
node1(1).sum_num=0;
node1(1).sum_rating(1)=0;
node1(1).sum_rating(2)=0;
node1(1).sum_rating(3)=0;
node1(1).sum_rating(4)=0;
node1(1).sum_rating(5)=0;
 for j=1:1:(w(1)-1)    
 node1(1).node(j)=node(j);                    
 end

 
node1(2).level=1;
node1(2).mintime=node(w(1)).mintime;
node1(2).maxtime=max;%%新结点时间
node1(2).minprice=0;
node1(2).maxprice=max;

for  j=w(1):1:size(node, 2)
    if  node(j).mintime==record
        v(t)=j;
        t=t+1;
    end
end

% if  (pot==0) && (pot==node_num)
%     test='line 22 splitnode.m';
% end
%%%pot前的全是node(1)

for p=1:1:size(v,2)
    vtempnode(k2).sum_num=node(v(p)).sum_num;
    vtempnode(k2).sum_rating(1)=node(v(p)).sum_rating(1);
    vtempnode(k2).sum_rating(2)=node(v(p)).sum_rating(2);
    vtempnode(k2).sum_rating(3)=node(v(p)).sum_rating(3);
    vtempnode(k2).sum_rating(4)=node(v(p)).sum_rating(4);
    vtempnode(k2).sum_rating(5)=node(v(p)).sum_rating(5);
    vtempnode(k2).onedimR=node(v(p)).onedimR;
    k2=k2+1;
end



[node1(2).sum_num, node1(2).sum_rating(1), node1(2).sum_rating(2), node1(2).sum_rating(3), node1(2).sum_rating(4), node1(2).sum_rating(5)]=smallsizemerge(vtempnode);

 for j=w(1):1:size(node, 2)  
 node1(2).node(j-w(1)+1)=node(j);                    
 end 
          break;                 
        end
        
            break;         
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
       if v==size(w, 2)
     
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
                node(r)=node(r);
            end
            for r=1:1:size(vector, 2)
               node(w(1)-1+r)=vector(r);        
            end
            mark=0; %%没有分裂
            
            node1=node;                           
         end       
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
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
          vector(v).leaf(u+1).sum_rating(5)=str2double(rating5);      
          vector(v).maxprice=num1;
          %#ok<NASGU>
          %%%直接返回
            
            for r=1:1:(w(1)-1)                
                node(r)=node(r);
            end
            for r=1:1:size(vector, 2)
                node(w(1)-1+r)=vector(r);        
            end   
          mark=0; %%????????
              node1=node; 
       elseif ((size(vector(v).leaf, 2)+1)> n_leaf)&&(sameitem==0) %%叶子分裂同时伴随key分解 
           
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
                node(r)=node(r);
            end
            for r=1:1:size(vector1, 2)
                node(w(1)-1+r)=vector1(r);        
            end
           mark=1;
           %%需要分裂
node1(1).level=1;
node1(1).mintime=node(1).mintime;
node1(1).maxtime=node(node_num-1).maxtime;
node1(1).minprice=0;
node1(1).maxprice=max;
node1(1).sum_num=0;
node1(1).sum_rating(1)=0;
node1(1).sum_rating(2)=0;
node1(1).sum_rating(3)=0;
node1(1).sum_rating(4)=0;
node1(1).sum_rating(5)=0;
 for j=1:1:(w(1)-1)    
 node1(1).node(j)=node(j);                    
 end

 
node1(2).level=1;
node1(2).mintime=node(w(1)).mintime;
node1(2).maxtime=max;%%新结点时间
node1(2).minprice=0;
node1(2).maxprice=max;

for  j=w(1):1:size(node, 2)
    if  node(j).mintime==record
        v(t)=j;
        t=t+1;
    end
end

% if  (pot==0) && (pot==node_num)
%     test='line 22 splitnode.m';
% end
%%%pot前的全是node(1)

for p=1:1:size(v,2)
    vtempnode(k2).sum_num=node(v(p)).sum_num;
    vtempnode(k2).sum_rating(1)=node(v(p)).sum_rating(1);
    vtempnode(k2).sum_rating(2)=node(v(p)).sum_rating(2);
    vtempnode(k2).sum_rating(3)=node(v(p)).sum_rating(3);
    vtempnode(k2).sum_rating(4)=node(v(p)).sum_rating(4);
    vtempnode(k2).sum_rating(5)=node(v(p)).sum_rating(5);
    vtempnode(k2).onedimR=node(v(p)).onedimR;
    k2=k2+1;
end



[node1(2).sum_num, node1(2).sum_rating(1), node1(2).sum_rating(2), node1(2).sum_rating(3), node1(2).sum_rating(4), node1(2).sum_rating(5)]=smallsizemerge(vtempnode);

 for j=w(1):1:size(node, 2)  
 node1(2).node(j-w(1)+1)=node(j);                    
 end 
                    
       end
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
       end        
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
          sameitem=0;  
    end
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif num2>node(node_num).maxtime&&(node(1).dimark==1)
%test='情况4';
mark=1;
rtemp.level=0;
rtemp.dimark=1;
rtemp.mintime=num2;
rtemp.maxtime=max;
rtemp.minprice=0;
rtemp.maxprice=max;
[rtemp.sum_num, rtemp.sum_rating(1), rtemp.sum_rating(2), rtemp.sum_rating(3), rtemp.sum_rating(4), rtemp.sum_rating(5), rtemp.onedimR]=mergebackup(node);                             
rtemp.leaf(1).item=item; %%新结点初始化
rtemp.leaf(1).price=num1;
rtemp.leaf(1).time=num2;%%maxtime;        
rtemp.leaf(1).sum_num=1;
rtemp.leaf(1).sum_rating(1)=str2double(rating1);
rtemp.leaf(1).sum_rating(2)=str2double(rating2);
rtemp.leaf(1).sum_rating(3)=str2double(rating3);
rtemp.leaf(1).sum_rating(4)=str2double(rating4);
rtemp.leaf(1).sum_rating(5)=str2double(rating5); 


%    test=1;再单独建一个结点
node1(1).level=1;
node1(1).mintime=node(1).mintime;
%%%pot前的全是node(1)
node1(1).maxtime=node(node_num).maxtime;
node1(1).minprice=0;
node1(1).maxprice=max;
node1(1).sum_num=0;
node1(1).sum_rating(1)=0;
node1(1).sum_rating(2)=0;
node1(1).sum_rating(3)=0;
node1(1).sum_rating(4)=0;
node1(1).sum_rating(5)=0;


node1(2).level=1;
node1(2).mintime=num2;
node1(2).maxtime=max;%%新结点时间
node1(2).minprice=0;
node1(2).maxprice=max;
node1(2).sum_num=rtemp.sum_num;
node1(2).sum_rating(1)=rtemp.sum_rating(1);
node1(2).sum_rating(2)=rtemp.sum_rating(2);
node1(2).sum_rating(3)=rtemp.sum_rating(3);
node1(2).sum_rating(4)=rtemp.sum_rating(4);
node1(2).sum_rating(5)=rtemp.sum_rating(5);



 for j=1:1:node_num    
 node1(1).node(j)=node(j);                    
 end

 node1(2).node(1)=rtemp;



end

 end
 
 
 