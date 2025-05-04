function out=DetectBurst(subspan,fd,bound)

out=[];
for i=1:size(subspan,1)
    [~,d1]=ismember(subspan(i,1:2),fd.ms,'rows'); 
    [~,d2]=ismember(subspan(i,3:4),fd.ms,'rows');
    g=fd.g(d1:d2);
    [v,~]=max(g);
    if v>bound.g && v<15 
        out(end+1,:)=subspan(i,:);
    end    
end
