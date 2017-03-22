function [entropy]=entropy_noise(Init, window_ms,step_ms, fs)

   % conversion ms to sample
   window_sample= floor(window_ms*10^-3*fs);
   step_sample = floor(step_ms*10^-3*fs);
   
   % variable 
   nbFrame = floor((numel(Init)-window_sample)/step_sample);
   nfft=2^nextpow2(window_sample);
   Init=Init./max(Init);
   
   % allocation
   Histogramme=zeros(nbFrame,(nfft/2+1));
   % Calculation of PSD of each Frame with nbin
   for w=1:nbFrame
      Histogramme(w,:)=periodogram(Init((1+(w-1)*step_sample):((w-1)*step_sample+window_sample)),[],nfft);
   end
   Histogramme=Histogramme./sum(sum(Histogramme));
    % normalize histogram
   log_pi=log2(Histogramme+eps);
   pi=Histogramme+eps;
   entropy=-sum((pi.*log_pi).');
   
   entropy=(entropy/max(abs(entropy)));
   
end