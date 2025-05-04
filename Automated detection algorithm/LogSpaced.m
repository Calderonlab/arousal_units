function [z,freq]=LogSpaced(f,subS,num_freq)

%FUNCTION: CALCULATE LOG SPACED SPECTRUM THAT MEASURES POWER FOR EACH 100 LOG-SPACED FREQUENCY BETWEEN 2-150HZ
%REFERENCE: Jeremy et.al, "Broadband Shifts in Local Field Potential Power Spectra Are
%Correlated with Single-Neuron Spiking in Humans"

freq=logspace(log10(2),log10(150),num_freq+1);

for i=1:length(freq)-1
    idx=intersect(find(f>freq(i)),find(f<freq(i+1)));
    if ~isempty(idx)
        z(i)=mean(subS(min(idx):max(idx)));
    elseif isempty(idx) && freq(i)<max(f)
        [~,idx]=min(abs(f-freq(i)));
        z(i)=subS(idx);
    else
        z(i)=NaN;
    end
   
end




