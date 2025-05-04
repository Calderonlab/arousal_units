function subspan=RemoveBurstSuppression(subspan,data,subtime,params)

%FUNCTION: REMOVE SUBSPANS CONTAINING BURST SUPPRESSIONS
%INPUTS:
%subspan   (rows of subspans in form [onset_minute, onset_second, end_minute, end_second])
%data      (structure array containing EEG time series)
%subtime   (time range of epoch)
%params    (parameters of the model)

idx=[];
for i=1:size(subspan,1)
      for j=1:length(params.Ch)
       bsupp=Isoelectric([subspan(i,1:2);subspan(i,3:4)],subtime,data,params,params.Ch(j));
       if sum((bsupp(:,1)<0.02).*(bsupp(:,1)>0))/length(bsupp(:,1))>=0.1
         idx(end+1)=i;
       end
      end
end

idx=unique(idx);
subspan(idx,:)=[];