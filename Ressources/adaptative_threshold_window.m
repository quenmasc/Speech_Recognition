%% MASCRET Quentin - Copyright 2017 %%
% This function allow to extract an adaptative threshold.
function threshold=adaptative_threshold_window(Signal,fs,time_exclusion, window_ms, step_ms)
    % variables 
    count =0;
    mini=100;
    condition=0;
    Flags=0;
    
    % window
    windows=fs*time_exclusion;
    window_sample=floor(window_ms*10^-3*fs);
    step_sample=floor(step_ms*10^-3*fs);
    window_forward=floor((windows-window_sample)/step_sample);
    % nbFrame 
    nbFrame = floor(numel(Signal)-window_forward);
    % mean of signal 
    average=mean(Signal);
    
    % step
    step_threshold=1e-4;
    
    % Loop
    while(condition==0)
        Flags_initial=(Signal>average);
        Flags_initial=+Flags_initial;
        for w=1:nbFrame
            vect_test=mean(Flags_initial(w:w+window_forward-1));
            if (vect_test~=0)
                count=count+1;
            elseif (vect_test==0 && count~=0)
                Flags=1;
            end
            if (Flags==1)
                if(mini>=count)
                    mini=count;
                    count=0;
                    Flags=0;
                end
            end
        end
        if(mini>=floor(3*windows))
            average=average-step_threshold;
        else
            break;
        end
        
    end
    threshold=average;
end