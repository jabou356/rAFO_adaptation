%programme combine data

%amelioration de voir_reflex avec validation en continu et synchro un cycle
%sur deux (18 juin 2012) Amélioration, enlève moyenne EMG JASON(19 novembre
%2012)
function combine_data_WinVisio
clear all;

verification=menu('Avez-vous un fichier de calibration et êtes-vous dans le bon dossier de données?','oui','non');

if verification ==2
    plante
end


    
[fn,pn]=uigetfile('*.mat','select the calibration file')

%% Load calibration
load([pn,fn],'-mat');


%% data transformation
k=menu('data will now be prepared','OK');

count=0; %number of files transformed
choice=1;
rawdata=[];
while choice==1
    count=count+1;
    [fn,pn]=uigetfile('*.*','select a data file');
    load([pn,fn],'-mat');
    
        rawdata=data([EMG_channels, Other_channels],:)';
        data=rawdata;
        data(1,1)=data(2,1);
  
    
       
    
    %calibrate data
    data=double(data);
    rawdata=double(rawdata);
    %+++++++++++ICI ON POURRAIT CALIBRER LES DONNEES
    
    numchan=size(data,2); %calcule le nombre de canaux
    
    %filter emg
    h=waitbar(0.5,'Filtering EMG... please wait');
    emgdata=data(:,1:size(EMG_channels,2)); %filtrer juste l'EMG
    
    for i=1:size(EMG_channels,2)
        data(:,i)=data(:,i)-mean(data(:,i),1);
    end
    
    Fc=EMG_filter;
    order=2;
    [b,a] = butter(order,Fc/500);
    fdata=filtfilt(b,a,emgdata);
    
    fdata_display=fdata;
    %fdata=abs(fdata); %keep none rectified EMG as long as possible
    close(h);
    
    %filter other channels
    h=waitbar(0.5,'Filtering other channels... please wait');
    otherdata=data(:,size(EMG_channels,2)+1:size(EMG_channels,2)+size(Other_channels,2)); %filtrer juste les canaux non EMG
    Fc=Other_filter;
    order=2;
    [b,a] = butter(order,Fc/500);
    fdata2=filtfilt(b,a,otherdata);
    close(h);
    
    
    %combine all channels
    fdata=[fdata,fdata2];
    fdata_display=[fdata_display,fdata2];%so that we don<t see rectified EMG

    
    %save data temporarily
    save(['temp_',num2str(count)],'fdata','rawdata');
   fdata=[];
    clear data;
    rawdata=[];;
    
    %ask to continue
    choice=menu('Process another data file?','yes','no');
end; %while

%% data combination
choice=menu('Do you want to combine data files?','yes','no');
if choice==1 %combine temp_n files
    tempdata=[];
    temprawdata=[];
    for i=1:count %number of files to be combined
        s=['load(''temp_',num2str(i),''');']; eval(s);
                        
        tempdata=[tempdata;fdata];
        temprawdata=[temprawdata;rawdata];
        
    end;
    
        fdata=tempdata;
        rawdata=temprawdata;
        clear tempdata;
        save('combined_data','rawdata','fdata');
else %no combination
    load('temp_1'); %load temp file containing fdata
    save('combined_data','rawsata','fdata'); % so from here loading combined data is sufficient
end
    


