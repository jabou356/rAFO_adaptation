function combine_data_WinVisio(config)
%COMBINE_DATA_WINVISIO This function is used to combine multiple data files
%extracted from Winvisio using Read_Winvisio_LB. Moreover, data are
%filtered based on config files 
%   INPUT: Config file generated with XXX FUNCTION. Data files are selected
%   in the function
%   OUTPUT: None. Combined raw and filtered data are saved in
%   combined_data.mat in the current directory.
%   
%   Initially developed by Martin Noel and Laurent Bouyer. Modified by
%   Jason Bouffard

%% initiate loop variables 
count=0; %number of files transformed
choice=1; %menu('Process another data file?','yes','no');
%% While user want to select other files
while choice==1
    count=count+1;
    
    % Get the data file
    [fn,pn]=uigetfile('*.*','select a data file');
    load([pn,fn],'-mat');
    
    %% Keep only selected channels, put EMG first
        data=double(data([config.EMG_channels, config.Other_channels, config.Square_channels],2:end))'; %set to double, and ignore first data point (bad in Winvisio)
        rawdata{count} = data;
    %% Preprocess data
    %filter emg
    
   % emgdata=data(:,1:size(EMG_channels,2)); %filtrer juste l'EMG
    
   % for iemg=1:size(EMG_channels,2)
    %    data(:,iemg)=data(:,iemg)-mean(data(:,iemg),1);
  %  end
      
    %% process EMG data
    nemg = length(config.EMG_channels);
    % rebase EMG
    data(:,1:nemg) = data(:,1:nemg)- mean(data(:,1:nemg));
    
    % Filter EMG data
    Fc=config.EMG_filter;
    order=config.Order;
    [b,a] = butter(order,Fc/500);
    fdata{count}=filtfilt(b,a,data(:,1:nemg));
    
    %fdata=abs(fdata); %keep none rectified EMG as long as possible
    
    %% filter other channels
    nothers = length(config.Other_channels);
    
    % Filter Other data
    Fc=config.Other_filter;
    order=config.Order;
    [b,a] = butter(order,Fc/500);
    fdata{count}=[fdata{count},filtfilt(b,a,data(:,nemg+1:nemg+nothers))];
    
    %% Do not filter square channels
    nsquare = length(config.Square_channels);
    fdata{count}=[fdata{count},data(:,nemg+nothers+1:nemg+nothers+nsquare)];
    
    choice=menu('Process another data file?','yes','no');
end %while

%% Concatenate all imported data files
    fdata=cat(1,fdata{:});
    rawdata=cat(1,rawdata{:});
    
%% Save concatenated filtered and raw data       
    save('combined_data','rawdata','fdata');

end
    


