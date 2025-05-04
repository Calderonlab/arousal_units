function [suppress,deltawave]=BurstSuppression_Deltawaves(nonau,fd,data,subtime,params)

%FUNCTION: DETECTION OF BURST SUPPRESSION AND DELTA WAVES IN SBI AND
%ISOFLURANE SHORTRAMP MODELS

suppress=[];
deltawave=[];

for i=1:size(nonau,1)
    [~,d1]=ismember(nonau(i,1:2),fd.ms,'rows');
    [~,d2]=ismember(nonau(i,3:4),fd.ms,'rows');
    lowfreq=fd.lowfreq(d1:d2);
    t1=pts_func(nonau(i,1:2));
    t2=pts_func(nonau(i,3:4));
    lfp_i=data.lfp(t1*params.Fs+1:t2*params.Fs,1);
    bsupp=Isoelectric(fd.ms(d1:d2,:),subtime,data,params,1);
    fg=fd.fg(d1:d2);
    if  ~isempty(find(bsupp(:,1)<0.001)) %no signals
    elseif max(abs(lfp_i))>=0.5 %artifact
    elseif  sum(bsupp(:,1)<0.02)/length(bsupp)>0.1 %burst suppression
         suppress(end+1,1)=t1; 
    elseif median(fg)<0.4 && median(lowfreq)>1.5 %delta waves
        deltawave(end+1,1)=t1;  
    end
end