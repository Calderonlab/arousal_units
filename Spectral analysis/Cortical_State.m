function spikes=Cortical_State(df_log)

%ASSIGN DOMINANT FREQUENCY TO THE NEAREST KMEANS CENTROID (cortical state) 
%INPUT
%df_log (dominant frequency in log-space)
%OUTPUT
%spikes (index of cortical state)


%Centroids in Hz
%Centroids were obtained by kMeans clustered dominant frequency bands in 3 isoflurane long ramps
centroids=[4,8;
           10,20;
           20,40;
           30,100;
           70,130];
       
freq=logspace(log10(2),log10(150),51);

%Centroids in log-space
spikes=[];
for i=1:size(centroids,1)
    for j=1:2
       [~,pos]=min(abs(freq-centroids(i,j)));
       centroids_log(i,j)=pos;
    end
end

for i=1:size(df_log,1)
    dis=[];
    for j=1:size(centroids,1)
        dis(j)=norm(df_log(i,:)-centroids_log(j,:));
    end
    [~,spikes(i)]=min(dis);
end
    

