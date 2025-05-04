function Subplot_isotrans(iso,isotrans,isotrans_line,endofrecording,string)
%FUNCTION: PLOT ANESHTETIC CONCENTRATION 

if iso(2)<iso(1)
y=-1.5;
delta=0.35;
for i=1:length(iso)-1
   pp=mean([isotrans(i),isotrans(i+1)]);
   cc=strcat(num2str(iso(i)),'%');
   plot([isotrans(i),isotrans(i+1)],[y,y],'color',colorset(isotrans_line),'linewidth',2);hold on;
   plot([isotrans(i+1),isotrans(i+1)],[y,y+delta],'color',colorset(isotrans_line),'linewidth',2);hold on;
   if strcmp(string,'writeiso')==1
   text(pp-50,y+delta,cc);
   end
   y=y+delta;
end
pp=mean([isotrans(end),endofrecording]);
cc=strcat(num2str(iso(end)),'%');
plot([isotrans(end),endofrecording],[y,y],'color',colorset(isotrans_line),'linewidth',2);
if strcmp(string,'writeiso')==1
text(pp,y+delta,cc);
end


else
y=2;
delta=0.35;
for i=1:length(iso)-1
   pp=mean([isotrans(i),isotrans(i+1)]);
   cc=strcat(num2str(iso(i)),'%');
   plot([isotrans(i),isotrans(i+1)],[y,y],'color',colorset(isotrans_line),'linewidth',2);hold on;
   plot([isotrans(i+1),isotrans(i+1)],[y,y-delta],'color',colorset(isotrans_line),'linewidth',2);hold on;
   if strcmp(string,'writeiso')==1
   text(pp-50,y+delta,cc);
   end
   
   y=y-delta;
   
end
pp=mean([isotrans(end),endofrecording]);
cc=strcat(num2str(iso(end)),'%');
plot([isotrans(end),endofrecording],[y,y],'color',colorset(isotrans_line),'linewidth',2);
if strcmp(string,'writeiso')==1
text(pp,y+delta,cc);
end

end




