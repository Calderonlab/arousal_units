function Tracking_Phase_Iso(model,file)

close all;
fh=figure('units','normalized','outerposition',[0 0 1 1], 'Color', [1 1 1]);
set(fh,'DefaultAxesFontName', 'Helvetica', 'DefaultAxesFontSize', 11, 'DefaultTextFontSize', 11, 'DefaultTextFontName', 'Helvetica');
row=7;col=2;


path2dataset=Read_Path2Dataset;
params=get_params(model,file);
[vidlist,vidtime]=get_Vidlist(model,file,{'all'});
%Read ramps if isoflurane long ramps
if strcmp(model,'iso')
subfiles=[];
for i=1:length(vidlist)
    [subfile,~]=get_subfile(model,file,vidlist{i});
    if ~ismember(subfile,subfiles)
        subfiles{end+1}=subfile;
    end
end

iso=[];isotrans=[];add=0;
for i=1:length(subfiles)
    path=strcat(path2dataset,'/data/',model,'/',file,'/',subfiles{i},'.mat');
    if isfile(path)
      load(path);
      iso=[iso,data.iso];
      isotrans=[isotrans,add+data.isotrans];
      add=add+length(data.lfp)/params.Fs;
    end
end
end

path=strcat(path2dataset,'/data/',model,'/',file,'/',file,'.mat');load(path);
%Read spectrogram
St=data.St;f=data.f;S=data.S;
for i=1:size(S,1)
      S(i,:)=S(i,:)/nansum(S(i,:));
end
S=10*log10(S);
for j=1:size(S,2)
S(:,j)=S(:,j)-nanmedian(S(:,j));
end
x_lim=[St(1),St(end)];
T=St(end);

if strcmp(model,'iso')
%Anesthetic concentration
subplot(row,col,1);
Subplot_isotrans(iso,isotrans,'pink',T,'writeiso');
set(gca,'XLim',x_lim);
set(gca,'YLim',[-1.5,2]);
set(gca,'visible','off');
end

%Spectrogram
subplot(row,col,col+1) 
pcolor(St,f,S');hold on;
shading flat;
colormap('jet');
set(gca,'YLim',[2,150],'Yscale','Log','YTick',[4,8,20,40,150]);
caxis([-5 5]);
set(gca,'XLim',x_lim);

%Cortical period
subplot(row,col,2*col+1); 
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
subplot(row,col,3*col+1); 
movdoc=[];
for i=1:length(vidlist)
toadd=ReadExcel(model,file,vidlist{i}); %%[ms ms movtype]
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

%Arousal index
subplot(row,col,4*col+1);
record_unit=[];
for loop2=1:length(vidlist)
    vid=vidlist{loop2};
    %load arousal units and spectral variables
    unit=importdata(strcat(path2dataset,'/results/automated detection algorithm/',model,'/',file,'/',vid,'.txt'));
    load(strcat(path2dataset,'/fd/',model,'/',file,'/',vid));
    %Measure arousal unit's gamma-theta
    unit=Unit_GammaTheta(unit,fd);
    if ~isempty(unit)
      record_unit=[record_unit;pts_func(unit(:,1:2))+vidtime(loop2),pts_func(unit(:,3:4))+vidtime(loop2),unit(:,5:end)]; %%[t_start t_end g fg theta_f theta_amp]
    end
end
l=ArousalIndex(record_unit(:,[3,5]));
for i=1:size(record_unit,1)
   plot([record_unit(i,1),record_unit(i,1)],[0 l(i)],'color',colorset('orange'),'linewidth',1.5);hold on;
end
[smooth_l,smooth_t]=ArousalIndex2Trajectory(record_unit,l,T);
plot(smooth_t,smooth_l,'k','linewidth',1.5);
set(gca,'XLim',x_lim);
set(gca,'YLim',[0 1]);
set(gca,'linewidth',1);
box off;
sgtitle(file);







