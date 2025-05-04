function output=ReadInject(model,file)

%FUNCTION: READ TIME OF INJECTION GLUCAGON FROM EXCEL
path2dataset=Read_Path2Dataset;
path=strcat(path2dataset,'/excel/',model,'.xlsx');
[~,~,raw] = xlsread(path,file);
output=[];

for i=1:size(raw,1)
    if ischar(raw{i,8}) && strcmp(raw{i,8},'inject')
        output=raw{i,9};
    end
end


