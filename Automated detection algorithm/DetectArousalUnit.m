function [unit,fd]=DetectArousalUnit(model,file,vid)

%FUNCTION: AUTOMATED DETECTION ALGORITHM OF AROUSAL UNITS
%INPUTS: 
%model: (animal models, including 'iso': isoflurane long ramp
%                                 'ins': hypoglycemic coma
%                                 'glucagon': hypoglycemic coma with glucagon injection
%                                 'SBI': blast brain injury
%                                 'shortramp': short isoflurane ramp, sham mouse)

%file: (subject ID, see worksheets in "dataset/excel/")
%vid:  (epoch ID, see colored 5-digit number in first column of worksheet ``dataset/excel/")

%OUTPUTS:
%unit: A matrix. Rows are arousal units. 
%First and second columns are onset of arousal units in form minute, second
%Third and fourth columns are ends of arousal units in form minute,second

%Get paramters
path2dataset=Read_Path2Dataset;
params=get_params(model,file);
[subfile,subtime]=get_subfile(model,file,vid);
load(fullfile(path2dataset,'/data/',model,'/',file,'/',subfile)); 

%Average spectrums across channels
S=Combined_Spectrum(model,file,vid,params);

%Calculate spectral variables
fd=SpectralVariable(S,params);

%Calculate spectral limits
bound=SpectralLimit(fd,[]);

%Detect spans of increased gamma
span=DetectSpan(fd,bound,params);

%Detect subspan of reduced delta within the span
subspan=[];
for i=1:size(span,1)
    out=DetectSubSpan(span(i,:),fd,bound);
    if ~isempty(out) 
        subspan(end+1,:)=out;
    end
end

%Detect burst of gamma within the subspan
subspan=DetectBurst(subspan,fd,bound);

%Postprocess subspans and return arousal units
subspan=PostProcessing(subspan, params, data, subtime,fd,S);
unit=subspan;


