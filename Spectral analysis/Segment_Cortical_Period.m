function [locfit_post,pts]=Segment_Cortical_Period(spikes,df_time,delta_time,T)

%SEGMENTATION OF CORTICAL PERIODS
%INPUT
%spikes (classification of cortical states 4-8Hz,10-20Hz,20-40Hz, 30-100Hz and 70-130Hz)
%df_time (time of cortical states)
%delta_time (time of cortical state 3-5Hz)
%OUTPUT
%locfit_post (normalized and interpoloated locfit density per cortical state)
%pts (time when locfit changes most drastically)

%locfit density (normalized and interpolated) of each cortical state as a function of time
locfit_post=LocfitDensity(spikes,df_time,delta_time,T);
%Identify timepoints where locfit changes most drastically
pts=ChangePts_Detection(locfit_post);
