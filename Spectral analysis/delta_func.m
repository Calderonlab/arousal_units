function delta=delta_func(y,freq)

%DETECT PROMINENT POWER IN 3-5Hz IN THE SPECTRTUM
%INPUT
%y (spectrum)
%freq (frequency)

delta=[];
i=intersect(find(freq>3),find(freq<5));
freq=[freq(i),freq(i(end)+1)];
y=y(i);

[v,j]=max(y);
if v>4.5
   delta=[freq(j),freq(j+1)];
end


