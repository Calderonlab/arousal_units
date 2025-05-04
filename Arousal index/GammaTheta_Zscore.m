function z=GammaTheta_Zscore(x)

%FUNCTION: Z-SCORE NORMALIZED GAMMA-THETA OF AROUSAL UNITS
%USE MEAN AND STANDARD ESTIMATED FROM ALL AROUSAL UNITS IN PERIOD FIVE 


load('STAT/miu');
load('STAT/sigma');

for i=1:size(x,2)
  z(:,i)=(x(:,i)-miu(i))/sigma(i);
end