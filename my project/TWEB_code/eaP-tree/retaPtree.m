 function [number, mm]=retaPtree(time, pricerange, node, totalleafnode, j) 
 number=[0,0,0,0,0,0];
 mm=0;

%    if node(1).level==4
% mm=mm+1;
%     for  k=1:1:size(node,2)
%         tag=overlap1(pricerange, node(k).pricerange.min_price);
%         if  (time(1) >= node(k).timerange.timebegin) && (tag==1)&&(node(k).timerange.timeend>=time(1) || strcmp(node(k).timerange.timeend,'*'))   
%   mm=mm+1;
%          for k1=1:1:size(node(k).internode3(k1),2)     
%               tag=overlap1(pricerange, node(k).internode3(k1).pricerange.min_price);
%              if  (time(1) >= node(k).internode3(k1).timerange.timebegin) && (tag==1)&&(node(k).internode3(k1).timerange.timeend>=time(1) || strcmp(node(k).internode3(k1).timerange.timeend,'*'))
%  mm=mm+1;
%                for k2=1:1:size(node(k).internode3(k1).internode2,2)
%                    tag=overlap1(pricerange, node(k).internode3(k1).internode2(k2).pricerange.min_price);
%                    if  (time(1) >= node(k).internode3(k1).internode2(k2).timerange.timebegin) && (tag==1)&&(node(k).internode3(k1).internode2(k2).timerange.timeend>=time(1) || strcmp(node(k).internode3(k1).internode2(k2).timerange.timeend,'*'))
%  mm=mm+1;
%                        for k3=1:1:size(node(k).internode3(k1).internode2(k2).internode1,2)
%                            tag=overlap1(pricerange, node(k).internode3(k1).internode2(k2).internode1(k3).pricerange.min_price);
%                          if  (time(1) >= node(k).internode3(k1).internode2(k2).internode1(k3).timerange.timebegin) && (tag==1)&&(node(k).internode3(k1).internode2(k2).internode1(k3).timerange.timeend>=time(1) || strcmp(node(k).internode3(k1).internode2(k2).internode1(k3).timerange.timeend,'*'))
% mm=mm+1;
%                                 for k4=1:1:size(node(k).internode3(k1).internode2(k2).internode1(k3).internode(k4), 2)
%                                     tag=overlap1(pricerange, node(k).internode3(k1).internode2(k2).internode1(k3).internode(k4).pricerange.min_price);
%                                     if (time(1) >=node(k).internode3(k1).internode2(k2).internode1(k3).internode(k4).timerange.timebegin) && (tag==1)&&(node(k).internode3(k1).internode2(k2).internode1(k3).internode(k4).timerange.timeend>=time(1) || strcmp(node(k).internode3(k1).internode2(k2).internode1(k3).internode(k4).timerange.timeend,'*'))
% mm=mm+1;
%                          [number(1), number(2), number(3), number(4), number(5), number(6)]=retusumleaf1(pricerange, node(k).internode3(k1).internode2(k2).internode1(k3).internode(k4), totalleafnode, j);
%                                     end
%                                 end
%                          end
%                        end
%                    end
%                end
%                
%              end
%              
%          end
%         
%         end
%         if  (time(2) >= node(k).timerange.timebegin) && (tag==1)&&(node(k).timerange.timeend>=time(2) || strcmp(node(k).timerange.timeend,'*'))   
%   mm=mm+1;
%          for k1=1:1:size(node(k).internode3(k1),2)     
%               tag=overlap1(pricerange, node(k).internode3(k1).pricerange.min_price);
%              if  (time(2) >= node(k).internode3(k1).timerange.timebegin) && (tag==1)&&(node(k).internode3(k1).timerange.timeend>=time(2) || strcmp(node(k).internode3(k1).timerange.timeend,'*'))
%  mm=mm+1;
%                for k2=1:1:size(node(k).internode3(k1).internode2, 2)
%                    tag=overlap1(pricerange, node(k).internode3(k1).internode2(k2).pricerange.min_price);
%                    if  (time(2) >= node(k).internode3(k1).internode2(k2).timerange.timebegin) && (tag==1)&&(node(k).internode3(k1).internode2(k2).timerange.timeend>=time(2) || strcmp(node(k).internode3(k1).internode2(k2).timerange.timeend,'*'))
%  mm=mm+1;
%                        for k3=1:1:size(node(k).internode3(k1).internode2(k2).internode1,2)
%                            tag=overlap1(pricerange, node(k).internode3(k1).internode2(k2).internode1(k3).pricerange.min_price);
%                          if  (time(2) >= node(k).internode3(k1).internode2(k2).internode1(k3).timerange.timebegin) && (tag==1)&&(node(k).internode3(k1).internode2(k2).internode1(k3).timerange.timeend>=time(2) || strcmp(node(k).internode3(k1).internode2(k2).internode1(k3).timerange.timeend,'*'))
% mm=mm+1;
%                                 for k4=1:1:size(node(k).internode3(k1).internode2(k2).internode1(k3).internode(k4), 2)
%                                     tag=overlap1(pricerange, node(k).internode3(k1).internode2(k2).internode1(k3).internode(k4).pricerange.min_price);
%                                     if (time(2) >=node(k).internode3(k1).internode2(k2).internode1(k3).internode(k4).timerange.timebegin) && (tag==1)&&(node(k).internode3(k1).internode2(k2).internode1(k3).internode(k4).timerange.timeend>=time(2) || strcmp(node(k).internode3(k1).internode2(k2).internode1(k3).internode(k4).timerange.timeend,'*'))
% mm=mm+1;
%                         [number(1), number(2), number(3), number(4), number(5), number(6)]=retusumleaf1(pricerange, node(k).internode3(k1).internode2(k2).internode1(k3).internode(k4), totalleafnode, j);
%                                     end
%                                 end
%                          end
%                        end
%                    end
%                end
%                
%              end
%              
%          end
%         
%        end 
%     end
%    end
 
   if node(1).level==3
       mm=mm+1;
    for  k=1:1: size(node,2)
        tag=overlap1(pricerange, node(k).pricerange.min_price);
        if  (time(1) >= node(k).timerange.timebegin) && (tag==1)&&(node(k).timerange.timeend>=time(1) || strcmp(node(k).timerange.timeend,'*'))  
            mm=mm+1;
         for k1=1:1:size(node(k).internode2,2)     
              tag=overlap1(pricerange, node(k).internode2(k1).pricerange.min_price);
             if  (time(1) >= node(k).internode2(k1).timerange.timebegin) && (tag==1)&&(node(k).internode2(k1).timerange.timeend>=time(1) || strcmp(node(k).internode2(k1).timerange.timeend,'*'))
               mm=mm+1;  
               for k2=1:1:size(node(k).internode2(k1).internode1,2)
                   tag=overlap1(pricerange, node(k).internode2(k1).internode1(k2).pricerange.min_price);
                   if  (time(1) >= node(k).internode2(k1).internode1(k2).timerange.timebegin) && (tag==1)&&(node(k).internode2(k1).internode1(k2).timerange.timeend>=time(1) || strcmp(node(k).internode2(k1).internode1(k2).timerange.timeend,'*'))
                       mm=mm+1;
                       for k3=1:1:size(node(k).internode2(k1).internode1(k2).internode,2)
                           tag=overlap1(pricerange, node(k).internode2(k1).internode1(k2).internode(k3).pricerange.min_price);
                         if  (time(1) >= node(k).internode2(k1).internode1(k2).internode(k3).timerange.timebegin) && (tag==1)&&(node(k).internode2(k1).internode1(k2).internode(k3).timerange.timeend>=time(1) || strcmp(node(k).internode2(k1).internode1(k2).internode(k3).timerange.timeend,'*'))
                             mm=mm+1;
%[number(1), number(2), number(3), number(4), number(5), number(6)]=retusumleaf1(pricerange, node(k).internode2(k1).internode1(k2).internode(k3), totalleafnode, j);
                         end
                       end
                   end
               end
               
             end
             
         end
        
        end
        if  (time(2) >= node(k).timerange.timebegin) && (tag==1)&&(node(k).timerange.timeend>=time(2) || strcmp(node(k).timerange.timeend,'*'))  
            mm=mm+1;
         for k1=1:1:size(node(k).internode2,2)     
              tag=overlap1(pricerange, node(k).internode2(k1).pricerange.min_price);
             if  (time(2) >= node(k).internode2(k1).timerange.timebegin) && (tag==1)&&(node(k).internode2(k1).timerange.timeend>=time(2) || strcmp(node(k).internode2(k1).timerange.timeend,'*'))
               mm=mm+1;  
               for k2=1:1:size(node(k).internode2(k1).internode1,2)
                   tag=overlap1(pricerange, node(k).internode2(k1).internode1(k2).pricerange.min_price);
                   if  (time(2) >= node(k).internode2(k1).internode1(k2).timerange.timebegin) && (tag==1)&&(node(k).internode2(k1).internode1(k2).timerange.timeend>=time(2) || strcmp(node(k).internode2(k1).internode1(k2).timerange.timeend,'*'))
                       mm=mm+1;
                       for k3=1:1:size(node(k).internode2(k1).internode1(k2).internode,2)
                           tag=overlap1(pricerange, node(k).internode2(k1).internode1(k2).internode(k3).pricerange.min_price);
                         if  (time(2) >= node(k).internode2(k1).internode1(k2).internode(k3).timerange.timebegin) && (tag==1)&&(node(k).internode2(k1).internode1(k2).internode(k3).timerange.timeend>=time(2) || strcmp(node(k).internode2(k1).internode1(k2).internode(k3).timerange.timeend,'*'))
                             mm=mm+1;
%[number(1), number(2), number(3), number(4), number(5), number(6)]=retusumleaf1(pricerange, node(k).internode2(k1).internode1(k2).internode(k3), totalleafnode, j);
                         end
                       end
                   end
               end
               
             end
             
         end
        
        end
    end
   end


 
 if node(1).level==2
     mm=mm+1;
    for  k=1:1:size(node,2)
        tag=overlap1(pricerange, node(k).pricerange.min_price);  %%记住 这里不能使用pricerange
        if  (time(1) >= node(k).timerange.timebegin) && (tag==1)&&(node(k).timerange.timeend>=time(1) || strcmp(node(k).timerange.timeend,'*'))
            mm=mm+1;
            for k1=1:1:size(node(k).internode1,2)
                 tag=overlap1(pricerange, node(k).internode1(k1).pricerange.min_price);
              if  (time(1)>= node(k).internode1(k1).timerange.timebegin)&& (tag==1)&&(node(k).internode1(k1).timerange.timeend>=time(1) || strcmp(node(k).internode1(k1).timerange.timeend,'*'))
                 mm=mm+1;
               for k2=1:1:size(node(k).internode1(k1).internode,2)
                   tag=overlap1(pricerange, node(k).internode1(k1).internode(k2).pricerange.min_price);
                   if  (time(1) >= node(k).internode1(k1).internode(k2).timerange.timebegin) && (tag==1)&&(node(k).internode1(k1).internode(k2).timerange.timeend>=time(1) || strcmp(node(k).internode1(k1).internode(k2).timerange.timeend,'*'))
                       mm=mm+1;
%[number(1), number(2), number(3), number(4), number(5), number(6)]=retusumleaf1(pricerange, node(k).internode1(k1).internode(k2), totalleafnode, j);
                   end
               end
              end
            end 
        end
        if  (time(2)>= node(k).timerange.timebegin) && (tag==1)&&(node(k).timerange.timeend>=time(2) || strcmp(node(k).timerange.timeend,'*'))
            mm=mm+1;
            for k1=1:1:size(node(k).internode1,2)
                tag=overlap1(pricerange, node(k).internode1(k1).pricerange.min_price);
              if  (time(2)>= node(k).internode1(k1).timerange.timebegin)&& (tag==1)&&(node(k).internode1(k1).timerange.timeend>=time(2) || strcmp(node(k).internode1(k1).timerange.timeend,'*'))
                 mm=mm+1;
               for k2=1:1:size(node(k).internode1(k1).internode,2)
                   tag=overlap1(pricerange, node(k).internode1(k1).internode(k2).pricerange.min_price);
                   if  (time(2)>= node(k).internode1(k1).internode(k2).timerange.timebegin) && (tag==1)&&(node(k).internode1(k1).internode(k2).timerange.timeend>=time(2) || strcmp(node(k).internode1(k1).internode(k2).timerange.timeend,'*'))
                       mm=mm+1;
%[number(1), number(2), number(3), number(4), number(5), number(6)]=retusumleaf1(pricerange, node(k).internode1(k1).internode(k2), totalleafnode, j);
                   end
               end
              end
            end
        end
    end
 end  
if node(1).level==1
    mm=mm+1;
    for  k=1:1:size(node,2)
    tag=overlap1(pricerange, node(k).pricerange.min_price);
        if  (time(1) >= node(k).timerange.timebegin)&& (tag==1)&&(node(k).timerange.timeend>=time(1) || strcmp(node(k).timerange.timeend,'*'))
        %%%入口      
        mm=mm+1;   
         for k1=1:1:size(node(k).internode,2)     
              tag=overlap1(pricerange, node(k).internode(k1).pricerange.min_price);
             if  (time(1) >= node(k).internode(k1).timerange.timebegin) && (tag==1)&&(node(k).internode(k1).timerange.timeend>=time(1) || strcmp(node(k).internode(k1).timerange.timeend,'*'))
             mm=mm+1;      
  %             [number(1), number(2), number(3), number(4), number(5), number(6)]=retusumleaf1(pricerange, node(k).internode(k1), totalleafnode, j);
             end     
         end
        
        end
        if  (time(2) >= node(k).timerange.timebegin)&& (tag==1)&&(node(k).timerange.timeend>=time(2) || strcmp(node(k).timerange.timeend,'*'))
        %%%入口      
        mm=mm+1;   
         for k1=1:1:size(node(k).internode,2)     
              tag=overlap1(pricerange, node(k).internode(k1).pricerange.min_price);
             if  (time(2) >= node(k).internode(k1).timerange.timebegin) && (tag==1)&&(node(k).internode(k1).timerange.timeend>=time(2) || strcmp(node(k).internode(k1).timerange.timeend,'*'))
             mm=mm+1;      
    %           [number(1), number(2), number(3), number(4), number(5), number(6)]=retusumleaf1(pricerange, node(k).internode(k1), totalleafnode, j);
             end     
         end
        
        end
    end
end
 
 end

   

