%% MASCRET Quentin - Copyright 2017 %%

function [Energy]= short_time_energy(Signal, window_ms, step_ms , fs)
    % variables
    alpha=0.97;
    
    if( max(abs(Signal))<=1 ), Signal = Signal * 2^15; end;
    % preemphasis filtering
    Signal = filter( [1 -alpha], 1, Signal );
    % normalisation of the Signal %
    
    
    % Variables
    window_sample=floor(window_ms*10^-3*fs) ;
    step_sample = floor(step_ms*10^-3*fs);
    nbFrame = floor((numel(Signal) - window_sample)/step_sample);
    
    % Allocation 
    Energy=zeros(1, nbFrame);
     for  w = 1:nbFrame % Pour chaque fenètre
         energy_window_calculation = Signal((1+(w-1)*step_sample):((w-1)*step_sample+window_sample)); % fenêtre de calcul de l'énergie à chaque instant
         Energy(w)=(1/window_sample)*sum(energy_window_calculation.^2); % calcul de l'énergie %
     end
     
   %  Energy=medfilt1(Energy,5);
   Energy=log(1+Energy);
    
end

