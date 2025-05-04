function l=ArousalIndex(x)

%FUNCTION: GENERATE AROUSAL INDEX FROM AROUSAL UNITS GAMMA-THETA
%INPUTS:
%x (arousal units gamma-theta)
%OUTPUTS:
%l (arousal index)


%load pre-fit logistic curve
load('STAT/k');
load('STAT/x_zero');

z=GammaTheta_Zscore(x);
dis_c=Zscore2Scaler(z);
l=Logistic_func(dis_c);






