function EndPoint=EndPoint_noise(Init, window_ms, step_ms, fs)

    % MFCC of all signal
    Mel_feature= MFCC(Init,window_ms, step_ms,fs);
    EndPoint=mean(Mel_feature(:,1:end),2);
end