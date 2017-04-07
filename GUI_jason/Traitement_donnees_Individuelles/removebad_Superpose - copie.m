
function data.Cycles_Table = removebad_Superpose( data, signal, cycles )

numchan=length(signal);
dureecycle=size(data.Cycles_Table,2);

j=0;
for isignal=1:numchan
    j=j+1;
    validnum(isignal)=find(strcmp(data.chan_name,signal{i})==1);
    
    s=['top(j)=max(data.Table' num2str(validnum(isignal)) '(:,cycles)']; eval(s);
    s=['bottom(j)=min(data.Table' num2str(validnum(isignal)) '(:,cycles)']; eval(s);
    
end

%Procedure Baseline
figure(1)
clf
j=0;
for isignal=1:numchan
    j=j+1;
    subplot(numchan+1,1,j) %numchan2+1
    s=['plot(','Table',num2str(validnum(isignal)),'(:,cycles))'];
    
    
    h(cycles,j)=eval(s);
    set(h(cycles,j),'color','b')
    
    hold on;
    
    a=axis;
    axis([0 dureecycle bottom(j) top(j)])
    
end %For

for i=cycles
    subplot(numchan2+1,1,numchan2+1)
    s=['plot(i,Cycle_Table(i,2)-Cycle_Table(i,1))'];
    h(i,numchan2+1)=eval(s);
    hold on
    set(h(i,numchan2+1),'color','b','marker','o');
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
        set(h(bad,1:numchan2),'color','r','linewidth',2);
        ylabel(bad);
        set(h(bad,numchan2+1),'color','r','marker','o')
        
        for i=1:numchan2
            uistack(h(bad,i),'top')
        end
        
        confirmation=menu('Non valide?','oui','non');
        
        if confirmation==1
            
            delete(h(bad,:))
            count=count+1;
            bad_cycles(count)=bad;
            
        else
            
            set(h(bad,1:numchan2),'color','b','linewidth',0.5);
            set(h(bad,numchan2+1),'color','b','marker','o')
        end %if
        
    else
        over=1;
    end; %if
end; %while

data.Cycle_Table(:,3)=1;
data.Cycle_Table(bad_cycles,3)=0;

close(figure(1))
