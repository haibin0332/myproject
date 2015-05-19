function  [internode1_1, internode1_2]=spiltinternode(internode1 ,internode2)


    if size(internode2,2)==1
    
    tempinternode=internode1;
    i=size(internode1, 2);
    tempinternode(i+1)=internode2;
 

q=1;

for k=1:1:size(tempinternode,2)
    if strcmp(tempinternode(k).timerange.timeend,'*')
        internode1_1(q)=tempinternode(k); %#ok<AGROW>
        q=q+1;  
         
    end          
end
    internode1_2=internode1;



    elseif size(internode2,2)==2
        
    tempinternode=internode1;
    i=size(internode1, 2);
    tempinternode(i+1)=internode2(1);
    tempinternode(i+2)=internode2(2);
    
q=1;


for k=1:1:size(tempinternode,2)
    if strcmp(tempinternode(k).timerange.timeend,'*')
        internode1_1(q)=tempinternode(k); %#ok<AGROW>
        q=q+1;  
    end         
end

      internode1_2=internode1;
 
    end
    
end