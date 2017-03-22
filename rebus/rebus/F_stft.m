function [X_im] = F_stft(LT_n, STEP_n, L_n,N, audio_v)

%% Quentin MASCRET %%
%% 2017            %%
          % calcul de nbFrame %
          nbFrame=floor((LT_n-L_n)/STEP_n);
          % Allocation statique de X_im %  
          X_im=zeros((N/2)+1,nbFrame); %(N/2)+1
          % Allocation statique d'un vecteur intermédiaire de longueur N %
          % Fenêtre de hanning de longueur L_n %
          Hanning=hann(L_n);
          for  w = 1:nbFrame % Pour chaque fenètre
              pos_v = (1+(w-1)*STEP_n):((w-1)*STEP_n+L_n);
              intermediate = fft(audio_v(pos_v).* Hanning,N); % On stocke l'ensemble de la valeur dans un vecteur intermédiaire
              X_im(:,w)=intermediate(1:(N/2)+1); % On récupère les N.2 premières valeurs %
          end   
end