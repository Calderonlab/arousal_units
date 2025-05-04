function [out_f,out_amp]=getTheta(S)
%FUNCTION:CALCULATE THETA FREQUENCY AND THETA AMPLITUDE FROM SPECTRUM
%INPUTS:
%S   (100 log-spaced spectrum)
%OUTPUTS:
%out_f  (theta frequency)
%out_theta (theta amplitude)

for i=1:size(S,1)
    y=S(i,:);
    p_value=[];
    sur=y(15:35);
    for j=15:35
        [~,p_value(end+1)]=ztest(y(j),mean(sur),std(sur),'tail','right');
    end
    idx=find(p_value<0.1);
    if ~isempty(idx)
       out_f(i,1)=max(idx)+14;
       out_amp(i,1)=y(out_f(i));
    else
       out_f(i,1)=15;
       out_amp(i,1)=0;
    end

end



    