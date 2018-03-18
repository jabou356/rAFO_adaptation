
function bad_cycles = removebad_Superpose( data, signal, cycles, type)

% Lorsque cette fonction est utilisé dans un fichier de groupe, il y a
% seulement un signal
if strcmp(type, 'Group')
    data.Table1=data;
    data.chan_name=signal;
    
    if exist('flagDuree','var')
    data.Cycle_Table(cycles,1) = 1;
    data.Cycle_Table(cycles,1)=dureecycles;
    end
    
end

numchan=length(signal);


for isignal=1:numchan
    
    % Trouve le numéro de Table correspondant au signal d'intérêt
    validnum(isignal)=find(strcmp(data.chan_name,signal{isignal})==1);
    
    %Déterminer la limite supérieure et inférieure du signal pour les axes
    top(isignal)=max(data.(['Table' num2str(validnum(isignal))])(:,cycles));
    bottom(isignal)=min(data.(['Table' num2str(validnum(isignal))])(:,cycles));
    
end

figure(1)
clf

%% Initialise the graph
for isignal=1:numchan % Plot each signal
    
    subplot(numchan+1,1,isignal) %numchan2+1
    h(cycles,isignal)=plot(data.(['Table' num2str(validnum(isignal))])(:,cycles))
    
    set(h(cycles,isignal),'color','b')
    
    hold on;
    
    a=axis;
    axis([a(1) a(2) bottom(isignal) top(isignal)])
    
end %For

% Plot length of each trial if flag in varargin
if exist('flagDuree', 'var')
    
for icycle=cycles
    
    subplot(numchan+1,1,numchan+1)
    h(icycle,numchan+1)=plot(icycle,data.Cycle_Table(icycle,2)-data.Cycle_Table(i,1));
    hold on
    
    set(h(i,numchan+1),'color','b','marker','o');
    
end

end

% Plot mean value of Table1 if flag in varargin
if exist('flagMean', 'var')
    
for icycle=cycles
    
    subplot(numchan+1,1,numchan+1)
    h(icycle,numchan+1)=plot(icycle,mean(data.Table1(:,icycle)));
    hold on
    
    set(h(i,numchan+1),'color','b','marker','o');
    
end

end


xlabel('click in the white space when finished');

%% clean data
bad_cycles=[];
count=0;
over=0;

while not(over)
    
    waitforbuttonpress;
    hz=gco;
    [bad,channel]=find(h==hz);
    
    if not(isempty(bad))
        set(h(bad,1:numchan),'color','r','linewidth',2);
        ylabel(bad);
        set(h(bad,numchan+1),'color','r','marker','o')
        
        for i=1:numchan
            uistack(h(bad,i),'top')
        end
        
        confirmation=menu('Non valide?','oui','non');
        
        if confirmation==1
            
            delete(h(bad,:))
            count=count+1;
            bad_cycles(count)=bad;
            
        else
            
            set(h(bad,1:numchan),'color','b','linewidth',0.5);
            set(h(bad,numchan+1),'color','b','marker','o')
        end %if
        
    else
        over=1;
    end; %if
end; %while

close(figure(1))
