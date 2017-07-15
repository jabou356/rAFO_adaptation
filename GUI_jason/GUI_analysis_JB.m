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

% Last Modified by GUIDE v2.5 06-Apr-2017 19:54:42

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


% --------------------------------------------------------------------
function Combine_Group_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Combine_Group_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GroupTablesGeneratorJB
disp('GroupData saved')

% --------------------------------------------------------------------
function convert_raw_to_mat_Callback(hObject, eventdata, handles)
% hObject    handle to convert_raw_to_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Read_WinVisio_LB
disp('file *.mat saved')


% --------------------------------------------------------------------
function Cut_Table_Lokomath_Callback(hObject, eventdata, handles)
% hObject    handle to Cut_Table_Lokomath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cutTable_Lokomath
disp('Table_data saved')


% --------------------------------------------------------------------
function Cut_Table_Peak_Velocity_Callback(hObject, eventdata, handles)
% hObject    handle to Cut_Table_Peak_Velocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cutTable_AnkleVelocity
disp('Table_data saved')


% --------------------------------------------------------------------
function Combine_WinVisio_data_Callback(hObject, eventdata, handles)
% hObject    handle to Combine_WinVisio_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

combine_data_WinVisio
disp('combined file saved')


% --------------------------------------------------------------------
function Remove_bad_superpose_Callback(hObject, eventdata, handles)
% hObject    handle to Remove_bad_superpose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = load('Table_data.mat');

Signal = input(['Which signals would you like to show for validation?{''Sig1'',''Sig2'',''etc''}');

CTRL = find( data.Cycle_Table(:,4) == 0 & data.Cycle_Table(:,5) == 0);
FF = find( data.Cycle_Table(:,4) == 0 & data.Cycle_Table(:,5) == 1);
RFLX = find( data.Cycle_Table(:,4) == 1 & data.Cycle_Table(:,5) == 0);
RFLXFF = find( data.Cycle_Table(:,4) == 1 & data.Cycle_Table(:,5) == 1);

if ~isempty(CTLR)
data.Cycle_Table = removebad_Superpose (data, Signal, CTRL, 'subject')
end

if ~isempty(FF)
data.Cycle_Table = removebad_Superpose (data, Signal, FF, 'subject')
end

if ~isempty(RFLX)
data.Cycle_Table = removebad_Superpose (data, Signal, RFLX, 'subject')
end

if ~isempty(RFLXFF)
data.Cycle_Table = removebad_Superpose (data, Signal, RFLXFF, 'subject')
end

clearvars -except data

disp('Table_data saved')


% --------------------------------------------------------------------
function Close_files_Callback(hObject, eventdata, handles)
% hObject    handle to Close_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all


% --------------------------------------------------------------------
function Synchro_Pushoff_Callback(hObject, eventdata, handles)
% hObject    handle to Synchro_Pushoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données');
load([pn,fn],'-mat');

[SyncTiming, SyncThreshold] = SyncPushoff(GroupData.Cycle_Table,GroupData.ENCO);
save('SyncData','SyncTiming','SyncThreshold'); 
disp('SyncData saved')


% --------------------------------------------------------------------
function Idendification_Cycles_Callback(hObject, eventdata, handles)
% hObject    handle to Idendification_Cycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données GroupData');
load([pn,fn],'-mat');

if isfield(GroupData,'CONS_F')
[FF1, POST1, fin, RFLX, stimtiming]=cyclesIdentifiant(GroupData.Cycle_Table,GroupData.CONS_F);
else
[FF1, POST1, fin, RFLX, stimtiming]=cyclesIdentifiant(GroupData.Cycle_Table);
end


save('CyclesCritiques','FF1','POST1','fin','RFLX','stimtiming'); 
disp('CyclesCritiques saved')




% --------------------------------------------------------------------
function BaselineAnkleVariables_Callback(hObject, eventdata, handles)
% hObject    handle to BaselineAnkleVariables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname]=uigetfile('*.mat','Sélectionnez votre fichier de groupe baseline1')
load([pathname,filename])

[ENCO,baseline2,baseline1,cycleID,BASELINE2end,BASELINE1end,deltaENCO, meanABSError,dureeswing,peakDorsi,peakPlant,peakDorsitiming,peakPlanttiming, deltaBaseline1, meanABSdeltabaseline1]=BaselineAnkletimenorm(GroupData.Cycle_Table,GroupData.ENCO);

[filename, pathname]=uiputfile('*.mat','Placez le fichier AnalENCO');
save(filename,'ENCO','baseline2','baseline1','cycleID','BASELINE2end','BASELINE1end','deltaENCO', 'meanABSError','dureeswing','peakDorsi','peakPlant','peakDorsitiming','peakPlanttiming', 'deltaBaseline1', 'meanABSdeltabaseline1'); 

disp('BaselineError saved')


% --------------------------------------------------------------------
function BaselineTAVariables_Callback(hObject, eventdata, handles)
% hObject    handle to BaselineTAVariables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname]=uigetfile('*.mat','Sélectionnez votre fichier de groupe baseline1')
load([pathname,filename])

[TA, baseline1, cycleID, BASELINE1end, BASELINE2end, RMSburstTA, MEANburstTA,debutbouffee, finbouffee, peakTA]=BaselineTA(GroupData.Cycle_Table,GroupData.RTA)

[filename, pathname]=uiputfile('*.mat','Placez le fichier AnalTA');
save(filename,'TA','baseline1','cycleID','BASELINE2end','BASELINE1end','RMSburstTA','MEANburstTA','debutbouffee', 'finbouffee', 'peakTA'); 

disp('BaselineTA saved')


% --------------------------------------------------------------------
function Group_Ankle_Kinematic_Analysis_timenorm_Callback(hObject, eventdata, handles)
% hObject    handle to Group_Ankle_Kinematic_Analysis_timenorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données');
load([pn,fn],'-mat');


[ENCO,baseline2,cycleID,BASELINE2end,CHAMPend,POSTend,deltaENCO,MaxDorsiError,MaxPlantError,meanABSError,meanSIGNEDError,meanUndershoot,percentUndershoot,meanOvershoot,percentOvershoot,dureeswing,peakDorsi,peakPlant,MaxDorsiErrortiming,MaxPlantErrortiming,peakDorsitiming,peakPlanttiming,CoG, CoGrelatif, normPFC]=ENCOvariablesgeneratortimenorm(GroupData.Cycle_Table,GroupData.ENCO);

clear GroupData

[filename, pathname]=uiputfile('*.mat','Placez le fichier AnalENCO');
save(filename,'ENCO','baseline2','cycleID','BASELINE2end','CHAMPend','POSTend','deltaENCO','MaxDorsiError','MaxPlantError','meanABSError','meanSIGNEDError','meanUndershoot','meanOvershoot', 'percentUndershoot', 'percentOvershoot','dureeswing', 'peakDorsi', 'peakPlant', 'MaxDorsiErrortiming', 'MaxPlantErrortiming', 'peakDorsitiming', 'peakPlanttiming','CoG','CoGrelatif','normPFC'); 

disp('AnalENCO saved')


% --------------------------------------------------------------------
function Validation_GroupSync_Callback(hObject, eventdata, handles)
% hObject    handle to Validation_GroupSync (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données');
load([pn,fn],'-mat');

Signal=input('Quel signal voulez-vous valider? ');

s=['GroupData.Cycle_Table=ValidationGroup(GroupData.',Signal,',GroupData.Cycle_Table);'];eval(s);


[filename, pathname]=uiputfile('*.mat','Placez le fichier GroupData');
save(filename,'GroupData');


% --------------------------------------------------------------------
function GroupData_TimeNorm_Callback(hObject, eventdata, handles)
% hObject    handle to GroupData_TimeNorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données');
load([pn,fn],'-mat');

Signal=input('Quel signal voulez-vous valider? ');

s=['[GroupData.',Signal,'Norm,GroupData.',Signal,'Bin,GroupData.Cycle_Table]=TimeNormGroup(GroupData.',Signal,',GroupData.Cycle_Table);'];eval(s);

[filename, pathname]=uiputfile('*.mat','Placez le fichier GroupDataNorm');
save(filename,'GroupData');


% --------------------------------------------------------------------
function AnalENCO_Blanchette2011_Callback(hObject, eventdata, handles)
% hObject    handle to AnalENCO_Blanchette2011 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données');
load([pn,fn],'-mat');
[ENCO,Velocity,dureecycle,deltaENCO,deltaVelocity,meanSIGNEDError,meanABSError,MaxPlantError,MaxDorsiError,meanSIGNEDErrorVelocity,meanABSErrorVelocity,MaxPlantErrorVelocity,MaxDorsiErrorVelocity,MaxPlantErrortiming] = AnalENCO_Blanchette( GroupData.ENCOBin,GroupData.Cycle_Table )

[filename, pathname]=uiputfile('*.mat','Placez le fichier AnalENCO_Blanchette');
save(filename,'ENCO','Velocity','dureecycle','deltaENCO','deltaVelocity','meanSIGNEDError','meanABSError','MaxPlantError','MaxDorsiError','meanSIGNEDErrorVelocity','meanABSErrorVelocity','MaxPlantErrorVelocity','MaxDorsiErrorVelocity','MaxPlantErrortiming');


% --------------------------------------------------------------------
function AnalCOUPLE_mNoel_Callback(hObject, eventdata, handles)
% hObject    handle to AnalCOUPLE_mNoel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données');
load([pn,fn],'-mat');
[COUPLE,rmsCOUPLEtotal,rmsCOUPLE020,rmsCOUPLE20100,meanCOUPLEtotal,meanCOUPLE020,meanCOUPLE20100] = AnalCOUPLE_Noel( GroupData.COUPLENorm,GroupData.Cycle_Table )

[filename, pathname]=uiputfile('*.mat','Placez le fichier AnalENCO_Blanchette');
save(filename,'COUPLE','rmsCOUPLEtotal','rmsCOUPLE020','rmsCOUPLE20100','meanCOUPLEtotal','meanCOUPLE020','meanCOUPLE20100');


% --------------------------------------------------------------------
function Group_CONSF_Analysis_timenorm_Callback(hObject, eventdata, handles)
% hObject    handle to Group_CONSF_Analysis_timenorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

choice=menu('Veux-tu travailler avec des données de groupe ou individuel','GroupeCONS_F','Individuel');

[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données');
load([pn,fn],'-mat');

[CONS_F,peakCONS_F,peakCONS_Ftiming,onsetCONS_Ftiming,BASELINE2end,CHAMPend,POSTend,cycleID]=CONS_Fvariablesgeneratortimenorm(GroupData.Cycle_Table,GroupData.CONS_F);

[filename, pathname]=uiputfile('*.mat','Placez le fichier AnalCONS_Ftimenorm');
save(filename,'CONS_F','peakCONS_F','peakCONS_Ftiming','onsetCONS_Ftiming','BASELINE2end','CHAMPend','POSTend','cycleID');


% --------------------------------------------------------------------
function TAAnal_TimeNorm_Callback(hObject, eventdata, handles)
% hObject    handle to TAAnal_TimeNorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données de groupe');
load([pn,fn],'-mat');

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

[AnalTA]=RBITAvariablesgeneratorTimenorm(GroupData.Cycle_Table,data,pn,AnalTA)

save([pn, 'AnalRBITA.mat'], 'AnalTA'); 

disp('AnalRBITA saved')

TAratiovariable = EMGratioCode(GroupData,AnalTA, pn);

save([pn, 'TAratio.mat'], 'TAratiovariable'); 

disp('TAratio saved')


% --------------------------------------------------------------------
function COUPLEtimenorm_Callback(hObject, eventdata, handles)
% hObject    handle to COUPLEtimenorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fn,pn]=uigetfile('*.mat','Choisi ton fichier de données');
load([pn,fn],'-mat');

[COUPLE, baseline2, cycleID, BASELINE2end, CHAMPend, POSTend,deltaCOUPLE, peakCOUPLE, peakCOUPLEtiming]=COUPLEtimenormvariablesgenerator(GroupData.Cycle_Table,GroupData.COUPLE)

clear GroupData

[filename, pathname]=uiputfile('*.mat','Placez le fichier AnalTA');
save(filename,'COUPLE','baseline2','cycleID','BASELINE2end','CHAMPend','POSTend','deltaCOUPLE', 'peakCOUPLE','peakCOUPLEtiming');
