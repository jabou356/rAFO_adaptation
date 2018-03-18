
% Programme servant à combiner les données afin de créer des populations
function GroupData = GroupTablesGenerator

clear all
clc


Question=menu('Avez-vous déjà un fichier de groupe?','oui','non');
Signal=input('Quel signal voulez-vous intégrer? ');


if Question==1
    %Si vous avez un fichier de groupe, chargez le fichier de groupe
    [filename,pathname]=uigetfile('*.mat','Sélectionnez votre fichier de groupe')
    load([pathname,filename])
    
    % Détermine le nombre de sujet déjà entré dans le fichier (Max n=30)
    s=['tempN=find(isnan(GroupData.',cell2mat(Signal(1)),'(1,1,:))==1)'];eval(s);
     clear s ;
    N=tempN(1)-1;
  
    
else
    
    for i=1:length(Signal)
    %Si vous n'avez pas de fichier de groupe, en crée un
    tempSignal=cell2mat(Signal(i));
    N=0;
    s=['GroupData.',tempSignal,'(1:1500,1:1200,1:30)=nan'];eval(s);
     clear s 
    end
    
    GroupData.Cycle_Table(1:5,1:1200,1:30)=nan;
   
end

Question=menu('Avez vous des fichiers à intégrer?','oui', 'non')

while Question==1
    
    clear Table* chan_name Cycle_Table ISRFLX_channel numchan num* s templenght onsetFF
    N=N+1;
    
    % Va chercher le fichier de donnée du sujet N
    [filename,pathname]=uigetfile('*.mat','Sélectionnez votre fichier contenant votre table de données')
    load([pathname,filename])
      
    for i=1:length(Signal)
        %Détermine le numéro de table du signal d'intérêt à partir du fichier
        %de calibration
        tempSignal=cell2mat(Signal(i));
        s=['numSignal=find(strcmp(chan_name(1,:),',char(39),tempSignal,char(39),')==1);'];eval(s);
        clear s
        
        %Va chercher les données dans la table du signal d'intérêt
        s=['GroupData.',tempSignal,'(:,1:size(Table1,2),N)=Table',num2str(numSignal),'(1:1500,:);'];eval(s);
        clear s
        
        if size(Table1,2)<1200
            s=['GroupData.',tempSignal,'(:,size(Table1,2)+1:end,N)=nan'];eval(s);
            clear s
            
        end
        
    end
    
    GroupData.Cycle_Table(:,1:size(Table1,2),N)=Cycle_Table(:,:)';
    GroupData.Cycle_Table(:,size(Table1,2)+1:end,N)=nan;
    
    
    %Pad le reste du fichier avec des NAN pour garder une grandeur de table
    %constante ( 1200 > que le nombre de cycles de marche)
    
    
    
    Question=menu('Avez vous des fichiers à intégrer?','oui', 'non')
end %while

[filename,pathname]=uiputfile('*.mat');
s=['save(',char(39),[pathname,filename],char(39),',',char(39),'GroupData',char(39),',''-v7.3'')'];eval(s); %Problème!! Je ne peux pas overwriter
