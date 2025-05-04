function   Accuracy_Sensitivity(model)

%FUNCTION: CALCULATE ACCURACY AND SENSITIVITY OF AROUSAL UNITS PREDICTING
%MOVEMENT, RESULTS ARE SAVED IN "STAT/"

%ACCURACY: RATIO BETWEEN NUMBER OF AROUSAL UNITS ASSOCIATED WITH MOVEMENT
%AND THE NUMBER OF AROUSAL UNITS

%SENSITIVITY: RATIO BETWEEN NUMBER OF MOVEMENTS ASSOCIATED WITH AROUSAL
%UNITS AND THE NUMBER OF MOVEMENTS

path2dataset=Read_Path2Dataset;
load(strcat('STAT/list/',model));

for p=2:5
    [charac.acc,charac.sensitivity]= deal([]);
for loop1=1:length(filelist)
    file=filelist{loop1};
    [vidlist,~]=get_Vidlist(model,file,{strcat('P',num2str(p))});
    for loop2=1:length(vidlist)
        vid=vidlist{loop2};
        %movdoc
        [movdoc,~]=ReadExcel(model,file,vid);sync=get_sync(model,file,vid);
        %arousal unit
        unit=importdata(strcat(path2dataset,'/results/automated detection algorithm/',model,'/',file,'/',vid,'.txt')); %%[ms ms g fg theta_f theta_amp]
        [pred,unitpred_flag]=Unit2Mov(unit,movdoc,sync);
        %precision and sensitivity
        if ~isempty(unit)
          charac.acc(end+1,:)=sum(pred>=0)/size(pred,1);
        end
        if ~isempty(movdoc)
          charac.sensitivity(end+1,:)=CalculateSensitivity(movdoc,unitpred_flag);
        else
          charac.sensitivity(end+1,:)=[NaN NaN NaN NaN];
        end
    end
end
save(strcat('STAT/iso/','P',num2str(p)),'charac');
end




