function Tracking_Phase_SBI(model,file)
%FUNCTION: AROUSAL UNITS TRACK RECOVERY FROM BLAST BRAIN INJURY

close all;

fh=figure('units','normalized','outerposition',[0 0 1 1], 'Color', [1 1 1]);
set(fh,'DefaultAxesFontName', 'Aerial', 'DefaultAxesFontSize',11, 'DefaultTextFontSize',11, 'DefaultTextFontName', 'Aerial');
row=6;col=3;

path2dataset=Read_Path2Dataset;
vid='00001';
params=get_params(model,file);
[subfile,subtime]=get_subfile(model,file,'00001');
movdoc=ReadExcel(model,file,vid);

%SPECTROGRAM
subplot(row,col,1);
load(fullfile(path2dataset,'/data/',model,'/',file,'/',subfile)); 
[S,St,f]=mtspecgramc(data.lfp,[5,2.5],params);
x_lim=[St(1) St(end)];
for i=1:size(S,1)
    S(i,:)=S(i,:)/sum(S(i,:));
end
S=10*log10(S);
for j=1:size(S,2)
S(:,j)=S(:,j)-median(S(:,j));
end
pcolor(St,f,S');hold on;
shading flat;
colormap('jet');
set(gca,'YLim',[2,150],'Yscale','Log','YTick',[4,8,20,40,150]);
caxis([-5,5]);
set(gca,'XLim',x_lim);


%MOTOR RECOVERY
subplot(row,col,col+1);
movstr=[{[0,0.5]},{[1 1.5]},{[2,2.5]},{[3,3.5]}];
colors_p=[colorset('gray');0,0,1;colorset('dark green');1 0 0];
pset=[-3,-2;-2,-1;-1,0;0,1];
for i=1:length(movstr)
   tf=ismember(movdoc(:,end),movstr{i});
   sub=movdoc(tf,:);
   for j=1:size(sub,1)
     plot(pts_func(sub(j,1:2))*ones(1,2),pset(i,:),'color',colors_p(i,:),'linewidth',1.5);hold on;
   end
end
set(gca,'XLim',x_lim);
set(gca,'YLim',[-3,1]);
set(gca,'visible','off');

%BURST SUPPRESSION AND DELTAWAVES
subplot(row,col,2*col+1);
%load arousal units 
unit=importdata(strcat(path2dataset,'/results/automated detection algorithm/',model,'/',file,'/',vid,'.txt'));
%load spectral variables
load(strcat(path2dataset,'/fd/',model,'/',file,'/',vid));
%10-second time window between arousal units
nonau=NonAu_func(unit,fd,10);
[suppress,deltawave]=BurstSuppression_Deltawaves(nonau,fd,data,subtime,params);
scatter(suppress,zeros(length(suppress),1),30,'x','markeredgecolor','k','linewidth',1.2);hold on;
scatter(deltawave,zeros(length(deltawave),1),30,'d','markeredgecolor','k','linewidth',1.2);hold on;
set(gca,'linewidth',1);
box off;
set(gca,'XLim',x_lim);
set(gca,'visible','off');


%AROUSAL INDEX
subplot(row,col,3*col+1);
%Measure arousal units in gamma-theta space
unit=Unit_GammaTheta(unit,fd);
%Generate arousal index
l=ArousalIndex(unit(:,[5,7]));
t_start=pts_func(unit(:,1:2));
t_end=pts_func(unit(:,3:4));
record_unit=[t_start t_end unit(:,5:end)];
%Concatenate and smooth arousal indexes
[smooth_l,smooth_t]=ArousalIndex2Trajectory(record_unit,l,St(end));
for i=1:size(unit,1)
  t=pts_func(unit(i,:));
  plot([t,t],[0 l(i)],'color',colorset('orange'),'linewidth',1.5);hold on;
end
plot(smooth_t,smooth_l,'-','linewidth',1.5,'color','k');hold on;

set(gca,'linewidth',1);
box off;
set(gca,'YLim',[0 1]);
set(gca,'XLim',x_lim);
xticks([]);
sgtitle(file);
















    
    
   
    










