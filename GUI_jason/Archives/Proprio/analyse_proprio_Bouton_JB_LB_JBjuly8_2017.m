function [variable,resultat]=analyse_proprio_Bouton_LB



clear all
load('Table_data.mat');


Direction=menu('Quelle est la direction du champ de force?','Flexion plantaire (r?sistif)','Flexion dorsale (assistif)');

STIM=find(Cycle_Table(:,5)==1);
CTRL=find(Cycle_Table(:,5)==0);
reponse(1:length(STIM))=nan;
CF(1:length(STIM))=nan;
maxdeltaF(1:length(STIM))=nan;
maxF(1:length(STIM))=nan;
erreur_max(1:length(STIM))=nan;
erreur_max1(1:length(STIM))=nan;
erreur_max2(1:length(STIM))=nan;
numcycle=size(Cycle_Table,1);
onsetCF(1:length(STIM))=nan;
themax1(1:length(STIM))=nan;
onsetCF(1:length(STIM))=nan;
themax2(1:length(STIM))=nan;
peakFtiming(1:length(STIM))=nan;


%%%%%% Add by JB on July 8th 2015
deltaENCO(1:2750,1:length(STIM))=nan; 
deltaENCOcorrected(1:2750,1:length(STIM))=nan;
deltaCOUPLE(1:2750,1:length(STIM))=nan;
deltaCOUPLEcorrected(1:2750,1:length(STIM))=nan; %LB 2017
CONS_F(1:2750,1:length(STIM))=nan;
bouton(1:2750,1:length(STIM))=nan;
%%% for later validation

chan_ENCO=find(strcmp(chan_name,'ENCO')==1);
chan_COUPLE=find(strcmp(chan_name,'COUPLE')==1);
chan_CONSF=find(strcmp(chan_name,'CONS_F')==1);
chan_Response=find(strcmp(chan_name,'Response')==1);


for i=1:length(STIM)
    if STIM(i)<length(Cycle_Table(:,3))
        reponse(i)=sum(Cycle_Table(STIM(i):STIM(i)+1,4));
        if reponse(i)>1
            reponse(i)=1;
        end
        
    else
        reponse(i)=nan;
    end
    
    if Cycle_Table(STIM(i),3)==0
        reponse(i)=nan;
    end
end


%% synchronize data on pushoff
figure(1)
clf
s=['plot(Table',num2str(chan_ENCO),'(500:end,:))'];eval(s);
hold on
title('Put the cursor in the middle of the pushoff (y axis)');
[x,syncthreshold]=ginput(1)
syncthreshold=round(syncthreshold(1));


for i=1:size(Cycle_Table,1);
    s=['temp=find(round(Table',num2str(chan_ENCO),'(500:end-1,i))==syncthreshold & diff(Table',num2str(chan_ENCO),'(500:end,i))<0);'];eval(s);
    
    if temp>0
        synctiming(i)=temp(1)+499;
    else
        synctiming(i)=nan;
    end
    
end

%Validate synchronisation
% For baseline1

%Procedure Baseline
figure(1)
clf

for i=1:numcycle
    
    if isnan(synctiming(i))==0
        s=['plot(','Table',num2str(chan_ENCO),'(synctiming(i):end,i));'];
        h(i)=double(eval(s));
        
        hold on;
    else
        h(i)=NaN;
    end
    
end
cycles=find(isnan(h)==0); %added by JB July 13th voir l 92 136 137
set(h(cycles),'color','b') %set(h(:),'color','b')
a=axis;
axis([0 1500 a(3) a(4)])

xlabel('click in the white space when finished');

bad_cycles=[];
count=0;
over=0;

while not(over)
    
    waitforbuttonpress;
    hz=gco;
    [bad]=find(h==hz);
    
    if not(isempty(bad))
        set(h(bad),'color','r','linewidth',2);
        ylabel(bad);
        set(h(bad),'color','r','marker','o')
        
        uistack(h(bad),'top')
        
        
        confirmation=menu('Non valide?','oui','non');
        
        switch confirmation
            case confirmation==1
                
                delete(h(bad))
                count=count+1;
                bad_cycles(count)=bad;
                
            otherwise
                
                set(h(bad),'color','b','linewidth',0.5);
                
        end %SWITCH
        
    else
        over=1;
    end; %if
end;

mauvaissync=find(isnan(h)==1); %Add JB July13
Cycle_Table(mauvaissync,3)=-1; %Add JB July13
Cycle_Table(bad_cycles,3)=-1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end synchronisation on pushoff

%% resultats
j=1;
baselinesync(1:750,1:length(CTRL))=nan;
dureecycle=size(Table1,1);

for i=1:length(CTRL)
    if Cycle_Table(CTRL(i),3)==1
        
        cyclesbaseline(j)=CTRL(i);
        s=['baselineENCOsync(1:dureecycle-synctiming(CTRL(i))+1,j)=Table',num2str(chan_ENCO),'(synctiming(CTRL(i)):end,CTRL(i));'];eval(s);
        s=['baselineCOUPLEsync(1:dureecycle-synctiming(CTRL(i))+1,j)=Table',num2str(chan_COUPLE),'(synctiming(CTRL(i)):end,CTRL(i));'];eval(s);
        j=j+1;
    end
end

ref_ENCO=mean(baselineENCOsync,2);
ref_COUPLE=mean(baselineCOUPLEsync,2);

figure(2);


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
        erreur_max2(i)=delta2(themax2(i));%Erreur maximal dont le offset lors du onsetCF a �t� retir�
        xlabel(erreur_max2(i));
        
        subplot(4,1,3);
        s=['a=Table',num2str(chan_COUPLE),'(synctiming(STIM(i)):end,STIM(i));'];eval(s);
        
        ref_COUPLE=ref_COUPLE-ref_COUPLE(onsetCF(i)); %%%%%%2017 ATTENTION: corrig� pour vertical displacement de couple!!!!!
        a=a-a(onsetCF(i)); %%%%%%2017 ATTENTION: corrig� pour vertical displacement de couple!!!!!
        
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
        
        deltaCOUPLE(1:length(deltaF),i)=deltaF; %%%%%%2017 ATTENTION: MAINTENANT CA DONNE corrig� pour vertical displacement de couple!!!!!

        
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
variable.deltaCOUPLE=deltaCOUPLE; %LB 2017 variable de sortie est maintenant couple corrig�
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
% xlswrite('AnalProprio',{'r�ponse'},'F1');



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
