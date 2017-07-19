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

for isubject=x:n
    isubject
    k=0;
    
    for itrial=1:FF1(isubject)-1
        k=k+1;
        if Cycle_Table(3,itrial,isubject)==1 & SyncTiming(isubject,itrial)<1000 & Cycle_Table(4,itrial,isubject)==0 & SyncTiming(isubject,itrial)>500
            
            stop=find(isnan(data(:,itrial,isubject))==1);
            if stop>0;
            stop=stop(1)-1;
            
            ENCO.baseline2(:,k,isubject)=interp1(1:(stop-SyncTiming(isubject,itrial)+1),data(SyncTiming(isubject,itrial):stop,itrial,isubject),1:(stop-SyncTiming(isubject,itrial))/(999):(stop-SyncTiming(isubject,itrial)+1));
                
            dureeswing.baseline2(k,isubject)=stop-SyncTiming(isubject,itrial)+1;
            
            else 
                              
            ENCO.baseline2(:,k,isubject)=nan;            
            dureeswing.baseline2(k,isubject)=nan;
            
            end
           
        else
            ENCO.baseline2(:,k,isubject)=nan;            
            dureeswing.baseline2(k,isubject)=nan;
        end
        cycleID.baseline2(k,isubject)=j;
        
        
    end
    BASELINE2end(isubject)=k;

    duree=dureeswing.baseline2(:,isubject);
    tempCycle_Table=removebad_Superpose(ENCO.baseline2(:,:,isubject),'ENCO',...
        1:find(~isnan(ENCO.baseline2(1,:,isubject)),1,'last'), 'Group', duree);
    
    GroupData.Cycle_Table(3,tempCycleTable==0,isubject)=-1;
    
%     clear h bad_cycles
%     figure(1)
%     clf
%     subplot(2,1,1)
%     for j=1:BASELINE2end(i)
%     h(j,1)=plot(ENCO.baseline2(:,j,i));
%     hold on
%     end
%     set(h(j,1),'color','b')
%        
%     subplot(2,1,2)
%     for j=1:BASELINE2end(i)
%         s=['plot(j,dureeswing.baseline2(j,i))'];
%         h(j,2)=eval(s);
%         hold on
%         set(h(j,2),'color','b','marker','o');
%     end 
%     
%     xlabel('click in the white space when finished');
%     
%     bad_cycles=[];
%     count=0;
%     over=0;
%     
%     while not(over)
%         
%         waitforbuttonpress;
%         hz=gco;
%         [bad,channel]=find(h==hz);
%         
%         if not(isempty(bad))
%             set(h(bad,1),'color','r','linewidth',2);
%             ylabel(bad);
%             set(h(bad,2),'color','r','marker','o')
%                         
%            for k=1:2
%             uistack(h(bad,k),'top')
%            end
%             
%             
%             confirmation=menu('Non valide?','oui','non');
%             
%             switch confirmation
%                 case confirmation==1
%                     
%                     delete(h(bad,:))
%                     count=count+1;
%                     bad_cycles(count)=bad;
%                     
%                 otherwise
%                     
%                     set(h(bad,1),'color','b','linewidth',0.5);
%                     set(h(bad,2),'color','b','marker','o')
%                     
%             end %SWITCH
%             
%         else
%             over=1;
%         end; %if
%     end; %while
%         
% Cycle_Table(3,cycleID.baseline2(bad_cycles,i),i)=-1;
 ENCO.baseline2(:,bad_cycles,isubject)=nan;

temp=find(Cycle_Table(3,BASELINE2end(isubject)-49:BASELINE2end(isubject),isubject)==1);
countbase=length(temp);

    baseline2(:,isubject)=mean(ENCO.baseline2(:,temp+BASELINE2end(isubject)-50,isubject),2); %
%    velocitybaseline2(:,i)=mean(Velocity.baseline2(:,temp+BASELINE2end(i)-50,i),2);
    clear temp
    
k=0;    
for itrial=FF1(isubject):POST1(isubject)-1
        k=k+1;
        if Cycle_Table(3,itrial,isubject)==1 & SyncTiming(isubject,itrial)<1000 & Cycle_Table(4,itrial,isubject)==0 & SyncTiming(isubject,itrial)>500
            
            stop=find(isnan(data(:,itrial,isubject))==1);
            if stop>0;
            stop=stop(1)-1;
            
            ENCO.CHAMP(:,k,isubject)=interp1(1:(stop-SyncTiming(isubject,itrial)+1),data(SyncTiming(isubject,itrial):stop,itrial,isubject),1:(stop-SyncTiming(isubject,itrial))/(999):(stop-SyncTiming(isubject,itrial)+1));
                
            dureeswing.CHAMP(k,isubject)=stop-SyncTiming(isubject,itrial)+1;
            
            else 
                              
            ENCO.CHAMP(:,k,isubject)=nan;            
            dureeswing.CHAMP(k,isubject)=nan;
            
            end
           
        else
            ENCO.CHAMP(:,k,isubject)=nan;            
            dureeswing.CHAMP(k,isubject)=nan;
        end
        cycleID.CHAMP(k,isubject)=j;
        
        
    end
    CHAMPend(isubject)=k;
% 
    duree=dureeswing.CHAMP(:,isubject);
    tempCycle_Table=removebad_Superpose(ENCO.CHAMP(:,:,isubject),'ENCO',...
        1:find(~isnan(ENCO.CHAMP(1,:,isubject)),1,'last'), 'Group', duree);
    
    GroupData.Cycle_Table(3,(tempCycleTable==0)+BASELINE2end(isubject),isubject)=-1;
%   clear h bad_cycles
%     figure(1)
%     clf
%     subplot(2,1,1)
%     for j=1:CHAMPend(i)
%     h(j,1)=plot(ENCO.CHAMP(:,j,i));
%     hold on
%     end
%     set(h(j,1),'color','b')
%        
%     subplot(2,1,2)
%     for j=1:CHAMPend(i)
%         s=['plot(j,dureeswing.CHAMP(j,i))'];
%         h(j,2)=eval(s);
%         hold on
%         set(h(j,2),'color','b','marker','o');
%     end 
%     
%     xlabel('click in the white space when finished');
%     
%     bad_cycles=[];
%     count=0;
%     over=0;
%     
%     while not(over)
%         
%         waitforbuttonpress;
%         hz=gco;
%         [bad,channel]=find(h==hz);
%         
%         if not(isempty(bad))
%             set(h(bad,1),'color','r','linewidth',2);
%             ylabel(bad);
%             set(h(bad,2),'color','r','marker','o')
%                         
%            for k=1:2
%             uistack(h(bad,k),'top')
%            end
%             
%             
%             confirmation=menu('Non valide?','oui','non');
%             
%             switch confirmation
%                 case confirmation==1
%                     
%                     delete(h(bad,:))
%                     count=count+1;
%                     bad_cycles(count)=bad;
%                     
%                 otherwise
%                     
%                     set(h(bad,1),'color','b','linewidth',0.5);
%                     set(h(bad,2),'color','b','marker','o')
%                     
%             end %SWITCH
%             
%         else
%             over=1;
%         end; %if
%     end; %while
%     
%     Cycle_Table(3,cycleID.CHAMP(bad_cycles,i),i)=-1;
    ENCO.CHAMP(:,bad_cycles,isubject)=nan;
    
k=0;

if fin(isubject)-POST1(isubject)>1;
for itrial=POST1(isubject):fin(isubject)-1
        k=k+1;
        if Cycle_Table(3,itrial,isubject)==1 & SyncTiming(isubject,itrial)<1000 & Cycle_Table(4,itrial,isubject)==0 & SyncTiming(isubject,itrial)>500
            
            stop=find(isnan(data(:,itrial,isubject))==1);
            if stop>0;
            stop=stop(1)-1;
            
            ENCO.POST(:,k,isubject)=interp1(1:(stop-SyncTiming(isubject,itrial)+1),data(SyncTiming(isubject,itrial):stop,itrial,isubject),1:(stop-SyncTiming(isubject,itrial))/(999):(stop-SyncTiming(isubject,itrial)+1));
                
            dureeswing.POST(k,isubject)=stop-SyncTiming(isubject,itrial)+1;
            
            else 
                              
            ENCO.POST(:,k,isubject)=nan;            
            dureeswing.POST(k,isubject)=nan;
            
            end
           
        else
            ENCO.POST(:,k,isubject)=nan;            
            dureeswing.POST(k,isubject)=nan;
        end
        cycleID.POST(k,isubject)=j;
        
        
    end
    POSTend(isubject)=k;
    
   
    
%      clear h bad_cycles
%     figure(1)
%     clf
%     subplot(2,1,1)
%     for j=1:POSTend(isubject)
%     h(j,1)=plot(ENCO.POST(:,j,isubject));
%     hold on
%     end
%     set(h(j,1),'color','b')
%        
%     subplot(2,1,2)
%     for j=1:POSTend()
%         s=['plot(j,dureeswing.POST(j,i))'];
%         h(j,2)=eval(s);
%         hold on
%         set(h(j,2),'color','b','marker','o');
%     end 
%     
%     xlabel('click in the white space when finished');
%     
%     bad_cycles=[];
%     count=0;
%     over=0;
%     
%     while not(over)
%         
%         waitforbuttonpress;
%         hz=gco;
%         [bad,channel]=find(h==hz);
%         
%         if not(isempty(bad))
%             set(h(bad,1),'color','r','linewidth',2);
%             ylabel(bad);
%             set(h(bad,2),'color','r','marker','o')
%                         
%            for k=1:2
%             uistack(h(bad,k),'top')
%            end
%             
%             
%             confirmation=menu('Non valide?','oui','non');
%             
%             switch confirmation
%                 case confirmation==1
%                     
%                     delete(h(bad,:))
%                     count=count+1;
%                     bad_cycles(count)=bad;
%                     
%                 otherwise
%                     
%                     set(h(bad,1),'color','b','linewidth',0.5);
%                     set(h(bad,2),'color','b','marker','o')
%                     
%             end %SWITCH
%             
%         else
%             over=1;
%         end; %if
%     end; %while
%     
%     Cycle_Table(3,cycleID.POST(bad_cycles,i),i)=-1;
    ENCO.POST(:,bad_cycles,isubject)=nan;
    end
end


clear data GroupData Cycle_Table
for isubject=x:n
    
    for itrial=1:size(ENCO.baseline2(:,:,isubject),2)
        
        deltaENCO.baseline2(:,itrial,isubject)=ENCO.baseline2(:,itrial,isubject)-baseline2(:,isubject);
        
    
    meanABSError.baseline2(itrial,isubject)=mean(abs(deltaENCO.baseline2(:,itrial,isubject)));
       
    end
    
    
novalid=find(isnan(meanABSError.baseline2(BASELINE2end(isubject)-49:BASELINE2end(isubject),isubject))==1);
if length(novalid)>5
    menu([num2str(isubject),'>10% baseline no valid'],'ok je vais aller voir ses données')
    temp=find(isnan(meanABSError.baseline2(BASELINE2end(isubject)-49:BASELINE2end(isubject),isubject))==0);
    cyclesbaseline(1:length(temp),isubject)=temp+BASELINE2end(isubject)-50;
    baseline2(:,isubject)=mean(ENCO.baseline2(:,cyclesbaseline(1:length(temp),isubject),isubject),2);
else
    temp=sort(meanABSError.baseline2(BASELINE2end(isubject)-49:BASELINE2end(isubject),isubject));
    for k=1:45
    temp2=find(meanABSError.baseline2(BASELINE2end(isubject)-49:BASELINE2end(isubject),isubject)==temp(k));
    cyclesbaseline(k,isubject)=temp2+BASELINE2end(isubject)-50;
    end
    baseline2(:,isubject)=mean(ENCO.baseline2(:,cyclesbaseline(:,isubject),isubject),2);
    %velocitybaseline2(:,i)=mean(Velocity.baseline2(:,cyclesbaseline(:,i),i),2);
end

end


for isubject=x:n
    
    for itrial=1:size(ENCO.baseline2(:,:,isubject),2)
        
        deltaENCO.baseline2(:,itrial,isubject)=ENCO.baseline2(:,itrial,isubject)-baseline2(:,isubject);
    end
    
    for itrial=1:size(ENCO.CHAMP(:,:,isubject),2)
        deltaENCO.CHAMP(:,itrial,isubject)=ENCO.CHAMP(:,itrial,isubject)-baseline2(:,isubject);
    end
    
    if fin(isubject)-POST1(isubject)>1;
    for itrial=1:size(ENCO.POST(:,:,isubject),2)
        deltaENCO.POST(:,itrial,isubject)=ENCO.POST(:,itrial,isubject)-baseline2(:,isubject);
    end
    end
end
 
for isubject=x:n
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
    
       
    for itrial=1:BASELINE2end(isubject)
        
        if isnan(deltaENCO.baseline2(1,itrial,isubject))==0
            
            
            MaxDorsiError.baseline2(itrial,isubject)=max(deltaENCO.baseline2(1:1000,itrial,isubject));
            MaxPlantError.baseline2(itrial,isubject)=min(deltaENCO.baseline2(:,itrial,isubject));
            peakDorsi.baseline2(itrial,isubject)=max(ENCO.baseline2(200:1000,itrial,isubject));
            peakPlant.baseline2(itrial,isubject)=min(ENCO.baseline2(1:600,itrial,isubject));
            
            temp=find(deltaENCO.baseline2(:,itrial,isubject)==min(deltaENCO.baseline2(:,itrial,isubject)));
            MaxPlantErrortiming.baseline2(itrial,isubject)=temp(1);
            
            temp=find(deltaENCO.baseline2(1:1000,itrial,isubject)==max(deltaENCO.baseline2(1:1000,itrial,isubject)));
            MaxDorisErrortiming.baseline2(itrial,isubject)=temp(1);
            
            temp=find(ENCO.baseline2(200:1000,itrial,isubject)==max(ENCO.baseline2(200:1000,itrial,isubject)));
            peakDorsitiming.baseline2(itrial,isubject)=temp(1)+199;
            
            temp=find(ENCO.baseline2(1:600,itrial,isubject)==min(ENCO.baseline2(1:600,itrial,isubject)));
            peakPlanttiming.baseline2(itrial,isubject)=temp(1);
            
            meanABSError.baseline2(itrial,isubject)=mean(abs(deltaENCO.baseline2(:,itrial,isubject)));
            meanSIGNEDError.baseline2(itrial,isubject)=mean(deltaENCO.baseline2(:,itrial,isubject));
            
            % Determine what is overshoot AND what is undershoot
            u=0;
            o=0;
            tempUNDER=[];
            tempOVER=[];
            
            for k=1:1000
                if deltaENCO.baseline2(k,itrial,isubject)<0;
                    u=u+1;
                    tempUNDER(u)=k;
                    
                elseif deltaENCO.baseline2(k,itrial,isubject)>0;
                    o=o+1;
                    tempOVER(o)=k;
                end
                
            end
            
            if length(tempUNDER)>0
                meanUndershoot.baseline2(itrial,isubject)=sum(abs(deltaENCO.baseline2(tempUNDER,itrial,isubject)))/(1000);
            else
                meanUndershoot.baseline2(itrial,isubject)=0;
            end
            
            if length(tempOVER)>0
                meanOvershoot.baseline2(itrial,isubject)=sum(abs(deltaENCO.baseline2(tempOVER,itrial,isubject)))/(1000);
            else
                meanOvershoot.baseline2(itrial,isubject)=0;
            end
            
            percentOvershoot.baseline2(itrial,isubject)=meanOvershoot.baseline2(itrial,isubject)/meanABSError.baseline2(itrial,isubject)*100;
            percentUndershoot.baseline2(itrial,isubject)=meanUndershoot.baseline2(itrial,isubject)/meanABSError.baseline2(itrial,isubject)*100;
            
            
            tempUNDER=[];
            tempOVER=[];
            
            
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%CHAMP
    for itrial=1:CHAMPend(isubject)
        
        if isnan(deltaENCO.CHAMP(1,itrial,isubject))==0
            
            MaxPlantError.CHAMP(itrial,isubject)=min(deltaENCO.CHAMP(:,itrial,isubject));
            peakDorsi.CHAMP(itrial,isubject)=max(ENCO.CHAMP(200:1000,itrial,isubject));
            peakPlant.CHAMP(itrial,isubject)=min(ENCO.CHAMP(1:600,itrial,isubject));
            
            temp=find(deltaENCO.CHAMP(:,itrial,isubject)==min(deltaENCO.CHAMP(:,itrial,isubject)));
            MaxPlantErrortiming.CHAMP(itrial,isubject)=temp(1);
            
            temp=find(ENCO.CHAMP(200:1000,itrial,isubject)==max(ENCO.CHAMP(200:1000,itrial,isubject)));
            peakDorsitiming.CHAMP(itrial,isubject)=temp(1)+199;
            
            temp=find(ENCO.CHAMP(1:600,itrial,isubject)==min(ENCO.CHAMP(1:600,itrial,isubject)));
            peakPlanttiming.CHAMP(itrial,isubject)=temp(1);
            
            meanABSError.CHAMP(itrial,isubject)=mean(abs(deltaENCO.CHAMP(:,itrial,isubject)));
            meanSIGNEDError.CHAMP(itrial,isubject)=mean(deltaENCO.CHAMP(:,itrial,isubject));
            
            % Determine what is overshoot AND what is undershoot
            u=0;
            o=0;
            
            for k=1:1000
                if deltaENCO.CHAMP(k,itrial,isubject)<0
                    u=u+1;
                    tempUNDER(u)=k;
                    
                elseif deltaENCO.CHAMP(k,itrial,isubject)>0
                    o=o+1;
                    tempOVER(o)=k;
                end
                
            end
            
            if length(tempUNDER)>0
                meanUndershoot.CHAMP(itrial,isubject)=sum(abs(deltaENCO.CHAMP(tempUNDER,itrial,isubject)))/(1000);
            else
                meanUndershoot.CHAMP(itrial,isubject)=0;
            end
            
            if length(tempOVER)>0
                meanOvershoot.CHAMP(itrial,isubject)=sum(abs(deltaENCO.CHAMP(tempOVER,itrial,isubject)))/(1000);
            else
                meanOvershoot.CHAMP(itrial,isubject)=0;
            end
            
            percentOvershoot.CHAMP(itrial,isubject)=meanOvershoot.CHAMP(itrial,isubject)/meanABSError.CHAMP(itrial,isubject)*100;
            percentUndershoot.CHAMP(itrial,isubject)=meanUndershoot.CHAMP(itrial,isubject)/meanABSError.CHAMP(itrial,isubject)*100;
            
            tempUNDER=[];
            tempOVER=[];
            
            %Absolute error center of gravity
            clear weight
            for k=1:1000
                weight(k)=abs(deltaENCO.CHAMP(k,itrial,isubject))*k;
            end
            
            CoG.CHAMP(itrial,isubject)=sum(weight)/sum(abs(deltaENCO.CHAMP(:,itrial,isubject)));
            normPFC.CHAMP(itrial,isubject)=stimtimingSync(itrial,isubject)*1000/dureeswing.CHAMP(itrial,isubject);
            CoGrelatif.CHAMP(itrial,isubject)=CoG.CHAMP(itrial,isubject)-normPFC.CHAMP(itrial,isubject);
            
      
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%POST
    if fin(isubject)-POST1(isubject)>1;
    for itrial=1:POSTend(isubject)
        
        if isnan(deltaENCO.POST(1,itrial,isubject))==0
            
            
            MaxDorsiError.POST(itrial,isubject)=max(deltaENCO.POST(:,itrial,isubject));
            peakDorsi.POST(itrial,isubject)=max(ENCO.POST(200:1000,itrial,isubject));
            peakPlant.POST(itrial,isubject)=min(ENCO.POST(1:600,itrial,isubject));
            
            temp=find(deltaENCO.POST(1:1000,itrial,isubject)==max(deltaENCO.POST(1:1000,itrial,isubject)));
            MaxDorsiErrortiming.POST(itrial,isubject)=temp(1);
            
            temp=find(ENCO.POST(200:1000,itrial,isubject)==max(ENCO.POST(200:1000,itrial,isubject)));
            peakDorsitiming.POST(itrial,isubject)=temp(1)+199;
            
            temp=find(ENCO.POST(1:600,itrial,isubject)==min(ENCO.POST(1:600,itrial,isubject)));
            peakPlanttiming.POST(itrial,isubject)=temp(1);
            
            meanABSError.POST(itrial,isubject)=mean(abs(deltaENCO.POST(:,itrial,isubject)));
            meanSIGNEDError.POST(itrial,isubject)=mean(deltaENCO.POST(:,itrial,isubject));
            
            u=0;
            o=0;
            
            for k=1:1000
                if deltaENCO.POST(k,itrial,isubject)<0;
                    u=u+1;
                    tempUNDER(u)=k;
                    
                elseif deltaENCO.POST(k,itrial,isubject)>0;
                    o=o+1;
                    tempOVER(o)=k;
                end
                
            end
            
            if length(tempUNDER)>0
                meanUndershoot.POST(itrial,isubject)=sum(abs(deltaENCO.POST(tempUNDER,itrial,isubject)))/(1000);
            else
                meanUndershoot.POST(itrial,isubject)=0;
            end
            
            if length(tempOVER)>0
                meanOvershoot.POST(itrial,isubject)=sum(abs(deltaENCO.POST(tempOVER,itrial,isubject)))/(1000);
            else
                meanOvershoot.POST(itrial,isubject)=0;
            end
            
            percentOvershoot.POST(itrial,isubject)=meanOvershoot.POST(itrial,isubject)/meanABSError.POST(itrial,isubject)*100;
            percentUndershoot.POST(itrial,isubject)=meanUndershoot.POST(itrial,isubject)/meanABSError.POST(itrial,isubject)*100;
            
            tempUNDER=[];
            tempOVER=[];
            
        else
            
            MaxDorsiError.POST(itrial,isubject)=nan;
            meanABSError.POST(itrial,isubject)=nan;
            meanSIGNEDError.POST(itrial,isubject)=nan;
            meanUndershoot.POST(itrial,isubject)=nan;
            meanOvershoot.POST(itrial,isubject)=nan;
            percentOvershoot.POST(itrial,isubject)=nan;
            percentUndershoot.POST(itrial,isubject)=nan;
            peakDorsi.POST(itrial,isubject)=nan;
            peakPlant.POST(itrial,isubject)=nan;
            MaxDorsiErrortiming.POST(itrial,isubject)=nan;
            peakDorsitiming.POST(itrial,isubject)=nan;
            peakPlanttiming.POST(itrial,isubject)=nan;
        end
        
    end
    end
    
    
end
