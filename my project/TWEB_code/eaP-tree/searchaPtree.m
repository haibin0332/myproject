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

load('root(SD2(S2)_555sec).mat')
load('leaf(SD2(S2)_555sec).mat')
cursorC1=exec(conna,'select begintime, endtime, lowprice, highprice, category from s2_2dim'); %%//????
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
               [number1, mm]=retaPtree(timerange2, pricerange2, roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode2, totalleafnode, j);
               find(i)=find(i)+mm;
                end
        elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==2
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode1, totalleafnode, j);
               find(i)=find(i)+mm;
                end
        elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==1
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    find(i)=find(i)+1;
                    for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode, 2)
                         tag=overlap1(pricerange2, roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).pricerange.min_price);
                    if  (timerange2(1)>=roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timebegin) && (tag==1)&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timeend>=timerange2(1) || strcmp(roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timeend,'*'))
                        find(i)=find(i)+1;
              %  [sum_k, sum_krating1, sum_krating2, sum_krating3, sum_krating4, sum_krating5]=retusumleaf1(pricerange2, rootnode(j).internode, totalleafnode, j); 
                    end
                    if  (timerange2(2) >= roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timebegin) && (tag==1)&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timeend>=timerange2(2) || strcmp(roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timeend,'*'))
                        find(i)=find(i)+1;
              %  [sum_k, sum_krating1, sum_krating2, sum_krating3, sum_krating4, sum_krating5]=retusumleaf1(pricerange2, rootnode(j).internode, totalleafnode, j); 
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
               [number1, mm]=retaPtree(timerange2, pricerange2, roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode2, totalleafnode, j);
               find(i)=find(i)+mm;
                end
        elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==2
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    break;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode1, totalleafnode, j);
               find(i)=find(i)+mm;
                end
        elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==1
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    break;  %#ok<NOPTS>
                else
                    find(i)=find(i)+1;
                    for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode, 2)
                         tag=overlap1(pricerange2, roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).pricerange.min_price);
                    if  (timerange2(1)>=roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timebegin) && (tag==1)&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timeend>=timerange2(1) || strcmp(roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timeend,'*'))
                        find(i)=find(i)+1;
              %  [sum_k, sum_krating1, sum_krating2, sum_krating3, sum_krating4, sum_krating5]=retusumleaf1(pricerange2, rootnode(j).internode, totalleafnode, j); 
                    end
                    if  (timerange2(2) >= roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timebegin) && (tag==1)&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timeend>=timerange2(2) || strcmp(roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timeend,'*'))
                        find(i)=find(i)+1;
              %  [sum_k, sum_krating1, sum_krating2, sum_krating3, sum_krating4, sum_krating5]=retusumleaf1(pricerange2, rootnode(j).internode, totalleafnode, j); 
                    end
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
               [number1, mm]=retaPtree(timerange2, pricerange2, roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode2, totalleafnode, j);
               find(i)=find(i)+mm;
                end
        elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==2
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode1, totalleafnode, j);
               find(i)=find(i)+mm;
                end
        elseif roottop(j).child(j1).child(j2).child(j3).child(j4).root.level==1
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(j4).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    find(i)=find(i)+1;
                    for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode, 2)
                         tag=overlap1(pricerange2, roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).pricerange.min_price);
                    if  (timerange2(1)>=roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timebegin) && (tag==1)&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timeend>=timerange2(1) || strcmp(roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timeend,'*'))
                        find(i)=find(i)+1;
              %  [sum_k, sum_krating1, sum_krating2, sum_krating3, sum_krating4, sum_krating5]=retusumleaf1(pricerange2, rootnode(j).internode, totalleafnode, j); 
                    end
                    if  (timerange2(2) >= roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timebegin) && (tag==1)&&(roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timeend>=timerange2(2) || strcmp(roottop(j).child(j1).child(j2).child(j3).child(j4).root.internode(k1).timerange.timeend,'*'))
                        find(i)=find(i)+1;
              %  [sum_k, sum_krating1, sum_krating2, sum_krating3, sum_krating4, sum_krating5]=retusumleaf1(pricerange2, rootnode(j).internode, totalleafnode, j); 
                    end
                    end
               end 
        end                                       
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                                            
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
               [number1, mm]=retaPtree(timerange2, pricerange2, roottop(j).child(j1).child(j2).child(j3).child(r).root.internode2, totalleafnode, j);
               find(i)=find(i)+mm;
                end
        elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.level==2
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(r).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(r).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, roottop(j).child(j1).child(j2).child(j3).child(r).root.internode1, totalleafnode, j);
               find(i)=find(i)+mm;
                end
        elseif roottop(j).child(j1).child(j2).child(j3).child(r).root.level==1
               pricerange1(1)=roottop(j).child(j1).child(j2).child(j3).child(r).root.minprice;
               pricerange1(2)=roottop(j).child(j1).child(j2).child(j3).child(r).root.maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    find(i)=find(i)+1;
                    for k1=1:1:size(roottop(j).child(j1).child(j2).child(j3).child(r).root.internode, 2)
                         tag=overlap1(pricerange2, roottop(j).child(j1).child(j2).child(j3).child(r).root.internode(k1).pricerange.min_price);
                    if  (timerange2(1)>=roottop(j).child(j1).child(j2).child(j3).child(r).root.internode(k1).timerange.timebegin) && (tag==1)&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.internode(k1).timerange.timeend>=timerange2(1) || strcmp(roottop(j).child(j1).child(j2).child(j3).child(r).root.internode(k1).timerange.timeend,'*'))
                        find(i)=find(i)+1;
              %  [sum_k, sum_krating1, sum_krating2, sum_krating3, sum_krating4, sum_krating5]=retusumleaf1(pricerange2, rootnode(j).internode, totalleafnode, j); 
                    end
                    if  (timerange2(2) >= roottop(j).child(j1).child(j2).child(j3).child(r).root.internode(k1).timerange.timebegin) && (tag==1)&&(roottop(j).child(j1).child(j2).child(j3).child(r).root.internode(k1).timerange.timeend>=timerange2(2) || strcmp(roottop(j).child(j1).child(j2).child(j3).child(r).root.internode(k1).timerange.timeend,'*'))
                        find(i)=find(i)+1;
              %  [sum_k, sum_krating1, sum_krating2, sum_krating3, sum_krating4, sum_krating5]=retusumleaf1(pricerange2, rootnode(j).internode, totalleafnode, j); 
                    end
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