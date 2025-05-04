function [S,record_S]=Combined_Spectrum(sheet,file,vid,params)
%FUNCTION: CALCULATE COMBINED SPECTRUM

path2dataset=Read_Path2Dataset;
%Load 100 log-spaced spectrum for each channel
record_S=[];
for i=1:length(params.Ch)
  load(strcat(path2dataset,'/spectrum/',sheet,'/',file,'/Ch',num2str(params.Ch(i)),'/',vid));
  record_S{end+1}=S/params.nor;
end

%Average spectrums across channels
num_Ch=length(record_S);
T=size(record_S{1},1);
S=[];
if isfield(params,'interchannel')
    f_range=[1 15;70,100];
    for i=1:T
        z=[];out_row=[];
        for j=1:num_Ch
           y=record_S{j}(i,:);
           dby=10*log10(y);
           z(end+1,:)=dby;
           out_row(end+1,:)=record_S{j}(i,:);
        end
        remove_Ch=Interchannel_Artifact(z,f_range);
        out_row(remove_Ch,:)=[];
        S(end+1,:)=nanmean(out_row,1);
    end

else
   for i=1:T
        z=[];out_row=[];
        for j=1:num_Ch
           y=record_S{j}(i,:);
           out_row(end+1,:)=record_S{j}(i,:);
        end
        S(end+1,:)=nanmean(out_row,1);
    end
    
end




