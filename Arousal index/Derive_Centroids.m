function Derive_Centroids
%FUNCTION: DERIVE CENTROIDS OF PERIODS IN GAMMA-THETA SPACE

path2dataset=Read_Path2Dataset;
%Load 8 isoflurane long ramps
load('STAT/list/iso.mat');
model='iso';

for p=2:5 %cortical period
    charac.unit=[];
for loop1=1:length(filelist)
    file=filelist{loop1};
    [vidlist,~]=get_Vidlist(model,file,{strcat('P',num2str(p))});
    for loop2=1:length(vidlist)
        vid=vidlist{loop2};
        %Load arousal units and spectral variables
        unit=importdata(strcat(path2dataset,'/results/automated detection algorithm/',model,'/',file,'/',vid,'.txt')); %%[ms ms g fg theta_f theta_amp]
        load(strcat(path2dataset,'/fd/',model,'/',file,'/',vid));
        %Measure arousal unit's gamma-theta
        unit=Unit_GammaTheta(unit,fd);
        charac.unit=[charac.unit;unit];
    end
end
save(strcat('STAT/iso/','P',num2str(p)),'charac');
end







