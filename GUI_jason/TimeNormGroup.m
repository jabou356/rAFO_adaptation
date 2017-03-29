function [ datanorm,databin,Cycle_Table] = TimeNormGroup( data,Cycle_Table )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n=find(isnan(Cycle_Table(1,1,:))==1);
    if n>0
        n=n(1)-1;
    else
        n=30;
    end
    
    for i=1:n
        temp=find(isnan(Cycle_Table(1,:,i))==1);
        
        if temp>0
        nbrcycle=temp(1)-1;
        else
            nbrcycle=size(Cycle_Table(1,:,i),2);
        end
        
        for j=1:nbrcycle
            
            dureecycle(j,i)=Cycle_Table(2,j,i)-Cycle_Table(1,j,i)+1;
            
            if dureecycle(j,i)<1500
            
            datanorm(:,j,i)=interp1(1:dureecycle(j,i),data(1:dureecycle(j,i),j,i),1:(dureecycle(j,i)-1)/999:dureecycle(j,i));
            else
            datanorm(:,j,i)=interp1(1:1500,data(1:1500,j,i),1:(1499)/999:1500);
            
            end
            
            for k=1:50
                databin(k,j,i)=mean(datanorm((k-1)*20+1:k*20,j,i),1);
            end
        
    end
            
        
        

end

