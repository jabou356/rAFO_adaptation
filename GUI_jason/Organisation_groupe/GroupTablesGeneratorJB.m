% Programme servant � combiner les donn�es afin de cr�er des populations
function GroupData = GroupTablesGenerator

clear all
clc


Question=menu('Avez-vous d�j� un fichier de groupe?','oui','non');
Signal=input('Quel signal voulez-vous int�grer? ');


if Question==1
    %Si vous avez un fichier de groupe, chargez le fichier de groupe
    [filename,pathname]=uigetfile('*.mat','S�lectionnez votre fichier de groupe')
    load([pathname,filename])
    
    % D�termine le nombre de sujet d�j� entr� dans le fichier (Max n=30)
    s=['tempN=find(isnan(GroupData.',cell2mat(Signal(1)),'(1,1,:))==1)'];eval(s);
     clear s ;
    N=tempN(1)-1;
  
    
else
    
    for i=1:length(Signal)
    %Si vous n'avez pas de fichier de groupe, en cr�e un
    tempSignal=cell2mat(Signal(i));
    N=0;
    s=['GroupData.',tempSignal,'(1:1500,1:1200,1:30)=nan'];eval(s);
     clear s 
    end
    
    GroupData.Cycle_Table(1:5,1:1200,1:30)=nan;
   
end

Question=menu('Avez vous des fichiers � int�grer?','oui', 'non')

while Question==1
    
    clear Table* chan_name Cycle_Table ISRFLX_channel numchan num* s templenght onsetFF
    N=N+1;
    
    % Va chercher le fichier de donn�e du sujet N
    [filename,pathname]=uigetfile('*.mat','S�lectionnez votre fichier contenant votre table de donn�es')
    load([pathname,filename])
      
    for i=1:length(Signal)
        %D�termine le num�ro de table du signal d'int�r�t � partir du fichier
        %de calibration
        tempSignal=cell2mat(Signal(i));
        s=['numSignal=find(strcmp(chan_name(1,:),',char(39),tempSignal,char(39),')==1);'];eval(s);
        clear s
        
        %Va chercher les donn�es dans la table du signal d'int�r�t
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
    
    
    
    Question=menu('Avez vous des fichiers � int�grer?','oui', 'non')
end %while

[filename,pathname]=uiputfile('*.mat');
s=['save(',char(39),[pathname,filename],char(39),',',char(39),'GroupData',char(39),')'];eval(s); %Probl�me!! Je ne peux pas overwriter