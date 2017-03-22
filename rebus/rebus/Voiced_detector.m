function [Position1, Position2, segments3, Rejected, Flags, Flags2, ok3, zero_cross_rate,Energy, entropy,th]= Voiced_detector(Signal,fs,window_ms, step_ms)

    % variables
    Weight=2;
    weight=2;
    %Threshold_energy= 0.0001;
   % Threshold_mass_of_center = 0.00002;
    step_sample =floor(step_ms*10^-3*fs);
    window_sample=floor(window_ms*10^-3*fs);
    % Determine STE, Spectral centroid, TKE and Entropy
    tke=Teager_Kaiser_Energy(Signal);
    Energy=short_time_energy(Signal,window_ms,step_ms,fs);
    mass_of_center=spectral_centroid(Signal, window_ms, step_ms, fs,'hanning',0.010);
    zero_cross_rate=zero_crossing_rate(Signal, window_ms, step_ms, fs);
    [entropy]=entropy_estimation(tke, window_ms,step_ms,fs);  
    figure(1);hold on ;plot(Signal); plot(tke);  hold off ; legend('signal','tke');
    
    % Find threshold of each one 
[HistE, X_E] = hist(Energy, round(length(Energy) / 10));  % histogram computation
[MaximaE, countMaximaE] = findMaxima(HistE, 3); % find the local maxima of the histogram
if (size(MaximaE,2)>=2) % if at least two local maxima have been found in the histogram:
    Threshold_energy = (Weight*X_E(MaximaE(1,1))+X_E(MaximaE(1,2))) / (Weight+1); % ... then compute the threshold as the weighted average between the two first histogram's local maxima.
else
    Threshold_energy = E_mean / 2;
end
% Find spectral centroid threshold:
[HistC, X_C] = hist(mass_of_center, round(length(mass_of_center) / 10));
[MaximaC, countMaximaC] = findMaxima(HistC, 3);
if (size(MaximaC,2)>=2)
    Threshold_mass_of_center = (Weight*X_C(MaximaC(1,1))+X_C(MaximaC(1,2))) / (Weight+1);
else
    Threshold_mass_of_center = Z_mean / 2;
end
    % threshold 
    [maxim,minim,th]=adaptive_threshold(entropy,4,1);
    figure(2);
    plot(th);
    % Applying threshold and extract a logical matrix 
    Flags= (Energy>=Threshold_energy) & (mass_of_center>=Threshold_mass_of_center);
    Flags2=(Energy>=Threshold_energy)&(zero_cross_rate<0.5);
    Flags3=(entropy>0.001);
    % plot
    
    zero_cross_rate(zero_cross_rate>=0.5)=0;
    Energy(Energy<Threshold_energy)=0;
    
    %
    ok3=+Flags3;
    segments2=Segmentation_of_voiced_on_input_signal(Flags2,Signal,8,window_sample,step_sample);
    segments3=Segmentation_of_voiced_on_input_signal(Flags3,Signal,1,window_sample,step_sample); % check segments de reinforce result -> error of count : check weight
    Autorisation =(find(Flags==1));
    Flags=+Flags;
    Flags2=+Flags2;
    Rejected=0;
    for i=1:(length(Flags)-weight)
        if(Flags(i:i+weight-1)==ones(1,weight))
            Flags(i)=Flags(i);
        else
            Flags(i)=0;
            Rejected=Rejected+1;
        end
    end

    %% find position of each "1" in the logical matrix %%
    % allocation %
    Limits=zeros(2,numel(Autorisation));
    
    % Initialization %
    count=1;
    
    % Loop %
    for w=1:length(Flags)
        if (Flags(w)==1)
            if (Limits(1,count)~=0)
                Limits(2,count)=(w-1)*step_sample+window_sample;
            else
                Limits(1,count)=1+(w-1)*step_sample;
            end
        end
        if (w>2)
            if(Flags(w-1)==1 && Flags(w)==0)
                count=count+1;
            end
        end
    end
    Limits(Limits==0) = [];
    Limits=reshape(Limits,2,[]);
    
    %% Create segments of voice extraction
    % allocation %
    segments = {};
    
    % Loop %
    for w=1:size(Limits,2)
        segments{w} = Signal(Limits(1,w):Limits(2,w)); 
    end
    Position1=segments;
    Position2=segments2;
    figure(3);
    subplot(511) ; 
    plot(Signal(100:end));
    subplot(512) ;
    plot(zero_cross_rate);
    title('zero cross rate');
    subplot(513)
    plot(mass_of_center);
    title('centre de masse');
    subplot(514); 
    plot(Energy);
    title('Energy');
    subplot(515) ;
    plot(entropy);
    title('Entropy');

end

