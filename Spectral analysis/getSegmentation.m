function out=getSegmentation(ipt_period,pts,T)

out=[];
for i=1:size(ipt_period,1)
    if  ipt_period(i,1)==0 
        t1=0;
    else
        t1=pts(ipt_period(i,1));
    end
    if length(ipt_period(i,:))==1 || isnan(ipt_period(i,2))
        t2=T;
    else
        t2=pts(ipt_period(i,2));
    end
    out(end+1,:)=[t1 t2];
end
   
