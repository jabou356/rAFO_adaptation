
function [AnalTA]= TAvariablesgenerator(Cycle_Table,data,path,AnalTA)
%% Baseline 2 TA enligné %MODIFICATION 30% au lieur de 20% du swing lignes 15:17, 50, 71, 170, 263
load([path, 'SyncData.mat']);
load([path 'CyclesCritiques.mat']);
n=find(isnan(Cycle_Table(1,1,:))==1);

if n>0
    n=n(1)-1;
else
    n=30
end



if isfield(AnalTA,'TA')

    x=find(sum(~isnan(AnalTA.TA.baseline2(1,:,:)),2)==0,1,'first');
    
else
    
x=1;
AnalTA.TA.baseline2(1:1300,1:588,1:30)=nan;
AnalTA.TA.CHAMP(1:1300,1:397,1:30)=nan;
AnalTA.TA.POST(1:1300,1:290,1:30)=nan;

AnalTA.dureeswing.baseline2(1:588,1:30)=nan;
AnalTA.dureeswing.CHAMP(1:397,1:30)=nan;
AnalTA.dureeswing.POST(1:290,1:30)=nan;

AnalTA.peakTA.baseline2(1:588,1:30)=nan;
AnalTA.peakTA.CHAMP(1:397,1:30)=nan;
AnalTA.peakTA.POST(1:290,1:30)=nan;

AnalTA.cycleID.baseline2(1:588,1:30)=nan;
AnalTA.cycleID.CHAMP(1:397,1:30)=nan;
AnalTA.cycleID.POST(1:290,1:30)=nan;

AnalTA.baseline2(1:1300,1:30)=nan;
AnalTA.BASELINE2end(1:30)=nan;
AnalTA.CHAMPend(1:30)=nan;
AnalTA.POSTend(1:30)=nan;

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
        if Cycle_Table(3,itrial,isubject)==1 & SyncTiming(isubject,itrial)<1000 & SyncTiming(isubject,itrial)>500
            
            stop=find(isnan(data(1:end,itrial,isubject))==0,1,'last')+4;
            
            if stop>0
            
           
            
            AnalTA.dureeswing.baseline2(k,isubject)=stop-SyncTiming(isubject,itrial)+1;
            
            AnalTA.TA.baseline2(:,k,isubject)=interp1(1:round(AnalTA.dureeswing.baseline2(k,isubject)*1.3),data(SyncTiming(isubject,itrial)-round(AnalTA.dureeswing.baseline2(k,isubject)*0.3):stop,itrial,isubject),1:(round(AnalTA.dureeswing.baseline2(k,isubject)*1.3)-1)/(1299):round(AnalTA.dureeswing.baseline2(k,isubject)*1.3));
                     
            temp=data(SyncTiming(isubject,itrial)-150:end,itrial,isubject);
            AnalTA.peakTA.baseline2(k,isubject)=max(data(:,itrial,isubject));
            
            end
            
        end
              
        AnalTA.cycleID.baseline2(k,isubject)=itrial;
                
    end
    AnalTA.BASELINE2end(isubject)=k;
   
    bad_cycles=removebad_Superpose1(AnalTA.TA.baseline2(:,:,isubject),{'TA'},...
        1:find(~isnan(AnalTA.TA.baseline2(1,:,isubject)),1,'last'), 'Group', 'flagMean');
%     clear h bad_cycles
%     figure(1)
%     clf
%     subplot(2,1,1)
%     for j=1:AnalTA.BASELINE2end(i)
%     h(j,1)=plot(AnalTA.TA.baseline2(:,j,i));
%     hold on
%     end
%     set(h(j,1),'color','b')
%        
%     subplot(2,1,2)
%     for j=1:AnalTA.BASELINE2end(i)
%         if isnan(AnalTA.TA.baseline2(1,j,i))==0
%         s=['plot(j,mean(AnalTA.TA.baseline2(1:end-20,j,i)))'];
%         h(j,2)=eval(s);
%         hold on
%         set(h(j,2),'color','b','marker','o');
%         end
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
        
Cycle_Table(3,AnalTA.cycleID.baseline2(bad_cycles,isubject),isubject)=-1;
AnalTA.TA.baseline2(:,bad_cycles,isubject)=nan;

temp=find(Cycle_Table(3,AnalTA.BASELINE2end(isubject)-49:AnalTA.BASELINE2end(isubject),isubject)==1);
countbase=length(temp);

    AnalTA.baseline2(:,isubject)=mean(AnalTA.TA.baseline2(:,temp+AnalTA.BASELINE2end(isubject)-50,isubject),2); %
%    velocitybaseline2(:,i)=mean(Velocity.baseline2(:,temp+BASELINE2end(i)-50,i),2);
    clear temp

 k=0;
    if isnan(FF1(isubject))==0
    for itrial=FF1(isubject):POST1(isubject)-1
           k=k+1;
        if Cycle_Table(3,itrial,isubject)==1 & SyncTiming(isubject,itrial)<1000 & SyncTiming(isubject,itrial)>500
            
            stop=find(isnan(data(1:end,itrial,isubject))==0,1,'last')+4;
            
            if stop>0;
            
           
            
            AnalTA.dureeswing.CHAMP(k,isubject)=stop-SyncTiming(isubject,itrial)+1;
            
            AnalTA.TA.CHAMP(:,k,isubject)=interp1(1:round(AnalTA.dureeswing.CHAMP(k,isubject)*1.3),data(SyncTiming(isubject,itrial)-round(AnalTA.dureeswing.CHAMP(k,isubject)*0.3):stop,itrial,isubject),1:(round(AnalTA.dureeswing.CHAMP(k,isubject)*1.3)-1)/(1299):round(AnalTA.dureeswing.CHAMP(k,isubject)*1.3));
                     
            temp=data(SyncTiming(isubject,itrial)-150:end,itrial,isubject);
            AnalTA.peakTA.CHAMP(k,isubject)=max(data(:,itrial,isubject));
            
            end
            
        end
              
        
     AnalTA.cycleID.CHAMP(k,isubject)=itrial;       
    end    
    AnalTA.CHAMPend(isubject)=k;
    
    bad_cycles=removebad_Superpose1(AnalTA.TA.CHAMP(:,:,isubject),{'TA'},...
        1:find(~isnan(AnalTA.TA.CHAMP(1,:,isubject)),1,'last'), 'Group', 'flagMean');
   
%     clear h bad_cycles
%     figure(1)
%     clf
%     subplot(2,1,1)
%     for j=1:AnalTA.CHAMPend(i)
%     h(j,1)=plot(AnalTA.TA.CHAMP(:,j,i));
%     hold on
%     end
%     set(h(j,1),'color','b')
%        
%     subplot(2,1,2)
%     for j=1:AnalTA.CHAMPend(i)
%         if isnan(AnalTA.TA.CHAMP(1,j,i))==0
%         s=['plot(j,mean(AnalTA.TA.CHAMP(1:end-20,j,i)))'];
%         h(j,2)=eval(s);
%         hold on
%         set(h(j,2),'color','b','marker','o');
%         end
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
        
Cycle_Table(3,AnalTA.cycleID.CHAMP(bad_cycles,isubject),isubject)=-1;
AnalTA.TA.CHAMP(:,bad_cycles,isubject)=nan;
    end

   if fin(isubject)-POST1(isubject)>1 
    k=0;
    for itrial=POST1(isubject):fin(isubject)-1
         k=k+1;
        if Cycle_Table(3,itrial,isubject)==1 & SyncTiming(isubject,itrial)<1000 & SyncTiming(isubject,itrial)>500
            
            stop=find(isnan(data(1:end,itrial,isubject))==0,1,'last')+4;
            
            if stop>0;
            
           
            
            AnalTA.dureeswing.POST(k,isubject)=stop-SyncTiming(isubject,itrial)+1;
            
            AnalTA.TA.POST(:,k,isubject)=interp1(1:round(AnalTA.dureeswing.POST(k,isubject)*1.3),data(SyncTiming(isubject,itrial)-round(AnalTA.dureeswing.POST(k,isubject)*0.3):stop,itrial,isubject),1:(round(AnalTA.dureeswing.POST(k,isubject)*1.3)-1)/(1299):round(AnalTA.dureeswing.POST(k,isubject)*1.3));
                     
            temp=data(SyncTiming(isubject,itrial)-150:end,itrial,isubject);
            AnalTA.peakTA.POST(k,isubject)=max(data(:,itrial,isubject));
            
            end
            
        end
        
        AnalTA.cycleID.POST(k,isubject)=itrial;     
    end
    
     AnalTA.POSTend(isubject)=k;
     bad_cycles=removebad_Superpose1(AnalTA.TA.POST(:,:,isubject),{'TA'},...
        1:find(~isnan(AnalTA.TA.POST(1,:,isubject)),1,'last'), 'Group', 'flagMean');
     
%      clear h bad_cycles
%     figure(1)
%     clf
%     subplot(2,1,1)
%     for j=1:AnalTA.POSTend(i)
%     h(j,1)=plot(AnalTA.TA.POST(:,j,i));
%     hold on
%     end
%     set(h(j,1),'color','b')
%        
%     subplot(2,1,2)
%     for j=1:AnalTA.POSTend(i)
%         if isnan(AnalTA.TA.POST(1,j,i))==0
%         s=['plot(j,mean(AnalTA.TA.POST(1:end-20,j,i)))'];
%         h(j,2)=eval(s);
%         hold on
%         set(h(j,2),'color','b','marker','o');
%         end
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
        
Cycle_Table(3,AnalTA.cycleID.POST(bad_cycles,isubject),isubject)=-1;
AnalTA.TA.POST(:,bad_cycles,isubject)=nan;
   end
     
end






%% TA activation levels
% 
% for i=1:n
%     
%     figure(1)
%     clf
%     plot(baseline2(:,i),'b')
%     hold on
%      temp=find(isnan(TA.CHAMP(1,:,i)')==0);
%     plot(mean(abs(TA.CHAMP(:,temp(end-9:end),i)),2),'m')
%     plot(mean(abs(TA.CHAMP(:,temp(2:11),i)),2),'r')
%     
%     temp=find(isnan(TA.POST(1,:,i)')==0);
%     if length(temp)>11
%     plot(mean(abs(TA.POST(:,temp(2:11),i)),2),'g')
%     end
%     
%     temp=ginput(1);
%     debutbouffee(i)=round(temp(1))
%     temp=ginput(1);
%     finbouffee(i)=round(temp(1))
%     
%      for j=1:BASELINE2end(i)
%    
%     
%     RMSburstTA.baseline2(j,i)=sqrt(sum(TA.baseline2(debutbouffee(i):finbouffee(i),j,i).^2));
%         
%     MEANburstTA.baseline2(j,i)=mean(abs(TA.baseline2(debutbouffee(i):finbouffee(i),j,i)),1);
%      end
%      
%      temp=find(isnan(RMSburstTA.baseline2(:,i)')==0);
%      norRMS=mean(RMSburstTA.baseline2(temp(end-99:end),i));
%      norMEAN=mean(MEANburstTA.baseline2(temp(end-99:end),i));
%      
%      for j=1:CHAMPend(i)
%          
%    if isnan(TA.CHAMP(1,j,i))==0
%     
%     RMSburstTA.CHAMP(j,i)=sqrt(sum(TA.CHAMP(debutbouffee(i):finbouffee(i),j,i).^2));
%     
%     normRMSburstTA.CHAMP(j,i)=RMSburstTA.CHAMP(j,i)/norRMS*100;   
%     
%     MEANburstTA.CHAMP(j,i)=mean(abs(TA.CHAMP(debutbouffee(i):finbouffee(i),j,i)),1);
%     normMEANburstTA.CHAMP(j,i)=MEANburstTA.CHAMP(j,i)/norMEAN*100; 
%     
%     normTAbefore.CHAMP(j,i)=mean(abs(TA.CHAMP(debutbouffee(i):stimtiming(j,i)+150,j,i)),1)/mean(abs(baseline2(debutbouffee(i):stimtiming(j,i)+150,i)),1)*100;
%     normTAafter.CHAMP(j,i)=mean(abs(TA.CHAMP(stimtiming(j,i)+150:finbouffee(i),j,i)),1)/mean(abs(baseline2(stimtiming(j,i)+150:finbouffee(i),i)),1)*100;
%    end
%      end
%      
%      for j=1:POSTend(i)
%        
%     
%     RMSburstTA.POST(j,i)=sqrt(sum(TA.POST(debutbouffee(i):finbouffee(i),j,i).^2));
%     normRMSburstTA.POST(j,i)=RMSburstTA.POST(j,i)/norRMS*100;   
%         
%     MEANburstTA.POST(j,i)=mean(abs(TA.POST(debutbouffee(i):finbouffee(i),j,i)),1);
%     normMEANburstTA.POST(j,i)=MEANburstTA.POST(j,i)/norMEAN*100;   
%      end
%     
% end
