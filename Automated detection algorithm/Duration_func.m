function d=Duration_func(x)

if ~isempty(x)
 d=[];
 for i=1:size(x,1)
    d(i,1)=pts_func(x(i,3:4))-pts_func(x(i,1:2))+1;
 end
else
    d=[];
end