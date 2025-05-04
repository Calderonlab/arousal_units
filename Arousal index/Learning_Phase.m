function Learning_Phase
%FUNCTION: AUTOMATED DETECTION ALGORITHM LEARNING PHASE

fh=figure('units','normalized','outerposition',[0 0 1 1], 'Color', [1 1 1]);
set(fh,'DefaultAxesFontName', 'Aerial', 'DefaultAxesFontSize',11, 'DefaultTextFontSize',11, 'DefaultTextFontName', 'Aerial');
row=3;col=4;

%Derive centroids of period in the gamma-theta space
subplot(row,col,1);
centroids=[];
for p=2:5
    load(strcat('STAT/iso/','P',num2str(p)));
    x=charac.unit;
    if p==2
        colors=colorset('light purple');
    elseif p==3
        colors=colorset('purple');
    elseif p==4
        colors=colorset('purple2');
    elseif p==5
        colors=colorset('dark purple');
    end
    g=x(:,5);theta=x(:,7);
    theta(g>7)=[];g(g>7)=[];
    scatter(g,theta,8,'markerfacecolor',colors,'markeredgecolor','none');hold on;
    record_g{p}=g;
    record_theta{p}=theta;
    centroids(end+1,:)=[mean(g),mean(theta)];
end
scatter(centroids(:,1),centroids(:,2),'v','markerfacecolor','r','markeredgecolor','none','linewidth',1.2);hold on;
set(gca,'XLim',[0 8]);
set(gca,'YLim',[15 35]);
set(gca,'linewidth',1);
box off;

%Calculate mean and standard deviaion of all arousal units in Period 5
miu=[mean(record_g{5}),mean(record_theta{5})];
sigma=[std(record_g{5}),std(record_theta{5})];
save('STAT/miu','miu');
save('STAT/sigma','sigma');

for p=2:5
    load(strcat('STAT/iso/','P',num2str(p)));
    x=charac.unit;
    g=x(:,5);theta=x(:,7);
    j=find(g>7);
    g(j)=[];theta(j)=[];
    centroids(p,:)=[mean(g),mean(theta)];
end

%Z-score normalization of centroids
subplot(row,col,2);
for p=2:5
  centroids_zscore(p,:)=GammaTheta_Zscore(centroids(p,:));
end
for p=2:5
 scatter(centroids_zscore(p,1),centroids_zscore(p,2),30,'v','markerfacecolor','r','markeredgecolor','none');hold on;
end
set(gca,'XLim',[-5 1]);
set(gca,'YLim',[-4 2]);
xticks(-5:1);
set(gca,'linewidth',1);
box off;

%Transform Z-scored centroids to scalers
subplot(row,col,3);
for p=2:5
 dis_c(p)=Zscore2Scaler(centroids_zscore(p,:));
 scatter(p,dis_c(p),30,'v','markerfacecolor','r','markeredgecolor','none');hold on;
end
set(gca,'linewidth',1);
box off;
set(gca,'XLim',[1,6]);
xticks(1:6);
set(gca,'YLim',[-8 2]);


%%Use scalers to fit logistic curve
subplot(row,col,4);
[k,x_zero]=Logistic_fit (dis_c);
save('STAT/k','k');
save('STAT/x_zero','x_zero');

outputs=[];
for d=-8:0.5:4
    outputs(end+1)=1/(1+exp(k*(d-x_zero)));
end
plot(-8:0.5:4,outputs,'linewidth',1.5,'color',colorset('orange'));hold on;
for p=2:5
  d=dis_c(p);scatter(d,1/(1+exp(k*(d-x_zero))),30,'v','markerfacecolor','r','markeredgecolor','none');hold on;
end
set(gca,'linewidth',1);
set(gca,'YLim',[0 1]);
yticks(0:0.1:1);
set(gca,'XLim',[-8 4]);
box off;






