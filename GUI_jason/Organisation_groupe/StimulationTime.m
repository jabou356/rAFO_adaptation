function [ stimtiming ] = StimulationTime(FF1,POST1,CONS_F)
%STIMULATIONTIME This function is used to find the timing of the force
%field within each stride
%   INPUT: Vectors indicating the first (FF1) and last (POST1) (+1) stride with Force
%   fields for each subject
%   CONS_F: Signal containing force command

% Determine the number of participants
n=length(FF1);

for isubject=1:n
    k=0;
    for istride=FF1(isubject):POST1(isubject)-1
        k=k+1;
        
        % for each subject and each stride, find the moment with the peak
        % force command
        stimtiming{isubject}(k)=find(abs(CONS_F{isubject}{istride})==max(abs(CONS_F{isubject}{istride})));
        
    end
end



