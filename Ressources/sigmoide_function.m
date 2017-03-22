function seuillage=sigmoide_function(lambda,feature)
    % variable 
    L=length(feature);
    
    % allocation
    seuillage=zeros(1,L);
    
    % Loop
    for i=1:L
        seuillage(i)=1/(5+exp(-lambda*feature(i)));
    end
    
end