%% MASCRET Quentin - 2017 Copyright %%
% This function allows to determine a variable threshold 
%% Input %% 
% Signal : vector of data
% Window_ms : length of the frame wished in ms
% fs : sample rate
%% Output %%
% entropy : variable threshold
function [entropy]=entropy_estimation(Signal, window_ms,step_ms, fs)

   % conversion ms to sample
   window_sample= floor(window_ms*10^-3*fs);
   step_sample = floor(step_ms*10^-3*fs);
   
   % variable 
   nbFrame = floor((numel(Signal)-window_sample)/step_sample);
   nbin= 401;
   Signal=Signal./max(Signal);
   
   % allocation
   Histogramme=zeros(nbFrame,nbin);
   
   % Calculation of histogram of each Frame with nbin
   for w=1:nbFrame
      Histogramme(w,:)=periodogram(Signal((1+(w-1)*step_sample):((w-1)*step_sample+window_sample)),[],800);
   end
   Histogramme=Histogramme./sum(Histogramme);
    % normalize histogram
   log_pi=log2(Histogramme+eps);
   pi=Histogramme+eps;
   entropy=-sum((pi.*log_pi).');
   entropy=entropy/max(max(entropy));
end