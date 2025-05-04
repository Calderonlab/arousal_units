function l=Logistic_func(dis_c)

%TRANSFORM DISTANCE SCALER TO AROUSAL INDEX BASED ON PRE-FIT LOGISTIC CURVE

load('STAT/k');
load('STAT/x_zero');

l=[];
for i=1:length(dis_c)
 l(i,1)=1/(1+exp(k*(dis_c(i)-x_zero)));
end