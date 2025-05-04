function [iso,isotrans]=ReadIsoTrans(model,file,params)
%FUNCTION: READ ANESHTETIC CONCENTRATION

path2dataset=Read_Path2Dataset;%Path to dataset

[vidlist,~]=get_Vidlist(model,file,{'all'});
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