function [z_timeline,z]=Normalize_Interpolate_Locfit(x,y,T,input)

%%THIS SCRIPT NORMALIZED AND INTERPOLATED LOCFIT DENSITY 
%%out:z-scored locfit density estimation per second
%%input: x (time),y (density) are direct results from locfit.m function 
%%method: interpolate x into per second including perform 1D interpolation
%between y(1):y(end) and add zeros for 0:y(1), y(end):T
%then apply z-score normalization


z_timeline=ceil(x(1)):floor(x(end));
y_interp=interp1(x,y,z_timeline);
add_front=0:z_timeline(1);
add_back=z_timeline(end):T;

z_timeline=[add_front,z_timeline,add_back];
y=[zeros(1,length(add_front)),y_interp,zeros(1,length(add_back))];

if strcmp(input,'zscore')==1
z=(y-mean(y))/std(y);
elseif strcmp(input,'nozscore')==1
z=y;
end





