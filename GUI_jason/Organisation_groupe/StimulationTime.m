function [ stimtiming ] = StimulationTime(FF1,POST1,CONS_F)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


n=length(FF1);

stimtiming(1:397,1:30)=nan;

for i=1:n
    k=0;
    for j=FF1(i):POST1(i)-1
        k=k+1;
        
        stimtiming(k,i)=find(CONS_F(:,j,i)==min(CONS_F(:,j,i)));
        
    end
end



