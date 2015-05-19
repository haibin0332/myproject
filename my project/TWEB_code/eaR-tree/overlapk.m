function  testrange=overlap(pricerange1, pricerange2) %%yuan $$query

if pricerange1(1)>pricerange2(2)||pricerange2(1)>pricerange1(2)
    
    testrange=0;
elseif pricerange1(1)>pricerange2(1)&&pricerange2(2)>pricerange1(2)
    testrange=0;
else 
    
    testrange=1;
    
end

end