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


    nsujets=length(BASELINE2end);


for isujet=nsujets:-1:1
    %% Get the baseline cycles used for kinematic Analyses with valid EMG and compute baseline template
    baselinecycles=find(~isnan(meanABSError.baseline2{isujet}(BASELINE2end(isujet)-49:BASELINE2end(isujet)))...
        & ~isnan(AnalTA.TA.baseline2{isujet}(1,BASELINE2end(isujet)-49:BASELINE2end(isujet))));
    baselinecycles=baselinecycles+BASELINE2end(isujet)-50;
    baselinelateTA(:,isujet)=mean(AnalTA.TA.baseline2{isujet}(:,baselinecycles),2);
    
    %% Get mean TA activity for the valid cycles during Fearly and late
    FFearlycycles=find(not(isnan(AnalTA.TA.CHAMP{isujet}(1,2:11)))...
        & not(isnan(meanABSError.CHAMP{isujet}(2:11))));
    FFearlycycles=FFearlycycles+1;
    FFearlyTA(:,isujet)=mean(AnalTA.TA.CHAMP{isujet}(:,FFearlycycles),2);
    
    FFlatecycles=find(not(isnan(AnalTA.TA.CHAMP{isujet}(1,CHAMPend(isujet)-49:CHAMPend(isujet))))...
        & not(isnan(meanABSError.CHAMP{isujet}(CHAMPend(isujet)-49:CHAMPend(isujet)))));
    FFlatecycles=FFlatecycles+CHAMPend(isujet)-50;
    FFlateTA(:,isujet)=mean(AnalTA.TA.CHAMP{isujet}(:,FFlatecycles),2);
    
    %% Compute TA ratio and log transformed TA ratio
    FFearlyratio(:,isujet)=FFearlyTA(:,isujet)./baselinelateTA(:,isujet);
    FFlateratio(:,isujet)=FFlateTA(:,isujet)./baselinelateTA(:,isujet);
    
    log2FFearlyratio(:,isujet)=log2(FFearlyratio(:,isujet));
    log2FFlateratio(:,isujet)=log2(FFlateratio(:,isujet));
    
    %% Synchronise CONS_F signal with TA  and interpolate on 1300 sample
    k=POST1(isujet)-FF1(isujet);
    for istride=POST1(isujet)-1:-1:FF1(isujet)
        if GroupData.Cycle_Table{isujet}(3,istride)==1 && SyncTiming{isujet}(istride)<1000 && SyncTiming{isujet}(istride)>500
            
            
                x=SyncTiming{isujet}(istride)-round(AnalTA.dureeswing.CHAMP{isujet}(k)*0.3):length(GroupData.CONS_F{isujet}{istride}(:))-4;
                y=GroupData.CONS_F{isujet}{istride}(x)';
                CONS_F{isujet}(:,k)=interp1(1:length(x),y,1:(length(x)-1)/1299:length(x));
            
            %% Find Peak Force Timing (PFC) for each stride
            peakCONS_Ftiming{isujet}(k)=round(find(CONS_F{isujet}(:,k)==min(CONS_F{isujet}(:,k)),1,'first'));
            
        else
            CONS_F{isujet}(:,k)=nan;
            peakCONS_Ftiming{isujet}(k)=nan;
        end
        
        k=k-1;
    end
    
    %% Find averaged PFC during early and late adaptation
    peakCONS_FtimingFFearly(isujet)=round(mean(peakCONS_Ftiming{isujet}(FFearlycycles)));
    peakCONS_FtimingFFlate(isujet)=round(mean(peakCONS_Ftiming{isujet}(FFlatecycles)));
    
    %% Compute Total TAratio, TAratio BeforePFC and TAratio AfterPFC and their log2 transform
    BeforePFCEarly(isujet)=mean(FFearlyratio(1:peakCONS_FtimingFFearly(isujet),isujet));
    log2BeforePFCEarly(isujet)=mean(log2FFearlyratio(1:peakCONS_FtimingFFearly(isujet),isujet));
    BeforePFCLate(isujet)=mean(FFlateratio(1:peakCONS_FtimingFFlate(isujet),isujet));
    log2BeforePFCLate(isujet)=mean(log2FFlateratio(1:peakCONS_FtimingFFlate(isujet),isujet));
    
    % For AfterPFC and Total, we use nanmean because the RBI filter applied
    % before TA analysis code create nans at the end of each stride. Does
    % not affect BeforePFC because the beginning of this window (30% stride duration before TO) is not the
    % beginning of the stride (HC)
    AfterPFCEarly(isujet)=nanmean(FFearlyratio(peakCONS_FtimingFFearly(isujet):end,isujet));
    log2AfterPFCEarly(isujet)=nanmean(log2FFearlyratio(peakCONS_FtimingFFearly(isujet):end,isujet));
    AfterPFCLate(isujet)=nanmean(FFlateratio(peakCONS_FtimingFFlate(isujet):end,isujet));
    log2AfterPFCLate(isujet)=nanmean(log2FFlateratio(peakCONS_FtimingFFlate(isujet):end,isujet));
    
    TotalEarly(isujet)=nanmean(FFearlyratio(:,isujet));
    log2TotalEarly(isujet)=nanmean(log2FFearlyratio(:,isujet));
    TotalLate(isujet)=nanmean(FFlateratio(:,isujet));
    log2TotalLate(isujet)=nanmean(log2FFlateratio(:,isujet));
    
    
    
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

