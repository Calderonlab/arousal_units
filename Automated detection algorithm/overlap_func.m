function out=overlap_func(x,y,str)

%FUNCTION: DETERMINE IF ARRAYS IN X AND Y WERE OVERLAPPED
if strcmp(str,'pts')
    for i=1:size(x,1)
        for j=1:size(y,1)
            if  max([x(i,1),y(j,1)])<=min([x(i,2),y(j,2)])
                out(i,j)=1;
            else
                out(i,j)=0;
            end
        end
    end

elseif strcmp(str,'ms')
    for i=1:size(x,1)
    for j=1:size(y,1)
        t1=pts_func(x(i,1:2));
        t2=pts_func(x(i,3:4));
        t3=pts_func(y(i,1:2));
        t4=pts_func(y(i,3:4));
        if max([t1,t3])<=min([t2,t4])
            out(i,j)=1;
        else
            out(i,j)=0;
        end
    end
    end
end