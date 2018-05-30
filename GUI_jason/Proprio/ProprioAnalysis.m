function AnalProprio = ProprioAnalysis (data, Cycle_Table, config, Sync_Data)
% Define Force field direction
Direction=menu('Which direction is the force field?','Toward plantar flexion, resist dorsiflexion','Toward dorsiflexion, resist plantar flexion');

% Identify strides with and without force fields
conditions = {'CTRL','STIM'};
condStrides{1} = find(Cycle_Table(:,5)==0);
condStrides{2} = find(Cycle_Table(:,5)==1);

% Identify relevent channels
chan_ENCO=find(strcmp(config.chan_name,config.AnkleName));
chan_COUPLE=find(strcmp(config.chan_name,config.COUPLEName));
chan_CONSF=find(strcmp(config.chan_name,config.ForcecommandName));
chan_Response=find(strcmp(config.chan_name,config.ResponseName));

% Find strides with an activated button 
AnalProprio.response = cellfun(@(x)(min(x(:,chan_Response))<config.ResponseTh),Table);
AnalProprio.response(Cycle_Table(:,3)==0) = nan;


%% Validate synchronisation
% PUT REMOVE BAD SUPERPOSE HERE
Cycle_Table(mauvaissync,3)=-1; %Add JB July13
Cycle_Table(bad_cycles,3)=-1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end synchronisation on pushoff

%% resultats
strideduration = cellfun(@(x)(size(x,1)),data);

for icond = 1:length(conditions)
for istride=1:length(condStrides{icond})
    if Cycle_Table(condStrides{icond}(istride),3)==1 && ...
            SyncData.SyncTiming{1}(condStrides{icond}(istride)) < strideduration(condStrides{icond}(istride))
                % it the stride is valid, SyncTiming is not the last
                % instant (or a NaN), Synchronize and interpolate the
                % signal.
       
                x = 1 : strideduration(condStrides{icond}(istride))-SyncData.SyncTiming{1}(condStrides{icond}(istride))+1;
                y = data{istride}(SyncData.SyncTiming{1}(condStrides{icond}(istride)):end,chan_ENCO);
                AnalProprio.ENCO.(conditions{icond})(:,istride)=interp1(x,y,1:(length(x)-1)/(999):length(x));
                
                y = data{istride}(SyncData.SyncTiming{1}(condStrides{icond}(istride)):end,chan_COUPLE);
                AnalProprio.COUPLE.(conditions{icond})(:,istride)=interp1(x,y,1:(length(x)-1)/(999):length(x));
                
                y = data{istride}(SyncData.SyncTiming{1}(condStrides{icond}(istride)):end,chan_CONSF);
                AnalProprio.CONS_F.(conditions{icond})(:,istride)=interp1(x,y,1:(length(x)-1)/(999):length(x));
                
                AnalProprio.dureeswing.(conditions{icond})(istride)=length(x);
                
    else
                AnalProprio.ENCO.(conditions{icond})(:,istride) = nan;
                AnalProprio.COUPLE.(conditions{icond})(:,istride) = nan;
                AnalProprio.CONS_F.(conditions{icond})(:,istride) = nan;
                AnalProprio.dureeswing.(conditions{icond})(:,istride) = nan;

    end
    
end

if icond == 1
AnalProprio.baselineENCO=nanmean(AnalProprio.ENCO.(conditions{icond}),2);
AnalProprio.baselineCOUPLE=nanmean(AnalProprio.COUPLE.(conditions{icond}),2);
end
end
%% Rendu ICITTE 2018-05-29

for i=1:length(STIM)
    % ***********ATTENTION MODIFIE PAR LB POUR REMETTRE GONIO A ZERO AU
    % maxCF
    
    
    %definit le max de deviation gonio apres le max de configne en force
    
    if Cycle_Table(STIM(i),3)==1
        %plot results
        %plot results
        clf;
        subplot(4,1,2);
        plot(a,'r');
        hold on;

        s=['a=Table',num2str(chan_CONSF),'(synctiming(STIM(i)):end,STIM(i));'];eval(s);
        clf;
        subplot(4,1,2);
        plot(a,'r');
        hold on;
        
        CONS_F(1:length(a),i)=a; %Add by JB July 8th 2015
        [onsetCF(i), y]=find(abs(a)>=0.4,1,'first');%ATTENTION: plus le max, mais le seuil de debut du CF
        themaxCF=find(abs(a)==max(abs(a)));
        CF(i)=a(themaxCF(1));
        
        zz=axis;
        plot([onsetCF(i) onsetCF(i)],[zz(3) zz(4)],'r:');
        ylabel('Consigne');
        
        tempref_ENCO=ref_ENCO-ref_ENCO(onsetCF(i));
        
        
        
        tempSTIM(1:750)=nan;
        s=['tempSTIM=Table',num2str(chan_ENCO),'(synctiming(STIM(i)):end,STIM(i));'];eval(s);
        tempSTIM2=tempSTIM-tempSTIM(onsetCF(i));
        
        subplot(4,1,1);
        hold on;
        plot(tempref_ENCO);
       %plot(ref_ENCO);
        hold on;
        plot(tempSTIM2,'r')
       %plot(tempSTIM,'r')
        
        if length(tempSTIM)<length(ref_ENCO)
            delta1=tempSTIM-ref_ENCO(1:length(tempSTIM));
            delta2=tempSTIM2-tempref_ENCO(1:length(tempSTIM));
        else
            delta1=tempSTIM(1:length(ref_ENCO))-ref_ENCO;
            delta2=tempSTIM2(1:length(ref_ENCO))-tempref_ENCO;
        end
        
        plot(delta2,'g');
        ylabel('Gonio');
        
        deltaENCO(1:length(delta1),i)=delta1; 
        deltaENCOcorrected(1:length(delta2),i)=delta2; 
                                      
        %retour en arriere et trouve le max de deviation APRES le max de
        %consigne en force
        
        %ICI!!!!!********
         subplot(4,1,1);
         
        x=find(isnan(delta1)==0);
        
        if Direction==1
            themax1(i)=find(delta1(onsetCF(i)+1:x(end))==min(delta1(onsetCF(i)+1:x(end))),1,'first');
            themax2(i)=find(delta2(onsetCF(i)+1:x(end))==min(delta2(onsetCF(i)+1:x(end))),1,'first');%themax=find((delta(themaxCF+1:end))==max(abs(delta(themaxCF+1:end)))); chang? par JB remove abs
        elseif Direction==2
            themax1(i)=find(delta1(onsetCF(i)+1:x(end))==max(delta1(onsetCF(i)+1:x(end))),1,'first');
            themax2(i)=find(delta2(onsetCF(i)+1:x(end))==max(delta2(onsetCF(i)+1:x(end))),1,'first');
        end
        
        themax2(i)=themax2(i)+onsetCF(i);
        themax1(i)=themax1(i)+onsetCF(i);
        
        zz=axis;
        plot([themax2(i) themax2(i)],[zz(3) zz(4)],'r:');
        
        erreur_max1(i)=delta1(themax1(i));%Erreur maximal sur rawdata
        erreur_max2(i)=delta2(themax2(i));%Erreur maximal dont le offset lors du onsetCF a été retiré
        xlabel(erreur_max2(i));
        
        subplot(4,1,3);
        s=['a=Table',num2str(chan_COUPLE),'(synctiming(STIM(i)):end,STIM(i));'];eval(s);
        
        ref_COUPLE=ref_COUPLE-ref_COUPLE(onsetCF(i)); %%%%%%2017 ATTENTION: corrigé pour vertical displacement de couple!!!!!
        a=a-a(onsetCF(i)); %%%%%%2017 ATTENTION: corrigé pour vertical displacement de couple!!!!!
        
        plot(ref_COUPLE);
        hold on;
        
        plot(a,'r');
                    
        
        if length(a)<length(ref_COUPLE)
            deltaF=a-ref_COUPLE(1:length(a));
        else
            deltaF=a(1:length(ref_COUPLE))-ref_COUPLE;   
        end
        
        plot(deltaF,'g');
        ylabel('Force');
        
        deltaCOUPLE(1:length(deltaF),i)=deltaF; %%%%%%2017 ATTENTION: MAINTENANT CA DONNE corrigé pour vertical displacement de couple!!!!!

        
        if Direction==1
            maxdeltaF(i)=min(deltaF(onsetCF(i)+1:x(end)));
            maxF(i)=min(a(onsetCF(i)+1:x(end)));
            
        elseif Direction==2
            
            maxdeltaF(i)=max(deltaF(onsetCF(i)+1:x(end)));
            maxF(i)=max(a(onsetCF(i)+1:x(end)));
        end
        
         
        
        peakFtiming(i)=find(deltaF==maxdeltaF(i),1,'first');
        
        

        
         s=['a=Table',num2str(chan_Response),'(synctiming(STIM(i)):end,STIM(i));'];eval(s);
         bouton(1:length(a),i)=a;
         s=['a=Table',num2str(chan_Response),'(1:end,STIM(i)+1);'];eval(s);
         bouton(751:750+length(a),i)=a;
         
         subplot(4,1,4);
         title(num2str(reponse(i)))
         hold on
        
        plot(bouton(:,i));
        ylabel('reponse');
        
        waitforbuttonpress

        
    end%if;
end %for
resultat(:,1)=CF';
resultat(:,3)=maxdeltaF';
resultat(:,2)=maxF';
resultat(:,4)=erreur_max1';
resultat(:,5)=erreur_max2';
resultat(:,6)=reponse';

variable.erreurmax1timing=themax1;
variable.onsetCF=onsetCF;
variable.erreurmax2timing=themax2;
variable.peakFtiming=peakFtiming;
variable.deltaCOUPLE=deltaCOUPLE; %LB 2017 variable de sortie est maintenant couple corrigé
variable.deltaENCO=deltaENCO;
variable.deltaENCOcorrected=deltaENCOcorrected;
variable.CONS_F=CONS_F;
variable.bouton=bouton;

%fn=strrep(fn,'.mat','.xls');
xlswrite('AnalProprio',resultat,'A2');
% xlswrite('AnalProprio',{'CONS_F'},'A1');
% xlswrite('AnalProprio',{'COUPLE'},'B1');
% xlswrite('AnalProprio',{'deltaCOUPLE'},'C1');
% xlswrite('AnalProprio',{'deltaENCO'},'D1');
% xlswrite('AnalProprio',{'deltaENCOcorrected'},'E1');
% xlswrite('AnalProprio',{'réponse'},'F1');



%% analyse


% figure(3);
% clf;
% plot(resultats(1,:),resultats(2,:),'o');
% ylabel('dev cheville');
% xlabel('consigne en force');
%
% figure(4);
% clf;
% plot(resultats(3,:),resultats(2,:),'o');
% ylabel('dev cheville');
% xlabel('force appliquee');
%
% figure(5);
% clf;
% plot(resultats(1,:),resultats(3,:),'o');
% ylabel('force appliquee');
% xlabel('consigne en force');
%
% figure(6);
% clf;
% plot(resultats(2,:),resultats(5,:),'o');
% ylabel('EMG change');
% xlabel('dev cheville');
%
%
% resultats=resultats';
% xlswrite(fn,resultats);
