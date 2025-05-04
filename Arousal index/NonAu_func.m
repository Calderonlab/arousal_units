function nonau=NonAu_func(unit,fd,delta)

%FUNCTION: SEGMENT TIME WINDOWS BETWEEN AROUSAL UNITS
nonau=[];
if ~isempty(unit)
    %start of recording to 1st unit
    t=sum(unit(1,1:2).*[60,1]);
    for kk=0:delta:t
        if kk+delta<t
        nonau=[nonau;transtime(kk),transtime(kk+delta)];
        end
    end


    for i=1:size(unit,1)-1
        t1=sum(unit(i,3:4).*[60,1]);
        t2=sum(unit(i+1,1:2).*[60,1]);
        for kk=t1:delta:t2
            if kk+delta<t2
                nonau=[nonau;transtime(kk),transtime(kk+delta)];
            end
        end
    end

    %last unit to end of recording
    t=sum(unit(end,3:4).*[60,1]);
    T=sum(fd.ms(end,:).*[60,1]);
    for kk=t:delta:T
            if kk+delta<T
                nonau=[nonau;transtime(kk),transtime(kk+delta)];
            end
    end

else
    nonau=[fd.ms(1,:),fd.ms(end,:)];
end