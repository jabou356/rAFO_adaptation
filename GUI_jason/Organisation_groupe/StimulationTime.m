function [ stimtiming ] = StimulationTime(FF1,POST1,CONS_F)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


n=length(FF1);

for isubject=1:n
    k=0;
    for istride=FF1(isubject):POST1(isubject)-1
        k=k+1;
        
        stimtiming{isubject}(k)=find(CONS_F{isubject}{istride}==min(CONS_F{isubject}{istride}));
        
    end
end



