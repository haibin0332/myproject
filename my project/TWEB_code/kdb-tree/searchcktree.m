conna=database('haibin0332','','');

setdbprefs ('DataReturnFormat','structure'); %%//?????
% 
% %cursorC=exec(conna,'select itemtitle, time, itemprice, rating1, rating2, rating3, rating4, rating5, cid from seller1 order by time ASC'); %%//????
% cursorC=exec(conna,'select itemtitle, time, itemprice, rating1, rating2, rating3, rating4, rating5, cid from syndata_s1_ram1'); %%//????
% %cursorC=exec(conna,'select * from testdata2 order by time ASC'); %%//????
% cursorC=fetch(cursorC);
% CC=cursorC.Data;
% tic
% [rootnode, totalleafnode]=buildaPtree(CC);
% toc

load('root(SD1(S2)_251sec).mat')
%load('leaf(SD2(S1)_1478sec).mat')
cursorC1=exec(conna,'select begintime, endtime, lowprice, highprice, category from s2_3dim'); %%//????
%cursorC1=exec(conna,'select begintime, endtime, lowprice, highprice, subcategory from enquiry8'); %%//????
cursorC1=fetch(cursorC1);
CC1=cursorC1.Data;

pause(10);

tic
for i=1:1:size(CC1.endtime, 1)
    
    %%%%%
    % 应该pricerange(1)搭配timerange1, pricerange(2)搭配timerange1;
    %%%%%
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
    category=cell2mat(CC1.category(i));
    if isempty(category) %%%如果要全搜索
    find(i)=0;


for  j=1:1:size(roottop, 2)   
    
              pricerange1(1)=roottop(j).minprice;
              pricerange1(2)=roottop(j).maxprice;
              testrange=overlap(pricerange1, pricerange2);
                 
 if     testrange==0
                    continue;  %#ok<NOPTS>
                    
 else  
%      
     for j1=1:1:size(roottop(j).child, 2)
         
              pricerange1(1)=roottop(j).child(j1).minprice;
              pricerange1(2)=roottop(j).child(j1).maxprice;
              testrange=overlap(pricerange1, pricerange2);        
   if   testrange==0
        continue;  %#ok<NOPTS> 
   else
       
       for j2=1:1:size(roottop(j).child(j1).child, 2)
              pricerange1(1)=roottop(j).child(j1).child(j2).minprice;
              pricerange1(2)=roottop(j).child(j1).child(j2).maxprice;
              testrange=overlap(pricerange1, pricerange2); 
           
              if    testrange==0
                  continue;  %#ok<NOPTS> 
              else
                  
                  for j3=1:1:size(roottop(j).child(j1).child(j2).child, 2)
              pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).minprice;
              pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).maxprice;
              testrange=overlap(pricerange1, pricerange2); 
                      
                      if  testrange==0
                          continue;
                      else
                          
                          for j4=1:1:size(roottop(j).child(j1).child(j2).child(j3).child, 2)
            if roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==3
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else

           for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2, 2)
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).mintime<=timerange2(1))%%%%%%%%%%%%%%%这个是递归条件
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).mintime<=timerange2(1))
                          find(i)=find(i)+1;
                                   for k3=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node, 2)
                                       if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).mintime<=timerange2(1))
                                           find(i)=find(i)+1;
                                          if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).mintime==timerange2(1)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                           find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end                                              
                                                                                                                                      
                                          else %%复制在加上叶子结点
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              find(i)=find(i)+1;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               find(i)=find(i)+1;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end 
                                     find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end   
                                      break;
                                          end
                                       end      
                                   end
%                               end
                             break;
                      end
                     end
 %                end
               end
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).mintime<=timerange2(2))
  %               if rootnode(j).root.node2(k1).mintime==timerange2(2)

%                 else
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).mintime<=timerange2(2))
                          find(i)=find(i)+1;
 %                              if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).mintime==timerange2(2)
  %                             else  %%%在下一层
                                   for k3=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node, 2)
                                       if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).mintime<=timerange2(2)) 
                                           find(i)=find(i)+1;
                                          if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).mintime==timerange2(2)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end                                              
                                                                                                                                      
                                          else %%复制在加上叶子结点
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              find(i)=find(i)+1;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               find(i)=find(i)+1;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end 
                                     find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                                              
                                          break; 
                                          end
                                       end      
                                   end
   %                            end
                          break;
                      end
                     end
 %                end
               end                
           end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                 
                end
                                
            elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==2
                %% 访问internode_1 
%                 tic
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    find(i)=find(i)+1;
           for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1, 2)
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).mintime<=timerange2(1))
%                 if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).mintime==timerange2(1)

%                 else
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).mintime<=timerange2(1))
                          find(i)=find(i)+1;
                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).mintime==timerange2(1)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end
                               else
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              find(i)=find(i)+1;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               find(i)=find(i)+1;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==1
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                              find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                     %%%%%%%%%%%%%%%%
                                                                                                                                   
                                               end
                                     end                                   
                                      %%%访问1-dim and leaf
                                      find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                                      break;
                               end
                      end
                     end
 %                end
               end  
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).mintime<=timerange2(2))
 %                if rootnode(j).root.node1(k1).mintime==timerange2(2)

 %                else
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).mintime<=timerange2(2))
                          find(i)=find(i)+1;
                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).mintime==timerange2(2)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==1
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                   
                             
                                               end
                                     end
                               else
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              find(i)=find(i)+1;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                              find(i)=find(i)+1;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==1
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                                 
                                               end
                                     end                                   
                                      %%%访问1-dim and leaf
                                      find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                                      break;
                               end
                      end
                     end
 %                end
               end
               
           end
                                    
                end
                  
            elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==1;
                %% 访问internode 
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                %    sss(i)= sss(i)+1;
                 %   aaa(i, sss(i))=rootnode(j).ctree;
                    find(i)=find(i)+1;
           for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node, 2)
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).mintime<=timerange2(1))
                 if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).mintime==timerange2(1)
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node, 2)
                                if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                    
                         end
                     end
                 else
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node, 2)
                                if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                              find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                              find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                            
                         end
                     end  
                     find(i)=find(i)+1;
                                       for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                            
                 end
               end
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).maxtime>timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).mintime<=timerange2(2))
                 if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).mintime==timerange2(2)
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node, 2)                               
                                if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                    
                         end
                     end
                 else
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node, 2)
                                if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                              find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                              find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                            
                         end
                     end  
                     find(i)=find(i)+1;
                                       for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).leaf, 2)
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
                
            elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==0;
                 %% 访问leafnode
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                  % sss(i)= sss(i)+1;
                   % aaa(i, sss(i))=rootnode(j).ctree;
                       find(i)=find(i)+1;
                    for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.leaf, 2)
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
                  
              end
       
       end
   end    
         
     end
     
 end
    
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else %%%%%%%%%%%%%%%%%%%%%%%%%%这里如果query是2D的没有类别
   % clength=length(category);
    find(i)=0;

    
for  j=1:1:size(roottop, 2)

    if (length(roottop(j).category)<=length(category))&&(str2double(roottop(j).category)==str2double(category(1:2))) %%%query比当前层数多,并且存在则往下一层     
         
        for j1=1:1:size(roottop(j).child, 2)
            
           if (length(roottop(j).child(j1).category)<=length(category))&&(str2double(roottop(j).child(j1).category)==str2double(category(1:4)))
               
               for j2=1:1:size(roottop(j).child(j1).child, 2)
                   
                   if (length(roottop(j).child(j1).child(j2).category)<=length(category))&&(str2double(roottop(j).child(j1).child(j2).category)==str2double(category(1:6)))
                       
                       for j3=1:1:size(roottop(j).child(j1).child(j2).child, 2)
                           
                           if (length(roottop(j).child(j1).child(j2).child(j3).category)<=length(category))&&(str2double(roottop(j).child(j1).child(j2).child(j3).category)==str2double(category(1:8)))
                            
                               for j4=1:1:size(roottop(j).child(j1).child(j2).child(j3).child, 2)
                                   
                                   if (length(cell2mat(roottop(j).child(j1).child(j2).child(j3).child(j4).ctree))<=length(category))&&(str2double(cell2mat(roottop(j).child(j1).child(j2).child(j3).child(j4).ctree))==str2double(category))

            if roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==3
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    break;  %#ok<NOPTS>
                else

           for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2, 2)
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).mintime<=timerange2(1))%%%%%%%%%%%%%%%这个是递归条件
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).mintime<=timerange2(1))
                          find(i)=find(i)+1;
                                   for k3=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node, 2)
                                       if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).mintime<=timerange2(1))
                                           find(i)=find(i)+1;
                                          if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).mintime==timerange2(1)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                           find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end                                              
                                                                                                                                      
                                          else %%复制在加上叶子结点
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                           find(i)=find(i)+1; 
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                           find(i)=find(i)+1;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                              find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end 
                                     find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end   
                                      break;
                                          end
                                       end      
                                   end
%                               end
                                break;
                      end
                     end
 %                end
               end
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).mintime<=timerange2(2))
  %               if rootnode(j).root.node2(k1).mintime==timerange2(2)

%                 else
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).mintime<=timerange2(2))
                          find(i)=find(i)+1;
 %                              if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).mintime==timerange2(2)
  %                             else  %%%在下一层
                                   for k3=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node, 2)
                                       if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).mintime<=timerange2(2)) 
                                           find(i)=find(i)+1;
                                          if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).mintime==timerange2(2)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end                                              
                                                                                                                                      
                                          else %%复制在加上叶子结点
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              find(i)=find(i)+1; 
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               find(i)=find(i)+1; 
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end 
                                     find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                                              
                                          break; 
                                          end
                                       end      
                                   end
   %                            end
   break;
                      end
                     end
 %                end
               end                
           end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                 
                end
                                
            elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==2
                %% 访问internode_1 
%                 tic
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    break;  %#ok<NOPTS>
                else
                    find(i)=find(i)+1;
           for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1, 2)
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).mintime<=timerange2(1))
%                 if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).mintime==timerange2(1)

%                 else
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).mintime<=timerange2(1))
                          find(i)=find(i)+1;
                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).mintime==timerange2(1)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end
                               else
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                             find(i)=find(i)+1;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               find(i)=find(i)+1;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==1
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                     %%%%%%%%%%%%%%%%
                                                                                                                                   
                                               end
                                     end                                   
                                      %%%访问1-dim and leaf
                                      find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                                      break;
                               end
                      end
                     end
 %                end
               end  
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).mintime<=timerange2(2))
 %                if rootnode(j).root.node1(k1).mintime==timerange2(2)

 %                else
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).mintime<=timerange2(2))
                          find(i)=find(i)+1;
                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).mintime==timerange2(2)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==1
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                   
                             
                                               end
                                     end
                               else
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              find(i)=find(i)+1;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               find(i)=find(i)+1;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==1
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                                 
                                               end
                                     end                                   
                                      %%%访问1-dim and leaf
                                      find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                                      break;
                               end
                      end
                     end
 %                end
               end
               
           end
                                    
                end
                  
            elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==1;
                %% 访问internode 
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    break;  %#ok<NOPTS>
                else
                %    sss(i)= sss(i)+1;
                 %   aaa(i, sss(i))=rootnode(j).ctree;
                    find(i)=find(i)+1;
           for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node, 2)
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).mintime<=timerange2(1))
                 if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).mintime==timerange2(1)
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node, 2)
                                if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                    
                         end
                     end
                 else
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                              find(i)=find(i)+1;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node, 2)
                                if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                              find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                            
                         end
                     end  
                     find(i)=find(i)+1;
                                       for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                            
                 end
               end
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).maxtime>timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).mintime<=timerange2(2))
                 if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).mintime==timerange2(2)
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node, 2)                               
                                if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                    
                         end
                     end
                 else
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node, 2)
                                if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                            
                         end
                     end  
                     find(i)=find(i)+1;
                                       for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).leaf, 2)
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
                
            elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==0;
                 %% 访问leafnode
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    break;  %#ok<NOPTS>
                else
                  % sss(i)= sss(i)+1;
                   % aaa(i, sss(i))=rootnode(j).ctree;
                       find(i)=find(i)+1;
                    for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.leaf, 2)
                                  sum_k=sum_k+1;
                                  sum_krating1=sum_krating1+1;
                                  sum_krating2=sum_krating2+1;
                                  sum_krating3=sum_krating3+1;
                                  sum_krating4=sum_krating4+1;
                                  sum_krating5=sum_krating5+1; 
                    end
                end
                                
            end                                        
                                       
                                                                       
                                    break;
                                   elseif  length(cell2mat(roottop(j).child(j1).child(j2).child(j3).child(j4).ctree))>length(category)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%这部分各种复制                                           
            if roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==3
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else

           for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2, 2)
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).mintime<=timerange2(1))%%%%%%%%%%%%%%%这个是递归条件
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).mintime<=timerange2(1))
                          find(i)=find(i)+1;
                                   for k3=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node, 2)
                                       if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).mintime<=timerange2(1))
                                           find(i)=find(i)+1;
                                          if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).mintime==timerange2(1)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                           find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end                                              
                                                                                                                                      
                                          else %%复制在加上叶子结点
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              find(i)=find(i)+1;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               find(i)=find(i)+1;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end 
                                     find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end   
                                      break;
                                          end
                                       end      
                                   end
%                               end
break;
                      end
                     end
 %                end
               end
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).mintime<=timerange2(2))
  %               if rootnode(j).root.node2(k1).mintime==timerange2(2)

%                 else
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).mintime<=timerange2(2))
                          find(i)=find(i)+1;
 %                              if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).mintime==timerange2(2)
  %                             else  %%%在下一层
                                   for k3=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node, 2)
                                       if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).mintime<=timerange2(2)) 
                                           find(i)=find(i)+1;
                                          if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).mintime==timerange2(2)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end                                              
                                                                                                                                      
                                          else %%复制在加上叶子结点
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              find(i)=find(i)+1;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               find(i)=find(i)+1;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                              find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                              find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end 
                                     find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node2(k1).node1(k2).node(k3).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                                          break;    
                                           
                                          end
                                       end      
                                   end
   %                            end
   break;
                      end
                     end
 %                end
               end                
           end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                 
                end
                                
            elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==2
                %% 访问internode_1 
%                 tic
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    find(i)=find(i)+1;
           for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1, 2)
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).mintime<=timerange2(1))
%                 if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).mintime==timerange2(1)

%                 else
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).mintime<=timerange2(1))
                          find(i)=find(i)+1;
                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).mintime==timerange2(1)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end
                               else
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                             find(i)=find(i)+1;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                              find(i)=find(i)+1;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==1
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                     %%%%%%%%%%%%%%%%
                                                                                                                                   
                                               end
                                     end                                   
                                      %%%访问1-dim and leaf
                                      find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                                      break;
                               end
                      end
                     end
 %                end
               end  
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).mintime<=timerange2(2))
 %                if rootnode(j).root.node1(k1).mintime==timerange2(2)

 %                else
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).mintime<=timerange2(2))
                          find(i)=find(i)+1;
                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).mintime==timerange2(2)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==1
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                   
                             
                                               end
                                     end
                               else
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                             find(i)=find(i)+1;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               find(i)=find(i)+1;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.level==1
                            if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                                 
                                               end
                                     end                                   
                                      %%%访问1-dim and leaf
                                      find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node1(k1).node(k2).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                                      break;
                               end
                      end
                     end
 %                end
               end
               
           end
                                    
                end
                  
            elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==1;
                %% 访问internode 
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                %    sss(i)= sss(i)+1;
                 %   aaa(i, sss(i))=rootnode(j).ctree;
                    find(i)=find(i)+1;
           for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node, 2)
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).mintime<=timerange2(1))
                 if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).mintime==timerange2(1)
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node, 2)
                                if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                    
                         end
                     end
                 else
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node, 2)
                                if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                             find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                            
                         end
                     end  
                     find(i)=find(i)+1;
                                       for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                            
                 end
               end
               if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).maxtime>timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).mintime<=timerange2(2))
                 if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).mintime==timerange2(2)
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node, 2)                               
                                if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                    
                         end
                     end
                 else
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node, 2)
                                if  (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                            
                         end
                     end  
                     find(i)=find(i)+1;
                                       for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.node(k1).leaf, 2)
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
                
            elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==0;
                 %% 访问leafnode
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                  % sss(i)= sss(i)+1;
                   % aaa(i, sss(i))=rootnode(j).ctree;
                       find(i)=find(i)+1;
                    for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.leaf, 2)
                                  sum_k=sum_k+1;
                                  sum_krating1=sum_krating1+1;
                                  sum_krating2=sum_krating2+1;
                                  sum_krating3=sum_krating3+1;
                                  sum_krating4=sum_krating4+1;
                                  sum_krating5=sum_krating5+1; 
                    end
                end
                                
            end                                                                            
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%各种复制结束                                                                            
                                   end
                               end
                               break;
                           elseif length(roottop(j).child(j1).child(j2).child(j3).category)>length(category)
                               allnode=size(roottop(j).child(j1).child(j2).child(j3).child, 2);
                               for r=1:1:allnode
             if roottop(j).child(j1).child(j2).child(j3).child(r).root.level==3
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(r).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(r).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else

           for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2, 2)
               if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).mintime<=timerange2(1))%%%%%%%%%%%%%%%这个是递归条件
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).mintime<=timerange2(1))
                          find(i)=find(i)+1;
                                   for k3=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node, 2)
                                       if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).mintime<=timerange2(1))
                                           find(i)=find(i)+1;
                                          if roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).mintime==timerange2(1)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                           find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end                                              
                                                                                                                                      
                                          else %%复制在加上叶子结点
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              find(i)=find(i)+1;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               find(i)=find(i)+1;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                              find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end 
                                     find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end 
                                      break;
                                          end
                                       end      
                                   end
%                               end
break;
                      end
                     end
 %                end
               end
               if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).mintime<=timerange2(2))
  %               if rootnode(j).root.node2(k1).mintime==timerange2(2)

%                 else
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).mintime<=timerange2(2))
                          find(i)=find(i)+1;
 %                              if roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).mintime==timerange2(2)
  %                             else  %%%在下一层
                                   for k3=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node, 2)
                                       if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).mintime<=timerange2(2)) 
                                           find(i)=find(i)+1;
                                          if roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).mintime==timerange2(2)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end                                              
                                                                                                                                      
                                          else %%复制在加上叶子结点
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                                                              find(i)=find(i)+1;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                                                              find(i)=find(i)+1;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).node(k3).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.maxprice<pricerange2(2))
                              find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end 
                                     find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node2(k1).node1(k2).node(k3).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                                         break;     
                                           
                                          end
                                       end      
                                   end
   %                            end
   break;
                      end
                     end
 %                end
               end                
           end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                 
                end
                                
            elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.level==2
                %% 访问internode_1 
%                 tic
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(r).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(r).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    find(i)=find(i)+1;
           for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1, 2)
               if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).mintime<=timerange2(1))
%                 if roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).mintime==timerange2(1)

%                 else
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).mintime<=timerange2(1))
                          find(i)=find(i)+1;
                               if roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).mintime==timerange2(1)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.level==1
                                                 %%%%%%%%%%%%%%%%%%  
                            if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                             
                                                                               
                                               end
                                     end
                               else
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              find(i)=find(i)+1;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               find(i)=find(i)+1;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.level==1
                            if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                     %%%%%%%%%%%%%%%%
                                                                                                                                   
                                               end
                                     end                                   
                                      %%%访问1-dim and leaf
                                      find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                                      break;
                               end
                      end
                     end
 %                end
               end  
               if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).mintime<=timerange2(2))
 %                if rootnode(j).root.node1(k1).mintime==timerange2(2)

 %                else
                     for k2=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node, 2)
                      if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).maxtime>=timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).mintime<=timerange2(2))
                          find(i)=find(i)+1;
                               if roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).mintime==timerange2(2)
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              break;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               break;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.level==1
                            if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                   
                             
                                               end
                                     end
                               else
                                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR,'level') %%如果存在1-dim
                                         find(i)=find(i)+1;
                                               if roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.level==0
                                                      if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                                                              find(i)=find(i)+1;
                                                        elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                                                               find(i)=find(i)+1;
                                                        else
                                                        for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node, 2)
                                                           if  (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node(x).sum_rating(5);        
                                                           end
                                                        end
                                                      end      
                                               elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.level==1
                            if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.maxprice<pricerange2(2))
                              find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                                 
                                               end
                                     end                                   
                                      %%%访问1-dim and leaf
                                      find(i)=find(i)+1;
                                      for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node1(k1).node(k2).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                                      break;
                               end
                      end
                     end
 %                end
               end
               
           end
                                    
                end
                  
            elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.level==1;
                %% 访问internode 
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(r).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(r).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                %    sss(i)= sss(i)+1;
                 %   aaa(i, sss(i))=rootnode(j).ctree;
                    find(i)=find(i)+1;
           for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node, 2)
               if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).maxtime>=timerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).mintime<=timerange2(1))
                 if roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).mintime==timerange2(1)
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node, 2)
                                if  (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                    
                         end
                     end
                 else
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node, 2)
                                if  (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                            
                         end
                     end  
                     find(i)=find(i)+1;
                                       for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).leaf, 2)
                                          sum_k=sum_k+1;
                                          sum_krating1=sum_krating1+1;
                                          sum_krating2=sum_krating2+1;
                                          sum_krating3=sum_krating3+1;
                                          sum_krating4=sum_krating4+1;
                                          sum_krating5=sum_krating5+1;
                                      end
                            
                 end
               end
               if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).maxtime>timerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).mintime<=timerange2(2))
                 if roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).mintime==timerange2(2)
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node, 2)                               
                                if  (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(2))
                               break;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(2))
                               break;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                                    
                         end
                     end
                 else
                     if isfield(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR,'level') %%如果存在1-dim
                         find(i)=find(i)+1;
                         if roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.level==0
                           if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(2))
                               find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node, 2)
                                if  (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).price<pricerange2(2))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).price>pricerange2(1))
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node(x).sum_rating(5);        
                                 end
                             end
                               
                           end
                         elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.level==1
                           if (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(1))||(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(2))
                              find(i)=find(i)+1;
                           elseif (roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.minprice>pricerange2(1))&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.maxprice<pricerange2(2))
                               find(i)=find(i)+1;
                           else
                             for v=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1, 2)
                                 find(i)=find(i)+1;
                                for v1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node, 2)
                                               sum_k=sum_k+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_num;
                                               sum_krating1=sum_krating1+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(1);
                                               sum_krating2=sum_krating2+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(2);
                                               sum_krating3=sum_krating3+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(3);
                                               sum_krating4=sum_krating4+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(4);
                                               sum_krating5=sum_krating5+roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).onedimR.node1(v).node(v1).sum_rating(5);   
                                 
                                end
                             end  
                           end                                                            
                         end
                     end  
                     find(i)=find(i)+1;
                                       for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.node(k1).leaf, 2)
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
                
            elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.level==0;
                 %% 访问leafnode
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(r).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(r).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                  % sss(i)= sss(i)+1;
                   % aaa(i, sss(i))=rootnode(j).ctree;
                       find(i)=find(i)+1;
                    for x=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.leaf, 2)
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
                       break;
                   elseif length(roottop(j).child(j1).child(j2).category)>length(category) %%以下所有结点搜索
                       k=1;
                       
                   end
               end
            break;
           elseif length(roottop(j).child(j1).category)>length(category) %%以下所有结点搜索

               k=1;

           end %%% 第二层
        end %%for
        break;
    elseif  length(roottop(j).category)>length(category)%%以下所有结点搜索
        
        k=1;
        
    end %%%第一层                              
end %%%for
                             
    end  %%%%%%%%%%%%%%isempty 2D/3D
       
end %%%%%%%%%%%%%%%%CC1.end
toc