function [z,movflag]=Unit2Mov(unit,movdoc,sync)

%FUNCTION: ASSOCIATED AROUSAL UNIT TO MOVEMENT

movflag=zeros(size(movdoc,1),1);
z=[];
if ~isempty(movdoc) && ~isempty(unit)
 movtime=sum(movdoc(:,[1,2]).*[60,1],2)+sync(2);
 for i=1:size(unit,1)
    t1=sum(unit(i,[1,2]).*[60,1])+sync(1);
    t2=sum(unit(i,[3,4]).*[60,1])+sync(1);
    k=intersect(find(movtime>=t1-5),find(movtime<=t2+5));
    movflag(k)=1;
    submov=movdoc(k,:);
    submov(submov(:,5)==5.1,:)=[];
    submov(submov(:,5)==5.2,:)=[];
    submov(submov(:,5)==-1,:)=[];
    submov(isnan(submov(:,5)),:)=[];
    
    if ~isempty(submov)
        [~,c]=max(submov(:,5));
        z=[z;submov(c,5)]; %%max movtype
    else
        z=[z;-1]; %%noMov
    end
    
 end
 
elseif isempty(movdoc) && ~isempty(unit)
    z=-1*ones(size(unit,1),1);
end


