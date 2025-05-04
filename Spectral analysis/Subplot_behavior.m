function Subplot_behavior(movdoc,movstr,colors_p)

%FUNCTION: PLOT MOTOR RECOVERY, SEE EXCEL SHEETS THAT DOCUMENT MOVEMENT IN
%EACH ANIMAL
pset=[-3,-2;-2,-1;-1,0;0,1];
for i=1:length(movstr)
   tf=ismember(movdoc(:,end),movstr{i});
   sub=movdoc(tf,:);
   for j=1:size(sub,1)
      plot(sub(j,1)*ones(1,2),pset(i,:),'color',colors_p(i,:),'linewidth',1.5);hold on;
   end
end




    










