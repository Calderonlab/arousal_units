function span=DetectSpan(fd,bound,params)

%DETECT SPANS OF INCREASED FRACTIONAL GAMMA
%INPUTS:
%fd     (structure array of spectral variables)
%bound  (structure array of spectral limits)
i=2;span=[];
while i<=length(fd.fg)
    idx=i-10:i-1;
    idx(idx<1)=[];
    if  fd.fg(i)>bound.fg && fd.fg(i)-min(fd.fg(idx))>min([0.1,bound.fg]) 
        j=i+1;
        while j<=length(fd.fg)
            if fd.fg(j)<bound.fg 
                break; 
            end
            j=j+1;
        end
        span(end+1,:)=[fd.ms(i,:),fd.ms(j-1,:)];
    end
    i=i+1;
end

%For overlapping spans, we only keep the one with the longest time length
idx=[];
for i=1:size(span,1)-1
    for j=i+1:size(span,1)
        xi=span(i,:);
        xj=span(j,:);
    if overlap_func(xi,xj,'ms') 
        if Duration_func(xi)<Duration_func(xj)
            idx(end+1)=i;
        else
            idx(end+1)=j;
        end
    end
    end
end
span(idx,:)=[]; 

%%%Remove spans with maximum fractional gamma lower than spectral limit
idx=[];
for i=1:size(span,1)
   span_i=span(i,:);
   [~,d1]=ismember(span_i(1:2),fd.ms,'rows');
   [~,d2]=ismember(span_i(3:4),fd.ms,'rows');
   if max(fd.fg(d1:d2))<bound.fg2
       idx(end+1)=i;
   end
end
span(idx,:)=[];

%Concatenate spans in hypoxic newborn and isoflurane short ramps
if ~isempty(span) && isfield(params,'concate')
  span=Concatenate_Unit(span,params.concate);
end