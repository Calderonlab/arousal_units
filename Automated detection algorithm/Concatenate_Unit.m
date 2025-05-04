function y=Concatenate_Unit(x,thres)

%FUNCTION: AROUSAL UNITS THAT WERE LESS THAN ``THRES" SECONDS APART WERE
%CONCATENATED INTO ONE

%INPUTS:
%x (matrix; rows represent arousal units in form [onset_minute, onset_second, end_minute, end_second])
%thres (threshold, arousal units less than this value apart were concatenated into one)

%OUTPUTS:
%y (arousal units after concatenation)

y(1,:)=[x(1,1:2),x(1,3:4)];
if size(x,1)>=2
for i=2:size(x,1)
    if pts_func(x(i,1:2))-pts_func(y(end,3:4))>=0 && pts_func(x(i,1:2))-pts_func(y(end,3:4))<=thres
        y(end,3:4)=x(i,3:4);
        
    else
        y(end+1,:)=[x(i,1:2),x(i,3:4)];
    end
end
end


