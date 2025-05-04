function [k,x_zero]=Logistic_fit(dis_c)

%FIT A LOGISTIC CURVE TO GENERATE AROUSAL INDEX BY SETTING DISTANCE
%BETWEEN CENTROIDS

%INPUTS:
%dis_c  (Z-scored scalers of cortical periods P2-P5)

k=(log(1/0.1-1)-log(1/0.9-1))/(dis_c(2)-dis_c(5));
x_zero=dis_c(2)-log(1/0.1-1)/k;

