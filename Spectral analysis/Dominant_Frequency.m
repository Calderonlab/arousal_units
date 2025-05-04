function [df,df_log,df_time,delta_f,delta_time]=Dominant_Frequency(S,f,St)

%THIS SCRIPT DETECTS DOMINANT FREQUENCY
%INPUT
%S (spectrogram in form time x frequency)
%f (frequencies)
%St (times)
%OUTPUT
%df (dominant frequency in Hz)
%df_log (dominant frequency in log-space)
%timepoint (timepoints of dominant frequency)
%delta_f (peak delta frequency in Hz)
%delta_time:timepoints of high power in delta (3-5Hz)



lag=5;threshold=2;influence=0.1;
%newS (mean power of each 50 log-spaced frequency between 2 and 150Hz)
newS=newS_func(f,S);
%freq (50 log-spaced frequencies between 2 and 150Hz)
freq=logspace(log10(2),log10(150),51);
df=[];df_log=[];df_time=[];
delta_f=[];delta_time=[];

for i=1:size(S,1)
    y=newS(i,:);
    %Apply z-score thresholding algorithm
    [signals,~,~] = ThresholdingAlgo(y,lag,threshold,influence);
    x=Peak_Func(signals,y);
    if isempty(x)==0 
     df_log=[df_log;x];
     df_time=[df_time;St(i)];
     df=[df;freq(x(1)),freq(x(2))];
    end
    %3-5Hz
    delta=delta_func(y,freq);
    if isempty(delta)==0
      delta_time=[delta_time;St(i)];
    end
    
 end
    






