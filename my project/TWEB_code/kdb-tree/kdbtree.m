%function [crtree]=kdbtree(CC)

conna=database('mywork','','');

setdbprefs ('DataReturnFormat','structure'); %%//?????
% 
cursorC=exec(conna,'select * from sd1'); %%//????
% 

cursorC=fetch(cursorC);

CC=cursorC.Data;

n_leaf=51;%%%  root*的个数
n_node=32;%% 所有node含有相同多的entries
max=100000;

%%%%这里开始初始化
crtree(1).ctree=CC.cid(1);
%%% 每一个entry要存储的
 %%% 树的indext price time 第一插入分成3部分
   % exmvsb(1).pricerange(1).min_price=str2double(cell2mat(CC.itemprice(1)));
    crtree(1).root.level=0; %%叶子节点
    %%%初始化第一个节点
    crtree(1).root.leaf(1).item=CC.itemtitle(1); %%maxkey
    crtree(1).root.leaf(1).price=round(str2double(cell2mat(CC.itemprice(1))));
    crtree(1).root.minprice=round(str2double(cell2mat(CC.itemprice(1))));
    crtree(1).root.maxprice=round(str2double(cell2mat(CC.itemprice(1))));
    crtree(1).root.leaf(1).time=timechange(cell2mat(CC.time(1)));%%maxtime;
    crtree(1).root.leaf(1).sum_num=1; %%maxkey
    crtree(1).root.leaf(1).sum_rating(1)=str2double((CC.rating1(1))); %#ok<ST2NM>
    crtree(1).root.leaf(1).sum_rating(2)=str2double((CC.rating2(1)));
    crtree(1).root.leaf(1).sum_rating(3)=str2double((CC.rating3(1)));
    crtree(1).root.leaf(1).sum_rating(4)=str2double((CC.rating4(1)));
    crtree(1).root.leaf(1).sum_rating(5)=str2double((CC.rating5(1)));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%参数初始化
    cnumber=1; %% 记录category的个数
    sameitem=0; 
    sametime=0;
    cexistmark=0;%% 如果category中不存在这个点为0存在为1；
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
for i=2:1:size(CC.itemtitle, 1)
        
        
 for j=1:1:cnumber   %%扫描所有root
       
    if  strcmp(crtree(j).ctree, CC.cid(i))==1  %%新的节点的类别不在root则新建一个 
        cexistmark=1;        
        %%%%
          if  crtree(j).root.level==0 %#ok<ALIGN> %%说明就一层  马上是根 
              leaf_num=size(crtree(j).root.leaf,2); %计算叶子节点的个数
                   for k=1:1:leaf_num  %找所有叶子节点中指向相同物品的   %%%这里有时间的问题了
                        if  (strcmp(crtree(j).root.leaf(k).item, CC.itemtitle(i))==1)&&(crtree(j).root.leaf(k).time==timechange(cell2mat(CC.time(i))))%%如果有相同的节点加上去  不同时间的应该是不同的节点 这里要重新弄的                         
                               crtree(j).root.leaf(k).sum_num=crtree(j).root.leaf(k).sum_num+1;
                               crtree(j).root.leaf(k).sum_rating(1)=crtree(j).root.leaf(k).sum_rating(1)+str2double((CC.rating1(i)));
                               crtree(j).root.leaf(k).sum_rating(2)=crtree(j).root.leaf(k).sum_rating(2)+str2double((CC.rating2(i)));
                               crtree(j).root.leaf(k).sum_rating(3)=crtree(j).root.leaf(k).sum_rating(3)+str2double((CC.rating3(i)));
                               crtree(j).root.leaf(k).sum_rating(4)=crtree(j).root.leaf(k).sum_rating(4)+str2double((CC.rating4(i)));
                               crtree(j).root.leaf(k).sum_rating(5)=crtree(j).root.leaf(k).sum_rating(5)+str2double((CC.rating5(i)));
                          sameitem=1;     
                        end
                   end
              
                   if  ((leaf_num+1)<= n_leaf)&&(sameitem==0)  %#ok<ALIGN>    
                               crtree(j).root.leaf(leaf_num+1).item=CC.itemtitle(i); %%maxkey
                               crtree(j).root.leaf(leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
                               crtree(j).root.leaf(leaf_num+1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
                               crtree(j).root.leaf(leaf_num+1).sum_num=1;
                               crtree(j).root.leaf(leaf_num+1).sum_rating(1)=str2double((CC.rating1(i)));
                               crtree(j).root.leaf(leaf_num+1).sum_rating(2)=str2double((CC.rating2(i)));
                               crtree(j).root.leaf(leaf_num+1).sum_rating(3)=str2double((CC.rating3(i)));
                               crtree(j).root.leaf(leaf_num+1).sum_rating(4)=str2double((CC.rating4(i)));
                               crtree(j).root.leaf(leaf_num+1).sum_rating(5)=str2double((CC.rating5(i)));
                   elseif ((leaf_num+1)> n_leaf)&&(sameitem==0) %%叶子分裂同时伴随key分解
                 temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                 temp2=timechange(cell2mat(CC.time(i))); %time
                 crtree(j).root.node=splitleaf(crtree(j).root.leaf, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));           
                 crtree(j).root.leaf=[];
                 crtree(j).root.level=crtree(j).root.level+1;  
                              
                   end
       
                  sameitem=0;%回执
          elseif crtree(j).root.level==1
              node_num=size(crtree(j).root.node,2);
  %% 这里要先找到插入位置       这里是有问题的当条件都不满足的时候pot找不到哦       
              for k=1:1:node_num  
                  if (crtree(j).root.node(k).maxtime==timechange(cell2mat(CC.time(i))))  %%如果插入的时间不是一个新的时间点插入到原来的结点中
                      sametime=1;
                  end %%%crtree(j).root.node(k).maxtime==timechange(cell2mat(CC.time(i)))  
                  if  (sametime==1)&&(round(str2double(cell2mat(CC.itemprice(i))))<=crtree(j).root.node(k).maxprice)     
                      pot=k; %#ok<NASGU>
                      break;
                  end
                  if  (sametime==1)    
                      pot=k; %#ok<NASGU>
                  end
              end
              
%%%然后再插入 如果sametime=1;
            if sametime==1
                %%%%再判断 相同物品
                [olynode, sameitem]=compdiff(crtree(j).root.node, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));
                if  sameitem==1
                    crtree(j).root.node=olynode;
                elseif sameitem==0
                    
          if  (node_num+1)<=n_node
                    temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                    temp2=timechange(cell2mat(CC.time(i))); %time
             crtree(j).root.node=newsplitleaf(crtree(j).root.node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  %%这个函数跟splitleaf不一样因为可以会伴随一维的分解                    
          elseif (node_num+1)>n_node
                   if (size(crtree(j).root.node(node_num).leaf,2)+1)<=n_leaf
                    temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                    temp2=timechange(cell2mat(CC.time(i))); %time
                    crtree(j).root.node=newsplitleaf(crtree(j).root.node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  %%这个函数跟splitleaf不一样因为可以会伴随一维的分解          
                   else
                    temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                    temp2=timechange(cell2mat(CC.time(i))); %time     
                    [kknode, pmark]=splitnode(crtree(j).root.node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));        
                    if pmark==1
                    crtree(j).root.node1=kknode;
                    crtree(j).root.node=[];
                    crtree(j).root.level=crtree(j).root.level+1; 
                    elseif pmark==0
                     crtree(j).root.node=kknode;   
                    end
                   end
          end
                                                                                  
                end                
            end 
%%%然后再插入 如果sametime=0;
             if sametime==0  %%重新建一个结点 
                 if  ((node_num+1)<=n_node) %%建一个新的结点插入，记住这个时候每个结点都要记录1-dim  
                    %%这里的重点是要处理小于半满啊 （这里要在paper里提出来）
                    if size(crtree(j).root.node(node_num).leaf,2)<ceil(n_leaf/2)
                               temp_leaf_num=size(crtree(j).root.node(node_num).leaf,2);
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).item=CC.itemtitle(i); %%maxkey
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_num=1;
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(1)=str2double((CC.rating1(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(2)=str2double((CC.rating2(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(3)=str2double((CC.rating3(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(4)=str2double((CC.rating4(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(5)=str2double((CC.rating5(i)));
                               crtree(j).root.node(node_num).maxtime=timechange(cell2mat(CC.time(i)));
                    else  %%满足半满了 新建一个结点给它 (node_num+1)                
                     %%%插入一个把所以1-dim全放上去然后出现分裂的时候分解1-dim哦 good
                               crtree(j).root.node(node_num+1).level=0;
                               crtree(j).root.node(node_num+1).dimark=1;
                               crtree(j).root.node(node_num+1).mintime=timechange(cell2mat(CC.time(i)));
                               crtree(j).root.node(node_num+1).maxtime=timechange(cell2mat(CC.time(i)));
                               crtree(j).root.node(node_num+1).minprice=0;
                               crtree(j).root.node(node_num+1).maxprice=max;
[crtree(j).root.node(node_num+1).sum_num, crtree(j).root.node(node_num+1).sum_rating(1), crtree(j).root.node(node_num+1).sum_rating(2), crtree(j).root.node(node_num+1).sum_rating(3), crtree(j).root.node(node_num+1).sum_rating(4), crtree(j).root.node(node_num+1).sum_rating(5), crtree(j).root.node(node_num+1).onedimR]=merge(crtree(j).root.node);                             
                               crtree(j).root.node(node_num+1).leaf(1).item=CC.itemtitle(i); %%新结点初始化
                               crtree(j).root.node(node_num+1).leaf(1).price=round(str2double(cell2mat(CC.itemprice(i))));
                               crtree(j).root.node(node_num+1).leaf(1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
                               crtree(j).root.node(node_num+1).leaf(1).sum_num=1;
                               crtree(j).root.node(node_num+1).leaf(1).sum_rating(1)=str2double((CC.rating1(i)));
                               crtree(j).root.node(node_num+1).leaf(1).sum_rating(2)=str2double((CC.rating2(i)));
                               crtree(j).root.node(node_num+1).leaf(1).sum_rating(3)=str2double((CC.rating3(i)));
                               crtree(j).root.node(node_num+1).leaf(1).sum_rating(4)=str2double((CC.rating4(i)));
                               crtree(j).root.node(node_num+1).leaf(1).sum_rating(5)=str2double((CC.rating5(i)));                                                                       
                    end
                 else %%((node_num+1)<=n_node)
                    %%%%这里首先判断(node_num+1)下的leaf叶子是否满，没满则继续插入，满了再上一层的分裂喽
                    if    size(crtree(j).root.node(node_num).leaf,2)<ceil(n_leaf/2)
                               temp_leaf_num=size(crtree(j).root.node(node_num).leaf,2);
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).item=CC.itemtitle(i); %%maxkey
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_num=1;
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(1)=str2double((CC.rating1(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(2)=str2double((CC.rating2(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(3)=str2double((CC.rating3(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(4)=str2double((CC.rating4(i)));
                               crtree(j).root.node(node_num).leaf(temp_leaf_num+1).sum_rating(5)=str2double((CC.rating5(i)));
                               crtree(j).root.node(node_num).maxtime=timechange(cell2mat(CC.time(i))); 
                    else
                    temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                    temp2=timechange(cell2mat(CC.time(i))); %time     
                    [kknode, pmark]=splitnode(crtree(j).root.node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));        
                    if pmark==1
                    crtree(j).root.node1=kknode;
                    crtree(j).root.node=[];
                    crtree(j).root.level=crtree(j).root.level+1; 
                    elseif pmark==0
                     crtree(j).root.node=kknode;   
                    end        
                    end
                       
                 end
             end
              
               sametime=0; %%回执
              
         elseif crtree(j).root.level==2
              node1_num=size(crtree(j).root.node1,2);
              node_num=size(crtree(j).root.node1(node1_num).node,2); %%肯定是在最后点插入的
  %% 这里要先找到插入位置       这里是有问题的当条件都不满足的时候pot找不到哦       
              for k=1:1:node_num;  
                  if (crtree(j).root.node1(node1_num).node(k).maxtime==timechange(cell2mat(CC.time(i))))  %%如果插入的时间不是一个新的时间点插入到原来的结点中
                      sametime=1;
                  end %%%crtree(j).root.node(k).maxtime==timechange(cell2mat(CC.time(i)))  
                  if  (sametime==1)&&(round(str2double(cell2mat(CC.itemprice(i))))<=crtree(j).root.node1(node1_num).node(k).maxprice)     
                      pot=k; %#ok<NASGU>
                      break;
                  end
                  if  (sametime==1)    
                      pot=k; %#ok<NASGU>
                  end
              end
              
             if sametime==1
                 
                [olynode, sameitem]=compdiff(crtree(j).root.node1(node1_num).node, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));
                if  sameitem==1
                    crtree(j).root.node1(node1_num).node=olynode;
                elseif sameitem==0
                    
                      if  ((node_num+1)<=n_node) %%插入分裂
                         temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                         temp2=timechange(cell2mat(CC.time(i))); %time
                         crtree(j).root.node1(node1_num).node=newsplitleaf(crtree(j).root.node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  %%这个函数跟splitleaf不一样因为可以会伴随一维的分解         
                     else %%上一层再分裂 再加一层
                          if (size(crtree(j).root.node1(node1_num).node(node_num).leaf,2)+1)<=n_leaf
                                                   temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                                                   temp2=timechange(cell2mat(CC.time(i))); %time
                                                   crtree(j).root.node1(node1_num).node=newsplitleaf(crtree(j).root.node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  %%这个函数跟splitleaf不一样因为可以会伴随一维的分解          
                         else
                         if ((node1_num+1)<=n_node) %%插入分裂
                        temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                        temp2=timechange(cell2mat(CC.time(i))); %time     
                         [ktempnode, pmark]=splitnode(crtree(j).root.node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i)); 
                        if pmark==1
                        yy1=crtree(j).root.node1(node1_num).sum_num;
                        yy2=crtree(j).root.node1(node1_num).sum_rating(1);
                        yy3=crtree(j).root.node1(node1_num).sum_rating(2);
                        yy4=crtree(j).root.node1(node1_num).sum_rating(3);                   
                        yy5=crtree(j).root.node1(node1_num).sum_rating(4);
                        yy6=crtree(j).root.node1(node1_num).sum_rating(5);                   
                        crtree(j).root.node1(node1_num)=ktempnode(1);
                        crtree(j).root.node1(node1_num).sum_num=yy1;
                        crtree(j).root.node1(node1_num).sum_rating(1)=yy2;
                        crtree(j).root.node1(node1_num).sum_rating(2)=yy3;
                        crtree(j).root.node1(node1_num).sum_rating(3)=yy4;
                        crtree(j).root.node1(node1_num).sum_rating(4)=yy5;
                        crtree(j).root.node1(node1_num).sum_rating(5)=yy6;
                        crtree(j).root.node1(node1_num+1)=ktempnode(2);
                        elseif pmark==0
                            crtree(j).root.node1(node1_num).node=ktempnode;
                            
                        end
                                                                                                                                                
                         else %%%再上一层
                       temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                       temp2=timechange(cell2mat(CC.time(i))); %time     
                       [jjnode, kmark]=splitnode1(crtree(j).root.node1, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));           
                        if kmark==1
                       crtree(j).root.node2=jjnode;
                       crtree(j).root.node1=[];
                       crtree(j).root.level=crtree(j).root.level+1;  
                       elseif kmark==0
                        crtree(j).root.node1=jjnode;    
                       end
                         end
                         end
                     end
                                       
                end             
                   
 %                 sameitem=0; 
             end   
%%%然后再插入 如果sametime=0;
             if sametime==0  %%重新建一个结点 
                 if  ((node_num+1)<=n_node) %%建一个新的结点插入，记住这个时候每个结点都要记录1-dim  
                    %%这里的重点是要处理小于半满啊 （这里要在paper里提出来）
                    if size(crtree(j).root.node1(node1_num).node(node_num).leaf,2)<ceil(n_leaf/2)
                               temp_leaf_num=size(crtree(j).root.node1(node1_num).node(node_num).leaf,2);
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).item=CC.itemtitle(i); %%maxkey
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_num=1;
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(1)=str2double((CC.rating1(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(2)=str2double((CC.rating2(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(3)=str2double((CC.rating3(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(4)=str2double((CC.rating4(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(5)=str2double((CC.rating5(i)));
                               crtree(j).root.node1(node1_num).node(node_num).maxtime=timechange(cell2mat(CC.time(i)));
                    else  %%满足半满了 新建一个结点给它 (node_num+1)                
                     %%%插入一个把所以1-dim全放上去然后出现分裂的时候分解1-dim哦 good
                               crtree(j).root.node1(node1_num).node(node_num+1).level=0;
                               crtree(j).root.node1(node1_num).node(node_num+1).dimark=1;
                               crtree(j).root.node1(node1_num).node(node_num+1).mintime=timechange(cell2mat(CC.time(i)));
                               crtree(j).root.node1(node1_num).node(node_num+1).maxtime=max;
                               crtree(j).root.node1(node1_num).node(node_num+1).minprice=0;
                               crtree(j).root.node1(node1_num).node(node_num+1).maxprice=max;
[crtree(j).root.node1(node1_num).node(node_num+1).sum_num, crtree(j).root.node1(node1_num).node(node_num+1).sum_rating(1), crtree(j).root.node1(node1_num).node(node_num+1).sum_rating(2), crtree(j).root.node1(node1_num).node(node_num+1).sum_rating(3), crtree(j).root.node1(node1_num).node(node_num+1).sum_rating(4), crtree(j).root.node1(node1_num).node(node_num+1).sum_rating(5), crtree(j).root.node1(node1_num).node(node_num+1).onedimR]=merge(crtree(j).root.node1(node1_num).node);                             
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).item=CC.itemtitle(i); %%新结点初始化
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).price=round(str2double(cell2mat(CC.itemprice(i))));
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).sum_num=1;
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).sum_rating(1)=str2double((CC.rating1(i)));
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).sum_rating(2)=str2double((CC.rating2(i)));
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).sum_rating(3)=str2double((CC.rating3(i)));
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).sum_rating(4)=str2double((CC.rating4(i)));
                               crtree(j).root.node1(node1_num).node(node_num+1).leaf(1).sum_rating(5)=str2double((CC.rating5(i)));                                                                       
                    end
                 else %%((node_num+1)<=n_node)
                    %%%%这里首先判断(node_num+1)下的leaf叶子是否满，没满则继续插入，满了再上一层的分裂喽
                    if    size(crtree(j).root.node1(node1_num).node(node_num).leaf,2)<ceil(n_leaf/2)
                               temp_leaf_num=size(crtree(j).root.node1(node1_num).node(node_num).leaf,2);
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).item=CC.itemtitle(i); %%maxkey
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_num=1;
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(1)=str2double((CC.rating1(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(2)=str2double((CC.rating2(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(3)=str2double((CC.rating3(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(4)=str2double((CC.rating4(i)));
                               crtree(j).root.node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(5)=str2double((CC.rating5(i)));
                               crtree(j).root.node1(node1_num).node(node_num).maxtime=timechange(cell2mat(CC.time(i))); 
                    else
                        if ((node1_num+1)<=n_node) %%插入分裂       
                       temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                       temp2=timechange(cell2mat(CC.time(i))); %time     
                       [ktempnode, pmark]=splitnode(crtree(j).root.node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));                                
                        if pmark==1
                        yy1=crtree(j).root.node1(node1_num).sum_num;
                        yy2=crtree(j).root.node1(node1_num).sum_rating(1);
                        yy3=crtree(j).root.node1(node1_num).sum_rating(2);
                        yy4=crtree(j).root.node1(node1_num).sum_rating(3);                   
                        yy5=crtree(j).root.node1(node1_num).sum_rating(4);
                        yy6=crtree(j).root.node1(node1_num).sum_rating(5);
                        crtree(j).root.node1(node1_num)=ktempnode(1);
                        crtree(j).root.node1(node1_num).sum_num=yy1;
                        crtree(j).root.node1(node1_num).sum_rating(1)=yy2;
                        crtree(j).root.node1(node1_num).sum_rating(2)=yy3;
                        crtree(j).root.node1(node1_num).sum_rating(3)=yy4;
                        crtree(j).root.node1(node1_num).sum_rating(4)=yy5;
                        crtree(j).root.node1(node1_num).sum_rating(5)=yy6;
                        crtree(j).root.node1(node1_num+1)=ktempnode(2);
                        elseif pmark==0
                           crtree(j).root.node1(node1_num).node=ktempnode;
                        end
                       %%%%以上部分
                        else
                       temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
                       temp2=timechange(cell2mat(CC.time(i))); %time     
                       [jjnode, kmark]=splitnode1(crtree(j).root.node1, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));        
                       if kmark==1
                       crtree(j).root.node2=jjnode;
                       crtree(j).root.node1=[];
                       crtree(j).root.level=crtree(j).root.level+1;  
                       elseif kmark==0
                        crtree(j).root.node1=jjnode;    
                       end
                        end

                    end
                       
                 end
             end
              
               sametime=0; %%回执     
%        elseif crtree(j).root.level==3
%               node2_num=size(crtree(j).root.node2,2);
%               node1_num=size(crtree(j).root.node2(node2_num).node1,2);
%               node_num=size(crtree(j).root.node2(node2_num).node1(node1_num).node,2); %%肯定是在最后点插入的              
%               for k=1:1:node_num;  
%                   if (crtree(j).root.node2(node2_num).node1(node1_num).node(k).maxtime==timechange(cell2mat(CC.time(i))))  %%如果插入的时间不是一个新的时间点插入到原来的结点中
%                       sametime=1;
%                   end %%%crtree(j).root.node(k).maxtime==timechange(cell2mat(CC.time(i)))  
%                   if  (sametime==1)&&(round(str2double(cell2mat(CC.itemprice(i))))<=crtree(j).root.node2(node2_num).node1(node1_num).node(k).maxprice)     
%                       pot=k; %#ok<NASGU>
%                       break;
%                   end
%                   if  (sametime==1)    
%                       pot=k; %#ok<NASGU>
%                   end
%               end
%            
%          if sametime==1
%              
%         [olynode, sameitem]=compdiff(crtree(j).root.node2(node2_num).node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));
%                 if  sameitem==1
%                     crtree(j).root.node2(node2_num).node1(node1_num).node=olynode;
%                 elseif sameitem==0
%                     
%                      if  ((node_num+1)<=n_node) %%插入分裂
%                          temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                          temp2=timechange(cell2mat(CC.time(i))); %time
%                          crtree(j).root.node2(node2_num).node1(node1_num).node=newsplitleaf(crtree(j).root.node2(node2_num).node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  %%这个函数跟splitleaf不一样因为可以会伴随一维的分解         
%                      else %%上一层再分裂 再加一层
%                          
%                                      if (size(crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf,2)+1)<=n_leaf
%                                                    temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                                                    temp2=timechange(cell2mat(CC.time(i))); %time
%                                                    crtree(j).root.node2(node2_num).node1(node1_num).node=newsplitleaf(crtree(j).root.node2(node2_num).node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  %%这个函数跟splitleaf不一样因为可以会伴随一维的分解          
%                                      else
%                                          
%                         if ((node1_num+1)<=n_node) %%插入分裂
%                         temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                         temp2=timechange(cell2mat(CC.time(i))); %time     
%                         [ktempnode, pmark]=splitnode(crtree(j).root.node2(node2_num).node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i)); 
%                         if pmark==1
%                         yyR=crtree(j).root.node2(node2_num).node1(node1_num).onedimR;
%                         yy1=crtree(j).root.node2(node2_num).node1(node1_num).sum_num;
%                         yy2=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(1);
%                         yy3=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(2);
%                         yy4=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(3);                   
%                         yy5=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(4);
%                         yy6=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(5);                   
%                         crtree(j).root.node2(node2_num).node1(node1_num)=ktempnode(1);
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_num=yy1;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(1)=yy2;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(2)=yy3;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(3)=yy4;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(4)=yy5;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(5)=yy6;
%                         crtree(j).root.node2(node2_num).node1(node1_num).onedimR=yyR;
%                         crtree(j).root.node2(node2_num).node1(node1_num+1)=ktempnode(2);
%                         elseif pmark==0
%                             crtree(j).root.node2(node2_num).node1(node1_num).node=ktempnode;
%                         end
%                          else %%%再上一层
%                              if ((node2_num+1)<=n_node)
%                        temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                        temp2=timechange(cell2mat(CC.time(i))); %time     
%                        [ktempnode1, kmark]=splitnode1(crtree(j).root.node2(node2_num).node1, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  
%                         if kmark==1
%                         yyR=crtree(j).root.node2(node2_num).onedimR;
%                         yy1=crtree(j).root.node2(node2_num).sum_num;
%                         yy2=crtree(j).root.node2(node2_num).sum_rating(1);
%                         yy3=crtree(j).root.node2(node2_num).sum_rating(2);
%                         yy4=crtree(j).root.node2(node2_num).sum_rating(3);                   
%                         yy5=crtree(j).root.node2(node2_num).sum_rating(4);
%                         yy6=crtree(j).root.node2(node2_num).sum_rating(5);                   
%                         crtree(j).root.node2(node2_num)=ktempnode1(1);
%                         crtree(j).root.node2(node2_num).sum_num=yy1;
%                         crtree(j).root.node2(node2_num).sum_rating(1)=yy2;
%                         crtree(j).root.node2(node2_num).sum_rating(2)=yy3;
%                         crtree(j).root.node2(node2_num).sum_rating(3)=yy4;
%                         crtree(j).root.node2(node2_num).sum_rating(4)=yy5;
%                         crtree(j).root.node2(node2_num).sum_rating(5)=yy6;
%                         crtree(j).root.node2(node2_num).onedimR=yyR;
%                         crtree(j).root.node2(node2_num+1)=ktempnode1(2);
%                         elseif kmark==0
%                             crtree(j).root.node1=ktempnode1;
%                                                                               
%                         end
%                              else
%                        temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                        temp2=timechange(cell2mat(CC.time(i))); %time     
%                        [rrnode, vmark]=splitnode2(crtree(j).root.node1, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));        
%                        if vmark==1
%                        crtree(j).root.node3=rrnode;
%                        crtree(j).root.node2=[];
%                        crtree(j).root.level=crtree(j).root.level+1;  
%                        elseif vmark==0
%                         crtree(j).root.node1=rrnode;    
%                        end
%                                 % test='line';
%                              end
%                          end
%                                                                                                                                                               
%                                      end
%                          
%                      end
%                                                                             
%                 end
%                              
%              %     sameitem=0; 
%          end   
%         
%             if sametime==0  %%重新建一个结点 
%                  if  ((node_num+1)<=n_node) %%建一个新的结点插入，记住这个时候每个结点都要记录1-dim  
%                     %%这里的重点是要处理小于半满啊 （这里要在paper里提出来）
%                     if size(crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf,2)<ceil(n_leaf/2)
%                                temp_leaf_num=size(crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf,2);
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).item=CC.itemtitle(i); %%maxkey
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_num=1;
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(1)=str2double((CC.rating1(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(2)=str2double((CC.rating2(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(3)=str2double((CC.rating3(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(4)=str2double((CC.rating4(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(5)=str2double((CC.rating5(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).maxtime=timechange(cell2mat(CC.time(i)));
%                     else  %%满足半满了 新建一个结点给它 (node_num+1)                
%                      %%%插入一个把所以1-dim全放上去然后出现分裂的时候分解1-dim哦 good
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).level=0;
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).dimark=1;
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).mintime=timechange(cell2mat(CC.time(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).maxtime=max;
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).minprice=0;
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).maxprice=max;
% [crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).sum_num, crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).sum_rating(1), crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).sum_rating(2), crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).sum_rating(3), crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).sum_rating(4), crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).sum_rating(5), crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).onedimR]=merge(crtree(j).root.node2(node2_num).node1(node1_num).node);                             
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).item=CC.itemtitle(i); %%新结点初始化
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).price=round(str2double(cell2mat(CC.itemprice(i))));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).sum_num=1;
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).sum_rating(1)=str2double((CC.rating1(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).sum_rating(2)=str2double((CC.rating2(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).sum_rating(3)=str2double((CC.rating3(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).sum_rating(4)=str2double((CC.rating4(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num+1).leaf(1).sum_rating(5)=str2double((CC.rating5(i)));                                                                       
%                     end
%                  else %%((node_num+1)<=n_node)
%                     %%%%这里首先判断(node_num+1)下的leaf叶子是否满，没满则继续插入，满了再上一层的分裂喽
%                     if    size(crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf,2)<ceil(n_leaf/2)
%                                temp_leaf_num=size(crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf,2);
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).item=CC.itemtitle(i); %%maxkey
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).price=round(str2double(cell2mat(CC.itemprice(i))));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).time=timechange(cell2mat(CC.time(i)));%%maxtime;        
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_num=1;
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(1)=str2double((CC.rating1(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(2)=str2double((CC.rating2(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(3)=str2double((CC.rating3(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(4)=str2double((CC.rating4(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).leaf(temp_leaf_num+1).sum_rating(5)=str2double((CC.rating5(i)));
%                                crtree(j).root.node2(node2_num).node1(node1_num).node(node_num).maxtime=timechange(cell2mat(CC.time(i))); 
%                     else
%                         if ((node1_num+1)<=n_node) %%插入分裂       
%                        temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                        temp2=timechange(cell2mat(CC.time(i))); %time     
%                        [ktempnode, pmark]=splitnode(crtree(j).root.node2(node2_num).node1(node1_num).node, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));                                
%                        if pmark==1 
%                        yyR=crtree(j).root.node2(node2_num).node1(node1_num).onedimR;
%                         yy1=crtree(j).root.node2(node2_num).node1(node1_num).sum_num;
%                         yy2=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(1);
%                         yy3=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(2);
%                         yy4=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(3);                   
%                         yy5=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(4);
%                         yy6=crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(5);
%                         crtree(j).root.node2(node2_num).node1(node1_num)=ktempnode(1);
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_num=yy1;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(1)=yy2;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(2)=yy3;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(3)=yy4;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(4)=yy5;
%                         crtree(j).root.node2(node2_num).node1(node1_num).sum_rating(5)=yy6;
%                         crtree(j).root.node2(node2_num).node1(node1_num).onedimR=yyR;
%                         crtree(j).root.node2(node2_num).node1(node1_num+1)=ktempnode(2);
%                        elseif pmark==0
%                            crtree(j).root.node2(node2_num).node1(node1_num).node=ktempnode;
%                        end
%                        %%%%以上部分
%                         else
%                             if ((node2_num+1)<=n_node)                    
%                        temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                        temp2=timechange(cell2mat(CC.time(i))); %time     
%                        [ktempnode1, kmark]=splitnode1(crtree(j).root.node2(node2_num).node1, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));  
%                        if kmark==1
%                         yyR=crtree(j).root.node2(node2_num).onedimR;
%                         yy1=crtree(j).root.node2(node2_num).sum_num;
%                         yy2=crtree(j).root.node2(node2_num).sum_rating(1);
%                         yy3=crtree(j).root.node2(node2_num).sum_rating(2);
%                         yy4=crtree(j).root.node2(node2_num).sum_rating(3);                   
%                         yy5=crtree(j).root.node2(node2_num).sum_rating(4);
%                         yy6=crtree(j).root.node2(node2_num).sum_rating(5);                   
%                         crtree(j).root.node2(node2_num)=ktempnode1(1);
%                         crtree(j).root.node2(node2_num).sum_num=yy1;
%                         crtree(j).root.node2(node2_num).sum_rating(1)=yy2;
%                         crtree(j).root.node2(node2_num).sum_rating(2)=yy3;
%                         crtree(j).root.node2(node2_num).sum_rating(3)=yy4;
%                         crtree(j).root.node2(node2_num).sum_rating(4)=yy5;
%                         crtree(j).root.node2(node2_num).sum_rating(5)=yy6;
%                         crtree(j).root.node2(node2_num).onedimR=yyR;
%                         crtree(j).root.node2(node2_num+1)=ktempnode1(2);  
%                        elseif kmark==0 
%                            crtree(j).root.node1=ktempnode1;                   
%                        end
%                             else 
%                        temp1=round(str2double(cell2mat(CC.itemprice(i)))); %price
%                        temp2=timechange(cell2mat(CC.time(i))); %time     
%                        [rrnode, vmark]=splitnode2(crtree(j).root.node1, temp1, temp2, (CC.rating1(i)), (CC.rating2(i)), (CC.rating3(i)), (CC.rating4(i)), (CC.rating5(i)), CC.itemtitle(i));        
%                        if vmark==1
%                        crtree(j).root.node3=rrnode;
%                        crtree(j).root.node2=[];
%                        crtree(j).root.level=crtree(j).root.level+1;  
%                        elseif vmark==0
%                         crtree(j).root.node1=rrnode;    
%                        end
% 
%                             end
%                         end
% 
%                     end
%                        
%                  end
%              end
%               
%                sametime=0; %%回执  
%        elseif crtree(j).root.level==4
             
       end  %%%%crtree(j).rootstar(n_rootstar).level==0  如果是叶子层    
       
              if crtree(j).root.minprice>round(str2double(cell2mat(CC.itemprice(i))))
                  crtree(j).root.minprice=round(str2double(cell2mat(CC.itemprice(i))));
              end
              if crtree(j).root.maxprice<round(str2double(cell2mat(CC.itemprice(i))))
                  
                  crtree(j).root.maxprice=round(str2double(cell2mat(CC.itemprice(i))));
              end
       break;
    end  %%strcmp(crtree(j).ctree, CC.cid(i))==1  别动
end  %%%j=1:1:cnumber 别动
            
     %    % % %新根节点重新赋值
 if cexistmark==0
    cnumber=cnumber+1;
    crtree(cnumber).ctree=CC.cid(i);
%%% 每一个entry要存储的

    crtree(cnumber).root.level=0; %%叶子节点
    %%%初始化第一个节点
    crtree(cnumber).root.minprice=round(str2double(cell2mat(CC.itemprice(i))));
    crtree(cnumber).root.maxprice=round(str2double(cell2mat(CC.itemprice(i))));
    crtree(cnumber).root.leaf(1).item=CC.itemtitle(i); %%maxkey
    crtree(cnumber).root.leaf(1).price=round(str2double(cell2mat(CC.itemprice(i))));
    crtree(cnumber).root.leaf(1).time=timechange(cell2mat(CC.time(i)));%%maxtime;
    crtree(cnumber).root.leaf(1).sum_num=1;
    crtree(cnumber).root.leaf(1).sum_rating(1)=str2double((CC.rating1(i))); %#ok<ST2NM>
    crtree(cnumber).root.leaf(1).sum_rating(2)=str2double((CC.rating2(i)));
    crtree(cnumber).root.leaf(1).sum_rating(3)=str2double((CC.rating3(i)));
    crtree(cnumber).root.leaf(1).sum_rating(4)=str2double((CC.rating4(i)));
    crtree(cnumber).root.leaf(1).sum_rating(5)=str2double((CC.rating5(i)));
    
 end                
   cexistmark=0;     
end
%end   
    
    
    
    
