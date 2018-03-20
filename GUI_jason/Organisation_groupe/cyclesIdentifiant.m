

function [FF1, POST1, fin, RFLX, stimtiming]=cyclesIdentifiant(Cycle_Table,CONS_F)

    
   n=length(Cycle_Table);
   
    for isubject=1:n
        FF=find(Cycle_Table{isubject}(5,:)==1);
           
        fin(isubject)=size(Cycle_Table{isubject},2);
            
      
        if length(FF)>1
            
            FF1(isubject)=FF(1);
            POST1(isubject)=FF(end)+1;
            
        else
            FF1(isubject)=nan;
            POST1(isubject)=nan;
        end
        
        temp=find(Cycle_Table{isubject}(4,:)==1);
    
    if temp>0
        RFLX{isubject}=temp;
    else
        RFLX{isubject}=nan;
    end
    
    
    end
    
    if exist('CONS_F')
        stimtiming=StimulationTime(FF1, POST1, CONS_F);
    else
        stimtiming=nan;
    end

        
    
    
