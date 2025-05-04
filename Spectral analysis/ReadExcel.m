function [movdoc,movstr]=ReadExcel(model,file,vid)


path2dataset=Read_Path2Dataset;%Path to dataset
path=strcat(path2dataset,'/excel/',model,'.xlsx');
[~,~,raw] = xlsread(path,file);
movdoc=[]; %%[m s m s movtype]
movstr=[];

for i=1:size(raw,1)
    if ischar(raw{i,1}) && strcmp(raw{i,1},vid)
        break;
    end
end

for j=i+1:size(raw,1)
    if ischar(raw{j,1})&& contains(raw{j,1},'//') 
        cc=strsplit(raw{j,1},'//');
        t1=str2num(cc{1,1});
        t2=str2num(cc{1,2});
        
        if ischar(raw{j,2})&& contains(raw{j,2},'//')
        cc=strsplit(raw{j,2},'//');
        t3=str2num(cc{1,1});
        t4=str2num(cc{1,2});
        else
        t3=t1;
        t4=t2;
        end
        
        movdoc(end+1,:)=[t1,t2,t3,t4,raw{j,5}];  %%[m s m s movtype]
        movstr{end+1,1}=raw{j,3};
        
    elseif ischar(raw{j,1})&& ~contains(raw{j,1},'//') 
        break
    else
        
    end
end



