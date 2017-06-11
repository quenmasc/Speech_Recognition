%% MASCRET Quentin - Copyright 2017 %%
%% 20/02/2017 %%%

function [X_im] = short_time_fourier_transform(Signal, window_ms, step_ms, fs, varargin )
          % variables
          alpha=0.97;
          
          % preemphasis filtering
          speech = filter( [1 -alpha], 1, Signal );
          % ms to sample
          window_sample=floor(window_ms*10^-3*fs);
          step_sample=floor(step_ms*10^-3*fs);
          % size of FFT
          N=2^(nextpow2(window_sample));
          % calcul de nbFrame %
          nbFrame=floor((numel(speech)-window_sample)/step_sample);
          % Allocation statique de X_im %  
          X_im=zeros(N,nbFrame); %(N/2)+1
          % Allocation statique d'un vecteur intermédiaire de longueur N %
          % Fenêtre de hanning de longueur L_n %
          Hanning=hamming(window_sample);
          for  w = 1:nbFrame % Pour chaque fenètre
              pos_v = (1+(w-1)*step_sample):((w-1)*step_sample+window_sample);
              intermediate = abs(fft(speech(pos_v).* Hanning,N)); % On stocke l'ensemble de la valeur dans un vecteur intermédiaire
              
              X_im(:,w)=intermediate(1:N); % On récupère les N.2 premières valeurs % %% (N/2)+1
          end 
end