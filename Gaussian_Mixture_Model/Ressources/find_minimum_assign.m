function [index]=find_minimum_assign(distance,clusters)
    
    %% find minimum
    value_min=min(distance);
    
    %% assign to a center of a cluster
    index=find(distance==value_min);
    if(length(index)>1)
       index=randi(length(index),1,1); 
    end
    %% checking before sending
    if (index==0 || index>clusters)
        disp('Something is worng');
        [index]=find_minimum_assign(distance, clusters);
    end
end