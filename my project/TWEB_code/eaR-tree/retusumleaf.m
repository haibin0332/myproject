function [number1, number2, number3, number4, number5, number6]=retusumleaf(leafnode,pricerange2,timerange2)

number1=0;
number2=0;
number3=0;
number4=0;
number5=0;
number6=0;
for i=1:1:size(leafnode.leafnode, 2)
    
if (pricerange2(1)<=leafnode.leafnode(i).price)&&(leafnode.leafnode(i).price<=pricerange2(2))&&(timerange2(1)<=leafnode.leafnode(i).time)&&(leafnode.leafnode(i).time<=timerange2(2))
  number1=number1+leafnode.leafnode(i).sum;
  number2=number2+leafnode.leafnode(i).rating(1);
  number3=number3+leafnode.leafnode(i).rating(2);
  number4=number4+leafnode.leafnode(i).rating(3);
  number5=number5+leafnode.leafnode(i).rating(4);
  number6=number6+leafnode.leafnode(i).rating(5);
  
end
end

end