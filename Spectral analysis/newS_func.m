function newS=newS_func(f,S)

%THIS SCRIPT MEASURES MEAN POWER OF EACH 50 LOG-SPACED FREQUENCY BETWEEN 2 AND 150Hz 
%Reference (Jeremy et.al, "Broadband Shifts in Local Field Potential Power
%Spectra Are Correlated with Single-Neuron Spiking in Humans")

freq=logspace(log10(2),log10(150),51);
pos=[];
for i=1:length(freq)-1
    pos(end+1,:)=[min(find(f>freq(i))),max(find(f<freq(i+1)))];
end

for i=1:size(S,1)
    for j=1:size(pos,1)
        newS(i,j)=mean(S(i,pos(j,1):pos(j,2)));
    end
end