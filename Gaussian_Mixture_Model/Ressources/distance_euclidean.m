function dist=distance_euclidean(data,center,clusters)
    %% center x & y
    center_x=center(1,:).';
    center_y=center(2,:).';
    
    %% data x & y
    data_x=data(1,:);
    data_y=data(2,:);
    
    %% euclidean distance
    dist=sqrt((center_x-data_x*ones(clusters,1)).^2+(center_y-data_y*ones(clusters,1)).^2);
   % dist=sqrt((center.'-data*ones(clusters,1)).^2);
end