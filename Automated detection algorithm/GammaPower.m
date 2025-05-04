function g=GammaPower(S,params)

%FUNCTION: CALCULATE GAMMA POWER

for i=1:size(S,1)
  y=S(i,:);
  dby=10*log10(y);  
  g(i,1)=nanmean(dby(70:100))+params.offset;
end





















