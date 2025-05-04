function pts=ChangePts_Detection(locfit_post)

%THIS SCRIPT DETECTS INDICES WHERE THE MATRIX CONTAINING NORMALZIED LOCFIT OF ALL CORTICAL STATES CHANGES MOST DRASTICALLY
%INPUT
%locfit_recorder (normalized and interpolated locfit density per cortical state)

num_state=5;
idx=1:num_state;
z=[];
for i=1:length(idx)  
 if ~isempty(locfit_post{i,2})
  z_timeline=locfit_post{i,1};
  z(end+1,:)=locfit_post{i,2};
 end
end

z=z';
getperiodlong=600;
getperiodshort=150;

ipt=findchangepts(z','MaxNUmChanges',10,'MinDistance',getperiodlong);
%ipt=findchangepts(z','MaxNUmChanges',20,'MinDistance',params.getperiodlong);
%ipt=findchangepts(z','MaxNUmChanges',8,'MinDistance',params.getperiodshort);
pts=z_timeline(ipt);


