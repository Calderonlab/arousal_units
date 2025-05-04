function [movdoc,response]=ReadExcel_hypoxia(model,file,vid)


path2dataset=Read_Path2Dataset;%Path to dataset
path=strcat(path2dataset,'/excel/',model,'.xlsx');
[~,~,raw] = xlsread(path,strcat(file,'_',vid));

%%%%%%%%%%%%%%movement%%%%%%%%%%%%%%%%%%%%%%
movdoc=[]; %%[m s m s movtype]
for j=1:size(raw,1)
    if ischar(raw{j,1})&& ~isnan(raw{j,4})
        cc=strsplit(raw{j,1},'//');
        t1=str2num(cc{1,1});
        t2=str2num(cc{1,2});
        t3=str2num(cc{1,3});
        
        if ischar(raw{j,2})&& contains(raw{j,2},'//')
        cc=strsplit(raw{j,2},'//');
        t4=str2num(cc{1,1});
        t5=str2num(cc{1,2});
        t6=str2num(cc{1,3});
        else
        t4=t1;
        t5=t2;
        t6=t3;
        end
        
        movdoc(end+1,:)=[t1,t2,t3,t4,t5,t6,raw{j,4}];  %%[h m s h m s movtype]
        
    end
end

%%%%%%%%%%%%%%response%%%%%%%%%%%%%%%%%%%%%%
response=[]; %%[m s m s movtype]
if size(raw,2)>4
for j=1:size(raw,1)
    if ischar(raw{j,5}) && ~isnan(raw{j,7})
        cc=strsplit(raw{j,5},'//');
        t1=str2num(cc{1,1});
        t2=str2num(cc{1,2});
        t3=str2num(cc{1,3});
        
        response(end+1,:)=[t1,t2,t3,t1,t2,t3,raw{j,7}];  %%[h m s h m s movtype]
        
    end
end
end



