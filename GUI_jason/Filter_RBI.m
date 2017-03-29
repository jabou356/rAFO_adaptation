
function FilterRBI
[fn,pn]=uigetfile('*.mat','select the calibration file');
load([pn,fn],'-mat');

[fn,pn]=uigetfile('*.mat','select the data file');
load([pn,fn],'-mat');

lenght=size(data(:,:),2);

Signal=input('Quel signal voulez-vous filtrer? ');

%Détermine le numéro de table du signal d'intérêt à partir du fichier
%de calibration
s=['numSignal=find(strcmp(chan_name(1,:),',char(39),Signal,char(39),')==1);'];eval(s);
clear s


for i=5:lenght-4
    
    s=['fdata(:,i-4)=mean(abs(data(',num2str(numSignal),',i-4:i+4)),2);'];eval(s);
        
end

%----------------%
% Enregistrer
%----------------%
cd(pn); %On va dans le repertoire du sujet traité

% Enregistrement des données
[outfn,outpn]=uiputfile([fn]);
save([outpn,outfn],'data','fdata','Signal');



