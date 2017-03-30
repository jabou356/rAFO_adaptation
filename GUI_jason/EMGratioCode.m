function [ TAratiovariable ] = EMGratioCode( GroupData,AnalTA,path )
%EMGratioCode Is used to compute EMGratio as in Bouffard et al. 2016 Neural
%Plasticity during force field adaptation. Inputs include the Force Command
%Signal synchronised on Heelstrike and the RBIAnalTA signal synchronised on
%the middle of the ENCO signal during pushoff.


%% Load files
[fn, pn] = uigetfile(path, 'Go get your KINEMATIC analysis file (AnalENCO)') ;
load([pn fn],'meanABSError', 'BASELINE2end','CHAMPend');

load([pn 'SyncData.mat']);
load([pn 'CyclesCritiques.mat']);


if sum(isnan(BASELINE2end))>0
    nsujets=find(isnan(BASELINE2end),1,'first')-1;
else
    nsujets=30;
end

for isujet=nsujets:-1:1
    %% Get the baseline cycles used for kinematic Analyses with valid EMG and compute baseline template
    baselinecycles=find(not(isnan(meanABSError.baseline2(BASELINE2end(isujet)-49:BASELINE2end(isujet),isujet)))...
        & not(isnan(AnalTA.TA.baseline2(1,BASELINE2end(isujet)-49:BASELINE2end(isujet),isujet)))');
    baselinecycles=baselinecycles+BASELINE2end(isujet)-50;
    baselinelateTA(:,isujet)=mean(AnalTA.TA.baseline2(:,baselinecycles,isujet),2);
    
    %% Get mean TA activity for the valid cycles during Fearly and late
    FFearlycycles=find(not(isnan(AnalTA.TA.CHAMP(1,2:11,isujet)))'...
        & not(isnan(meanABSError.CHAMP(2:11,isujet))));
    FFearlycycles=FFearlycycles+1;
    FFearlyTA(:,isujet)=mean(AnalTA.TA.CHAMP(:,FFearlycycles,isujet),2);
    
    FFlatecycles=find(not(isnan(AnalTA.TA.CHAMP(1,CHAMPend(isujet)-49:CHAMPend(isujet),isujet)))'...
        & not(isnan(meanABSError.CHAMP(CHAMPend(isujet)-49:CHAMPend(isujet),isujet))));
    FFlatecycles=FFlatecycles+CHAMPend(isujet)-50;
    FFlateTA(:,isujet)=mean(AnalTA.TA.CHAMP(:,FFlatecycles,isujet),2);
    
    %% Compute TA ratio and log transformed TA ratio
    FFearlyratio(:,isujet)=FFearlyTA(:,isujet)./baselinelateTA(:,isujet);
    FFlateratio(:,isujet)=FFlateTA(:,isujet)./baselinelateTA(:,isujet);
    
    log2FFearlyratio(:,isujet)=log2(FFearlyratio(:,isujet));
    log2FFlateratio(:,isujet)=log2(FFlateratio(:,isujet));
    
    %% Synchronise CONS_F signal with TA  and interpolate on 1300 sample
    k=POST1(isujet)-FF1(isujet);
    for j=POST1(isujet)-1:-1:FF1(isujet)
        if GroupData.Cycle_Table(3,j,isujet)==1 & SyncTiming(isujet,j)<1000 & SyncTiming(isujet,j)>500
            
            stop=find(isnan(GroupData.CONS_F(:,j,isujet))==0,1,'last')+4;
            
            if stop>0;
                x=SyncTiming(isujet,j)-round(AnalTA.dureeswing.CHAMP(k,isujet)*0.3):stop;
                y=GroupData.CONS_F(x,j,isujet)';
                CONS_F(:,k,isujet)=interp1(1:length(x),y,1:(length(x)-1)/1299:length(x));
            end
            %% Find Peak Force Timing (PFC) for each stride
            peakCONS_Ftiming(k,isujet)=round(find(CONS_F(:,k,isujet)==min(CONS_F(:,k,isujet)),1,'first'));
            
        else
            CONS_F(:,k,isujet)=nan;
            peakCONS_Ftiming(k,isujet)=nan;
        end
        
        k=k-1;
    end
    
    %% Find averaged PFC during early and late adaptation
    peakCONS_FtimingFFearly(isujet)=round(mean(peakCONS_Ftiming(FFearlycycles,isujet),1));
    peakCONS_FtimingFFlate(isujet)=round(mean(peakCONS_Ftiming(FFlatecycles,isujet),1));
    
    %% Compute Total TAratio, TAratio BeforePFC and TAratio AfterPFC and their log2 transform
    BeforePFCEarly(isujet)=mean(FFearlyratio(1:peakCONS_FtimingFFearly(isujet),isujet),1);
    log2BeforePFCEarly(isujet)=mean(log2FFearlyratio(1:peakCONS_FtimingFFearly(isujet),isujet),1);
    BeforePFCLate(isujet)=mean(FFlateratio(1:peakCONS_FtimingFFlate(isujet),isujet),1);
    log2BeforePFCLate(isujet)=mean(log2FFlateratio(1:peakCONS_FtimingFFlate(isujet),isujet),1);
    
    AfterPFCEarly(isujet)=mean(FFearlyratio(peakCONS_FtimingFFearly(isujet):end,isujet),1);
    log2AfterPFCEarly(isujet)=mean(log2FFearlyratio(peakCONS_FtimingFFearly(isujet):end,isujet),1);
    AfterPFCLate(isujet)=mean(FFlateratio(peakCONS_FtimingFFlate(isujet):end,isujet),1);
    log2AfterPFCLate(isujet)=mean(log2FFlateratio(peakCONS_FtimingFFlate(isujet):end,isujet),1);
    
    TotalEarly(isujet)=mean(FFearlyratio(:,isujet),1);
    log2TotalEarly(isujet)=mean(log2FFearlyratio(:,isujet),1);
    TotalLate(isujet)=mean(FFlateratio(:,isujet),1);
    log2TotalLate(isujet)=mean(log2FFlateratio(:,isujet),1);
    
    
    
end

TAratiovariable.peakCONS_FtimingFFearly=peakCONS_FtimingFFearly;
TAratiovariable.peakCONS_FtimingFFlate=peakCONS_FtimingFFlate;
TAratiovariable.BeforePFCEarly=BeforePFCEarly;
TAratiovariable.log2BeforePFCEarly=log2BeforePFCEarly;
TAratiovariable.BeforePFCLate=BeforePFCLate;
TAratiovariable.log2BeforePFCLate=log2BeforePFCLate;
TAratiovariable.AfterPFCEarly=AfterPFCEarly;
TAratiovariable.log2AfterPFCEarly=log2AfterPFCEarly;
TAratiovariable.AfterPFCLate=AfterPFCLate;
TAratiovariable.log2AfterPFCLate=log2AfterPFCLate;
TAratiovariable.TotalEarly=TotalEarly;
TAratiovariable.log2TotalEarly=log2TotalEarly;
TAratiovariable.TotalLate=TotalLate;
TAratiovariable.log2TotalLate=log2TotalLate;
TAratiovariable.FFearlyratio=FFearlyratio;
TAratiovariable.log2FFearlyratio=log2FFearlyratio;
TAratiovariable.FFlateratio=FFlateratio;
TAratiovariable.log2FFlateratio=log2FFlateratio;
TAratiovariable.baselinelateTA=baselinelateTA;
TAratiovariable.FFearlyTA=FFearlyTA;
TAratiovariable.FFlateTA=FFlateTA;


end

