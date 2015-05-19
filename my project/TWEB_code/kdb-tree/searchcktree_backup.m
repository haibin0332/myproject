conna=database('haibin0332','','');

setdbprefs ('DataReturnFormat','structure'); %%//?????
% 
cursorC=exec(conna,'select itemtitle, time, itemprice, rating1, rating2, rating3, rating4, rating5, cid from syndata_s3_ram1'); %%//????
% cursorC=exec(conna,'select itemtitle, time, itemprice, rating1, rating2, rating3, rating4, rating5, cid from seller1 order by time ASC'); %%//????
%cursorC=exec(conna,'select itemtitle, time, itemprice, rating1, rating2, rating3, rating4, rating5, cid from syndata_s2_ram2'); %%//????
% cursorC=exec(conna,'select * from testdata2 order by time ASC'); %%//????
% 
cursorC=fetch(cursorC);
CC=cursorC.Data;
tic
rootnode=kdbtree(CC);
toc
% 
load('s4.mat')
cursorC1=exec(conna,'select begintime, endtime, lowprice, highprice, subcategory from sellerd'); %%//????
cursorC1=fetch(cursorC1);
CC1=cursorC1.Data;
 aaa=cell(30, 30);

for i=1:1:size(CC1.endtime, 1)
    sum_k=0;
    sum_krating1=0;
    sum_krating2=0;
    sum_krating3=0;
    sum_krating4=0;
    sum_krating5=0;
    timerange2(1)=timechange(cell2mat(CC1.begintime(i)));
    timerange2(2)=timechange(cell2mat(CC1.endtime(i)));
    pricerange2(1)=round(str2double(cell2mat(CC1.lowprice(i))));
    pricerange2(2)=round(str2double(cell2mat(CC1.highprice(i))));
    subcategory=CC1.subcategory(i);
    category=cell2mat(subcategory);
    
    if isempty(category)
    find(i)=0;
     sss(i)=0;
   tic
    for  j=1:1:size(rootnode, 2)
%          if clength>8  %%最后一层
%         compcate=cell2mat(rootnode(j).ctree);
     %   if str2double(compcate)==str2double(category)  
            %%%% 在rootnode(j)里开始                              
            if rootnode(j).root.level==3
               pricerange1(1)=rootnode(j).root.minprice;
               pricerange1(2)=rootnode(j).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    sss(i)= sss(i)+1;
                     aaa(i, sss(i))=rootnode(j).ctree;
                    find(i)=find(i)+1;
           for k1=1:1:size(rootnode(j).root.node2, 2)
               if (rootnode(j).root.node2(k1).maxtime>=timerange2(1))&&(rootnode(j).root.node2(k1).mintime<=timerange2(1))%%%%%%%%%%%%%%%这个是递归条件
                     for k2=1:1:size(rootnode(j).root.node2(k1).node1, 2)
                      if (rootnode(j).root.node2(k1).node1(k2).maxtime>=timerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).mintime<=timerange2(1))
                          find(i)=find(i)+1;
                                   for k3=1:1:size(rootnode(j).root.node2(k1).node1(k2).node, 2)
                                       if (rootnode(j).root.node2(k1).node1(k2).node(k3).maxtime>=timerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).mintime<=timerange2(1))
                                           find(i)=find(i)+1;
                                          if rootnode(j).root.node2(k1).node1(k2).node(k3).mintime==timerange2(1)
                                     if isfield(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                           find(i)=find(i)+1;
                                               if rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node)
                                                           if  (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end                                              
                                                                                                                                      
                                          else %%复制在加上叶子结点
                                     if isfield(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node)
                                                           if  (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end 
                                     find(i)=find(i)+1;
                                      for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end                                                                                        
                                          end
                                       end      
                                   end
%                               end
                      end
                     end
 %                end
               end
               if (rootnode(j).root.node2(k1).maxtime>=timerange2(2))&&(rootnode(j).root.node2(k1).mintime<=timerange2(2))
  %               if rootnode(j).root.node2(k1).mintime==timerange2(2)

%                 else
                     for k2=1:1:size(rootnode(j).root.node2(k1).node1, 2)
                      if (rootnode(j).root.node2(k1).node1(k2).maxtime>=timerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).mintime<=timerange2(2))
                          find(i)=find(i)+1;
 %                              if rootnode(j).root.node2(k1).node1(k2).mintime==timerange2(2)
  %                             else  %%%在下一层
                                   for k3=1:1:size(rootnode(j).root.node2(k1).node1(k2).node, 2)
                                       if (rootnode(j).root.node2(k1).node1(k2).node(k3).maxtime>=timerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).mintime<=timerange2(2)) 
                                           find(i)=find(i)+1;
                                          if rootnode(j).root.node2(k1).node1(k2).node(k3).mintime==timerange2(2)
                                     if isfield(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node)
                                                           if  (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end                                              
                                                                                                                                      
                                          else %%复制在加上叶子结点
                                     if isfield(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node)
                                                           if  (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end 
                                     find(i)=find(i)+1;
                                      for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                                              
                                           
                                          end
                                       end      
                                   end
   %                            end
                      end
                     end
 %                end
               end                
           end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                 
                end
                                
            elseif rootnode(j).root.level==2
                %% 访问internode_1 
%                 tic
               pricerange1(1)=rootnode(j).root.minprice;
               pricerange1(2)=rootnode(j).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                   sss(i)= sss(i)+1;
                    aaa(i, sss(i))=rootnode(j).ctree;
                    find(i)=find(i)+1;
           for k1=1:1:size(rootnode(j).root.node1, 2)
               if (rootnode(j).root.node1(k1).maxtime>=timerange2(1))&&(rootnode(j).root.node1(k1).mintime<=timerange2(1))
%                 if rootnode(j).root.node1(k1).mintime==timerange2(1)

%                 else
                     for k2=1:1:size(rootnode(j).root.node1(k1).node, 2)
                      if (rootnode(j).root.node1(k1).node(k2).maxtime>=timerange2(1))&&(rootnode(j).root.node1(k1).node(k2).mintime<=timerange2(1))
                          find(i)=find(i)+1;
                               if rootnode(j).root.node1(k1).node(k2).mintime==timerange2(1)
                                     if isfield(rootnode(j).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node1(k1).node(k2).onedimR.level==0
                                                      if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node)
                                                           if  (rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end
                               else
                                     if isfield(rootnode(j).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node1(k1).node(k2).onedimR.level==0
                                                      if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node)
                                                           if  (rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).onedimR.level==1
                            if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                     %%%%%%%%%%%%%%%%
                                                                                                                                   
                                               end
                                     end                                   
                                      %%%访问1-dim and leaf
                                      find(i)=find(i)+1;
                                      for x=1:1:size(rootnode(j).root.node1(k1).node(k2).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                               end
                      end
                     end
 %                end
               end  
               if (rootnode(j).root.node1(k1).maxtime>=timerange2(2))&&(rootnode(j).root.node1(k1).mintime<=timerange2(2))
 %                if rootnode(j).root.node1(k1).mintime==timerange2(2)

 %                else
                     for k2=1:1:size(rootnode(j).root.node1(k1).node, 2)
                      if (rootnode(j).root.node1(k1).node(k2).maxtime>=timerange2(2))&&(rootnode(j).root.node1(k1).node(k2).mintime<=timerange2(2))
                          find(i)=find(i)+1;
                               if rootnode(j).root.node1(k1).node(k2).mintime==timerange2(2)
                                     if isfield(rootnode(j).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node1(k1).node(k2).onedimR.level==0
                                                      if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node)
                                                           if  (rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).onedimR.level==1
                            if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                   
                             
                                               end
                                     end
                               else
                                     if isfield(rootnode(j).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node1(k1).node(k2).onedimR.level==0
                                                      if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node)
                                                           if  (rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).onedimR.level==1
                            if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                                 
                                               end
                                     end                                   
                                      %%%访问1-dim and leaf
                                      find(i)=find(i)+1;
                                      for x=1:1:size(rootnode(j).root.node1(k1).node(k2).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                               end
                      end
                     end
 %                end
               end
               
           end
                                    
                end
                  
            elseif rootnode(j).root.level==1;
                %% 访问internode 
               pricerange1(1)=rootnode(j).root.minprice;
               pricerange1(2)=rootnode(j).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    sss(i)= sss(i)+1;
                    aaa(i, sss(i))=rootnode(j).ctree;
                    find(i)=find(i)+1;
           for k1=1:1:size(rootnode(j).root.node, 2)
               if (rootnode(j).root.node(k1).maxtime>=timerange2(1))&&(rootnode(j).root.node(k1).mintime<=timerange2(1))
                 if rootnode(j).root.node(k1).mintime==timerange2(1)
                     if isfield(rootnode(j).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if rootnode(j).root.node(k1).onedimR.level==0
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(rootnode(j).root.node(k1).onedimR.node)
                                if  (rootnode(j).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif rootnode(j).root.node(k1).onedimR.level==1
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node(k1).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node(k1).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                    
                         end
                     end
                 else
                     if isfield(rootnode(j).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if rootnode(j).root.node(k1).onedimR.level==0
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(rootnode(j).root.node(k1).onedimR.node)
                                if  (rootnode(j).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif rootnode(j).root.node(k1).onedimR.level==1
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node(k1).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node(k1).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                            
                         end
                     end  
                     find(i)=find(i)+1;
                                       for x=1:1:size(rootnode(j).root.node(k1).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                            
                 end
               end
               if (rootnode(j).root.node(k1).maxtime>timerange2(2))&&(rootnode(j).root.node(k1).mintime<=timerange2(2))
                 if rootnode(j).root.node(k1).mintime==timerange2(2)
                     if isfield(rootnode(j).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if rootnode(j).root.node(k1).onedimR.level==0
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(rootnode(j).root.node(k1).onedimR.node)                               
                                if  (rootnode(j).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif rootnode(j).root.node(k1).onedimR.level==1
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node(k1).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node(k1).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                    
                         end
                     end
                 else
                     if isfield(rootnode(j).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if rootnode(j).root.node(k1).onedimR.level==0
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(rootnode(j).root.node(k1).onedimR.node)
                                if  (rootnode(j).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif rootnode(j).root.node(k1).onedimR.level==1
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node(k1).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node(k1).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                            
                         end
                     end  
                     find(i)=find(i)+1;
                                       for x=1:1:size(rootnode(j).root.node(k1).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                            
                 end
               end               
               
           end
                              
        
                end
                
            elseif rootnode(j).root.level==0;
                 %% 访问leafnode
               pricerange1(1)=rootnode(j).root.minprice;
               pricerange1(2)=rootnode(j).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                   sss(i)= sss(i)+1;
                    aaa(i, sss(i))=rootnode(j).ctree;
                       find(i)=find(i)+1;
                    for x=1:1:size(rootnode(j).root.leaf, 2)
                                  sum_k=sum_k+1;
                                  sum_krating1=sum_krating1+1;
                                  sum_krating2=sum_krating2+1;
                                  sum_krating3=sum_krating3+1;
                                  sum_krating4=sum_krating4+1;
                                  sum_krating5=sum_krating5+1; 
                    end
                end
                                
            end
                      
   %     end             
               
           
        % end
    end
    
   toc
             
    else 
    clength=length(category);
    find(i)=0;
    sss(i)=0;
   tic
    for  j=1:1:size(rootnode, 2)
         if clength>8  %%最后一层
        compcate=cell2mat(rootnode(j).ctree);
        if str2double(compcate)==str2double(category)           
            %%%% 在rootnode(j)里开始                              
            if rootnode(j).root.level==3
               pricerange1(1)=rootnode(j).root.minprice;
               pricerange1(2)=rootnode(j).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);            
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    sss(i)=sss(i)+1;
                     aaa(i, sss(i))=rootnode(j).ctree;
                    find(i)=find(i)+1;
           for k1=1:1:size(rootnode(j).root.node2, 2)
               if (rootnode(j).root.node2(k1).maxtime>=timerange2(1))&&(rootnode(j).root.node2(k1).mintime<=timerange2(1))%%%%%%%%%%%%%%%这个是递归条件
                     for k2=1:1:size(rootnode(j).root.node2(k1).node1, 2)
                      if (rootnode(j).root.node2(k1).node1(k2).maxtime>=timerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).mintime<=timerange2(1))
                          find(i)=find(i)+1;
                                   for k3=1:1:size(rootnode(j).root.node2(k1).node1(k2).node, 2)
                                       if (rootnode(j).root.node2(k1).node1(k2).node(k3).maxtime>timerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).mintime<=timerange2(1))
                                           find(i)=find(i)+1;
                                          if rootnode(j).root.node2(k1).node1(k2).node(k3).mintime==timerange2(1)
                                     if isfield(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                           find(i)=find(i)+1;
                                               if rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node)
                                                           if  (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end                                              
                                                                                                                                      
                                          else %%复制在加上叶子结点
                                     if isfield(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node)
                                                           if  (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end 
                                     find(i)=find(i)+1;
                                      for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end                                                                                        
                                          end
                                       end      
                                   end
%                               end
                      end
                     end
 %                end
               end
               if (rootnode(j).root.node2(k1).maxtime>=timerange2(2))&&(rootnode(j).root.node2(k1).mintime<=timerange2(2))
  %               if rootnode(j).root.node2(k1).mintime==timerange2(2)

%                 else
                     for k2=1:1:size(rootnode(j).root.node2(k1).node1, 2)
                      if (rootnode(j).root.node2(k1).node1(k2).maxtime>=timerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).mintime<=timerange2(2))
                          find(i)=find(i)+1;
 %                              if rootnode(j).root.node2(k1).node1(k2).mintime==timerange2(2)
  %                             else  %%%在下一层
                                   for k3=1:1:size(rootnode(j).root.node2(k1).node1(k2).node, 2)
                                       if (rootnode(j).root.node2(k1).node1(k2).node(k3).maxtime>=timerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).mintime<=timerange2(2)) 
                                           find(i)=find(i)+1;
                                          if rootnode(j).root.node2(k1).node1(k2).node(k3).mintime==timerange2(2)
                                     if isfield(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node)
                                                           if  (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end                                              
                                                                                                                                      
                                          else %%复制在加上叶子结点
                                     if isfield(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node)
                                                           if  (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end 
                                     find(i)=find(i)+1;
                                      for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                                              
                                           
                                          end
                                       end      
                                   end
   %                            end
                      end
                     end
 %                end
               end                
           end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                 
                end
                                
            elseif rootnode(j).root.level==2
                %% 访问internode_1 
%                 tic
               pricerange1(1)=rootnode(j).root.minprice;
               pricerange1(2)=rootnode(j).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    sss(i)=sss(i)+1;
                     aaa(i, sss(i))=rootnode(j).ctree;
                    find(i)=find(i)+1;
           for k1=1:1:size(rootnode(j).root.node1, 2)
               if (rootnode(j).root.node1(k1).maxtime>=timerange2(1))&&(rootnode(j).root.node1(k1).mintime<=timerange2(1))
%                 if rootnode(j).root.node1(k1).mintime==timerange2(1)

%                 else
                     for k2=1:1:size(rootnode(j).root.node1(k1).node, 2)
                      if (rootnode(j).root.node1(k1).node(k2).maxtime>=timerange2(1))&&(rootnode(j).root.node1(k1).node(k2).mintime<=timerange2(1))
                          find(i)=find(i)+1;
                               if rootnode(j).root.node1(k1).node(k2).mintime==timerange2(1)
                                     if isfield(rootnode(j).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node1(k1).node(k2).onedimR.level==0
                                                      if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node)
                                                           if  (rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end
                               else
                                     if isfield(rootnode(j).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node1(k1).node(k2).onedimR.level==0
                                                      if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node)
                                                           if  (rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).onedimR.level==1
                            if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                     %%%%%%%%%%%%%%%%
                                                                                                                                   
                                               end
                                     end                                   
                                      %%%访问1-dim and leaf
                                      find(i)=find(i)+1;
                                      for x=1:1:size(rootnode(j).root.node1(k1).node(k2).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                               end
                      end
                     end
 %                end
               end  
               if (rootnode(j).root.node1(k1).maxtime>=timerange2(2))&&(rootnode(j).root.node1(k1).mintime<=timerange2(2))
 %                if rootnode(j).root.node1(k1).mintime==timerange2(2)

 %                else
                     for k2=1:1:size(rootnode(j).root.node1(k1).node, 2)
                      if (rootnode(j).root.node1(k1).node(k2).maxtime>=timerange2(2))&&(rootnode(j).root.node1(k1).node(k2).mintime<=timerange2(2))
                          find(i)=find(i)+1;
                               if rootnode(j).root.node1(k1).node(k2).mintime==timerange2(2)
                                     if isfield(rootnode(j).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node1(k1).node(k2).onedimR.level==0
                                                      if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node)
                                                           if  (rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).onedimR.level==1
                            if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                   
                             
                                               end
                                     end
                               else
                                     if isfield(rootnode(j).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node1(k1).node(k2).onedimR.level==0
                                                      if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node)
                                                           if  (rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).onedimR.level==1
                            if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                                 
                                               end
                                     end                                   
                                      %%%访问1-dim and leaf
                                      find(i)=find(i)+1;
                                      for x=1:1:size(rootnode(j).root.node1(k1).node(k2).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                               end
                      end
                     end
 %                end
               end
               
           end
                                    
                end
                  
            elseif rootnode(j).root.level==1;
                %% 访问internode 
               pricerange1(1)=rootnode(j).root.minprice;
               pricerange1(2)=rootnode(j).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    sss(i)=sss(i)+1;
                     aaa(i, sss(i))=rootnode(j).ctree;
                    find(i)=find(i)+1;
           for k1=1:1:size(rootnode(j).root.node, 2)
               if (rootnode(j).root.node(k1).maxtime>=timerange2(1))&&(rootnode(j).root.node(k1).mintime<=timerange2(1))
                 if rootnode(j).root.node(k1).mintime==timerange2(1)
                     if isfield(rootnode(j).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if rootnode(j).root.node(k1).onedimR.level==0
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(rootnode(j).root.node(k1).onedimR.node)
                                if  (rootnode(j).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif rootnode(j).root.node(k1).onedimR.level==1
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node(k1).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node(k1).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                    
                         end
                     end
                 else
                     if isfield(rootnode(j).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if rootnode(j).root.node(k1).onedimR.level==0
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(rootnode(j).root.node(k1).onedimR.node)
                                if  (rootnode(j).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif rootnode(j).root.node(k1).onedimR.level==1
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node(k1).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node(k1).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                            
                         end
                     end  
                     find(i)=find(i)+1;
                                       for x=1:1:size(rootnode(j).root.node(k1).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                            
                 end
               end
               if (rootnode(j).root.node(k1).maxtime>=timerange2(2))&&(rootnode(j).root.node(k1).mintime<=timerange2(2))
                 if rootnode(j).root.node(k1).mintime==timerange2(2)
                     if isfield(rootnode(j).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if rootnode(j).root.node(k1).onedimR.level==0
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(rootnode(j).root.node(k1).onedimR.node)                               
                                if  (rootnode(j).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif rootnode(j).root.node(k1).onedimR.level==1
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node(k1).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node(k1).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                    
                         end
                     end
                 else
                     if isfield(rootnode(j).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if rootnode(j).root.node(k1).onedimR.level==0
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(rootnode(j).root.node(k1).onedimR.node)
                                if  (rootnode(j).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif rootnode(j).root.node(k1).onedimR.level==1
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node(k1).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node(k1).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                            
                         end
                     end  
                     find(i)=find(i)+1;
                                       for x=1:1:size(rootnode(j).root.node(k1).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                            
                 end
               end               
               
           end
                              
        
                end
                
            elseif rootnode(j).root.level==0;
                 %% 访问leafnode
               pricerange1(1)=rootnode(j).root.minprice;
               pricerange1(2)=rootnode(j).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    sss(i)=sss(i)+1;
                    aaa(i, sss(i))=rootnode(j).ctree;
                       find(i)=find(i)+1;
                    for x=1:1:size(rootnode(j).root.leaf, 2)
                                  sum_k=sum_k+1;
                                  sum_krating1=sum_krating1+1;
                                  sum_krating2=sum_krating2+1;
                                  sum_krating3=sum_krating3+1;
                                  sum_krating4=sum_krating4+1;
                                  sum_krating5=sum_krating5+1; 
                    end
                end
                                
            end
                      
        end             
  
         else
        compcate=cell2mat(rootnode(j).ctree);
        rcate=compcate(1:clength);
        if strcmp(rcate, category)==1
            %%%% 在rootnode(j)里开始                              
            if rootnode(j).root.level==3
               pricerange1(1)=rootnode(j).root.minprice;
               pricerange1(2)=rootnode(j).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    sss(i)=sss(i)+1;
                     aaa(i, sss(i))=rootnode(j).ctree;
                    find(i)=find(i)+1;
           for k1=1:1:size(rootnode(j).root.node2, 2)
               if (rootnode(j).root.node2(k1).maxtime>=timerange2(1))&&(rootnode(j).root.node2(k1).mintime<=timerange2(1))%%%%%%%%%%%%%%%这个是递归条件
                     for k2=1:1:size(rootnode(j).root.node2(k1).node1, 2)
                      if (rootnode(j).root.node2(k1).node1(k2).maxtime>=timerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).mintime<=timerange2(1))
                          find(i)=find(i)+1;
                                   for k3=1:1:size(rootnode(j).root.node2(k1).node1(k2).node, 2)
                                       if (rootnode(j).root.node2(k1).node1(k2).node(k3).maxtime>=timerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).mintime<=timerange2(1))
                                           find(i)=find(i)+1;
                                          if rootnode(j).root.node2(k1).node1(k2).node(k3).mintime==timerange2(1)
                                     if isfield(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                           find(i)=find(i)+1;
                                               if rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node)
                                                           if  (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end                                              
                                                                                                                                      
                                          else %%复制在加上叶子结点
                                     if isfield(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node)
                                                           if  (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end 
                                     find(i)=find(i)+1;
                                      for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end                                                                                        
                                          end
                                       end      
                                   end
%                               end
                      end
                     end
 %                end
               end
               if (rootnode(j).root.node2(k1).maxtime>=timerange2(2))&&(rootnode(j).root.node2(k1).mintime<=timerange2(2))
  %               if rootnode(j).root.node2(k1).mintime==timerange2(2)

%                 else
                     for k2=1:1:size(rootnode(j).root.node2(k1).node1, 2)
                      if (rootnode(j).root.node2(k1).node1(k2).maxtime>=timerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).mintime<=timerange2(2))
                          find(i)=find(i)+1;
 %                              if rootnode(j).root.node2(k1).node1(k2).mintime==timerange2(2)
  %                             else  %%%在下一层
                                   for k3=1:1:size(rootnode(j).root.node2(k1).node1(k2).node, 2)
                                       if (rootnode(j).root.node2(k1).node1(k2).node(k3).maxtime>=timerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).mintime<=timerange2(2)) 
                                           find(i)=find(i)+1;
                                          if rootnode(j).root.node2(k1).node1(k2).node(k3).mintime==timerange2(2)
                                     if isfield(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node)
                                                           if  (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end                                              
                                                                                                                                      
                                          else %%复制在加上叶子结点
                                     if isfield(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node)
                                                           if  (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end 
                                     find(i)=find(i)+1;
                                      for x=1:1:size(rootnode(j).root.node2(k1).node1(k2).node(k3).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                                              
                                           
                                          end
                                       end      
                                   end
   %                            end
                      end
                     end
 %                end
               end                
           end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                 
                end
                                
            elseif rootnode(j).root.level==2
                %% 访问internode_1 
%                 tic
               pricerange1(1)=rootnode(j).root.minprice;
               pricerange1(2)=rootnode(j).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    sss(i)=sss(i)+1;
                    aaa(i, sss(i))=rootnode(j).ctree;
                    find(i)=find(i)+1;
           for k1=1:1:size(rootnode(j).root.node1, 2)
               if (rootnode(j).root.node1(k1).maxtime>=timerange2(1))&&(rootnode(j).root.node1(k1).mintime<=timerange2(1))
%                 if rootnode(j).root.node1(k1).mintime==timerange2(1)

%                 else
                     for k2=1:1:size(rootnode(j).root.node1(k1).node, 2)
                      if (rootnode(j).root.node1(k1).node(k2).maxtime>=timerange2(1))&&(rootnode(j).root.node1(k1).node(k2).mintime<=timerange2(1))
                          find(i)=find(i)+1;
                               if rootnode(j).root.node1(k1).node(k2).mintime==timerange2(1)
                                     if isfield(rootnode(j).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node1(k1).node(k2).onedimR.level==0
                                                      if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node)
                                                           if  (rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end
                               else
                                     if isfield(rootnode(j).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node1(k1).node(k2).onedimR.level==0
                                                      if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node)
                                                           if  (rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).onedimR.level==1
                            if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                     %%%%%%%%%%%%%%%%
                                                                                                                                   
                                               end
                                     end                                   
                                      %%%访问1-dim and leaf
                                      find(i)=find(i)+1;
                                      for x=1:1:size(rootnode(j).root.node1(k1).node(k2).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                               end
                      end
                     end
 %                end
               end  
               if (rootnode(j).root.node1(k1).maxtime>=timerange2(2))&&(rootnode(j).root.node1(k1).mintime<=timerange2(2))
 %                if rootnode(j).root.node1(k1).mintime==timerange2(2)

 %                else
                     for k2=1:1:size(rootnode(j).root.node1(k1).node, 2)
                      if (rootnode(j).root.node1(k1).node(k2).maxtime>=timerange2(2))&&(rootnode(j).root.node1(k1).node(k2).mintime<=timerange2(2))
                          find(i)=find(i)+1;
                               if rootnode(j).root.node1(k1).node(k2).mintime==timerange2(2)
                                     if isfield(rootnode(j).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node1(k1).node(k2).onedimR.level==0
                                                      if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node)
                                                           if  (rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).onedimR.level==1
                            if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                   
                             
                                               end
                                     end
                               else
                                     if isfield(rootnode(j).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if rootnode(j).root.node1(k1).node(k2).onedimR.level==0
                                                      if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node)
                                                           if  (rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif rootnode(j).root.node1(k1).node(k2).onedimR.level==1
                            if (rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                                 
                                               end
                                     end                                   
                                      %%%访问1-dim and leaf
                                      find(i)=find(i)+1;
                                      for x=1:1:size(rootnode(j).root.node1(k1).node(k2).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                               end
                      end
                     end
 %                end
               end
               
           end
                                    
                end
                  
            elseif rootnode(j).root.level==1;
                %% 访问internode 
               pricerange1(1)=rootnode(j).root.minprice;
               pricerange1(2)=rootnode(j).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else                   
                    sss(i)=sss(i)+1;
                     aaa(i, sss(i))=rootnode(j).ctree;
                    find(i)=find(i)+1;
           for k1=1:1:size(rootnode(j).root.node, 2)
               if (rootnode(j).root.node(k1).maxtime>=timerange2(1))&&(rootnode(j).root.node(k1).mintime<=timerange2(1))
                 if rootnode(j).root.node(k1).mintime==timerange2(1)
                     if isfield(rootnode(j).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if rootnode(j).root.node(k1).onedimR.level==0
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(rootnode(j).root.node(k1).onedimR.node)
                                if  (rootnode(j).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif rootnode(j).root.node(k1).onedimR.level==1
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node(k1).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node(k1).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                    
                         end
                     end
                 else
                     if isfield(rootnode(j).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if rootnode(j).root.node(k1).onedimR.level==0
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(rootnode(j).root.node(k1).onedimR.node)
                                if  (rootnode(j).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif rootnode(j).root.node(k1).onedimR.level==1
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node(k1).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node(k1).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                            
                         end
                     end  
                     find(i)=find(i)+1;
                                       for x=1:1:size(rootnode(j).root.node(k1).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                            
                 end
               end
               if (rootnode(j).root.node(k1).maxtime>=timerange2(2))&&(rootnode(j).root.node(k1).mintime<=timerange2(2))
                 if rootnode(j).root.node(k1).mintime==timerange2(2)
                     if isfield(rootnode(j).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if rootnode(j).root.node(k1).onedimR.level==0
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(rootnode(j).root.node(k1).onedimR.node)                               
                                if  (rootnode(j).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif rootnode(j).root.node(k1).onedimR.level==1
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node(k1).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node(k1).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                    
                         end
                     end
                 else
                     if isfield(rootnode(j).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if rootnode(j).root.node(k1).onedimR.level==0
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(rootnode(j).root.node(k1).onedimR.node)
                                if  (rootnode(j).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(rootnode(j).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif rootnode(j).root.node(k1).onedimR.level==1
                           if (rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(1))||(rootnode(j).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (rootnode(j).root.node(k1).onedimR.minprice>pricerange2(1))&&(rootnode(j).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(rootnode(j).root.node(k1).onedimR.node1)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(rootnode(j).root.node(k1).onedimR.node1(v).node)
                                               sum_k=sum_k+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+rootnode(j).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                            
                         end
                     end  
                     find(i)=find(i)+1;
                                       for x=1:1:size(rootnode(j).root.node(k1).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                            
                 end
               end               
               
           end
                              
        
                end
                
            elseif rootnode(j).root.level==0;
                 %% 访问leafnode
               pricerange1(1)=rootnode(j).root.minprice;
               pricerange1(2)=rootnode(j).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    sss(i)=sss(i)+1;
                    aaa(i, sss(i))=rootnode(j).ctree;
                       find(i)=find(i)+1;
                    for x=1:1:size(rootnode(j).root.leaf, 2)
                                  sum_k=sum_k+1;
                                  sum_krating1=sum_krating1+1;
                                  sum_krating2=sum_krating2+1;
                                  sum_krating3=sum_krating3+1;
                                  sum_krating4=sum_krating4+1;
                                  sum_krating5=sum_krating5+1; 
                    end
                end
                                
            end
                       
        end
                       
           
         end
    end
    
   toc
    end 
    
end



