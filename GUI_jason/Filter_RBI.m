
function fdata = FilterRBI(data,windowlength,type,dim)
% This function do a Rectified bin averaging filtering of EMG data
%Inputs: data: 2d or 3d Data tables
% window length: Length of the rbi window
%type: 1=vector; 2= matrixè 3= 3D matrix
%dim: dimension of the table corresponding to time

dimension=size(data);

if type == 3
    
fdata(1:dimension(1),1:dimension(2),1:dimension(3))=nan;

    if dim == 1
       
        for itime=ceil(windowlength/2):dimension(1)-ceil(windowlength/2)
            fdata(itime,:,:)=mean(data(itime-ceil(windowlength/2):itime+ceil(windowlength/2),:,:),1);
        end
    end
    
end

 



