function delta=Delta_feature(feature)
    % allocation
    [row, column]=size(feature);
    delta=zeros(row,column);
    for i = 1:column
    
        if i==1
            previous = feature(:,i);
            next = feature(:,i+1);
    
        elseif i==column
            previous = feature(:,i-1);
            next = feature(:,i); 
        
        else   
            previous = feature(:,i-1);
            next = feature(:,i+1);
        end
        delta(:,i) = (next-previous)/2;
    end
    
   
end