function unit=Unit_GammaTheta(unit,fd)

%CALCULATION OF AROUASL UNITS GAMMA-THETA DISTANCE


for i=1:size(unit,1) 
    [~,d1]=ismember(unit(i,1:2),fd.ms,'rows');
    [~,d2]=ismember(unit(i,3:4),fd.ms,'rows');
    g=fd.g(d1:d2);
    %gamma burst
    [v,j]=max(g);
    fg=fd.fg(d1:d2);
    %theta frequency assoicated with gamma burst
    theta=fd.theta(d1:d2);
    theta_amp=fd.theta_amp(d1:d2);
    unit(i,5:8)=[v fg(j) theta(j) theta_amp(j)]; %%[ms ms g fg theta_f theta_amp]
end

