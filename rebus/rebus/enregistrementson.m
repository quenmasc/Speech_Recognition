%%enregistrement d'un signal
clear;
[kk,vv]=recorder('B1');
%[zr,ste,frame]=STE_ZRC(kk,10,8000);
figure(1)
subplot(2,1,1)
spectrogram(kk,hann(4),'yaxis');
subplot(2,1,2)
plot(kk)

%% variable
            L_sec		= 0.025;		% --- analysis window length in seconds
            STEP_sec	= 0.010;
            sr_hz=48000;
            audio_v=kk;
            L_n=round(L_sec*sr_hz);
            STEP_n=round(STEP_sec*sr_hz);
            N=2^(nextpow2(L_n));
            audio_v=mean(audio_v,2);
            LT_n=length(audio_v); 
            X_im= F_stft(LT_n, STEP_n, L_n,N, audio_v);

            
            [ CC, FBE, frames ] = mfcc( kk, 48000, 25, 10, 0.6, hann(1200),[300 4000], 20, 13, 22 );

