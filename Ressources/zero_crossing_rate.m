function [ZRC]= zero_crossing_rate(Signal, window_ms,step_ms, fs)
    % conversion time to sample
    window_sample= floor(window_ms*10^-3*fs);
    step_sample = floor(step_ms*10^-3*fs);
    
    % normalization of voiced signal 
    Signal = Signal./max(Signal);
    
    % variables
    nbFrame=floor((numel(Signal)-window_sample)/step_sample);
    
    % allocation 
    zero_crossing=zeros(window_sample+1,nbFrame);
    
    % Loop 
    for  w = 1:nbFrame % Pour chaque fenètre
         windows = Signal((1+(w-1)*step_sample):((w-1)*step_sample+window_sample)); % fenêtre de calcul de l'énergie à chaque instant
        % window_n=[window,zeros(size(window,2),1)];
        % window_n_1=[zeros(size(window,2),1),window];
        window_n=[windows.',0];
        window_n_1=[0, windows.'];
        window_n_sgn=sgn(window_n);
        window_n_1_sgn=sgn(window_n_1);
        zero_crossing(:,w)=abs(window_n_sgn-window_n_1_sgn);
    end
    zero_crossing(zero_crossing~=0)=1;
    ZRC=sum(zero_crossing(2:end,:));
    ZRC=medfilt1(ZRC/window_sample,5);
 
end

function y=sgn(x)
    y=(x>=0) + (-1)*(x<0);
end
