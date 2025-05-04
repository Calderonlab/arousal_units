function locfit_post=LocfitDensity(spikes,df_time,delta_time,T)

%LOCFIT DENSITY FOR EACH CORTICAL STATE AS A FUNCTION OF TIME
%INPUT
%spikes (index of cortical state)
%timepoint (time)
%delta_timepoint (timepoints when 3-5Hz were significant)
%OUTPUT
%locfit_post (density estimation of each cortical state, in form of time X density)

num_state=6;
c=cell(num_state,1);
leastspikes=100;locfit_params=0.05;
for i=1:6
   if i~=6
      c{i}=df_time(spikes==i);
   else  
      c{i}=delta_time;
   end
   if length(c{i})>leastspikes
      fit{i}=locfit(c{i},'family','rate','nn',locfit_params);
   else
      fit{i}=[];
   end
end

locfit_raw=cell(num_state,2);
for i=1:num_state
figure(i);
subplot(12,2,1);
if isempty(fit{i})==0
    lfplot(fit{i});
    h = findobj(gca,'Type','line');
    x=get(h,'Xdata') ;
    y=get(h,'Ydata') ;
    locfit_raw{i,1}=x{2,1};
    locfit_raw{i,2}=y{2,1};
    close all;
    
else
    locfit_raw{i,1}=[];
    locfit_raw{i,2}=[];
end
end

%Normalize and interpolate locfit
for i=1:num_state
x=locfit_raw{i,1};
y=locfit_raw{i,2};
if ~isempty(x)
  [locfit_post{i,1},locfit_post{i,2}]=Normalize_Interpolate_Locfit(x,y,T,'zscore'); 
end
end




