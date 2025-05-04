function Spectral_analysis(model,file)
%FUNCTION: DERIVATION OF CORTICAL PERIODS AND MOTOR RECOVERY DURING
%SUBJECTS EMERGE FROM VARIOUS COMATOSE MODELS

fh=figure('units','normalized','outerposition',[0 0 1 1], 'Color', [1 1 1]);
set(fh,'DefaultAxesFontName', 'Helvetica', 'DefaultAxesFontSize', 8, 'DefaultTextFontSize', 8, 'DefaultTextFontName', 'Helvetica');

path2dataset=Read_Path2Dataset;

%Load file, containing EEGs and spectrogram
load(strcat(path2dataset,'/data/',model,'/',file,'/',file));
params=get_params(model,file);

%Normalized spectrogram (deviation from median)
St=data.St;f=data.f;S=data.S;
for i=1:size(S,1)
      S(i,:)=S(i,:)/nansum(S(i,:));
end
S=10*log10(S);
for j=1:size(S,2)
S(:,j)=S(:,j)-nanmedian(S(:,j));
end
x_lim=[St(1),St(end)];T=St(end);

%Calculate dominant frequency
[df,df_log,df_time,delta_f,delta_time]=Dominant_Frequency(S,f,St);
%Classify dominant frequency to cortical state
spikes=Cortical_State(df_log);
%Segment cortical period
[locfit_post,pts]=Segment_Cortical_Period(spikes,df_time,delta_time,data.St(end));

fh=figure('units','normalized','outerposition',[0 0 1 1], 'Color', [1 1 1]);
set(fh,'DefaultAxesFontName', 'Helvetica', 'DefaultAxesFontSize', 11, 'DefaultTextFontSize', 11, 'DefaultTextFontName', 'Helvetica');
row=7;col=4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PLOT%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(model,'iso')
   %For isoflurane long ramps, read isoflurane concentration
   [iso,isotrans]=ReadIsoTrans(model,file,params);
   subplot(row,col,1:3);
   Subplot_isotrans(iso,isotrans,'pink',T,'writeiso');
   set(gca,'XLim',x_lim);
   set(gca,'YLim',[-1.5,2]);
   set(gca,'visible','off');
end

%EEGs
subplot(row,col,col+[1,2,3]);
t=0:1/params.Fs:(length(data.lfp)-1)/params.Fs;
plot(t,data.lfp(:,1));hold on;
set(gca,'XLim',x_lim);
set(gca,'YLim',[-1 1]);
set(gca,'visible','off');

%Spectrogram
subplot(row,col,2*col+[1,2,3]) 
pcolor(St,f,S');hold on;
shading flat;
colormap('jet');
set(gca,'YLim',[2,150],'Yscale','Log','YTick',[4,8,20,40,150]);
caxis([-5 5]);
set(gca,'XLim',x_lim);

%Dominant frequency, cortical state
subplot(row,col,3*col+[1,2,3]);
load('plotting');
idx=1:6;
for i=1:length(idx)
    pos=find(spikes==i);
    for j=1:length(pos)
    plot([df_time(pos(j)),df_time(pos(j))],df(pos(j),:),'color',plotting.statecolor(i,:));hold on;
    end
end
for i=1:length(delta_f)
    plot([delta_time(i),delta_time(i)],delta_f(i,:),'k');hold on;
end
set(gca, 'YScale', 'log','YLim',[2,150]);
set(gca,'XLim',xlim);
yticks([4,8,20,40,150]);
yticklabels({'4','8','20','40','150'});
box off
set(gca,'XLim',x_lim);
set(gca,'linewidth',1);

%Locfit density
subplot(row,col,4*col+[1,2,3]);
ylim.locfit=[-1,4.5];
for i=1:5
 plot(locfit_post{i,1},locfit_post{i,2},'color',plotting.statecolor(i,:),'linewidth',1.5);hold on;
end
for i=1:length(pts)
    plot([pts(i),pts(i)],ylim.locfit,'r','linewidth',2);hold on;
    text(pts(i),ylim.locfit(2),num2str(i));
end
set(gca,'XLim',x_lim);
set(gca,'YLim',[0,6]);
box off;
set(gca,'linewidth',1);

%Cortical periods
subplot(row,col,5*col+[1,2,3]); 
load(strcat('STAT/ipt/',model,'/',file));
for p=1:5
if isfield(ipt,strcat('P',num2str(p)))
    c=getSegmentation(ipt.(strcat('P',num2str(p))),ipt.pts,data.St(end));
    plot(c,[0,0],'k','linewidth',1);hold on;
    if c(1)~=0
    plot([c(1),c(1)],[-0.3,0.3],'--','color',colorset('magenta'),'linewidth',1.5);hold on;
    end
    if c(2)~=data.St(end)
    plot([c(2),c(2)],[-0.3,0.3],'--','color',colorset('magenta'),'linewidth',1.5);hold on;
    end
    text(mean(c),0.2,num2str(p));hold on; 
end
end
set(gca,'linewidth',1);
set(gca,'XLim',x_lim);
set(gca,'YLim',[-1,1]);
set(gca,'visible','off');


%Motor recovery
subplot(row,col,6*col+[1,2,3]); 
movdoc=[];
[vidlist,vidtime]=get_Vidlist(model,file,{'all'});
for i=1:length(vidlist)
toadd=ReadExcel(model,file,vidlist{i}); %[min second min second type_of_movement]
if ~isempty(toadd)
movdoc=[movdoc;toadd(:,1)*60+toadd(:,2)+vidtime(i,1),toadd(:,5)];
end
end
movstr=[{[0]},{[1 1.5]},{[2 2.5]},{[3 3.5]}];
colors_p=[colorset('gray');0,0,1;colorset('dark green');1 0 0];
Subplot_behavior(movdoc,movstr,colors_p);
set(gca,'XLim',x_lim);
box off;
set(gca,'linewidth',1);
set(gca,'YLim',[-3,1]);
set(gca,'visible','off');
sgtitle(file);








