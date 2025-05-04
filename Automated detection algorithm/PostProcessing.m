function subspan=PostProcessing(subspan, params, data, subtime,fd,S)

%REMOVE SUBSPANS WITH SHORT LATENCIES, CONTAINING BURST SUPPRESSIONS
%OR ACOUSTIC CONTAMINATIONS

if isfield(params,'min_dur')
    subspan(Duration_func(subspan)<params.min_dur,:)=[];
end
if isfield(params,'burst_suppression')
    subspan=RemoveBurstSuppression(subspan,data,subtime,params); %%must add
end
if isfield(params,'acoustic')
   [subspan,~]=RemoveAcoustic(subspan,fd,S);
end