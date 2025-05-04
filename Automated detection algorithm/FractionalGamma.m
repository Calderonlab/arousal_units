function fg=FractionalGamma(S)
%FUNCTION: CALCULATE FRACTIONAL GAMMA FROM SPECTRUM

for i=1:size(S)
    y=S(i,:);
    fg(i,1)=10*nanmean(y(70:100))/nanmean(y);
end







