function Lift_cepstral_coeffs=MFCC(Signal, window_ms, step_ms , fs, varargin)
   % checking nargin
   if(nargin ==4)
       nb_filter=20;
       freq_limits=[300, fs/2-300];
       nb_cepstral_coef=13;
       cepstral_sine_lifter_parameter=22;
   elseif (nargin ==5)
       nb_filter= varargin{1};
   elseif (nargin ==6)
       freq_limits=varargin{2};
   elseif (nargin ==7)
       nb_cepstral_coef=varargin{3};
   elseif(nargin <4)
      
       return;
   else
       return;
   end
   
   % conversion ms to sample
   window_sample= floor(window_ms*10^-3*fs);
   step_sample = floor(step_ms*10^-3*fs);
   
   %dtcm  (function from
   %https://www.mathworks.com/matlabcentral/fileexchange/32849-htk-mfcc-matlab/content/mfcc/mfcc.m)
    dctm = @(N , M )( sqrt(2.0/M) * cos( repmat([0:N-1].',1,M) ...
                                       .* repmat(pi*([1:M]-0.5)/M,N,1) ) );
                                   
    ceplifter = @( N, L )( 1+0.5*L*sin(pi*(0:N-1)/L) );
   
   % variables concerning FFT
   nfft = 2^nextpow2(window_sample); % length of FFT
   freq_response = nfft/2 +1 ; % length of the unique part of FFT
   
   % STFT 
   Magnitude = short_time_fourier_transform (Signal, window_ms, step_ms, fs);

   % creation of triangular filterbank
   TFB = triangular_filterbank (nb_filter, freq_response,freq_limits, fs);
   % Filterbank application to unique part of FFT magnitude
   FBA = TFB * Magnitude(1:freq_response,:);
   %DCT
   DCT=dctm(nb_cepstral_coef,nb_filter);
   % Cepstral coefficients
   Cepstral_coeff= DCT*log(FBA);

   % lifter low pass
   lifter_low_pass=ceplifter(nb_cepstral_coef,cepstral_sine_lifter_parameter);
   
   % liftering cepstral coefficient 
   
   Lift_cepstral_coeffs=diag(lifter_low_pass)*Cepstral_coeff;
end