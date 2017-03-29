function [CONS_F,peakCONS_F,peakCONS_Ftiming,onsetCONS_Ftiming,BASELINE2end,CHAMPend,POSTend,cycleID]=CONS_Fvariablesgeneratortimenorm(Cycle_Table,data)

n=find(isnan(Cycle_Table(1,1,:))==1);
if n>0
    n=n(1)-1;
else
    n=30
end

load('SyncData.mat');
load('CyclesCritiques.mat');

question=menu('Avez-vous déjà un fichier AnalCONS_Ftimenorm?','oui','non');

if question==2

figure(1)
CONS_F.baseline2(1:1000,1:588,1:30)=nan;
CONS_F.CHAMP(1:1000,1:450,1:30)=nan;
CONS_F.POST(1:1000,1:400,1:30)=nan;

peakCONS_F.baseline2(1:588,1:30)=nan;
peakCONS_F.CHAMP(1:450,1:30)=nan;
peakCONS_F.POST(1:400,1:30)=nan;

cycleID.baseline2(1:588,1:30)=nan;
cycleID.CHAMP(1:450,1:30)=nan;
cycleID.POST(1:400,1:30)=nan;

peakCONS_Ftiming.baseline2(1:588,1:30)=nan;
peakCONS_Ftiming.CHAMP(1:450,1:30)=nan;
peakCONS_Ftiming.POST(1:400,1:30)=nan;


onsetCONS_Ftiming.CHAMP(1:450,1:30)=nan;


BASELINE2end(1:30)=nan;
CHAMPend(1:30)=nan;
POSTend(1:30)=nan;

x=1;

elseif question==1
    load('AnalCONS_Ftimenorm.mat')
    temp=find(isnan(BASELINE2end)==1);
    x=temp(1);
end

for i=x:n
    i
    k=0;
    
    for j=1:FF1(i)-1
        k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & Cycle_Table(4,j,i)==0 & SyncTiming(i,j)>500
            
            stop=find(isnan(data(:,j,i))==1);
            if stop>0;
            stop=stop(1)-1;
            
            CONS_F.baseline2(:,k,i)=interp1(1:(stop-SyncTiming(i,j)+1),data(SyncTiming(i,j):stop,j,i),1:(stop-SyncTiming(i,j))/(999):(stop-SyncTiming(i,j)+1));
                
            else 
                              
            CONS_F.baseline2(:,k,i)=nan;            
                        
            end
           
        else
            CONS_F.baseline2(:,k,i)=nan;            
            
        end
        cycleID.baseline2(k,i)=j;
        
        
    end
    BASELINE2end(i)=k;

    
k=0;    
for j=FF1(i):POST1(i)-1
        k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & Cycle_Table(4,j,i)==0 & SyncTiming(i,j)>500
            
            stop=find(isnan(data(:,j,i))==1);
            if stop>0;
            stop=stop(1)-1;
            
            CONS_F.CHAMP(:,k,i)=interp1(1:(stop-SyncTiming(i,j)+1),data(SyncTiming(i,j):stop,j,i),1:(stop-SyncTiming(i,j))/(999):(stop-SyncTiming(i,j)+1));

            
            else 
                              
            CONS_F.CHAMP(:,k,i)=nan;            
            
            end
           
        else
            CONS_F.CHAMP(:,k,i)=nan;            

        end
        cycleID.CHAMP(k,i)=j;
        
        
    end
    CHAMPend(i)=k;


k=0;
if fin(i)-POST1(i)>1;
for j=POST1(i):fin(i)-1
        k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & Cycle_Table(4,j,i)==0 & SyncTiming(i,j)>500
            
            stop=find(isnan(data(:,j,i))==1);
            if stop>0;
            stop=stop(1)-1;
            
            CONS_F.POST(:,k,i)=interp1(1:(stop-SyncTiming(i,j)+1),data(SyncTiming(i,j):stop,j,i),1:(stop-SyncTiming(i,j))/(999):(stop-SyncTiming(i,j)+1));
                            
            else 
                              
            CONS_F.POST(:,k,i)=nan;            

            end
           
        else
            CONS_F.POST(:,k,i)=nan;            

        end
        cycleID.POST(k,i)=j;
           
    end
    POSTend(i)=k;
    
    end
end


clear data GroupData Cycle_Table

for i=x:n
%     clf
%     plot(ENCO.CHAMP(:,:,i),'r')
%     hold on
%     plot(baseline2(:,i),'b','linewidth',2)
%     
%     
%     temp=ginput(1);
%     debut(i)=round(temp(1));
%     temp=ginput(1);
%     fin(i)=round(temp(1));
    
       
    for j=1:BASELINE2end(i)
        
        if isnan(CONS_F.baseline2(1,j,i))==0
            
            
            peakCONS_F.baseline2(j,i)=min(CONS_F.baseline2(:,j,i));
            peakCONS_Ftiming.baseline2(j,i)=find(CONS_F.baseline2(:,j,i)==min(CONS_F.baseline2(:,j,i)),1,'first');
             
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%CHAMP
    for j=1:CHAMPend(i)
        
        if isnan(CONS_F.CHAMP(1,j,i))==0
            
           peakCONS_F.CHAMP(j,i)=min(CONS_F.CHAMP(:,j,i));
            peakCONS_Ftiming.CHAMP(j,i)=find(CONS_F.CHAMP(:,j,i)==min(CONS_F.CHAMP(:,j,i)),1,'first');
           onsetCONS_Ftiming.CHAMP(j,i)=find(CONS_F.CHAMP(:,j,i)<-1,1,'first');
           
           
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%POST
    if fin(i)-POST1(i)>1;
    for j=1:POSTend(i)
        
        if isnan(CONS_F.POST(1,j,i))==0
            
            peakCONS_F.POST(j,i)=min(CONS_F.POST(:,j,i));
            peakCONS_Ftiming.POST(j,i)=find(CONS_F.POST(:,j,i)==min(CONS_F.POST(:,j,i)),1,'first');
       end
        
    end
    end
    
    
end
