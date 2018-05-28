function [config] = DefaultConfigGen(inputArg1,inputArg2)
%MainConfigGen Generate the main configuration file for the project
%   Generate Default Configuration file. Configuration file could be edit
%   manually by experimenter directly it the .mat file

%% Channel identifier
config.EMG_channels = [1,2,3,4,5,7]; %Original chan number in WinVisio
config.chan_name = {'TA','SOL','GM','VL','RF','ST','Knee','CONS_F',...
    'ENCO','COUPLE','HS'};%EMG goes first
config.Other_channels = [8,14,15,16];
config.Square_channels = 12;

%% Identifier event and sync channels with properties
config.ISFF_channel = 8;
config.FFdetect_level = 5;

config.ISRFLX_channel = 0;
config.RFLXdetect_level = 2.5;

config.Sync_channels = 11;
config.trig_direction = '<';
config.pct_refractaire = 0.8;

%% Preprocessing properties
config.chan_gain = [250, 250, 250, 250, 250, 250, 90, 4, 4, 10, 1];

config.EMG_filter = [20 450];
config.Other_filter = 15;
config.Order = 2;

config.sFz = 1000;
end

