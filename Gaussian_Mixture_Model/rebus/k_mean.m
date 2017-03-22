function [center,index]=k_mean(feature,clusters,loop)
    %% addpath 
    addpath('../ressources');


    %% initialization
    % choose points of feature as the starting center
    if (size(feature,2)==2)
        feature=feature.';
    end
    random_number=randperm(size(feature,2));
    random_number=random_number(1:clusters);
    old_center=zeros(2,clusters);
    center=feature(:,random_number);
    
    %% allocation
    value=zeros(2,size(feature,2));
    index=zeros(1,size(feature,2));
    
    %% Loop
    for i=1:loop
        % define old center as the new center
        if (old_center==center)
            break;
        else
            old_center=center;
        end
        
        % assign each point of closest mean
        for w=1:size(feature,2)
          % distance between points and centers
          dist=distance_euclidean(feature(:,w),old_center,clusters);
          % find min and assign it to closest mean
          [index(w)]=find_minimum_assign(dist,clusters); 
        end
        for c=1:clusters
            local_center_x=0;
            local_center_y=0;
            count=0;
            for w=1:size(feature,2)
                if (index(w)==c)
                    local_center_x=local_center_x+feature(1,w);
                    local_center_y=local_center_y+feature(2,w);
                    count=count+1;
                end
            end
            center(:,c)=[(1/count)*local_center_x;(1/count)*local_center_y];
        end
    end
    
    %% plot 
    
end
