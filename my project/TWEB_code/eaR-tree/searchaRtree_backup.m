conna=database('haibin0332','','');

setdbprefs ('DataReturnFormat','structure'); %%//?????
% % 
cursorC=exec(conna,'select itemtitle, time, itemprice, rating1, rating2, rating3, rating4, rating5, cid from syndata_s3_eql_general'); %%//????
%cursorC=exec(conna,'select * from testdata1 order by time ASC'); %%//????
cursorC=fetch(cursorC);
CC=cursorC.Data;
tic
rootnode=buildaRtree(CC);
toc
% 
%load('tree1.mat')
cursorC1=exec(conna,'select begintime, endtime, lowprice, highprice, subcategory from enquiry5'); %%//????
cursorC1=fetch(cursorC1);
CC1=cursorC1.Data;

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
  
    if isempty(category) %%kong
    find(i)=0;
   tic
    for  j=1:1:size(rootnode, 2)
%          if clength>8  %%最后一层
%         compcate=cell2mat(rootnode(j).ctree);
 %       if str2double(compcate)==str2double(category)
            %%%% 在rootnode(j)里开始
            if rootnode(j).n_level==4
               pricerange1(1)=rootnode(j).pricerange.min_price;
               pricerange1(2)=rootnode(j).pricerange.max_price;
               timerange1(1)=rootnode(j).timerange.min_time;
               timerange1(2)=rootnode(j).timerange.max_time;
               testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                if     testrange==0 
                   continue;
                else     
                    find(i)=find(i)+1;
                for k1=1:1:size(rootnode(j).internode_3, 2)
               pricerange1(1)=rootnode(j).internode_3(k1).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_3(k1).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_3(k1).timerange.min_time;
               timerange1(2)=rootnode(j).internode_3(k1).timerange.max_time;
                    testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                    if  testrange==1
                        find(i)=find(i)+1;
                     for k2=1:1:size(rootnode(j).internode_3(k1).internode_2, 2)
               pricerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).timerange.min_time;
               timerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);         
                       if testrange==1;
                           find(i)=find(i)+1;
                           for k3=1:1:size(rootnode(j).internode_3(k1).internode_2(k2).internode_1, 2)
               pricerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).timerange.min_time;
               timerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);  
                           if testrange==1;
                               find(i)=find(i)+1;
                               for k4=1:1:size(rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode, 2)
               pricerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode(k4).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode(k4).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode(k4).timerange.min_time;
               timerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode(k4).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2); 
                     if testrange==1; 
                         find(i)=find(i)+1;
                              [number1, number2, number3, number4, number5, number6]=retusumleaf(rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode(k4), pricerange2, timerange2);
                              sum_k=sum_k+number1;
                              sum_krating1=sum_krating1+number2;
                              sum_krating2=sum_krating2+number3;
                              sum_krating3=sum_krating3+number4;
                              sum_krating4=sum_krating4+number5;
                              sum_krating5=sum_krating5+number6;             
                     end
                               end
                           end
                           end
                           
                       end 
                     end 
                    end    
                end
                end       
                
            elseif rootnode(j).n_level==3
             %% 访问internode_2
%                  tic
               pricerange1(1)=rootnode(j).pricerange.min_price;
               pricerange1(2)=rootnode(j).pricerange.max_price;
               timerange1(1)=rootnode(j).timerange.min_time;
               timerange1(2)=rootnode(j).timerange.max_time;
               testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                if     testrange==0 
                   continue;
                else                    
                    find(i)=find(i)+1;
                for k1=1:1:size(rootnode(j).internode_2, 2)
               pricerange1(1)=rootnode(j).internode_2(k1).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_2(k1).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_2(k1).timerange.min_time;
               timerange1(2)=rootnode(j).internode_2(k1).timerange.max_time;
                    testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                    if  testrange==1
                        find(i)=find(i)+1;
                     for k2=1:1:size(rootnode(j).internode_2(k1).internode_1, 2)
               pricerange1(1)=rootnode(j).internode_2(k1).internode_1(k2).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_2(k1).internode_1(k2).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_2(k1).internode_1(k2).timerange.min_time;
               timerange1(2)=rootnode(j).internode_2(k1).internode_1(k2).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);         
                       if testrange==1;
                           find(i)=find(i)+1;
                           for k3=1:1:size(rootnode(j).internode_2(k1).internode_1(k2).internode, 2)
               pricerange1(1)=rootnode(j).internode_2(k1).internode_1(k2).internode(k3).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_2(k1).internode_1(k2).internode(k3).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_2(k1).internode_1(k2).internode(k3).timerange.min_time;
               timerange1(2)=rootnode(j).internode_2(k1).internode_1(k2).internode(k3).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);  
                           if testrange==1; 
                               find(i)=find(i)+1;
                            [number1, number2, number3, number4, number5, number6]=retusumleaf(rootnode(j).internode_2(k1).internode_1(k2).internode(k3), pricerange2, timerange2);
                                  sum_k=sum_k+number1;
                                  sum_krating1=sum_krating1+number2;
                                  sum_krating2=sum_krating2+number3;
                                  sum_krating3=sum_krating3+number4;
                                  sum_krating4=sum_krating4+number5;
                                  sum_krating5=sum_krating5+number6;
                           end
                           end
                           
                       end 
                     end 
                    end    
                end
                end
                
                
            elseif rootnode(j).n_level==2
                %% 访问internode_1 
%                 tic
               pricerange1(1)=rootnode(j).pricerange.min_price;
               pricerange1(2)=rootnode(j).pricerange.max_price;
               timerange1(1)=rootnode(j).timerange.min_time;
               timerange1(2)=rootnode(j).timerange.max_time;
               testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    find(i)=find(i)+1;
                for k1=1:1:size(rootnode(j).internode_1, 2)
               pricerange1(1)=rootnode(j).internode_1(k1).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_1(k1).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_1(k1).timerange.min_time;
               timerange1(2)=rootnode(j).internode_1(k1).timerange.max_time;
                    testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                    if  testrange==1
                        find(i)=find(i)+1;
                     for k2=1:1:size(rootnode(j).internode_1(k1).internode, 2)
               pricerange1(1)=rootnode(j).internode_1(k1).internode(k2).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_1(k1).internode(k2).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_1(k1).internode(k2).timerange.min_time;
               timerange1(2)=rootnode(j).internode_1(k1).internode(k2).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);         
                       if testrange==1;
                           find(i)=find(i)+1;
                                [number1, number2, number3, number4, number5, number6]=retusumleaf(rootnode(j).internode_1(k1).internode(k2), pricerange2, timerange2);
                                  sum_k=sum_k+number1;
                                  sum_krating1=sum_krating1+number2;
                                  sum_krating2=sum_krating2+number3;
                                  sum_krating3=sum_krating3+number4;
                                  sum_krating4=sum_krating4+number5;
                                  sum_krating5=sum_krating5+number6;
                       end 
                     end 
                    end    
                end
                end
                
            elseif rootnode(j).n_level==1;
                %% 访问internode 
               pricerange1(1)=rootnode(j).pricerange.min_price;
               pricerange1(2)=rootnode(j).pricerange.max_price;
               timerange1(1)=rootnode(j).timerange.min_time;
               timerange1(2)=rootnode(j).timerange.max_time;
               testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                if     testrange==0
                    continue;
                else    
                    find(i)=find(i)+1;
                for k1=1:1:size(rootnode(j).internode, 2)
               pricerange1(1)=rootnode(j).internode(k1).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode(k1).pricerange.max_price;
               timerange1(1)=rootnode(j).internode(k1).timerange.min_time;
               timerange1(2)=rootnode(j).internode(k1).timerange.max_time;
                    testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                    if  testrange==1
                        find(i)=find(i)+1;
                                  [number1, number2, number3, number4, number5, number6]=retusumleaf(rootnode(j).internode(k1), pricerange2, timerange2);
                                  sum_k=sum_k+number1;
                                  sum_krating1=sum_krating1+number2;
                                  sum_krating2=sum_krating2+number3;
                                  sum_krating3=sum_krating3+number4;
                                  sum_krating4=sum_krating4+number5;
                                  sum_krating5=sum_krating5+number6;
                    end    
                end
                end
                
            elseif rootnode(j).n_level==0;
                 %% 访问leafnode
               pricerange1(1)=rootnode(j).pricerange.min_price;
               pricerange1(2)=rootnode(j).pricerange.max_price;
               timerange1(1)=rootnode(j).timerange.min_time;
               timerange1(2)=rootnode(j).timerange.max_time;
               testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                     find(i)=find(i)+1;
                                  [number1, number2, number3, number4, number5, number6]=retusumleaf(rootnode(j), pricerange2, timerange2);
                                  sum_k=sum_k+number1;
                                  sum_krating1=sum_krating1+number2;
                                  sum_krating2=sum_krating2+number3;
                                  sum_krating3=sum_krating3+number4;
                                  sum_krating4=sum_krating4+number5;
                                  sum_krating5=sum_krating5+number6;              
                end
                
                
            end
            
            
      %  end                
                   
  %       end             
    end
    
   toc             
    else %%不空 
    clength=length(category);
    find(i)=0;
   tic
    for  j=1:1:size(rootnode, 2)
         if clength>8  %%最后一层
        compcate=cell2mat(rootnode(j).ctree);
        if str2double(compcate)==str2double(category)
            %%%% 在rootnode(j)里开始
            if rootnode(j).n_level==4
               pricerange1(1)=rootnode(j).pricerange.min_price;
               pricerange1(2)=rootnode(j).pricerange.max_price;
               timerange1(1)=rootnode(j).timerange.min_time;
               timerange1(2)=rootnode(j).timerange.max_time;
               testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                if     testrange==0 
                   continue;
                else     
                    find(i)=find(i)+1;
                for k1=1:1:size(rootnode(j).internode_3, 2)
               pricerange1(1)=rootnode(j).internode_3(k1).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_3(k1).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_3(k1).timerange.min_time;
               timerange1(2)=rootnode(j).internode_3(k1).timerange.max_time;
                    testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                    if  testrange==1
                        find(i)=find(i)+1;
                     for k2=1:1:size(rootnode(j).internode_3(k1).internode_2, 2)
               pricerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).timerange.min_time;
               timerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);         
                       if testrange==1;
                           find(i)=find(i)+1;
                           for k3=1:1:size(rootnode(j).internode_3(k1).internode_2(k2).internode_1, 2)
               pricerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).timerange.min_time;
               timerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);  
                           if testrange==1;
                               find(i)=find(i)+1;
                               for k4=1:1:size(rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode, 2)
               pricerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode(k4).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode(k4).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode(k4).timerange.min_time;
               timerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode(k4).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2); 
                     if testrange==1; 
                         find(i)=find(i)+1;
                              [number1, number2, number3, number4, number5, number6]=retusumleaf(rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode(k4), pricerange2, timerange2);
                              sum_k=sum_k+number1;
                              sum_krating1=sum_krating1+number2;
                              sum_krating2=sum_krating2+number3;
                              sum_krating3=sum_krating3+number4;
                              sum_krating4=sum_krating4+number5;
                              sum_krating5=sum_krating5+number6;             
                     end
                               end
                           end
                           end
                           
                       end 
                     end 
                    end    
                end
                end       
                
            elseif rootnode(j).n_level==3
             %% 访问internode_2
%                  tic
               pricerange1(1)=rootnode(j).pricerange.min_price;
               pricerange1(2)=rootnode(j).pricerange.max_price;
               timerange1(1)=rootnode(j).timerange.min_time;
               timerange1(2)=rootnode(j).timerange.max_time;
               testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                if     testrange==0 
                   continue;
                else                    
                    find(i)=find(i)+1;
                for k1=1:1:size(rootnode(j).internode_2, 2)
               pricerange1(1)=rootnode(j).internode_2(k1).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_2(k1).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_2(k1).timerange.min_time;
               timerange1(2)=rootnode(j).internode_2(k1).timerange.max_time;
                    testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                    if  testrange==1
                        find(i)=find(i)+1;
                     for k2=1:1:size(rootnode(j).internode_2(k1).internode_1, 2)
               pricerange1(1)=rootnode(j).internode_2(k1).internode_1(k2).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_2(k1).internode_1(k2).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_2(k1).internode_1(k2).timerange.min_time;
               timerange1(2)=rootnode(j).internode_2(k1).internode_1(k2).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);         
                       if testrange==1;
                           find(i)=find(i)+1;
                           for k3=1:1:size(rootnode(j).internode_2(k1).internode_1(k2).internode, 2)
               pricerange1(1)=rootnode(j).internode_2(k1).internode_1(k2).internode(k3).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_2(k1).internode_1(k2).internode(k3).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_2(k1).internode_1(k2).internode(k3).timerange.min_time;
               timerange1(2)=rootnode(j).internode_2(k1).internode_1(k2).internode(k3).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);  
                           if testrange==1; 
                               find(i)=find(i)+1;
                            [number1, number2, number3, number4, number5, number6]=retusumleaf(rootnode(j).internode_2(k1).internode_1(k2).internode(k3), pricerange2, timerange2);
                                  sum_k=sum_k+number1;
                                  sum_krating1=sum_krating1+number2;
                                  sum_krating2=sum_krating2+number3;
                                  sum_krating3=sum_krating3+number4;
                                  sum_krating4=sum_krating4+number5;
                                  sum_krating5=sum_krating5+number6;
                           end
                           end
                           
                       end 
                     end 
                    end    
                end
                end
                
                
            elseif rootnode(j).n_level==2
                %% 访问internode_1 
%                 tic
               pricerange1(1)=rootnode(j).pricerange.min_price;
               pricerange1(2)=rootnode(j).pricerange.max_price;
               timerange1(1)=rootnode(j).timerange.min_time;
               timerange1(2)=rootnode(j).timerange.max_time;
               testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    find(i)=find(i)+1;
                for k1=1:1:size(rootnode(j).internode_1, 2)
               pricerange1(1)=rootnode(j).internode_1(k1).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_1(k1).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_1(k1).timerange.min_time;
               timerange1(2)=rootnode(j).internode_1(k1).timerange.max_time;
                    testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                    if  testrange==1
                        find(i)=find(i)+1;
                     for k2=1:1:size(rootnode(j).internode_1(k1).internode, 2)
               pricerange1(1)=rootnode(j).internode_1(k1).internode(k2).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_1(k1).internode(k2).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_1(k1).internode(k2).timerange.min_time;
               timerange1(2)=rootnode(j).internode_1(k1).internode(k2).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);         
                       if testrange==1;
                           find(i)=find(i)+1;
                                [number1, number2, number3, number4, number5, number6]=retusumleaf(rootnode(j).internode_1(k1).internode(k2), pricerange2, timerange2);
                                  sum_k=sum_k+number1;
                                  sum_krating1=sum_krating1+number2;
                                  sum_krating2=sum_krating2+number3;
                                  sum_krating3=sum_krating3+number4;
                                  sum_krating4=sum_krating4+number5;
                                  sum_krating5=sum_krating5+number6;
                       end 
                     end 
                    end    
                end
                end
                
            elseif rootnode(j).n_level==1;
                %% 访问internode 
               pricerange1(1)=rootnode(j).pricerange.min_price;
               pricerange1(2)=rootnode(j).pricerange.max_price;
               timerange1(1)=rootnode(j).timerange.min_time;
               timerange1(2)=rootnode(j).timerange.max_time;
               testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                if     testrange==0
                    continue;
                else    
                    find(i)=find(i)+1;
                for k1=1:1:size(rootnode(j).internode, 2)
               pricerange1(1)=rootnode(j).internode(k1).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode(k1).pricerange.max_price;
               timerange1(1)=rootnode(j).internode(k1).timerange.min_time;
               timerange1(2)=rootnode(j).internode(k1).timerange.max_time;
                    testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                    if  testrange==1
                        find(i)=find(i)+1;
                                  [number1, number2, number3, number4, number5, number6]=retusumleaf(rootnode(j).internode(k1), pricerange2, timerange2);
                                  sum_k=sum_k+number1;
                                  sum_krating1=sum_krating1+number2;
                                  sum_krating2=sum_krating2+number3;
                                  sum_krating3=sum_krating3+number4;
                                  sum_krating4=sum_krating4+number5;
                                  sum_krating5=sum_krating5+number6;
                    end    
                end
                end
                
            elseif rootnode(j).n_level==0;
                 %% 访问leafnode
               pricerange1(1)=rootnode(j).pricerange.min_price;
               pricerange1(2)=rootnode(j).pricerange.max_price;
               timerange1(1)=rootnode(j).timerange.min_time;
               timerange1(2)=rootnode(j).timerange.max_time;
               testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                     find(i)=find(i)+1;
                                  [number1, number2, number3, number4, number5, number6]=retusumleaf(rootnode(j), pricerange2, timerange2);
                                  sum_k=sum_k+number1;
                                  sum_krating1=sum_krating1+number2;
                                  sum_krating2=sum_krating2+number3;
                                  sum_krating3=sum_krating3+number4;
                                  sum_krating4=sum_krating4+number5;
                                  sum_krating5=sum_krating5+number6;              
                end
                
                
            end
            
            
        end                
         else
        compcate=cell2mat(rootnode(j).ctree);
        rcate=compcate(1:clength);
        if strcmp(rcate, category)==1
            %%%% 在rootnode(j)里开始
            if rootnode(j).n_level==4
               pricerange1(1)=rootnode(j).pricerange.min_price;
               pricerange1(2)=rootnode(j).pricerange.max_price;
               timerange1(1)=rootnode(j).timerange.min_time;
               timerange1(2)=rootnode(j).timerange.max_time;
               testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                if     testrange==0 
                   continue;
                else     
                    find(i)=find(i)+1;
                for k1=1:1:size(rootnode(j).internode_3, 2)
               pricerange1(1)=rootnode(j).internode_3(k1).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_3(k1).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_3(k1).timerange.min_time;
               timerange1(2)=rootnode(j).internode_3(k1).timerange.max_time;
                    testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                    if  testrange==1
                        find(i)=find(i)+1;
                     for k2=1:1:size(rootnode(j).internode_3(k1).internode_2, 2)
               pricerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).timerange.min_time;
               timerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);         
                       if testrange==1;
                           find(i)=find(i)+1;
                           for k3=1:1:size(rootnode(j).internode_3(k1).internode_2(k2).internode_1, 2)
               pricerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).timerange.min_time;
               timerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);  
                           if testrange==1;
                               find(i)=find(i)+1;
                               for k4=1:1:size(rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode, 2)
               pricerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode(k4).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode(k4).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode(k4).timerange.min_time;
               timerange1(2)=rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode(k4).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2); 
                     if testrange==1; 
                         find(i)=find(i)+1;
                              [number1, number2, number3, number4, number5, number6]=retusumleaf(rootnode(j).internode_3(k1).internode_2(k2).internode_1(k3).internode(k4), pricerange2, timerange2);
                              sum_k=sum_k+number1;
                              sum_krating1=sum_krating1+number2;
                              sum_krating2=sum_krating2+number3;
                              sum_krating3=sum_krating3+number4;
                              sum_krating4=sum_krating4+number5;
                              sum_krating5=sum_krating5+number6;             
                     end
                               end
                           end
                           end
                           
                       end 
                     end 
                    end    
                end
                end       
                
            elseif rootnode(j).n_level==3
             %% 访问internode_2
%                  tic
               pricerange1(1)=rootnode(j).pricerange.min_price;
               pricerange1(2)=rootnode(j).pricerange.max_price;
               timerange1(1)=rootnode(j).timerange.min_time;
               timerange1(2)=rootnode(j).timerange.max_time;
               testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                if     testrange==0 
                   continue;
                else                    
                    find(i)=find(i)+1;
                for k1=1:1:size(rootnode(j).internode_2, 2)
               pricerange1(1)=rootnode(j).internode_2(k1).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_2(k1).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_2(k1).timerange.min_time;
               timerange1(2)=rootnode(j).internode_2(k1).timerange.max_time;
                    testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                    if  testrange==1
                        find(i)=find(i)+1;
                     for k2=1:1:size(rootnode(j).internode_2(k1).internode_1, 2)
               pricerange1(1)=rootnode(j).internode_2(k1).internode_1(k2).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_2(k1).internode_1(k2).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_2(k1).internode_1(k2).timerange.min_time;
               timerange1(2)=rootnode(j).internode_2(k1).internode_1(k2).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);         
                       if testrange==1;
                           find(i)=find(i)+1;
                           for k3=1:1:size(rootnode(j).internode_2(k1).internode_1(k2).internode, 2)
               pricerange1(1)=rootnode(j).internode_2(k1).internode_1(k2).internode(k3).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_2(k1).internode_1(k2).internode(k3).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_2(k1).internode_1(k2).internode(k3).timerange.min_time;
               timerange1(2)=rootnode(j).internode_2(k1).internode_1(k2).internode(k3).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);  
                           if testrange==1; 
                               find(i)=find(i)+1;
                            [number1, number2, number3, number4, number5, number6]=retusumleaf(rootnode(j).internode_2(k1).internode_1(k2).internode(k3), pricerange2, timerange2);
                                  sum_k=sum_k+number1;
                                  sum_krating1=sum_krating1+number2;
                                  sum_krating2=sum_krating2+number3;
                                  sum_krating3=sum_krating3+number4;
                                  sum_krating4=sum_krating4+number5;
                                  sum_krating5=sum_krating5+number6;
                           end
                           end
                           
                       end 
                     end 
                    end    
                end
                end
                
                
            elseif rootnode(j).n_level==2
                %% 访问internode_1 
%                 tic
               pricerange1(1)=rootnode(j).pricerange.min_price;
               pricerange1(2)=rootnode(j).pricerange.max_price;
               timerange1(1)=rootnode(j).timerange.min_time;
               timerange1(2)=rootnode(j).timerange.max_time;
               testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    find(i)=find(i)+1;
                for k1=1:1:size(rootnode(j).internode_1, 2)
               pricerange1(1)=rootnode(j).internode_1(k1).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_1(k1).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_1(k1).timerange.min_time;
               timerange1(2)=rootnode(j).internode_1(k1).timerange.max_time;
                    testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                    if  testrange==1
                        find(i)=find(i)+1;
                     for k2=1:1:size(rootnode(j).internode_1(k1).internode, 2)
               pricerange1(1)=rootnode(j).internode_1(k1).internode(k2).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode_1(k1).internode(k2).pricerange.max_price;
               timerange1(1)=rootnode(j).internode_1(k1).internode(k2).timerange.min_time;
               timerange1(2)=rootnode(j).internode_1(k1).internode(k2).timerange.max_time; 
                     testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);         
                       if testrange==1;
                           find(i)=find(i)+1;
                                [number1, number2, number3, number4, number5, number6]=retusumleaf(rootnode(j).internode_1(k1).internode(k2), pricerange2, timerange2);
                                  sum_k=sum_k+number1;
                                  sum_krating1=sum_krating1+number2;
                                  sum_krating2=sum_krating2+number3;
                                  sum_krating3=sum_krating3+number4;
                                  sum_krating4=sum_krating4+number5;
                                  sum_krating5=sum_krating5+number6;
                       end 
                     end 
                    end    
                end
                end
                
            elseif rootnode(j).n_level==1;
                %% 访问internode 
               pricerange1(1)=rootnode(j).pricerange.min_price;
               pricerange1(2)=rootnode(j).pricerange.max_price;
               timerange1(1)=rootnode(j).timerange.min_time;
               timerange1(2)=rootnode(j).timerange.max_time;
               testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                if     testrange==0
                    continue;
                else    
                    find(i)=find(i)+1;
                for k1=1:1:size(rootnode(j).internode, 2)
               pricerange1(1)=rootnode(j).internode(k1).pricerange.min_price;
               pricerange1(2)=rootnode(j).internode(k1).pricerange.max_price;
               timerange1(1)=rootnode(j).internode(k1).timerange.min_time;
               timerange1(2)=rootnode(j).internode(k1).timerange.max_time;
                    testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                    if  testrange==1
                        find(i)=find(i)+1;
                                  [number1, number2, number3, number4, number5, number6]=retusumleaf(rootnode(j).internode(k1), pricerange2, timerange2);
                                  sum_k=sum_k+number1;
                                  sum_krating1=sum_krating1+number2;
                                  sum_krating2=sum_krating2+number3;
                                  sum_krating3=sum_krating3+number4;
                                  sum_krating4=sum_krating4+number5;
                                  sum_krating5=sum_krating5+number6;
                    end    
                end
                end
                
            elseif rootnode(j).n_level==0;
                 %% 访问leafnode
               pricerange1(1)=rootnode(j).pricerange.min_price;
               pricerange1(2)=rootnode(j).pricerange.max_price;
               timerange1(1)=rootnode(j).timerange.min_time;
               timerange1(2)=rootnode(j).timerange.max_time;
               testrange=overlap(pricerange1, timerange1, pricerange2, timerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                     find(i)=find(i)+1;
                                  [number1, number2, number3, number4, number5, number6]=retusumleaf(rootnode(j), pricerange2, timerange2);
                                  sum_k=sum_k+number1;
                                  sum_krating1=sum_krating1+number2;
                                  sum_krating2=sum_krating2+number3;
                                  sum_krating3=sum_krating3+number4;
                                  sum_krating4=sum_krating4+number5;
                                  sum_krating5=sum_krating5+number6;              
                end
                
                
            end
            
            
        end             
                    
         end             
    end
    
   toc                  
    end  
     
end



