
function data.Cycles_Table = removebad_Superpose( data, signal, cycles, type, varargin )

if strcmp(type, 'Group')
    data.Table1=data;
    data.Cycle_Table=GroupData.CycleTable(:,:,isubject);

numchan=length(signal);
dureecycle=size(data.Cycles_Table,2);

j=0;
for isignal=1:numchan
    j=j+1;
    validnum(isignal)=find(strcmp(data.chan_name,signal{i})==1);
    
    top(j)=max(data.(['Table' num2str(validnum(isignal))])(:,cycles));
    bottom(j)=min(data.(['Table' num2str(validnum(isignal))])(:,cycles));
    
end

%Procedure Baseline
figure(1)
clf
j=0;
for isignal=1:numchan
    subplot(numchan+1,1,isignal) %numchan2+1
    h(cycles,isignal)=plot(data.(['Table' num2str(validnum(isignal))])(:,cycles))
    
    set(h(cycles,j),'color','b')
    
    hold on;
    
    a=axis;
    axis([0 dureecycle bottom(j) top(j)])
    
end %For

for icycle=cycles
    
    subplot(numchan+1,1,numchan+1)
    h(icycle,numchan+1)=plot(icycle,data.Cycle_Table(icycle,2)-data.Cycle_Table(i,1));
    hold on
    
    set(h(i,numchan+1),'color','b','marker','o');
    
end

xlabel('click in the white space when finished');

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

data.Cycle_Table(:,3)=1;
data.Cycle_Table(bad_cycles,3)=0;

close(figure(1))
