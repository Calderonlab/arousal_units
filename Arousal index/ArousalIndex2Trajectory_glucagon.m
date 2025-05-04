function [smooth_l,smooth_t]=ArousalIndex2Trajectory_glucagon(record_unit,l,T,inj)

%%before injection
l1=l;
l1(record_unit(:,1)>inj)=[];
record_unit1=record_unit;
record_unit1(record_unit(:,1)>inj,:)=[];
[l1,t1]=ArousalIndex2Trajectory(record_unit1,l1,inj);
%%after injection
l2=l;
l2(record_unit(:,1)<inj)=[];
record_unit2=record_unit;
record_unit2(record_unit(:,1)<inj,:)=[];
[l2,t2]=ArousalIndex2Trajectory(record_unit2,l2,T-inj);
l2(t2<inj)=[];
t2(t2<inj)=[];
smooth_l=[l1;l2];
smooth_t=[t1,t2];