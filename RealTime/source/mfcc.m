function coeff =mfcc(buffer,fs)
    %% Parameter %%
       nb_filter=40;
       freq_limits=[10, fs/2];
       nb_cepstral_coef=12;
       cepstral_sine_lifter_parameter=22;
  
   
   %dtcm  (function from
   %https://www.mathworks.com/matlabcentral/fileexchange/32849-htk-mfcc-matlab/content/mfcc/mfcc.m)
    dctm = @(N , M )( sqrt(2.0/M) * cos( repmat([0:N-1].',1,M) ...
                                       .* repmat(pi*([1:M]-0.5)/M,N,1) ) );
                                   
    ceplifter = @( N, L )( 1+0.5*L*sin(pi*(0:N-1)/L) );
   
   % variables concerning FFT
   nfft = 2^nextpow2(numel(buffer)); % length of FFT
   freq_response = nfft/2 +1 ; % length of the unique part of FFT
   
   % STFT 
   Magnitude = short_time_fourier_transform (Signal, window_ms, step_ms, fs);
   % creation of triangular filterbank
   TFB = triangular_filterbank (nb_filter, freq_response,freq_limits);
   % Filterbank application to unique part of FFT magnitude
   FBA = TFB * Magnitude(1:freq_response,:);
   
   %DCT
   DCT=dctm(nb_cepstral_coef,nb_filter);
   
   % Cepstral coefficients
   Cepstral_coeff= DCT*log(FBA);
   % lifter low pass
   lifter_low_pass=ceplifter(nb_cepstral_coef,cepstral_sine_lifter_parameter);
   
   % liftering cepstral coefficient 
   
   coeff=diag(lifter_low_pass)*Cepstral_coeff;
end