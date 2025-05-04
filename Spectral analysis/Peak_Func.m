function df_log=Peak_Func(signals,y)

%THIS SCRIPT DETECTS SPANS OF ``1"s IN SIGNALS WITH HIGHEST MEAN POWER
%INPUT
% signals (sequence of zeros and ones) 
% y (power)
%OUPTUT
% df_log (dominant frequency band in log-space)

freq=logspace(log10(2),log10(150),51);
%Zero signals with frequencies <4Hz to avoid artifacts
signals(freq<4)=0;
df_log=[];
%Find spans of ``1"s in signals
start_ones=strfind([0,(signals==1)'],[0,1]);
stop_ones=strfind([(signals==1)',0],[1,0]);
x=[start_ones',stop_ones'];
%Choose spans of ``1"s with length>=5 
if ~isempty(x)
x=x(x(:,2)-x(:,1)>=5,:);
if ~isempty(x)
for i=1:size(x,1)
  p(i)=mean(y(x(i,1):x(i,2)));
end
%Span with highest mean power was determined as the signle dominant frequency band
[~,pos]=max(p);
df_log=x(pos,:);
end
end










    




