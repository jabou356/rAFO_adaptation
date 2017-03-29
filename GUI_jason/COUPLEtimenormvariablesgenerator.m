function [COUPLE, baseline2, cycleID, BASELINE2end, CHAMPend, POSTend,deltaCOUPLE, peakCOUPLE, peakCOUPLEtiming]=COUPLEtimenormvariablesgenerator(Cycle_Table,data)

n=find(isnan(Cycle_Table(1,1,:))==1);
if n>0
    n=n(1)-1;
else
    n=30
end

load('SyncData.mat');
load('CyclesCritiques.mat');

question=menu('Avez-vous déjà un fichier AnalCOUPLEtimenorm?','oui','non');

if question==2

figure(1)
COUPLE.baseline2(1:1000,1:588,1:30)=nan;
COUPLE.CHAMP(1:1000,1:450,1:30)=nan;
COUPLE.POST(1:1000,1:400,1:30)=nan;

deltaCOUPLE.baseline2(1:1000,1:588,1:30)=nan;
deltaCOUPLE.CHAMP(1:1000,1:450,1:30)=nan;
deltaCOUPLE.POST(1:1000,1:400,1:30)=nan;

peakCOUPLE.baseline2(1:588,1:30)=nan;
peakCOUPLE.CHAMP(1:450,1:30)=nan;
peakCOUPLE.POST(1:400,1:30)=nan;

cycleID.baseline2(1:588,1:30)=nan;
cycleID.CHAMP(1:450,1:30)=nan;
cycleID.POST(1:400,1:30)=nan;

peakCOUPLEtiming.baseline2(1:588,1:30)=nan;
peakCOUPLEtiming.CHAMP(1:450,1:30)=nan;
peakCOUPLEtiming.POST(1:400,1:30)=nan;


BASELINE2end(1:30)=nan;
CHAMPend(1:30)=nan;
POSTend(1:30)=nan;

x=1;

elseif question==1
    load('AnalCOUPLEtimenorm.mat')
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
            
            COUPLE.baseline2(:,k,i)=interp1(1:(stop-SyncTiming(i,j)+1),data(SyncTiming(i,j):stop,j,i),1:(stop-SyncTiming(i,j))/(999):(stop-SyncTiming(i,j)+1));
                
            else 
                              
            COUPLE.baseline2(:,k,i)=nan;            
                        
            end
           
        else
            COUPLE.baseline2(:,k,i)=nan;            
            
        end
        cycleID.baseline2(k,i)=j;
        
        
    end
    BASELINE2end(i)=k;
    temp=find(isnan(COUPLE.baseline2(1,:,i)')==0);
    baseline2(:,i)=mean(COUPLE.baseline2(1:1000,temp(end-49:end),i),2);

    
k=0;    
for j=FF1(i):POST1(i)-1
        k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & Cycle_Table(4,j,i)==0 & SyncTiming(i,j)>500
            
            stop=find(isnan(data(:,j,i))==1);
            if stop>0;
            stop=stop(1)-1;
            
            COUPLE.CHAMP(:,k,i)=interp1(1:(stop-SyncTiming(i,j)+1),data(SyncTiming(i,j):stop,j,i),1:(stop-SyncTiming(i,j))/(999):(stop-SyncTiming(i,j)+1));

            
            else 
                              
            COUPLE.CHAMP(:,k,i)=nan;            
            
            end
           
        else
            COUPLE.CHAMP(:,k,i)=nan;            

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
            
            COUPLE.POST(:,k,i)=interp1(1:(stop-SyncTiming(i,j)+1),data(SyncTiming(i,j):stop,j,i),1:(stop-SyncTiming(i,j))/(999):(stop-SyncTiming(i,j)+1));
                            
            else 
                              
            COUPLE.POST(:,k,i)=nan;            

            end
           
        else
            COUPLE.POST(:,k,i)=nan;            

        end
        cycleID.POST(k,i)=j;
           
    end
    POSTend(i)=k;
    
    end
end


clear data GroupData Cycle_Table

for i=x:n
    
    for j=1:size(COUPLE.baseline2(:,:,i),2)
        
        deltaCOUPLE.baseline2(:,j,i)=COUPLE.baseline2(:,j,i)-baseline2(:,i);
    end
    
    for j=1:size(COUPLE.CHAMP(:,:,i),2)
        deltaCOUPLE.CHAMP(:,j,i)=COUPLE.CHAMP(:,j,i)-baseline2(:,i);
    end
    
    for j=1:size(COUPLE.POST(:,:,i),2)
        deltaCOUPLE.POST(:,j,i)=COUPLE.POST(:,j,i)-baseline2(:,i);
    end
end

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
        
        if isnan(deltaCOUPLE.baseline2(1,j,i))==0
            
            
            peakCOUPLE.baseline2(j,i)=min(deltaCOUPLE.baseline2(:,j,i));
            peakCOUPLEtiming.baseline2(j,i)=find(deltaCOUPLE.baseline2(:,j,i)==min(deltaCOUPLE.baseline2(:,j,i)),1,'first');
             
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%CHAMP
    for j=1:CHAMPend(i)
        
        if isnan(deltaCOUPLE.CHAMP(1,j,i))==0
            
           peakCOUPLE.CHAMP(j,i)=min(deltaCOUPLE.CHAMP(:,j,i));
            peakCOUPLEtiming.CHAMP(j,i)=find(deltaCOUPLE.CHAMP(:,j,i)==min(deltaCOUPLE.CHAMP(:,j,i)),1,'first');

           
           
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%POST
    if fin(i)-POST1(i)>1;
    for j=1:POSTend(i)
        
        if isnan(deltaCOUPLE.POST(1,j,i))==0
            
            peakCOUPLE.POST(j,i)=min(deltaCOUPLE.POST(:,j,i));
            peakCOUPLEtiming.POST(j,i)=find(deltaCOUPLE.POST(:,j,i)==min(deltaCOUPLE.POST(:,j,i)),1,'first');
       end
        
    end
    end
    
    
end
