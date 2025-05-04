function x=CalculateSensitivity(movdoc,unitpred)

%FUNCTION: SENSITIVITY, CALCULATED AS THE RATIO BETWEEN NUMBER OF MOVEMENTS
%ASSOCIATED WITH AROUSAL UNITS AND THE NUMBER OF MOVEMENTS
movtype=movdoc(:,end);

idx=find(movtype==0);
x(1)=sum(unitpred(idx))/length(idx);

idx=[find(movtype==1);find(movtype==1.5)];
x(2)=sum(unitpred(idx))/length(idx);

idx=[find(movtype==2);find(movtype==2.5)];
x(3)=sum(unitpred(idx))/length(idx);

idx=[find(movtype==3);find(movtype==3.5)];
x(4)=sum(unitpred(idx))/length(idx);