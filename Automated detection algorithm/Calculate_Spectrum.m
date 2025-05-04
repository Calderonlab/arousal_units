function Calculate_Spectrum(model,file,vid,params)

%CALCULATE 100 LOG-SPACED SPECTRUM FOR EACH CHANNEL
%INPUTS: 
%model: (animal models, including       'iso': isoflurane long ramp
%                                       'ins': hypoglycemic coma
%                                       'glucagon': hypoglycemic coma with glucagon injection
%                                       'SBI': blast brain injury
%                                       'shortramp': isoflurane shortramp)
%       clinical models, including      'hypoxia': hypoxic newborns
%                                       'human anesthesia': seniors emerging from anesthesia)

%file: (subject ID, see worksheets in "dataset/excel/")
%vid:  (epoch ID, see colored 5-digit number in the first column of worksheet ``dataset/excel/")

path2dataset=Read_Path2Dataset;
for loop=1:length(params.Ch)
    Ch=params.Ch(loop);
    [subfile,subtime]=get_subfile(model,file,vid);
    %Load EEGs
    if strcmp(model,'hypoxia')
       load(strcat(path2dataset,'/data/hypoxia/',file,'/preprocess/',subfile,'.mat'));
    elseif strcmp(model,'human anesthesia')
       load(strcat(path2dataset,'/data/human anesthesia/',file,'/preprocess/',subfile,'.mat')); 
    else
       load(fullfile(path2dataset,'/data/',model,'/',file,'/',subfile)); 
    end
    
    if subtime(2)>length(data.lfp)/params.Fs
       subtime(2)=length(data.lfp)/params.Fs;
    end

    %Calculate log-spaced spectrum
    S=[];
    for t=subtime(1):params.step:subtime(2)-params.movingwin
       lfps=data.lfp(max([1,t*params.Fs]):(t+params.movingwin)*params.Fs,Ch); %%single channel lfps
       [y,f]=mtspectrumc(lfps,params);
       y=LogSpaced(f,y,params.num_freq);
       S(end+1,:)=y;
    end
    path_save=strcat(path2dataset,'/spectrum/',model,'/',file,'/Ch',num2str(Ch),'/',vid);
    save(path_save,'S');
end





   
    
   
