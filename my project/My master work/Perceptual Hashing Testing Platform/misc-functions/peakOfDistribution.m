function [peak,center] = peakOfDistribution(x,sampleNumber)
[f,xi,u] = ksdensity(x,'npoints',sampleNumber,'support','positive','kernel','box');% 
peak = max(f);
index = find(f == peak);
center = xi(index);
