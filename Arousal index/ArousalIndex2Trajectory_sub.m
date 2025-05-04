function [smooth_l,smooth_t,rsquare]=ArousalIndex2Trajectory_sub(record_unit,l,T,c)

%CONCATENATE AND SMOOTH AROUSAL INDEX GIVEN A SMOOTHING PARAMETER
%INPUTS:
%record_unit  (arousal unit)
%l            (arousal index)
%T            (time length of the recording)
%c            (smoothing parameter)

t_start=record_unit(:,1);
t_end=record_unit(:,2);
delta=T/c;

%%Add zeros before 1st arousal unit
add_t=[0:t_start(1)-1]';
add_l=zeros(length(add_t),1);
pad_t=add_t;
pad_l=add_l;

%%Add zeros between adjacent arousal units
for i=1:length(t_start)-1
    add_t=[t_end(i):delta:t_start(i+1)]';
    add_t(1)=[];
    if ~isempty(add_t) && add_t(end)==t_start(i+1)
        add_t(end)=[];
    end
    add_l=zeros(length(add_t),1);
    pad_t=[pad_t;add_t];
    pad_l=[pad_l;add_l];
end
pad_t=[pad_t;t_start];
pad_l=[pad_l;l];
[pad_t,I]=sort(pad_t,'ascend');
pad_l=pad_l(I);

%Interpolation:
smooth_t=0:t_start(end);
interp_l=interp1(pad_t,pad_l,smooth_t);
%Smooth
smooth_l=smooth(interp_l',T/c);
%rsquare
sse=sum((smooth_l-interp_l').^2);
sst=sum((interp_l-mean(interp_l)).^2);
rsquare=1-sse/sst;

