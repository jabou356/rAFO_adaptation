

function [FF1, POST1, fin, RFLX, stimtiming]=cyclesIdentifiant(Cycle_Table,CONS_F)

    
    n=find(isnan(Cycle_Table(1,1,:))==1);
    if n>0
        n=n(1)-1;
    else
        n=30
    end
    
    for i=1:n
        FFbegin=find(Cycle_Table(5,:,i)==1);
        temp=find(isnan(Cycle_Table(5,:,i))==1);
        
        if temp>0
            
            fin(i)=temp(1)-1;
            
        else
            
            fin(i)=size(Cycle_Table(5,:,i),2);
            
        end
        
        temp=find(FFbegin>1);
        
        if temp>0
            
            FF1(i)=FFbegin(1);
            POST1(i)=FFbegin(end)+1;
            
        else
            FF1(i)=nan;
            POST1(i)=nan;
        end
        
        temp=find(Cycle_Table(:,4)==1);
    
    if temp>0
        RFLX(i)=temp;
    else
        RFLX(i)=nan;
    end
    
    
    end
    
    if exist('CONS_F')
        stimtiming=StimulationTime(FF1, POST1, CONS_F);
    else
        stimtiming=nan
    end
        
    
    
