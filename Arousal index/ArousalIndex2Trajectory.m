function [smooth_l,smooth_t]=ArousalIndex2Trajectory(record_unit,l,T)

%CONCATENATE AND SMOOTH AROUSAL INDEX TO OBTAIN TRAJECTORY OF RECOVERY
%INPUTS:
%record_unit (arousal unit in form row x quantifications
% column 1-4: onset_minute, onset_second, end_minute, end_second
% column 5-8: spectral features at burst: gamma, fractional gamma,
% theta_freq, theta_amplitude)
%l           (arousal index associated with each arousal unit)
%T           (time length of the recovery)

rsquare=[];
for c=10:100
  [~,~,rsquare(end+1)]=ArousalIndex2Trajectory_sub(record_unit,l,T,c);
end

%Find constant ``c" that optimizes the smoothing procedure
j=10:100;
if ~isempty(find(rsquare>0.8))
   c=j(min(find(rsquare>0.8)));
else
   [~,idx]=max(rsquare);
   c=j(idx);
end

[smooth_l,smooth_t]=ArousalIndex2Trajectory_sub(record_unit,l,T,c);
    






