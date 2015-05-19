conna=database('haibin0332','','');

setdbprefs ('DataReturnFormat','structure'); %%//?????
% 
%cursorC=exec(conna,'select itemtitle, time, itemprice, rating1, rating2, rating3, rating4, rating5, cid from seller1 order by time ASC'); %%//????
cursorC=exec(conna,'select itemtitle, time, itemprice, rating1, rating2, rating3, rating4, rating5, cid from syndata_s1_ram1'); %%//????
%cursorC=exec(conna,'select * from testdata2 order by time ASC'); %%//????
cursorC=fetch(cursorC);
CC=cursorC.Data;
tic
[rootnode, totalleafnode]=buildaPtree(CC);
toc

load('caproot_s2.mat')
load('capleaf_s2.mat')
cursorC1=exec(conna,'select begintime, endtime, lowprice, highprice, subcategory from sellerb'); %%//????
%cursorC1=exec(conna,'select begintime, endtime, lowprice, highprice, subcategory from enquiry8'); %%//????
cursorC1=fetch(cursorC1);
CC1=cursorC1.Data;

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
    subcategory=CC1.subcategory(i);
    category=cell2mat(subcategory);
    if isempty(category) %%%如果要全搜索
    find(i)=0;
 tic
    
for  j=1:1:size(rootnode, 2)                  
       if rootnode(j).n_level==5
               pricerange1(1)=rootnode(j).minprice;
               pricerange1(2)=rootnode(j).maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, rootnode(j).internode4, totalleafnode, j);
               find(i)=find(i)+mm;
                end
       elseif rootnode(j).n_level==4
               pricerange1(1)=rootnode(j).minprice;
               pricerange1(2)=rootnode(j).maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, rootnode(j).internode3, totalleafnode, j);
                find(i)=find(i)+mm;
                end
        elseif rootnode(j).n_level==3
               pricerange1(1)=rootnode(j).minprice;
               pricerange1(2)=rootnode(j).maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, rootnode(j).internode2, totalleafnode, j);
               find(i)=find(i)+mm;
                end
        elseif rootnode(j).n_level==2
               pricerange1(1)=rootnode(j).minprice;
               pricerange1(2)=rootnode(j).maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, rootnode(j).internode1, totalleafnode, j);
               find(i)=find(i)+mm;
                end
        elseif rootnode(j).n_level==1
               pricerange1(1)=rootnode(j).minprice;
               pricerange1(2)=rootnode(j).maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else       
                    find(i)=find(i)+1;
                    for k1=1:1:size(rootnode(j).internode, 2)
                         tag=overlap1(pricerange2, rootnode(j).internode(k1).pricerange.min_price);
                    if  (timerange2(1) >= rootnode(j).internode(k1).timerange.timebegin) && (tag==1)&&(rootnode(j).internode(k1).timerange.timeend>=timerange2(1) || strcmp(rootnode(j).internode(k1).timerange.timeend,'*'))
                        find(i)=find(i)+1;
             %   [sum_k, sum_krating1, sum_krating2, sum_krating3, sum_krating4, sum_krating5]=retusumleaf1(pricerange2, rootnode(j).internode, totalleafnode, j); 
                    end
                    if  (timerange2(2) >= rootnode(j).internode(k1).timerange.timebegin) && (tag==1)&&(rootnode(j).internode(k1).timerange.timeend>=timerange2(2) || strcmp(rootnode(j).internode(k1).timerange.timeend,'*'))
                        find(i)=find(i)+1;
               % [sum_k, sum_krating1, sum_krating2, sum_krating3, sum_krating4, sum_krating5]=retusumleaf1(pricerange2, rootnode(j).internode, totalleafnode, j); 
                    end
                    end
                end 
        end
    %end                   
        %end

end
toc                                        
    else 
    clength=length(category);
    find(i)=0;
 tic
    
for  j=1:1:size(rootnode, 2)
        if clength>8  %%最后一层
        compcate=cell2mat(rootnode(j).ctree);
        %rlength=length(compcate);
        %rcate=compcate(1:clength); 
    if str2double(compcate)==str2double(category)                    
       if rootnode(j).n_level==5
               pricerange1(1)=rootnode(j).minprice;
               pricerange1(2)=rootnode(j).maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, rootnode(j).internode4, totalleafnode, j);
               find(i)=find(i)+mm;
                end
       elseif rootnode(j).n_level==4
               pricerange1(1)=rootnode(j).minprice;
               pricerange1(2)=rootnode(j).maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, rootnode(j).internode3, totalleafnode, j);
                find(i)=find(i)+mm;
                end
        elseif rootnode(j).n_level==3
               pricerange1(1)=rootnode(j).minprice;
               pricerange1(2)=rootnode(j).maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, rootnode(j).internode2, totalleafnode, j);
             find(i)=find(i)+mm;
                end
        elseif rootnode(j).n_level==2
               pricerange1(1)=rootnode(j).minprice;
               pricerange1(2)=rootnode(j).maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, rootnode(j).internode1, totalleafnode, j);
               find(i)=find(i)+mm;
                end
        elseif rootnode(j).n_level==1
               pricerange1(1)=rootnode(j).minprice;
               pricerange1(2)=rootnode(j).maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
                    find(i)=find(i)+1;
                    for k1=1:1:size(rootnode(j).internode, 2)
                         tag=overlap1(pricerange2, rootnode(j).internode(k1).pricerange.min_price);
                    if  (timerange2(1) >= rootnode(j).internode(k1).timerange.timebegin) && (tag==1)&&(rootnode(j).internode(k1).timerange.timeend>=timerange2(1) || strcmp(rootnode(j).internode(k1).timerange.timeend,'*'))
                        find(i)=find(i)+1;
              %  [sum_k, sum_krating1, sum_krating2, sum_krating3, sum_krating4, sum_krating5]=retusumleaf1(pricerange2, rootnode(j).internode, totalleafnode, j); 
                    end
                    if  (timerange2(2) >= rootnode(j).internode(k1).timerange.timebegin) && (tag==1)&&(rootnode(j).internode(k1).timerange.timeend>=timerange2(2) || strcmp(rootnode(j).internode(k1).timerange.timeend,'*'))
                        find(i)=find(i)+1;
              %  [sum_k, sum_krating1, sum_krating2, sum_krating3, sum_krating4, sum_krating5]=retusumleaf1(pricerange2, rootnode(j).internode, totalleafnode, j); 
                    end
                    end
               end 
        end
    end
              
        else
         compcate=cell2mat(rootnode(j).ctree);
        rcate=compcate(1:clength); 
    if strcmp(rcate, category)==1                     
       if rootnode(j).n_level==5
               pricerange1(1)=rootnode(j).minprice;
               pricerange1(2)=rootnode(j).maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, rootnode(j).internode4, totalleafnode, j);
               find(i)=find(i)+mm;
                end
       elseif rootnode(j).n_level==4
               pricerange1(1)=rootnode(j).minprice;
               pricerange1(2)=rootnode(j).maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, rootnode(j).internode3, totalleafnode, j);
                find(i)=find(i)+mm;
                end
        elseif rootnode(j).n_level==3
               pricerange1(1)=rootnode(j).minprice;
               pricerange1(2)=rootnode(j).maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, rootnode(j).internode2, totalleafnode, j);
               find(i)=find(i)+mm;
                end
        elseif rootnode(j).n_level==2
               pricerange1(1)=rootnode(j).minprice;
               pricerange1(2)=rootnode(j).maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else
               [number1, mm]=retaPtree(timerange2, pricerange2, rootnode(j).internode1, totalleafnode, j);
               find(i)=find(i)+mm;
                end
        elseif rootnode(j).n_level==1
               pricerange1(1)=rootnode(j).minprice;
               pricerange1(2)=rootnode(j).maxprice;
               testrange=overlap(pricerange1, pricerange2);
                if     testrange==0
                    continue;  %#ok<NOPTS>
                else       
                    find(i)=find(i)+1;
                    for k1=1:1:size(rootnode(j).internode, 2)
                         tag=overlap1(pricerange2, rootnode(j).internode(k1).pricerange.min_price);
                    if  (timerange2(1) >= rootnode(j).internode(k1).timerange.timebegin) && (tag==1)&&(rootnode(j).internode(k1).timerange.timeend>=timerange2(1) || strcmp(rootnode(j).internode(k1).timerange.timeend,'*'))
                        find(i)=find(i)+1;
             %   [sum_k, sum_krating1, sum_krating2, sum_krating3, sum_krating4, sum_krating5]=retusumleaf1(pricerange2, rootnode(j).internode, totalleafnode, j); 
                    end
                    if  (timerange2(2) >= rootnode(j).internode(k1).timerange.timebegin) && (tag==1)&&(rootnode(j).internode(k1).timerange.timeend>=timerange2(2) || strcmp(rootnode(j).internode(k1).timerange.timeend,'*'))
                        find(i)=find(i)+1;
               % [sum_k, sum_krating1, sum_krating2, sum_krating3, sum_krating4, sum_krating5]=retusumleaf1(pricerange2, rootnode(j).internode, totalleafnode, j); 
                    end
                    end
                end 
        end
    end                   
        end

end
toc                              
    end  
       
end
