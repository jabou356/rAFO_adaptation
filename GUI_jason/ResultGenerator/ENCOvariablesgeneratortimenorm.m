function [ENCO,baseline2,cycleID,BASELINE2end,CHAMPend,POSTend,deltaENCO,MaxDorsiError,MaxPlantError,meanABSError,meanSIGNEDError,meanUndershoot,percentUndershoot,meanOvershoot,percentOvershoot,dureeswing,peakDorsi,peakPlant,MaxPlantErrortiming,peakDorsitiming,peakPlanttiming,CoG, CoGrelatif, normPFC]=ENCOvariablesgeneratortimenorm(Cycle_Table,data)

n=length(Cycle_Table);

load('SyncData.mat');
load('CyclesCritiques.mat');

question=menu('Avez-vous déjà un fichier AnalENCO?','oui','non');

if question==2

figure(1)

x=1;

elseif question==1
    load('AnalENCO.mat')
    x=length(BASELINE2end);
end

for isubject=x:n
    isubject
    k=0;
    
    for istride=1:FF1(isubject)-1
        k=k+1;
        if Cycle_Table{isubject}(3,istride)==1 && Cycle_Table{isubject}(4,istride)==0 ...
            && SyncTiming{isubject}(istride)<1000 && SyncTiming{isubject}(istride)>500
            
            x = 1 : length(data{isubject}{istride})-SyncTiming{isubject}(istride)+1;    
            y = data{isubject}{istride}(SyncTiming{isubject}(istride):end);
            
            ENCO.baseline2{isubject}(:,k)=interp1(x,y,1:(length(x)-1)/(999):length(x));             
            dureeswing.baseline2{isubject}(k)=length(x);
            
            else 
                              
            ENCO.baseline2{isubject}(:,k)=nan;             
            dureeswing.baseline2{isubject}(k)=nan;
            
            end
          
        end
        cycleID.baseline2{isubject}(k)=istride;
              
    
    BASELINE2end(isubject)=k;

    %% remove bad baseline ENCO
    duree=dureeswing.baseline2{isubject};   
   tovalidate.Table=ENCO.baseline2{isubject};
    
    bad_cycles=removebad_Superpose1(tovalidate,{'ENCO'},...
        1:size(ENCO.baseline2{isubject},2), 'Group', 'flagDuree', duree);
    
    Cycle_Table{isubject}(3,bad_cycles)=-1;
   
 ENCO.baseline2{isubject}(:,bad_cycles)=nan;

baseline2(:,isubject)=nanmean(ENCO.baseline2{isubject}(:,BASELINE2end(isubject)-49:BASELINE2end(isubject)),2); %


%% 
k=0;    
for istride=FF1(isubject):POST1(isubject)-1
        k=k+1;
        if Cycle_Table{isubject}(3,istride)==1 && Cycle_Table{isubject}(4,istride)==0 ...
            && SyncTiming{isubject}(istride)<1000 && SyncTiming{isubject}(istride)>500
            
            x = 1 : length(data{isubject}{istride})-SyncTiming{isubject}(istride)+1;    
            y = data{isubject}{istride}(SyncTiming{isubject}(istride):end);
            
            ENCO.CHAMP{isubject}(:,k)=interp1(x,y,1:(length(x)-1)/(999):length(x));             
            dureeswing.CHAMP{isubject}(k)=length(x);
            
            else 
                              
            ENCO.CHAMP{isubject}(:,k)=nan;             
            dureeswing.CHAMP{isubject}(k)=nan;
            
        end
                cycleID.CHAMP{isubject}(k)=istride;
        
        
    end
    CHAMPend(isubject)=k;
    
    %% Validate CHAMP cycles
    duree=dureeswing.CHAMP{isubject};   
   tovalidate.Table=ENCO.CHAMP{isubject};
    
    bad_cycles=removebad_Superpose1(tovalidate,{'ENCO'},...
        1:size(ENCO.CHAMP{isubject},2), 'Group', 'flagDuree', duree);
    
    Cycle_Table{isubject}(3, cycleID.CHAMP{isubject}(bad_cycles))=-1;
   
 ENCO.CHAMP{isubject}(:,bad_cycles)=nan;

 %% POST
k=0;

if fin(isubject)-POST1(isubject)>1;
for istride=POST1(isubject):fin(isubject)-1
    k=k+1;
        if Cycle_Table{isubject}(3,istride)==1 && Cycle_Table{isubject}(4,istride)==0 ...
            && SyncTiming{isubject}(istride)<1000 && SyncTiming{isubject}(istride)>500
            
            x = 1 : length(data{isubject}{istride})-SyncTiming{isubject}(istride)+1;    
            y = data{isubject}{istride}(SyncTiming{isubject}(istride):end);
            
            ENCO.POST{isubject}(:,k)=interp1(x,y,1:(length(x)-1)/(999):length(x));             
            dureeswing.POST{isubject}(k)=length(x);
            
            else 
                              
            ENCO.POST{isubject}(:,k)=nan;             
            dureeswing.POST{isubject}(k)=nan;
            
        end
                cycleID.POST{isubject}(k)=istride;
        
    %%  
        
    end
    POSTend(isubject)=k;
    
    %% Validate POST cycles
    duree=dureeswing.POST{isubject};   
    tovalidate.Table=ENCO.POST{isubject};
    
    bad_cycles=removebad_Superpose1(tovalidate,{'ENCO'},...
        1:size(ENCO.POST{isubject},2), 'Group', 'flagDuree', duree);
    
    Cycle_Table{isubject}(3, cycleID.POST{isubject}(bad_cycles))=-1;
   
    ENCO.POST{isubject}(:,bad_cycles)=nan;
    
    end
end


clear data GroupData Cycle_Table
for isubject=x:n
    
    for istride=1:size(ENCO.baseline2{isubject},2)
        
        deltaENCO.baseline2{isubject}(:,istride)=ENCO.baseline2{isubject}(:,istride)-baseline2(:,isubject);
        
    
    meanABSError.baseline2{isubject}(istride)=mean(abs(deltaENCO.baseline2{isubject}(:,istride)));
       
    end
    
    
novalid=find(isnan(meanABSError.baseline2{isubject}(BASELINE2end(isubject)-49:BASELINE2end(isubject))));
if length(novalid)>5
    menu([num2str(isubject),'>10% baseline no valid'],'ok je vais aller voir ses données')   
    cyclesbaseline{isubject}=find(~isnan(meanABSError.baseline2{isubject}(BASELINE2end(isubject)-49:BASELINE2end(isubject))));
    cyclesbaseline{isubject}+BASELINE2end(isubject)-50;
    baseline2(:,isubject)=mean(ENCO.baseline2{isubject}(:,cyclesbaseline{isubject}),2);
    
else
    
    temp=sort(meanABSError.baseline2{isubject}(BASELINE2end(isubject)-49:BASELINE2end(isubject)));
    cyclesbaseline{isubject}=find(ismember(meanABSError.baseline2{isubject}(BASELINE2end(isubject)-49:BASELINE2end(isubject)),temp(1:45)));
    cyclesbaseline{isubject}+BASELINE2end(isubject)-50;
    baseline2(:,isubject)=mean(ENCO.baseline2{isubject}(:,cyclesbaseline{isubject}),2);
end

end


for isubject=x:n
    
    for istride=1:size(ENCO.baseline2{isubject},2)
        
        deltaENCO.baseline2{isubject}(:,istride)=ENCO.baseline2{isubject}(:,istride)-baseline2(:,isubject);
    end
    
    for istride=1:size(ENCO.CHAMP{isubject},2)
        deltaENCO.CHAMP{isubject}(:,istride)=ENCO.CHAMP{isubject}(:,istride)-baseline2(:,isubject);
    end
    
    if fin(isubject)-POST1(isubject)>1;
    for istride=1:size(ENCO.POST{isubject},2)
        deltaENCO.POST{isubject}(:,istride)=ENCO.POST{isubject}(:,istride)-baseline2(:,isubject);
    end
    end
end
 
for isubject=x:n
       
    for istride=1:BASELINE2end(isubject)
        
        if ~isnan(deltaENCO.baseline2{isubject}(1,istride))
            
            
            MaxDorsiError.baseline2{isubject}(istride)=max(deltaENCO.baseline2{isubject}(:,istride));
            MaxPlantError.baseline2{isubject}(istride)=min(deltaENCO.baseline2{isubject}(:,istride));
            peakDorsi.baseline2{isubject}(istride)=max(ENCO.baseline2{isubject}(200:1000,istride));
            peakPlant.baseline2{isubject}(istride)=min(ENCO.baseline2{isubject}(1:600,istride));
            
            temp=find(deltaENCO.baseline2{isubject}(:,istride)==min(deltaENCO.baseline2{isubject}(:,istride)));
            MaxPlantErrortiming.baseline2{isubject}(istride)=temp(1);
            
            temp=find(deltaENCO.baseline2{isubject}(1:1000,istride)==max(deltaENCO.baseline2{isubject}(1:1000,istride)));
            MaxDorisErrortiming.baseline2{isubject}(istride)=temp(1);
            
            temp=find(ENCO.baseline2{isubject}(200:1000,istride)==max(ENCO.baseline2{isubject}(200:1000,istride)));
            peakDorsitiming.baseline2{isubject}(istride)=temp(1)+199;
            
            temp=find(ENCO.baseline2{isubject}(1:600,istride)==min(ENCO.baseline2{isubject}(1:600,istride)));
            peakPlanttiming.baseline2{isubject}(istride)=temp(1);
            
            meanABSError.baseline2{isubject}(istride)=mean(abs(deltaENCO.baseline2{isubject}(:,istride)));
            meanSIGNEDError.baseline2{isubject}(istride)=mean(deltaENCO.baseline2{isubject}(:,istride));
            
            % Determine what is overshoot AND what is undershoot
            u=0;
            o=0;
            tempUNDER=[];
            tempOVER=[];
            
            for k=1:1000
                if deltaENCO.baseline2{isubject}(k,istride)<0;
                    u=u+1;
                    tempUNDER(u)=k;
                    
                elseif deltaENCO.baseline2{isubject}(k,istride)>0;
                    o=o+1;
                    tempOVER(o)=k;
                end
                
            end
            
            if length(tempUNDER)>0
                meanUndershoot.baseline2{isubject}(istride)=sum(abs(deltaENCO.baseline2{isubject}(tempUNDER,istride)))/(1000);
            else
                meanUndershoot.baseline2{isubject}(istride)=0;
            end
            
            if length(tempOVER)>0
                meanOvershoot.baseline2{isubject}(istride)=sum(abs(deltaENCO.baseline2{isubject}(tempOVER,istride)))/(1000);
            else
                meanOvershoot.baseline2{isubject}(istride)=0;
            end
            
            percentOvershoot.baseline2{isubject}(istride)=meanOvershoot.baseline2{isubject}(istride)/meanABSError.baseline2{isubject}(istride)*100;
            percentUndershoot.baseline2{isubject}(istride)=meanUndershoot.baseline2{isubject}(istride)/meanABSError.baseline2{isubject}(istride)*100;
            
            
            tempUNDER=[];
            tempOVER=[];
            
            
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%CHAMP
    for istride=1:CHAMPend(isubject)
        
        if ~isnan(deltaENCO.CHAMP{isubject}(1,istride))
            
             
            MaxDorsiError.CHAMP{isubject}(istride)=max(deltaENCO.CHAMP{isubject}(:,istride));
            MaxPlantError.CHAMP{isubject}(istride)=min(deltaENCO.CHAMP{isubject}(:,istride));
            peakDorsi.CHAMP{isubject}(istride)=max(ENCO.CHAMP{isubject}(200:1000,istride));
            peakPlant.CHAMP{isubject}(istride)=min(ENCO.CHAMP{isubject}(1:600,istride));
            
            temp=find(deltaENCO.CHAMP{isubject}(:,istride)==min(deltaENCO.CHAMP{isubject}(:,istride)));
            MaxPlantErrortiming.CHAMP{isubject}(istride)=temp(1);
            
            temp=find(deltaENCO.CHAMP{isubject}(1:1000,istride)==max(deltaENCO.CHAMP{isubject}(1:1000,istride)));
            MaxDorisErrortiming.CHAMP{isubject}(istride)=temp(1);
            
            temp=find(ENCO.CHAMP{isubject}(200:1000,istride)==max(ENCO.CHAMP{isubject}(200:1000,istride)));
            peakDorsitiming.CHAMP{isubject}(istride)=temp(1)+199;
            
            temp=find(ENCO.CHAMP{isubject}(1:600,istride)==min(ENCO.CHAMP{isubject}(1:600,istride)));
            peakPlanttiming.CHAMP{isubject}(istride)=temp(1);
            
            meanABSError.CHAMP{isubject}(istride)=mean(abs(deltaENCO.CHAMP{isubject}(:,istride)));
            meanSIGNEDError.CHAMP{isubject}(istride)=mean(deltaENCO.CHAMP{isubject}(:,istride));
            
            % Determine what is overshoot AND what is undershoot
            u=0;
            o=0;
            tempUNDER=[];
            tempOVER=[];
            
            for k=1:1000
                if deltaENCO.CHAMP{isubject}(k,istride)<0;
                    u=u+1;
                    tempUNDER(u)=k;
                    
                elseif deltaENCO.CHAMP{isubject}(k,istride)>0;
                    o=o+1;
                    tempOVER(o)=k;
                end
                
            end
            
            if length(tempUNDER)>0
                meanUndershoot.CHAMP{isubject}(istride)=sum(abs(deltaENCO.CHAMP{isubject}(tempUNDER,istride)))/(1000);
            else
                meanUndershoot.CHAMP{isubject}(istride)=0;
            end
            
            if length(tempOVER)>0
                meanOvershoot.CHAMP{isubject}(istride)=sum(abs(deltaENCO.CHAMP{isubject}(tempOVER,istride)))/(1000);
            else
                meanOvershoot.CHAMP{isubject}(istride)=0;
            end
            
            percentOvershoot.CHAMP{isubject}(istride)=meanOvershoot.CHAMP{isubject}(istride)/meanABSError.CHAMP{isubject}(istride)*100;
            percentUndershoot.CHAMP{isubject}(istride)=meanUndershoot.CHAMP{isubject}(istride)/meanABSError.CHAMP{isubject}(istride)*100;
            
            
            tempUNDER=[];
            tempOVER=[];
            
           
            
            %Absolute error center of gravity
            clear weight
            for k=1:1000
                weight(k)=abs(deltaENCO.CHAMP{isubject}(k,istride))*k;
            end
            
            CoG.CHAMP{isubject}(istride)=sum(weight)/sum(abs(deltaENCO.CHAMP{isubject}(:,istride)));
            normPFC.CHAMP{isubject}(istride)=stimtimingSync{isubject}(istride)*1000/dureeswing.CHAMP{isubject}(istride);
            CoGrelatif.CHAMP{isubject}(istride)=CoG.CHAMP{isubject}(istride)-normPFC.CHAMP{isubject}(istride);
            
      
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%POST
    if fin(isubject)-POST1(isubject)>1;
    for istride=1:POSTend(isubject)
        
        if ~isnan(deltaENCO.POST{isubject}(1,istride))
            
            
            
            MaxDorsiError.POST{isubject}(istride)=max(deltaENCO.POST{isubject}(:,istride));
            MaxPlantError.POST{isubject}(istride)=min(deltaENCO.POST{isubject}(:,istride));
            peakDorsi.POST{isubject}(istride)=max(ENCO.POST{isubject}(200:1000,istride));
            peakPlant.POST{isubject}(istride)=min(ENCO.POST{isubject}(1:600,istride));
            
            temp=find(deltaENCO.POST{isubject}(:,istride)==min(deltaENCO.POST{isubject}(:,istride)));
            MaxPlantErrortiming.POST{isubject}(istride)=temp(1);
            
            temp=find(deltaENCO.POST{isubject}(1:1000,istride)==max(deltaENCO.POST{isubject}(1:1000,istride)));
            MaxDorisErrortiming.POST{isubject}(istride)=temp(1);
            
            temp=find(ENCO.POST{isubject}(200:1000,istride)==max(ENCO.POST{isubject}(200:1000,istride)));
            peakDorsitiming.POST{isubject}(istride)=temp(1)+199;
            
            temp=find(ENCO.POST{isubject}(1:600,istride)==min(ENCO.POST{isubject}(1:600,istride)));
            peakPlanttiming.POST{isubject}(istride)=temp(1);
            
            meanABSError.POST{isubject}(istride)=mean(abs(deltaENCO.POST{isubject}(:,istride)));
            meanSIGNEDError.POST{isubject}(istride)=mean(deltaENCO.POST{isubject}(:,istride));
            
            % Determine what is overshoot AND what is undershoot
            u=0;
            o=0;
            tempUNDER=[];
            tempOVER=[];
            
            for k=1:1000
                if deltaENCO.POST{isubject}(k,istride)<0;
                    u=u+1;
                    tempUNDER(u)=k;
                    
                elseif deltaENCO.POST{isubject}(k,istride)>0;
                    o=o+1;
                    tempOVER(o)=k;
                end
                
            end
            
            if length(tempUNDER)>0
                meanUndershoot.POST{isubject}(istride)=sum(abs(deltaENCO.POST{isubject}(tempUNDER,istride)))/(1000);
            else
                meanUndershoot.POST{isubject}(istride)=0;
            end
            
            if length(tempOVER)>0
                meanOvershoot.POST{isubject}(istride)=sum(abs(deltaENCO.POST{isubject}(tempOVER,istride)))/(1000);
            else
                meanOvershoot.POST{isubject}(istride)=0;
            end
            
            percentOvershoot.POST{isubject}(istride)=meanOvershoot.POST{isubject}(istride)/meanABSError.POST{isubject}(istride)*100;
            percentUndershoot.POST{isubject}(istride)=meanUndershoot.POST{isubject}(istride)/meanABSError.POST{isubject}(istride)*100;
            
            
            tempUNDER=[];
            tempOVER=[];
            
        else
            
            MaxDorsiError.POST(istride,isubject)=nan;
            meanABSError.POST(istride,isubject)=nan;
            meanSIGNEDError.POST(istride,isubject)=nan;
            meanUndershoot.POST(istride,isubject)=nan;
            meanOvershoot.POST(istride,isubject)=nan;
            percentOvershoot.POST(istride,isubject)=nan;
            percentUndershoot.POST(istride,isubject)=nan;
            peakDorsi.POST(istride,isubject)=nan;
            peakPlant.POST(istride,isubject)=nan;
            peakDorsitiming.POST(istride,isubject)=nan;
            peakPlanttiming.POST(istride,isubject)=nan;
        end
        
    end
    end
    
    
end
