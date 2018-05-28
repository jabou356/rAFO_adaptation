function varargout = GUI_analysis_JB(varargin)
% GUI_ANALYSIS_JB MATLAB code for GUI_analysis_JB.fig
%      GUI_ANALYSIS_JB, by itself, creates a new GUI_ANALYSIS_JB or raises the existing
%      singleton*.
%
%      H = GUI_ANALYSIS_JB returns the handle to a new GUI_ANALYSIS_JB or the handle to
%      the existing singleton*.
%
%      GUI_ANALYSIS_JB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ANALYSIS_JB.M with the given input arguments.
%
%      GUI_ANALYSIS_JB('Property','Value',...) creates a new GUI_ANALYSIS_JB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_analysis_JB_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_analysis_JB_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_analysis_JB

% Last Modified by GUIDE v2.5 25-May-2018 19:14:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_analysis_JB_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_analysis_JB_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI_analysis_JB is made visible.
function GUI_analysis_JB_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_analysis_JB (see VARARGIN)

% Choose default command line output for GUI_analysis_JB
handles.output = hObject;

%% my global variables
handles.MainDir = uigetdir('Go get the parent folder for your project');

% Load or generate default config file
if exist([handles.MainDir, 'config.mat'],'file')
    load([handles.MainDir, 'config.mat'])
    handles.config = config;
else
    config = 
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_analysis_JB wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_analysis_JB_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% MY FUNCTIONS START HERE

%% Single subject data preprocessing / processing
% --------------------------------------------------------------------
function convert_raw_to_mat_Callback(hObject, eventdata, handles)
% hObject    handle to convert_raw_to_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function import WinVisio .raw files into .mat format
Read_WinVisio_LB
disp('file *.mat saved')

% --------------------------------------------------------------------
function Combine_WinVisio_data_Callback(hObject, eventdata, handles)
% hObject    handle to Combine_WinVisio_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function combine multiple .mat files and process data (filters,
% gain, etc.)
%% Load calibration
[fn,pn]=uigetfile('*.mat','select the calibration file');
config=load([pn,fn],'-mat');

combine_data_WinVisio(config)
disp('combined file saved')

% --------------------------------------------------------------------
function Cut_Table_Lokomath_Callback(hObject, eventdata, handles)
% hObject    handle to Cut_Table_Lokomath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%This function cut processed data into individual strides
%% load config file
[filename,pathfile]=uigetfile('*.*','Choisir fichier de calibration');
config = load([pathfile,filename],'-mat');

%% Load combined data file in the current folder
load('combined_data');

%% Cut and save tables
cutTable_Lokomath(config, fdata);
disp('Table_data saved')

% --------------------------------------------------------------------
function Remove_bad_superpose_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_bad_superpose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function open a GUI to clean individual data files
data = load('Table_data.mat');

Signal = input('Which signals would you like to show for validation?{''ENCO'',''CONS_F'',''etc''}');

CTRL = find( data.Cycle_Table(:,4) == 0 & data.Cycle_Table(:,5) == 0);
FF = find( data.Cycle_Table(:,4) == 0 & data.Cycle_Table(:,5) == 1);
RFLX = find( data.Cycle_Table(:,4) == 1 & data.Cycle_Table(:,5) == 0);
RFLXFF = find( data.Cycle_Table(:,4) == 1 & data.Cycle_Table(:,5) == 1);

if ~isempty(CTRL)
bad_cycles = removebad_Superpose1 (data, Signal, CTRL, 'subject','flagDuree');
data.Cycle_Table(bad_cycles,3)=0;
data.Cycle_Table(CTRL(~ismember(CTRL, bad_cycles)),3) = 1;
end

if ~isempty(FF)
bad_cycles = removebad_Superpose1 (data, Signal, FF, 'subject', 'flagDuree');
data.Cycle_Table(bad_cycles,3)=0;
data.Cycle_Table(FF(~ismember(FF, bad_cycles)),3) = 1;
end

if ~isempty(RFLX)
bad_cycles = removebad_Superpose1 (data, Signal, RFLX, 'subject', 'flagDuree');
data.Cycle_Table(bad_cycles,3)=0;
data.Cycle_Table(RFLX(~ismember(RFLX, bad_cycles)),3) = 1;
end

if ~isempty(RFLXFF)
bad_cycles = removebad_Superpose1 (data, Signal, RFLXFF, 'subject', 'flagDuree');
data.Cycle_Table(bad_cycles,3)=0;
data.Cycle_Table(RFLXFF(~ismember(RFLXFF, bad_cycles)),3) = 1;
end

clearvars -except data
v2struct(data)
clear data
save('Table_data.mat')

disp('Table_data saved')

%% Group data organization
% --------------------------------------------------------------------
function Combine_Group_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Combine_Group_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function combine multiple subjects data into a single structure/cell
% array
cd(handles.MainDir)

GroupTablesGeneratorJB
disp('GroupData saved')

% --------------------------------------------------------------------
function Idendification_Cycles_Callback(hObject, eventdata, handles)
% hObject    handle to Idendification_Cycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function identify critical cycles as last baseline, FF or POST
% strides, presences of RFLX, and timing of FF within each stride

[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données GroupData');
load([pn,fn],'-mat');
cd(pn)

if isfield(GroupData,'CONS_F')
[CTRLlast, FFlast, fin, RFLX, stimtiming]=cyclesIdentifiant(GroupData.Cycle_Table,GroupData.CONS_F);
else
[CTRLlast, FFlast, fin, RFLX, stimtiming]=cyclesIdentifiant(GroupData.Cycle_Table);
end


save('CyclesCritiques','CTRLlast','FFlast','fin','RFLX','stimtiming'); 
disp('CyclesCritiques saved')

% --------------------------------------------------------------------
function Synchro_Pushoff_Callback(hObject, eventdata, handles)
% hObject    handle to Synchro_Pushoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function is used to synchronize data on the middle of the PushOff
% based on kinematic data %%% COULD IT BE GENERALIZED TO OTHER
% SIGNALS/EVENTS?

[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données');
load([pn,fn],'-mat');
cd(pn)

[SyncTiming, SyncThreshold, stimtimingSync] = SyncPushoff(GroupData.Cycle_Table,GroupData.ENCO);
save('SyncData','SyncTiming','SyncThreshold', 'stimtimingSync'); 
disp('SyncData saved')

%% Results generators
% --------------------------------------------------------------------
function KinematicAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to KinematicAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function generates Kinematic outcome measures for FF adaptation

% Load GroupData
[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données');
load([pn,fn],'-mat');
cd(pn)

% Load SyncData
useSync = 1; % switch, should be in config file

if useSync
    SyncData = load([pn,'SyncData.mat']);
else
    %If you don't want to use SyncData, use the beginning of each stride
    for isubject = 1:length(GroupData.Cycle_Table)
       SyncData.SyncTiming{isubject}(1:size(GroupData.Cycle_Table{isubject},2))=1;
       SyncData.stimtimingSync{isubject}=cellfun(@(x)(find(x == min(x))),GroupData.CONS_F{isubject});
    end
end

load([pn,'CyclesCritiques.mat']);
criticalCycles = [zeros(1,length(CTRLlast));CTRLlast; FFlast; fin];

conditions = {'Baseline2', 'CHAMP', 'POST'};

AnalENCO = ENCOvariablesgeneratortimenorm(GroupData.Cycle_Table,GroupData.ENCO, conditions, criticalCycles, SyncData);

[filename, pathname]=uiputfile('*.mat','Placez le fichier AnalENCO');
save(filename,'AnalENCO'); 

disp('AnalENCO saved')


% --------------------------------------------------------------------
function TAAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to TAAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%This function generates TA outcome measures for FF adaptation

[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données de groupe');
load([pn,fn],'-mat');
cd(pn)

side=menu('Do you want to Analyse right or left TA?','Right (RTA)','Left (LTA)','Just TA (TA)');
if side==1
    data=Filter_RBI(GroupData.RTA,9,3,1);
    
elseif side==2
    
    data=Filter_RBI(GroupData.LTA,9,3,1);
    
elseif side==3
    
    data=Filter_RBI(GroupData.TA,9,3,1);
    
end

useold=menu('Do you already have AnalTA file?','Yes','No');

if useold==1
    load([pn, 'AnalRBITA.mat']);
else
    AnalTA=[];
end

useSync = 1; % to add in configg
if useSync
    SyncData = load([pn,'SyncData.mat']);
else 
    %If you don't want to use SyncData, use the beginning of each stride
    for isubject = 1:length(GroupData.Cycle_Table)
       SyncData.SyncTiming{isubject}(1:size(GroupData.Cycle_Table{isubject},2))=1;
       SyncData.stimtimingSync{isubject}=cellfun(@(x)(find(x == min(x))),GroupData.CONS_F{isubject});
    end
end

load([pn,'CyclesCritiques.mat']);
criticalCycles = [zeros(1,length(CTRLlast));CTRLlast; FFlast; fin];

conditions = {'Baseline2', 'CHAMP', 'POST'};


[AnalTA]=RBITAvariablesgeneratorTimenorm(GroupData.Cycle_Table,data,conditions,criticalCycles,pn,AnalTA,SyncData);

save([pn, 'AnalRBITA.mat'], 'AnalTA'); 

disp('AnalRBITA saved')

TAratiovariable = EMGratioCode(GroupData,AnalTA, criticalCycles, SyncData, pn);

save([pn, 'TAratio.mat'], 'TAratiovariable'); 

disp('TAratio saved')

% --------------------------------------------------------------------
function COUPLEAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to COUPLEAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function generates COUPLE outcome measures for FF adaptation

% Load GroupData
[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données');
load([pn,fn],'-mat');
cd(pn)

useSync = 0; % to add in configg
if useSync
    SyncData = load([pn,'SyncData.mat']);
else % not tested
    %If you don't want to use SyncData, use the beginning of each stride
    for isubject = 1:length(GroupData.Cycle_Table)
       SyncData.SyncTiming{isubject}(1:size(GroupData.Cycle_Table{isubject},2))=1;
       SyncData.stimtimingSync{isubject}=cellfun(@(x)(find(x == min(x))),GroupData.CONS_F{isubject});
    end
end


% load Cycles critiques (onset and end of each condition)
load([pn,'CyclesCritiques.mat']);
criticalCycles = [zeros(1,length(CTRLlast));CTRLlast; FFlast; fin];

conditions = {'Baseline2', 'CHAMP', 'POST'};

[AnalCOUPLE] = COUPLEtimenormvariablesgenerator(GroupData.Cycle_Table, GroupData.COUPLE, conditions, criticalCycles, SyncData);

[filename, pathname]=uiputfile('*.mat','Placez le fichier AnalCOUPLE');
save(filename,'AnalCOUPLE');

% --------------------------------------------------------------------
function CONSFAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to CONSFAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function generates CONS_F outcome measures for FF adaptation

% Load GroupData
[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données');
load([pn,fn],'-mat');
cd(pn)

% Load SyncData
useSync = 1; % switch, should be in config file

if useSync
    SyncData = load([pn,'SyncData.mat']);
else % not tested
    %If you don't want to use SyncData, use the beginning of each stride
    for isubject = 1:length(GroupData.Cycle_Table)
       SyncData.SyncTiming{isubject}(1:size(GroupData.Cycle_Table{isubject},2))=1;
       SyncData.stimtimingSync{isubject}=cellfun(@(x)(find(x == min(x))),GroupData.CONS_F{isubject});
    end
end

% load Cycles critiques (onset and end of each condition)
load([pn,'CyclesCritiques.mat']);
criticalCycles = [zeros(1,length(CTRLlast));CTRLlast; FFlast; fin];

conditions = {'Baseline2', 'CHAMP', 'POST'};

[AnalCONS_F]=CONS_Fvariablesgeneratortimenorm(GroupData.Cycle_Table, GroupData.CONS_F, conditions, criticalCycles, SyncData);

[filename, pathname]=uiputfile('*.mat','Placez le fichier AnalCONS_Ftimenorm');
save(filename,'AnalCONS_F');

% --------------------------------------------------------------------
function GroupData_TimeNorm_Callback(hObject, eventdata, handles)
% hObject    handle to GroupData_TimeNorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function generate Time normalized vectors for each stride of each
% participant

[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données');
load([pn,fn],'-mat');
cd(pn)

GroupData=TimeNormGroup(GroupData);

save([pn,fn],'GroupData');

