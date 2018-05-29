function [config] = DefaultConfigGen()
%MainConfigGen Generate the main configuration file for the project
%   Generate Default Configuration file. Configuration file could be edit
%   manually by experimenter directly it the .mat file

%% Channel identifier (all vectors, and cell array {chan names})
config.EMG_channels = [1,2,3,4,5,7]; %Original EMG chan number in WinVisio
config.Other_channels = [8,14,15,16]; %Original chan number (not EMG, not squared) in WinVisio
config.Square_channels = 12; %Original chan number (square waves) in WinVisio
config.chan_name = {'TA','SOL','GM','VL','RF','ST','Knee','CONS_F',...
    'ENCO','COUPLE','HS'};%EMG goes first

%% Identifier event channels with properties (all scalars)
config.ISFF_channel = 8; % Channel with FF command (e.g. CONS_F)
config.FFdetect_level = 5; % Threshold for FF detection (should be an positive scalar)

config.ISRFLX_channel = 0; % Channel to identify RFLX, catch, anticatch (e.g. Memory gate)
config.RFLXdetect_level = 2.5; % Threshold for event channel (should be a positive scalar)

%% Partition table into individual strides (all scalars or char)
config.Sync_channel = 11; % Channel # used to partition data
config.trig_direction = '<'; %Trig direction: '<': descending, '>': ascending
config.trig_diff = 0; % set to diff order of sync chan (0 if no differentiation)
config.trig_lowpass = 0; % Set low pass filter frequency of sync chan (0 if no filter)
config.trig_Nlowpass = 0; % Set low pass order if to be used
config.pct_refractaire = 0.8; % Duration of refractory period (must be between 0 and 1) 

%% Preprocessing properties
config.chan_gain = [250, 250, 250, 250, 250, 250, 90, 4, 4, 10, 1]; % vector with chan gains

config.EMG_filter = [20 450]; % [low pass Fz, High pass Fz 0
config.Other_filter = 15; %[Low pass Fz]
config.Order = 2; % filter order (divide the wanted number by two as we use filtfilt

config.sFz = 1000; % Sampling frequency (scalar)
end
