
function [AnalTA]= TAvariablesgenerator(Cycle_Table,data,path,AnalTA)
%% Baseline 2 TA enligné %MODIFICATION 30% au lieur de 20% du swing lignes 15:17, 50, 71, 170, 263

load([path, 'SyncData.mat']);
load([path 'CyclesCritiques.mat']);
n=length(Cycle_Table);

if isfield(AnalTA,'TA')

    x=find(sum(~isnan(AnalTA.TA.baseline2(1,:,:)),2)==0,1,'first');
    
else
    
x=1;

end


for isubject=x:n
    
    k=0;
    
    if isnan(FF1(isubject))==0
        lastcycle=FF1(isubject)-1;
    else
        lastcycle=fin(isubject);
    end
    
    for itrial=1:lastcycle
         k=k+1;
         
    if Cycle_Table{isubject}(3,istride)==1 && Cycle_Table{isubject}(4,istride)==0 ...
            && SyncTiming{isubject}(istride)<1000 && SyncTiming{isubject}(istride)>500 
        
            
            
            AnalTA.dureeswing.baseline2{isubject}(k)=(length(data{isubject}{istride})-SyncTiming{isubject}(istride)+1);

            x = 1 : round(AnalTA.dureeswing.baseline2{isubject}(k)*1.3);    
            y = data{isubject}{istride}(SyncTiming{isubject}(istride)-round(AnalTA.dureeswing.baseline2{isubject}(k)*0.3):end);
            
            AnalTA.TA.baseline2{isubject}(:,k)=interp1(x,y,1:(length(x)-1)/(999):length(x));             
            AnalTA.peakTA.baseline2{isubject}(k)=max(data{isubject}{istride});

            else 
                              
            AnalTA.TA.baseline2{isubject}(:,k)=nan;             
            AnalTA.dureeswing.baseline2{isubject}(k)=nan;            
            AnalTA.peakTA.baseline2{isubject}(k)=nan;
  
            end
            
        
              
        AnalTA.cycleID.baseline2{isubject}(k)=itrial;
                
    end
    AnalTA.BASELINE2end(isubject)=k;
    
    tovalidate.Table=AnalTA.TA.baseline2{isubject};
    
    bad_cycles=removebad_Superpose1(tovalidate,{'TA'},...
        1:size(Anal.TA.baseline2{isubject},2), 'Group', 'flagMean');
    
    Cycle_Table{isubject}(3,AnalTA.cycleID.baseline2{isubject}(bad_cycles))=-1;
        
AnalTA.TA.baseline2{isubject}(:,bad_cycles)=nan;

AnalTA.baseline2(:,isubject)=nanmean(AnalTA.TA.baseline2{isubject}(:,AnalTA.BASELINE2end(isubject)-49:AnalTA.BASELINE2end(isubject)),2); %

%% CHAMP
 k=0;
    if isnan(FF1(isubject))==0
    for itrial=FF1(isubject):POST1(isubject)-1
           k=k+1;
         if Cycle_Table{isubject}(3,istride)==1 && Cycle_Table{isubject}(4,istride)==0 ...
            && SyncTiming{isubject}(istride)<1000 && SyncTiming{isubject}(istride)>500 
        
            
            
            AnalTA.dureeswing.CHAMP{isubject}(k)=(length(data{isubject}{istride})-SyncTiming{isubject}(istride)+1);

            x = 1 : round(AnalTA.dureeswing.CHAMP{isubject}(k)*1.3);    
            y = data{isubject}{istride}(SyncTiming{isubject}(istride)-round(AnalTA.dureeswing.CHAMP{isubject}(k)*0.3):end);
            
            AnalTA.TA.CHAMP{isubject}(:,k)=interp1(x,y,1:(length(x)-1)/(999):length(x));             
            AnalTA.peakTA.CHAMP{isubject}(k)=max(data{isubject}{istride});

            else 
                              
            AnalTA.TA.CHAMP{isubject}(:,k)=nan;             
            AnalTA.dureeswing.CHAMP{isubject}(k)=nan;            
            AnalTA.peakTA.CHAMP{isubject}(k)=nan;
  
            end
            
        
              
        AnalTA.cycleID.CHAMP{isubject}(k)=itrial;
          
    end    
    AnalTA.CHAMPend(isubject)=k;
    
    tovalidate.Table=AnalTA.TA.CHAMP{isubject};
    
    bad_cycles=removebad_Superpose1(tovalidate,{'TA'},...
        1:size(Anal.TA.CHAMP{isubject},2), 'Group', 'flagMean');
    
    Cycle_Table{isubject}(3,AnalTA.cycleID.CHAMP{isubject}(bad_cycles))=-1;
    AnalTA.TA.CHAMP{isubject}(:,bad_cycles)=nan;
    end

    %% POST
   if fin(isubject)-POST1(isubject)>1 
    k=0;
    for itrial=POST1(isubject):fin(isubject)-1
         k=k+1;
           if Cycle_Table{isubject}(3,istride)==1 && Cycle_Table{isubject}(4,istride)==0 ...
            && SyncTiming{isubject}(istride)<1000 && SyncTiming{isubject}(istride)>500 
        
            
            
            AnalTA.dureeswing.POST{isubject}(k)=(length(data{isubject}{istride})-SyncTiming{isubject}(istride)+1);

            x = 1 : round(AnalTA.dureeswing.POST{isubject}(k)*1.3);    
            y = data{isubject}{istride}(SyncTiming{isubject}(istride)-round(AnalTA.dureeswing.POST{isubject}(k)*0.3):end);
            
            AnalTA.TA.POST{isubject}(:,k)=interp1(x,y,1:(length(x)-1)/(999):length(x));             
            AnalTA.peakTA.POST{isubject}(k)=max(data{isubject}{istride});

            else 
                              
            AnalTA.TA.POST{isubject}(:,k)=nan;             
            AnalTA.dureeswing.POST{isubject}(k)=nan;            
            AnalTA.peakTA.POST{isubject}(k)=nan;
  
            end
            
        
              
        AnalTA.cycleID.POST{isubject}(k)=itrial;
           
    end
    
     AnalTA.POSTend(isubject)=k;
     
     tovalidate.Table=AnalTA.TA.POST{isubject};
    
    bad_cycles=removebad_Superpose1(tovalidate,{'TA'},...
        1:size(Anal.TA.POST{isubject},2), 'Group', 'flagMean');
    
    Cycle_Table{isubject}(3,AnalTA.cycleID.POST{isubject}(bad_cycles))=-1;
    AnalTA.TA.POST{isubject}(:,bad_cycles)=nan;
     
   end
     
end

