function [background, distance]=updateBackgroundVectorAndDistance(background,parameter,p)
    
    %Entropy_noise=entropy_noise+mean(entropy(1:10)); %mean(entropy(1:30),2)
    background=p*background+(1-p)*parameter;
    distance=euclidean_distance(parameter,background);
end