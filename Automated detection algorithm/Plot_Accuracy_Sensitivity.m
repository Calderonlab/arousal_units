%function Plot_Accuracy_Sensitivity

close all;
fh=figure('units','normalized','outerposition',[0 0 1 1], 'Color', [1 1 1]);
set(fh,'DefaultAxesFontName', 'Aerial', 'DefaultAxesFontSize',11, 'DefaultTextFontSize',11, 'DefaultTextFontName', 'Aerial');
row=3;col=4;

load('STAT/iso/P2');P2=charac;
load('STAT/iso/P3');P3=charac;
load('STAT/iso/P4');P4=charac;
load('STAT/iso/P5');P5=charac;

%%%%%precision
subplot(row,col,1);
x2=P2.acc;x3=P3.acc;x4=P4.acc;x5=P5.acc;
xaxis=[mean(x2),mean(x3),mean(x4),mean(x5)];
err=[std_err(x2),std_err(x3),std_err(x4),std_err(x5)];
bar(xaxis,'facecolor','cyan','linewidth',1.5,'barwidth',0.5);hold on;
scatter(ones(length(x2),1),x2,8,'markeredgecolor','k','markerfacecolor','none');hold on;
scatter(2*ones(length(x3),1),x3,8,'markeredgecolor','k','markerfacecolor','none');hold on;
scatter(3*ones(length(x4),1),x4,8,'markeredgecolor','k','markerfacecolor','none');hold on;
scatter(4*ones(length(x5),1),x5,8,'markeredgecolor','k','markerfacecolor','none');hold on;
errorbar(xaxis,err,'k+','linestyle','none','linewidth',1.5);hold on;
set(gca,'YLim',[0,1.2]);
set(gca,'linewidth',1);
box off;
yticks([0:0.2:1]);


%%%%%sensitivity
subplot(row,col,2);
x2=P2.sensitivity;
x3=P3.sensitivity;
x4=P4.sensitivity;
x5=P5.sensitivity;
x2=x2(:,1);x2(isnan(x2))=[];
x3=x3(:,2);x3(isnan(x3))=[];
x4=x4(:,3);x4(isnan(x4))=[];
x5=x5(:,4);x5(isnan(x5))=[];

xaxis=[mean(x2),mean(x3),mean(x4),mean(x5)];
err=[std_err(x2),std_err(x3),std_err(x4),std_err(x5)];
b=bar(xaxis,'facecolor','flat','linewidth',1.5,'barwidth',0.5);hold on;
b.CData(1,:)=colorset('gray');
b.CData(2,:)=[0 0 1];
b.CData(3,:)=colorset('dark green');
b.CData(4,:)=[1 0 0];
scatter(ones(length(x2),1),x2,8,'markeredgecolor','k','markerfacecolor','none');hold on;
scatter(2*ones(length(x3),1),x3,8,'markeredgecolor','k','markerfacecolor','none');hold on;
scatter(3*ones(length(x4),1),x4,8,'markeredgecolor','k','markerfacecolor','none');hold on;
scatter(4*ones(length(x5),1),x5,8,'markeredgecolor','k','markerfacecolor','none');hold on;
errorbar(xaxis,err,'k+','linestyle','none','linewidth',1.5);hold on;
set(gca,'YLim',[0,1.2]);
set(gca,'linewidth',1);
box off;
yticks([0 0.2 0.4 0.6 0.8 1]);