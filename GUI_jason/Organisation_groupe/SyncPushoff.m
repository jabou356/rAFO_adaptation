function [SyncTiming, SyncThreshold] = SyncPushoff(Cycle_Table,data)


    load('CyclesCritiques.mat')
    
    N = length(Cycle_Table);
  
    
    question=menu('Avez-vous déjà un fichier de synchro?','oui','non');
    
    if question==2
        x=1;       
    elseif question==1
        load('SyncData.mat')
        x=size(SyncTiming,1)+1;
    end
    
    for isubject=x:N
        figure(1)
        clf
        
        if FF1(isubject)>0
            
            for istride=1:FF1(isubject)-1
                % data(:,j,i)=data(:,j,i)-data(1,j,i); % pour enlever le premier point
                if Cycle_Table{isubject}(3,istride) == 1
                    
                    plot(data{isubject}{istride}(500:end-1),'b')
                    hold on
                    
                end
            end
            
            for istride=POST1(isubject):fin(isubject)
                %data(:,j,i)=data(:,j,i)-data(1,j,i); % pour enlever le premier point
                if Cycle_Table{isubject}(3,istride)==1
                    
                    plot(data{isubject}{istride}(500:end-1),'r')
                    hold on
                    
                end
            end
            
            for istride=FF1(isubject):POST1(isubject)-1
                %data(:,j,i)=data(:,j,i)-data(1,j,i); % pour enlever le premier point
                if Cycle_Table{isubject}(3,istride)==1
                    plot(data{isubject}{istride}(500:end-1),'r')
                    hold on
                    
                end
            end
            
        else
            
            for istride=1:fin(isubject)
                % data(:,j,i)=data(:,j,i)-data(1,j,i); % pour enlever le premier point
                if Cycle_Table{isubject}(3,istride) == 1
                    plot(data{isubject}{istride}(500:end-1),'b')
                    hold on
                    
                end
            end
        end
        
        
        temp=ginput(1);
        SyncThreshold(isubject)=temp(2);
        
        for istride=1:fin(isubject)
            
            if Cycle_Table{isubject}(3,istride) == 1
                temp=find((data{isubject}{istride}(500:end-1)<SyncThreshold(isubject))&(diff(data{isubject}{istride}(500:end))<0));
                if ~isempty(temp)
                    SyncTiming{isubject}(istride)=temp(1)+499;
                else
                    SyncTiming{isubject}(istride)=nan;
                end
                
            else
                    SyncTiming{isubject}(istride)=nan;
            end
            
        end
        

        for istride=1:POST1(isubject)-FF1(isubject)
            stimtimingSync{isubject}(istride)=stimtiming{isubject}(istride)-SyncTiming{isubject}(FF1(isubject)+istride-1);
        end
        
    end
        
    save('CyclesCritiques','FF1','POST1','fin','RFLX','stimtiming','stimtimingSync')
        
        