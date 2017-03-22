%% MASCRET Quentin _ Copyright 2017
%% 03.01.17

function threshold=variable_threshold(Signal,th_original,p)
    % Noise Entropy
    threshold_noise=th_original;
    % allocation
    threshold=zeros(1,length(Signal));
    % Loop
    for w=1:length(Signal)
        % update noisy entropy value
        if(w+10<length(Signal))
            threshold(w)=p*threshold_noise+(1-p)*(mean(Signal(w:w+10))+3*std(Signal(w:w+10)));
        else
            threshold(w)=p*threshold_noise+(1-p)*(mean(Signal(w:end))+3*std(Signal(w:end)));
        end
        % euclidean distance
    %    threshold(w)=euclidean_distance(threshold(w),cno);
       
    end
end