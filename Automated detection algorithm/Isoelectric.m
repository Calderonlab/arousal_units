function bsupp=Isoelectric(ms,subtime,data,params,Ch)

%THIS SCRIPT DETECTS ISOELECTRIC LINES AS A MEASURE OF BURST-SUPPRESSIONS
%INPUTS:
%ms      (target time range for detection of burst suppression; 
%        consists of two rows, first row is start time, second time is the end time)
%subtime (time range of epoch)
%data    (structure array containing EEGs)
%params  (parameters of the model)
%Ch      (index of channel)

t=[pts_func(ms(1,:)) pts_func(ms(end,1:2))+params.movingwin];
t=subtime(1)+t;
c=data.lfp(max([1,t(1)*params.Fs]):t(2)*params.Fs,Ch);
c=locdetrend(c,params.Fs,[1 0.5]);

bsupp=[];
%Use 0.5 seconds nonoverlapping slide window
delta=0.5*params.Fs;
count=1;
for i=1:delta:length(c)
    if i+delta>length(c)
        break;
    end
    clip=c(i:i+delta);
    bsupp(end+1,:)=[mean(abs(clip)),std_err(abs(clip)),transtime(t(1)+(count-1)*0.5)];
    count=count+1;
end

