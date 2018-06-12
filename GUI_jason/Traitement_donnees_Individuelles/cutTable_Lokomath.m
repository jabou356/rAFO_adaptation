function cutTable_Lokomath(config,fdata) 
%CUTTABLE_LOKOMATH: This function is used to cut continuous data vectors 
%into separate strides based on the the selected Sync_Channel. Also create
%Cycle_Table with key events (FF or Reflexes). 
%   INPUT: Config file generated with XXX FUNCTION. Filtered data.
%   OUTPUT: None. Table_data saved..
%   
%   Initially developed by Martin Noel and Laurent Bouyer. Modified by
%   Jason Bouffard
%% Select the signal to use to create an offset in the data synchronisation
Offsetchan = {'ENCO','ENCO','HS','COUPLE'};
DiffOffsetchan = [0 1 0 0];


%% Select data of the channel to be used for synchronisation
signal=fdata(:,config.Sync_channel);

if config.trig_lowpass > 0
    % If you want to apply a lowpass filter to sync channel (e.g. EMG)
    [b,a]=butter(config.trig_Nlowpass,config.trig_lowpass/config.sFz*2);
    signal = filtfilt(b,a,abs(signal));
end

if config.trig_diff > 0
    % If you want to differentiate your sync channel
    signal = diff(signal,config.trig_diff)*config.sFz;
end
% Decimate signal to accelerate the process
signal=decimate(signal,5);

%Parametre d'entré de la boucle indéfinie
choice_redo=1;

while choice_redo == 1
    
    %% Manually define detection threshold, cycle duration and refractory period
    
    % show 10 seconds of data
    figure('units','normalized','outerposition',[0 0 1 1])
    
    
    if config.sFz*20/5 < length(signal)
        % if file duration is greater than 20 seconds (20 sec * sampling
        % frequency / decimation factor), show 10 seconds in the middle 
        debut_signal=round(length(signal)/2);
        fin_signal=debut_signal+round(config.sFz*10/5);
        
        plot(signal(debut_signal:fin_signal))
    else
        % if file duration < 20 second, show all the data
        plot(signal)
    end

    % Define detection threshold
    title('Define detection threshold')
    [~,seuil]=ginput(1);
    
    % Define stride duration
    title('Define stride duration: Click at the beginning of a stride')
    [x(1),~]=ginput(1);
    title('Define stride duration: Click at the end of a stride')
    [x(2),~]=ginput(1);
    duree_cycle=round(x(2)-x(1));
    
    %% Find data points when sync channel is...
    if strcmp(config.trig_direction,'<')
        %... below threshold if we sync on a descending signal
    test=(signal<seuil);
    else
        %... above threshold if we sync on an ascending signal
    test=(signal>seuil);
    end
    
    %% Define the beginning of each stride taking into accound the refractory period
    istride=1; % 1st stride
    identifiant_init(istride)=find(test==1,1,'first');
    
    % Define refractory period based on config file and stride duration
    refractaire=round(config.pct_refractaire*duree_cycle);
    
    itest=2; %itère le no. du point étudié
    h = waitbar(0,'Please wait...');
    
    while itest<length(test)-1
        
        
        if (test(itest)<test(itest+1))&&(itest>(identifiant_init(istride)+refractaire))
            %If we cross threshold, and we are further than the preceding
            %stride than the refractory period: it is a new stride, we
            %record the data point ID, and we progress further than the
            %refractory period
            
            istride=istride+1; 
            identifiant_init(istride)=itest; 
            itest=itest+refractaire; 
            
        else
        %If conditions are not met, we progress by 1 data point
        
        itest=itest+1;
        
        end
        
        waitbar(itest/length(test),h);
    end
    
    
    
    %% We build Cycle_Table which contains: 
    %1, beginning of the strides
    %2, end of the stride
    %3, is the stride valid?(no strides are valid before validation)
    
Cycle_Table(:,1)= identifiant_init(1:end-1)*5;% *5 because of decimation factor
Cycle_Table(:,2)= identifiant_init(2:end)*5;
Cycle_Table(:,3) = 0;

    figure('units','normalized','outerposition',[0 0 1 1])
    % We show the cycle duration and ask if the user is happy
    plot(1:size(Cycle_Table,1),Cycle_Table(:,2)-Cycle_Table(:,1),'bo')
    
choice_redo = menu('Do you want to redefine the threshold','yes','no');
% if not happy, do it again
close; % close waitbar and figure
end

%% Create an offset in the data
Choice_offset=1; %'Do you want to create an offset of the HS position'

while Choice_offset==1 || Choice_offset==2
    
figure('units','normalized','outerposition',[0 0 1 1])

for istride=10:100:size(Cycle_Table,1)
%% Show one stride, every 100 stride, starting at the 10th    
    for isignal = 1:length(Offsetchan)
        % for all signals chosen as offsetchan
    subplot(length(Offsetchan),1,isignal)
    signal = find(strcmp(config.chan_name,Offsetchan{isignal}));
    
    if DiffOffsetchan(isignal) == 0
        % if you don't want to differentiate it, just show the chan
    plot(fdata(Cycle_Table(istride,1):Cycle_Table(istride,2),signal),'b')
    hold on
    title(Offsetchan{isignal})
    else
        % if you want to differentiate it, do it with the defined order
    plot(diff(fdata(Cycle_Table(istride,1):Cycle_Table(istride,2),signal),DiffOffsetchan(isignal)),'b')
    hold on
    title(['diff(', Offsetchan{isignal}, '), ',num2str(DiffOffsetchan(isignal)), ' Order'])
    end
    
    end

end

%% Based on what you see, do you want to create an offset?
Choice_offset = menu('Do you want to create an offset of the HS position','Yes, I want to choose when the strides finish',...
    'Yes, I want to choose when the strides start','No');

if Choice_offset == 1
    %% If you want to create an offset based on the end of the stride
    title('put the ginput where you would like the stride end, focus on one stride')
    desired=ginput(1);
    desired=round(desired(1));
    
    title('put the ginput where the stride presently stop, focus on one stride')
    present=ginput(1);
    present=round(present(1));
    
    % create the offset
    offset=present-desired;
    Cycle_Table(2:end,1)=Cycle_Table(2:end,1)-offset;
    Cycle_Table(2:end,2)=Cycle_Table(2:end,2)-offset;
    
elseif Choice_offset == 2
    %% If you want to create an offset based on the beginning of the stride
    title('put the ginput where you would like the strides to begin')
    offset=ginput(1);
    offset=round(offset(1));
    
    % apply the offset
    Cycle_Table(2:end,1)=Cycle_Table(2:end,1) + offset;
    Cycle_Table(2:end,2)=Cycle_Table(2:end,2) + offset;
    
end 
close

end

%% Create the tables

h=waitbar(0,'please wait');
for istride=size(Cycle_Table,1):-1:1
    
    waitbar(istride/size(Cycle_Table,1),h);
               
        Table{istride} = fdata(Cycle_Table(istride,1):Cycle_Table(istride,2),:).*config.chan_gain;
   
end %for istride

close(h);

%% create reflex indexes
Cycle_Table(:,4)=0; %fourth column is reflex cycle or not

if config.ISRFLX_channel>0 %if there are reflexes
        
    for istride = size(Cycle_Table,1):-1:1
        
        if max(abs(Table{istride}(:,config.ISRRFLX_channel)))>config.detect_level %  By pass detect_onset, detect offset. S'il y a un reflexe mal placé, je veux le savoir
            Cycle_Table(istride,4)=1;
        end
    end
    
end

%% create FF indexes
Cycle_Table(:,5)=0; %fifth column is force field cycle or not

if config.ISFF_channel>0 %if there are FF
    
    for istride= size(Cycle_Table,1):-1:1
        
        if max(abs(Table{istride}(:,config.ISFF_channel)))>config.FFdetect_level % bypass FFdetect_onset et FFdetect_offset. Dans fichier de calibration, c,est tout le cycle
            Cycle_Table(istride,5)=1;
        end
    end
end



%% save tables & stimpos
save('Table_data','Table','Cycle_Table','config');
