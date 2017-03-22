function d_euclidean=EndPoint(Signal, window_ms, step_ms, fs,p, MFCC_noise)

    % MFCC of all signal
    Mel_feature= MFCC(Signal,window_ms, step_ms,fs);
    % Noise MFCC
    MFCC_noise=MFCC_noise+mean(Mel_feature(:,1:20),2);
    % allocation
    d_euclidean=zeros(1,size(Mel_feature,2));
    % Loop
    for w=1:size(Mel_feature,2)
        % update noisy MFCC vector
        cno=p*MFCC_noise+(1-p)*Mel_feature(:,w);
        % euclidean distance
        d_euclidean(w)=correlation_distance(Mel_feature(:,w),cno);
       
    end
    
    % Post-traitment
    d_euclidean=d_euclidean-min(abs(d_euclidean));
    d_euclidean=medfilt1(d_euclidean,5);
    d_euclidean=d_euclidean/max((d_euclidean));
    
    
    
    
    
end