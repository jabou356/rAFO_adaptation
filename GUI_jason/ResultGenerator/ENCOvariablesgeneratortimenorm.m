function [ENCO,baseline2,cycleID,BASELINE2end,CHAMPend,POSTend,deltaENCO,MaxDorsiError,MaxPlantError,meanABSError,meanSIGNEDError,meanUndershoot,percentUndershoot,meanOvershoot,percentOvershoot,dureeswing,peakDorsi,peakPlant,MaxDorsiErrortiming,MaxPlantErrortiming,peakDorsitiming,peakPlanttiming,CoG, CoGrelatif, normPFC]=ENCOvariablesgeneratortimenorm(Cycle_Table,data)

n=find(isnan(Cycle_Table(1,1,:))==1);
if n>0
    n=n(1)-1;
else
    n=30
end

load('SyncData.mat');
load('CyclesCritiques.mat');

question=menu('Avez-vous déjà un fichier AnalENCO?','oui','non');

if question==2

figure(1)
ENCO.baseline2(1:1000,1:588,1:30)=nan;
ENCO.CHAMP(1:1000,1:450,1:30)=nan;
ENCO.POST(1:1000,1:400,1:30)=nan;

dureeswing.baseline2(1:588,1:30)=nan;
dureeswing.CHAMP(1:450,1:30)=nan;
dureeswing.POST(1:400,1:30)=nan;

deltaENCO.baseline2(1:1000,1:588,1:30)=nan;
deltaENCO.CHAMP(1:1000,1:450,1:30)=nan;
deltaENCO.POST(1:1000,1:400,1:30)=nan;

cycleID.baseline2(1:588,1:30)=nan;
cycleID.CHAMP(1:450,1:30)=nan;
cycleID.POST(1:400,1:30)=nan;

baseline2(1:1000,1:30)=nan;
BASELINE2end(1:30)=nan;
CHAMPend(1:30)=nan;
POSTend(1:30)=nan;

meanUndershoot.baseline2(1:588,1:30)=nan;
meanUndershoot.CHAMP(1:450,1:30)=nan;
meanUndershoot.POST(1:400,1:30)=nan;

CoG.CHAMP(1:450,1:30)=nan;

CoGrelatif.CHAMP(1:450,1:30)=nan;

normPFC.CHAMP(1:450,1:30)=nan;


percentUndershoot.baseline2(1:588,1:30)=nan;
percentUndershoot.CHAMP(1:450,1:30)=nan;
percentUndershoot.POST(1:400,1:30)=nan;

meanOvershoot.baseline2(1:588,1:30)=nan;
meanOvershoot.CHAMP(1:450,1:30)=nan;
meanOvershoot.POST(1:400,1:30)=nan;

percentOvershoot.baseline2(1:588,1:30)=nan;
percentOvershoot.CHAMP(1:450,1:30)=nan;
percentOvershoot.POST(1:400,1:30)=nan;

meanSIGNEDError.baseline2(1:588,1:30)=nan;
meanSIGNEDError.CHAMP(1:450,1:30)=nan;
meanSIGNEDError.POST(1:400,1:30)=nan;

meanABSError.baseline2(1:588,1:30)=nan;
meanABSError.CHAMP(1:450,1:30)=nan;
meanABSError.POST(1:400,1:30)=nan;

MaxPlantError.baseline2(1:588,1:30)=nan;
MaxPlantError.CHAMP(1:450,1:30)=nan;

MaxDorsiError.baseline2(1:588,1:30)=nan;
MaxDorsiError.POST(1:400,1:30)=nan;



x=1;

elseif question==1
    load('AnalENCO.mat')
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
            
            ENCO.baseline2(:,k,i)=interp1(1:(stop-SyncTiming(i,j)+1),data(SyncTiming(i,j):stop,j,i),1:(stop-SyncTiming(i,j))/(999):(stop-SyncTiming(i,j)+1));
                
            dureeswing.baseline2(k,i)=stop-SyncTiming(i,j)+1;
            
            else 
                              
            ENCO.baseline2(:,k,i)=nan;            
            dureeswing.baseline2(k,i)=nan;
            
            end
           
        else
            ENCO.baseline2(:,k,i)=nan;            
            dureeswing.baseline2(k,i)=nan;
        end
        cycleID.baseline2(k,i)=j;
        
        
    end
    BASELINE2end(i)=k;
    
    clear h bad_cycles
    figure(1)
    clf
    subplot(2,1,1)
    for j=1:BASELINE2end(i)
    h(j,1)=plot(ENCO.baseline2(:,j,i));
    hold on
    end
    set(h(j,1),'color','b')
       
    subplot(2,1,2)
    for j=1:BASELINE2end(i)
        s=['plot(j,dureeswing.baseline2(j,i))'];
        h(j,2)=eval(s);
        hold on
        set(h(j,2),'color','b','marker','o');
    end 
    
    xlabel('click in the white space when finished');
    
    bad_cycles=[];
    count=0;
    over=0;
    
    while not(over)
        
        waitforbuttonpress;
        hz=gco;
        [bad,channel]=find(h==hz);
        
        if not(isempty(bad))
            set(h(bad,1),'color','r','linewidth',2);
            ylabel(bad);
            set(h(bad,2),'color','r','marker','o')
                        
           for k=1:2
            uistack(h(bad,k),'top')
           end
            
            
            confirmation=menu('Non valide?','oui','non');
            
            switch confirmation
                case confirmation==1
                    
                    delete(h(bad,:))
                    count=count+1;
                    bad_cycles(count)=bad;
                    
                otherwise
                    
                    set(h(bad,1),'color','b','linewidth',0.5);
                    set(h(bad,2),'color','b','marker','o')
                    
            end %SWITCH
            
        else
            over=1;
        end; %if
    end; %while
        
Cycle_Table(3,cycleID.baseline2(bad_cycles,i),i)=-1;
 ENCO.baseline2(:,bad_cycles,i)=nan;

temp=find(Cycle_Table(3,BASELINE2end(i)-49:BASELINE2end(i),i)==1);
countbase=length(temp);

    baseline2(:,i)=mean(ENCO.baseline2(:,temp+BASELINE2end(i)-50,i),2); %
%    velocitybaseline2(:,i)=mean(Velocity.baseline2(:,temp+BASELINE2end(i)-50,i),2);
    clear temp
    
k=0;    
for j=FF1(i):POST1(i)-1
        k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & Cycle_Table(4,j,i)==0 & SyncTiming(i,j)>500
            
            stop=find(isnan(data(:,j,i))==1);
            if stop>0;
            stop=stop(1)-1;
            
            ENCO.CHAMP(:,k,i)=interp1(1:(stop-SyncTiming(i,j)+1),data(SyncTiming(i,j):stop,j,i),1:(stop-SyncTiming(i,j))/(999):(stop-SyncTiming(i,j)+1));
                
            dureeswing.CHAMP(k,i)=stop-SyncTiming(i,j)+1;
            
            else 
                              
            ENCO.CHAMP(:,k,i)=nan;            
            dureeswing.CHAMP(k,i)=nan;
            
            end
           
        else
            ENCO.CHAMP(:,k,i)=nan;            
            dureeswing.CHAMP(k,i)=nan;
        end
        cycleID.CHAMP(k,i)=j;
        
        
    end
    CHAMPend(i)=k;

  clear h bad_cycles
    figure(1)
    clf
    subplot(2,1,1)
    for j=1:CHAMPend(i)
    h(j,1)=plot(ENCO.CHAMP(:,j,i));
    hold on
    end
    set(h(j,1),'color','b')
       
    subplot(2,1,2)
    for j=1:CHAMPend(i)
        s=['plot(j,dureeswing.CHAMP(j,i))'];
        h(j,2)=eval(s);
        hold on
        set(h(j,2),'color','b','marker','o');
    end 
    
    xlabel('click in the white space when finished');
    
    bad_cycles=[];
    count=0;
    over=0;
    
    while not(over)
        
        waitforbuttonpress;
        hz=gco;
        [bad,channel]=find(h==hz);
        
        if not(isempty(bad))
            set(h(bad,1),'color','r','linewidth',2);
            ylabel(bad);
            set(h(bad,2),'color','r','marker','o')
                        
           for k=1:2
            uistack(h(bad,k),'top')
           end
            
            
            confirmation=menu('Non valide?','oui','non');
            
            switch confirmation
                case confirmation==1
                    
                    delete(h(bad,:))
                    count=count+1;
                    bad_cycles(count)=bad;
                    
                otherwise
                    
                    set(h(bad,1),'color','b','linewidth',0.5);
                    set(h(bad,2),'color','b','marker','o')
                    
            end %SWITCH
            
        else
            over=1;
        end; %if
    end; %while
    
    Cycle_Table(3,cycleID.CHAMP(bad_cycles,i),i)=-1;
    ENCO.CHAMP(:,bad_cycles,i)=nan;
    
k=0;

if fin(i)-POST1(i)>1;
for j=POST1(i):fin(i)-1
        k=k+1;
        if Cycle_Table(3,j,i)==1 & SyncTiming(i,j)<1000 & Cycle_Table(4,j,i)==0 & SyncTiming(i,j)>500
            
            stop=find(isnan(data(:,j,i))==1);
            if stop>0;
            stop=stop(1)-1;
            
            ENCO.POST(:,k,i)=interp1(1:(stop-SyncTiming(i,j)+1),data(SyncTiming(i,j):stop,j,i),1:(stop-SyncTiming(i,j))/(999):(stop-SyncTiming(i,j)+1));
                
            dureeswing.POST(k,i)=stop-SyncTiming(i,j)+1;
            
            else 
                              
            ENCO.POST(:,k,i)=nan;            
            dureeswing.POST(k,i)=nan;
            
            end
           
        else
            ENCO.POST(:,k,i)=nan;            
            dureeswing.POST(k,i)=nan;
        end
        cycleID.POST(k,i)=j;
        
        
    end
    POSTend(i)=k;
    
     clear h bad_cycles
    figure(1)
    clf
    subplot(2,1,1)
    for j=1:POSTend(i)
    h(j,1)=plot(ENCO.POST(:,j,i));
    hold on
    end
    set(h(j,1),'color','b')
       
    subplot(2,1,2)
    for j=1:POSTend(i)
        s=['plot(j,dureeswing.POST(j,i))'];
        h(j,2)=eval(s);
        hold on
        set(h(j,2),'color','b','marker','o');
    end 
    
    xlabel('click in the white space when finished');
    
    bad_cycles=[];
    count=0;
    over=0;
    
    while not(over)
        
        waitforbuttonpress;
        hz=gco;
        [bad,channel]=find(h==hz);
        
        if not(isempty(bad))
            set(h(bad,1),'color','r','linewidth',2);
            ylabel(bad);
            set(h(bad,2),'color','r','marker','o')
                        
           for k=1:2
            uistack(h(bad,k),'top')
           end
            
            
            confirmation=menu('Non valide?','oui','non');
            
            switch confirmation
                case confirmation==1
                    
                    delete(h(bad,:))
                    count=count+1;
                    bad_cycles(count)=bad;
                    
                otherwise
                    
                    set(h(bad,1),'color','b','linewidth',0.5);
                    set(h(bad,2),'color','b','marker','o')
                    
            end %SWITCH
            
        else
            over=1;
        end; %if
    end; %while
    
    Cycle_Table(3,cycleID.POST(bad_cycles,i),i)=-1;
    ENCO.POST(:,bad_cycles,i)=nan;
    end
end


clear data GroupData Cycle_Table
for i=x:n
    
    for j=1:size(ENCO.baseline2(:,:,i),2)
        
        deltaENCO.baseline2(:,j,i)=ENCO.baseline2(:,j,i)-baseline2(:,i);
        
    
    meanABSError.baseline2(j,i)=mean(abs(deltaENCO.baseline2(:,j,i)));
       
    end
    
    
novalid=find(isnan(meanABSError.baseline2(BASELINE2end(i)-49:BASELINE2end(i),i))==1);
if length(novalid)>5
    menu([num2str(i),'>10% baseline no valid'],'ok je vais aller voir ses données')
    temp=find(isnan(meanABSError.baseline2(BASELINE2end(i)-49:BASELINE2end(i),i))==0);
    cyclesbaseline(1:length(temp),i)=temp+BASELINE2end(i)-50;
    baseline2(:,i)=mean(ENCO.baseline2(:,cyclesbaseline(1:length(temp),i),i),2);
else
    temp=sort(meanABSError.baseline2(BASELINE2end(i)-49:BASELINE2end(i),i));
    for k=1:45
    temp2=find(meanABSError.baseline2(BASELINE2end(i)-49:BASELINE2end(i),i)==temp(k));
    cyclesbaseline(k,i)=temp2+BASELINE2end(i)-50;
    end
    baseline2(:,i)=mean(ENCO.baseline2(:,cyclesbaseline(:,i),i),2);
    %velocitybaseline2(:,i)=mean(Velocity.baseline2(:,cyclesbaseline(:,i),i),2);
end

end


for i=x:n
    
    for j=1:size(ENCO.baseline2(:,:,i),2)
        
        deltaENCO.baseline2(:,j,i)=ENCO.baseline2(:,j,i)-baseline2(:,i);
    end
    
    for j=1:size(ENCO.CHAMP(:,:,i),2)
        deltaENCO.CHAMP(:,j,i)=ENCO.CHAMP(:,j,i)-baseline2(:,i);
    end
    
    if fin(i)-POST1(i)>1;
    for j=1:size(ENCO.POST(:,:,i),2)
        deltaENCO.POST(:,j,i)=ENCO.POST(:,j,i)-baseline2(:,i);
    end
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
        
        if isnan(deltaENCO.baseline2(1,j,i))==0
            
            
            MaxDorsiError.baseline2(j,i)=max(deltaENCO.baseline2(1:1000,j,i));
            MaxPlantError.baseline2(j,i)=min(deltaENCO.baseline2(:,j,i));
            peakDorsi.baseline2(j,i)=max(ENCO.baseline2(200:1000,j,i));
            peakPlant.baseline2(j,i)=min(ENCO.baseline2(1:600,j,i));
            
            temp=find(deltaENCO.baseline2(:,j,i)==min(deltaENCO.baseline2(:,j,i)));
            MaxPlantErrortiming.baseline2(j,i)=temp(1);
            
            temp=find(deltaENCO.baseline2(1:1000,j,i)==max(deltaENCO.baseline2(1:1000,j,i)));
            MaxDorisErrortiming.baseline2(j,i)=temp(1);
            
            temp=find(ENCO.baseline2(200:1000,j,i)==max(ENCO.baseline2(200:1000,j,i)));
            peakDorsitiming.baseline2(j,i)=temp(1)+199;
            
            temp=find(ENCO.baseline2(1:600,j,i)==min(ENCO.baseline2(1:600,j,i)));
            peakPlanttiming.baseline2(j,i)=temp(1);
            
            meanABSError.baseline2(j,i)=mean(abs(deltaENCO.baseline2(:,j,i)));
            meanSIGNEDError.baseline2(j,i)=mean(deltaENCO.baseline2(:,j,i));
            
            % Determine what is overshoot AND what is undershoot
            u=0;
            o=0;
            tempUNDER=[];
            tempOVER=[];
            
            for k=1:1000
                if deltaENCO.baseline2(k,j,i)<0;
                    u=u+1;
                    tempUNDER(u)=k;
                    
                elseif deltaENCO.baseline2(k,j,i)>0;
                    o=o+1;
                    tempOVER(o)=k;
                end
                
            end
            
            if length(tempUNDER)>0
                meanUndershoot.baseline2(j,i)=sum(abs(deltaENCO.baseline2(tempUNDER,j,i)))/(1000);
            else
                meanUndershoot.baseline2(j,i)=0;
            end
            
            if length(tempOVER)>0
                meanOvershoot.baseline2(j,i)=sum(abs(deltaENCO.baseline2(tempOVER,j,i)))/(1000);
            else
                meanOvershoot.baseline2(j,i)=0;
            end
            
            percentOvershoot.baseline2(j,i)=meanOvershoot.baseline2(j,i)/meanABSError.baseline2(j,i)*100;
            percentUndershoot.baseline2(j,i)=meanUndershoot.baseline2(j,i)/meanABSError.baseline2(j,i)*100;
            
            
            tempUNDER=[];
            tempOVER=[];
            
            
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%CHAMP
    for j=1:CHAMPend(i)
        
        if isnan(deltaENCO.CHAMP(1,j,i))==0
            
            MaxPlantError.CHAMP(j,i)=min(deltaENCO.CHAMP(:,j,i));
            peakDorsi.CHAMP(j,i)=max(ENCO.CHAMP(200:1000,j,i));
            peakPlant.CHAMP(j,i)=min(ENCO.CHAMP(1:600,j,i));
            
            temp=find(deltaENCO.CHAMP(:,j,i)==min(deltaENCO.CHAMP(:,j,i)));
            MaxPlantErrortiming.CHAMP(j,i)=temp(1);
            
            temp=find(ENCO.CHAMP(200:1000,j,i)==max(ENCO.CHAMP(200:1000,j,i)));
            peakDorsitiming.CHAMP(j,i)=temp(1)+199;
            
            temp=find(ENCO.CHAMP(1:600,j,i)==min(ENCO.CHAMP(1:600,j,i)));
            peakPlanttiming.CHAMP(j,i)=temp(1);
            
            meanABSError.CHAMP(j,i)=mean(abs(deltaENCO.CHAMP(:,j,i)));
            meanSIGNEDError.CHAMP(j,i)=mean(deltaENCO.CHAMP(:,j,i));
            
            % Determine what is overshoot AND what is undershoot
            u=0;
            o=0;
            
            for k=1:1000
                if deltaENCO.CHAMP(k,j,i)<0;
                    u=u+1;
                    tempUNDER(u)=k;
                    
                elseif deltaENCO.CHAMP(k,j,i)>0;
                    o=o+1;
                    tempOVER(o)=k;
                end
                
            end
            
            if length(tempUNDER)>0
                meanUndershoot.CHAMP(j,i)=sum(abs(deltaENCO.CHAMP(tempUNDER,j,i)))/(1000);
            else
                meanUndershoot.CHAMP(j,i)=0;
            end
            
            if length(tempOVER)>0
                meanOvershoot.CHAMP(j,i)=sum(abs(deltaENCO.CHAMP(tempOVER,j,i)))/(1000);
            else
                meanOvershoot.CHAMP(j,i)=0;
            end
            
            percentOvershoot.CHAMP(j,i)=meanOvershoot.CHAMP(j,i)/meanABSError.CHAMP(j,i)*100;
            percentUndershoot.CHAMP(j,i)=meanUndershoot.CHAMP(j,i)/meanABSError.CHAMP(j,i)*100;
            
            tempUNDER=[];
            tempOVER=[];
            
            %Absolute error center of gravity
            clear weight
            for k=1:1000
                weight(k)=abs(deltaENCO.CHAMP(k,j,i))*k;
            end
            
            CoG.CHAMP(j,i)=sum(weight)/sum(abs(deltaENCO.CHAMP(:,j,i)));
            normPFC.CHAMP(j,i)=stimtimingSync(j,i)*1000/dureeswing.CHAMP(j,i);
            CoGrelatif.CHAMP(j,i)=CoG.CHAMP(j,i)-normPFC.CHAMP(j,i);
            
      
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%POST
    if fin(i)-POST1(i)>1;
    for j=1:POSTend(i)
        
        if isnan(deltaENCO.POST(1,j,i))==0
            
            
            MaxDorsiError.POST(j,i)=max(deltaENCO.POST(:,j,i));
            peakDorsi.POST(j,i)=max(ENCO.POST(200:1000,j,i));
            peakPlant.POST(j,i)=min(ENCO.POST(1:600,j,i));
            
            temp=find(deltaENCO.POST(1:1000,j,i)==max(deltaENCO.POST(1:1000,j,i)));
            MaxDorsiErrortiming.POST(j,i)=temp(1);
            
            temp=find(ENCO.POST(200:1000,j,i)==max(ENCO.POST(200:1000,j,i)));
            peakDorsitiming.POST(j,i)=temp(1)+199;
            
            temp=find(ENCO.POST(1:600,j,i)==min(ENCO.POST(1:600,j,i)));
            peakPlanttiming.POST(j,i)=temp(1);
            
            meanABSError.POST(j,i)=mean(abs(deltaENCO.POST(:,j,i)));
            meanSIGNEDError.POST(j,i)=mean(deltaENCO.POST(:,j,i));
            
            u=0;
            o=0;
            
            for k=1:1000
                if deltaENCO.POST(k,j,i)<0;
                    u=u+1;
                    tempUNDER(u)=k;
                    
                elseif deltaENCO.POST(k,j,i)>0;
                    o=o+1;
                    tempOVER(o)=k;
                end
                
            end
            
            if length(tempUNDER)>0
                meanUndershoot.POST(j,i)=sum(abs(deltaENCO.POST(tempUNDER,j,i)))/(1000);
            else
                meanUndershoot.POST(j,i)=0;
            end
            
            if length(tempOVER)>0
                meanOvershoot.POST(j,i)=sum(abs(deltaENCO.POST(tempOVER,j,i)))/(1000);
            else
                meanOvershoot.POST(j,i)=0;
            end
            
            percentOvershoot.POST(j,i)=meanOvershoot.POST(j,i)/meanABSError.POST(j,i)*100;
            percentUndershoot.POST(j,i)=meanUndershoot.POST(j,i)/meanABSError.POST(j,i)*100;
            
            tempUNDER=[];
            tempOVER=[];
            
        else
            
            MaxDorsiError.POST(j,i)=nan;
            meanABSError.POST(j,i)=nan;
            meanSIGNEDError.POST(j,i)=nan;
            meanUndershoot.POST(j,i)=nan;
            meanOvershoot.POST(j,i)=nan;
            percentOvershoot.POST(j,i)=nan;
            percentUndershoot.POST(j,i)=nan;
            peakDorsi.POST(j,i)=nan;
            peakPlant.POST(j,i)=nan;
            MaxDorsiErrortiming.POST(j,i)=nan;
            peakDorsitiming.POST(j,i)=nan;
            peakPlanttiming.POST(j,i)=nan;
        end
        
    end
    end
    
    
end
