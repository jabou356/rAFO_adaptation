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

% Find strides with an activated button & consider a positive response if
% the button was clicked during the current or the following stride & if the
% stride is not valid  the button is not valid
response = cellfun(@(x)(min(x(:,chan_Response))<config.ResponseTh),Table);
AnalProprio.response = response(1:end-2)+response(2:end);
AnalProprio.response(Cycle_Table(:,3)==0) = nan;


SyncData = SyncPushoffProprio (Cycle_Table,data,condStrides, chan_ENCO);


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

%% Validate synchronisation
% PUT REMOVE BAD SUPERPOSE HERE
Cycle_Table(mauvaissync,3)=-1; %Add JB July13
Cycle_Table(bad_cycles,3)=-1;

if icond == 1
AnalProprio.baselineENCO=nanmean(AnalProprio.ENCO.(conditions{icond}),2);
AnalProprio.baselineCOUPLE=nanmean(AnalProprio.COUPLE.(conditions{icond}),2);
end

% I keep baseline to have an idea of the specificity of FF induced
% deviation
for istride=1:length(condStrides{icond})
    
    % Find max kinematic deviation after FF onset
    if Cycle_Table(condStrides{icond}(istride),3)==1

        %Find onset FF = 1st instance CONS_F cross detection threshold
        AnalProprio.onsetFF.(conditions{icond})(istride) =find(abs(AnalProprio.CONS_F.(conditions{icond})(:,istride)) ...
            >= config.RFLXdetect_level ,1,'first'); 
        
        % Find max FF and index
        [AnalProprio.maxFF.(conditions{icond})(istride), AnalProprio.maxFFtiming.(conditions{icond})(istride)] = ...
            max(abs(AnalProprio.CONS_F.(conditions{icond})(:,istride))); 
        

        % compute delta ENCO and deltaCOUPLE for each stride
        AnalProprio.deltaENCO.(conditions{icond})(:,istride) = ...
            AnalProprio.ENCO.(conditions{icond})(:,istride) - AnalProprio.baselineENCO;
        
        AnalProprio.deltaCOUPLE.(conditions{icond})(:,istride) = ...
            AnalProprio.COUPLE.(conditions{icond})(:,istride) - AnalProprio.baselineCOUPLE;
        
        % compute corrected deltaENCO and deltaCOUPLE: bring deltaENCO and deltaCOUPLE to zero at onsetFF
        AnalProprio.deltaENCOcorr.(conditions{icond})(:,istride) = ...
            AnalProprio.deltaENCO.(conditions{icond})(:,istride) - ...
            AnalProprio.deltaENCO.(conditions{icond})(AnalProprio.onsetFF.(conditions{icond})(istride),istride);
        
        AnalProprio.deltaCOUPLEcorr.(conditions{icond})(:,istride) = ...
            AnalProprio.deltaCOUPLE.(conditions{icond})(:,istride) - ...
            AnalProprio.deltaCOUPLE.(conditions{icond})(AnalProprio.onsetFF.(conditions{icond})(istride),istride);
        
        
        if Direction==1
            % If FF is toward plantarflexion, find peakDeltaENCO (MIN) and its
            % index
            [AnalProprio.peakDeltaENCO.(conditions{icond})(istride), temptiming] = ...
               min(AnalProprio.deltaENCO.(conditions{icond})(AnalProprio.onsetFF.(conditions{icond})(istride):end,istride));
           
           AnalProprio.peakDeltaENCOtiming.(conditions{icond})(istride) = temptiming + AnalProprio.onsetFF.(conditions{icond})(istride) -1;
           
           % If FF is toward plantarflexion, find peakDeltaENCO (MIN) corrected for delta ENCO at onsetFF and its
            % index
           [AnalProprio.peakDeltaENCOcorr.(conditions{icond})(istride), temptiming] = ...
               min(AnalProprio.deltaENCOcorr.(conditions{icond})(AnalProprio.onsetFF.(conditions{icond})(istride):end,istride));
           
           AnalProprio.peakDeltaENCOcorrtiming.(conditions{icond})(istride) = temptiming + AnalProprio.onsetFF.(conditions{icond})(istride) -1;
           
           % If FF is toward plantarflexion, find peakDeltaCOUPLE (MIN) and its
            % index
            [AnalProprio.peakDeltaCOUPLE.(conditions{icond})(istride), temptiming] = ...
               min(AnalProprio.deltaCOUPLE.(conditions{icond})(AnalProprio.onsetFF.(conditions{icond})(istride):end,istride));
           
           AnalProprio.peakDeltaCOUPLEtiming.(conditions{icond})(istride) = temptiming + AnalProprio.onsetFF.(conditions{icond})(istride) -1;
           
           % If FF is toward plantarflexion, find peakDeltaCOUPLE (MIN) corrected for delta ENCO at onsetFF and its
            % index
           [AnalProprio.peakDeltaCOUPLEcorr.(conditions{icond})(istride), temptiming] = ...
               min(AnalProprio.deltaCOUPLEcorr.(conditions{icond})(AnalProprio.onsetFF.(conditions{icond})(istride):end,istride));
           
           AnalProprio.peakDeltaCOUPLEcorrtiming.(conditions{icond})(istride) = temptiming + AnalProprio.onsetFF.(conditions{icond})(istride) -1;
       
        elseif Direction==2
            
            % If FF is toward dorsiflexion, find peakDeltaENCO (MAX) and its
            % index
            [AnalProprio.peakDeltaENCO.(conditions{icond})(istride), temptiming] = ...
               max(AnalProprio.deltaENCO.(conditions{icond})(AnalProprio.onsetFF.(conditions{icond})(istride):end,istride));
           
           AnalProprio.peakDeltaENCOtiming.(conditions{icond})(istride) = temptiming + AnalProprio.onsetFF.(conditions{icond})(istride) -1;
           
           % If FF is toward dorsiflexion, find peakDeltaENCO (MAX) corrected for delta ENCO at onsetFF and its
            % index
           [AnalProprio.peakDeltaENCOcorr.(conditions{icond})(istride), temptiming] = ...
               max(AnalProprio.deltaENCOcorr.(conditions{icond})(AnalProprio.onsetFF.(conditions{icond})(istride):end,istride));
           
           AnalProprio.peakDeltaENCOcorrtiming.(conditions{icond})(istride) = temptiming + AnalProprio.onsetFF.(conditions{icond})(istride) -1;
           
           % If FF is toward plantarflexion, find peakDeltaCOUPLE (max) and its
            % index
            [AnalProprio.peakDeltaCOUPLE.(conditions{icond})(istride), temptiming] = ...
               max(AnalProprio.deltaCOUPLE.(conditions{icond})(AnalProprio.onsetFF.(conditions{icond})(istride):end,istride));
           
           AnalProprio.peakDeltaCOUPLEtiming.(conditions{icond})(istride) = temptiming + AnalProprio.onsetFF.(conditions{icond})(istride) -1;
           
           % If FF is toward plantarflexion, find peakDeltaCOUPLE (max) corrected for delta ENCO at onsetFF and its
            % index
           [AnalProprio.peakDeltaCOUPLEcorr.(conditions{icond})(istride), temptiming] = ...
               max(AnalProprio.deltaCOUPLEcorr.(conditions{icond})(AnalProprio.onsetFF.(conditions{icond})(istride):end,istride));
           
           AnalProprio.peakDeltaCOUPLEcorrtiming.(conditions{icond})(istride) = temptiming + AnalProprio.onsetFF.(conditions{icond})(istride) -1;
        end
        
        
    end%if;
end %for
end

