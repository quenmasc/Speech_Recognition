%% MASCRET Quentin - 2017 Copyright %%
% This function allows to determine a variable threshold 
%% Input %% 
% Signal : vector of data
% Window_ms : length of the frame wished in ms
% fs : sample rate
%% Output %%
% entropy : variable threshold
function [entropy]=entropy_estimation(Signal, window_ms,step_ms, fs, p,entropy_noise)

   % conversion ms to sample
   window_sample= floor(window_ms*10^-3*fs);
   step_sample = floor(step_ms*10^-3*fs);
   
   % variable 
   nbFrame = floor((numel(Signal)-window_sample)/step_sample);
   nfft=2^nextpow2(window_sample);
   Signal=Signal./max(Signal);
   
   % allocation
   Histogramme=zeros(nbFrame,(nfft/2+1));
   % Calculation of PSD of each Frame with nbin
   for w=1:nbFrame
      Histogramme(w,:)=periodogram(Signal((1+(w-1)*step_sample):((w-1)*step_sample+window_sample)),[],nfft);
   end
   Histogramme=Histogramme./sum(sum(Histogramme));
    % normalize histogram
   log_pi=log2(Histogramme+eps);
   pi=Histogramme+eps;
   entropy=-sum((pi.*log_pi).');
   
   % Noise Entropy
    Entropy_noise=entropy_noise+mean(entropy(1:10)); %mean(entropy(1:30),2);
    % allocation
    Entropy=zeros(1,length(entropy));
    % Loop
    for w=1:length(entropy)
        % update noisy entropy value
        cno=p*Entropy_noise+(1-p)*entropy(w);
        % euclidean distance
        Entropy(w)=euclidean_distance(entropy(w),cno);
       
    end
    entropy=max(Entropy)-Entropy;
    entropy=medfilt1(entropy./max(entropy),10);
    
end