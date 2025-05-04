function z=DeltaPower(S)

%FUNCTION: CALCULATE DELTA POWER
for i=1:size(S,1)
    y=S(i,:);
    z(i,1)=nanmean(y(1:15));
end