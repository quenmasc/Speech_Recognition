%% MASCRET Quentin - Copyright 2017 
% This function allow to extract speech in a recording. 
%% DATE 02-24-17
%% Maj 1.2
%
%% INPUT 
% Signal = vector of 1 x n dimension -> mono
% window_ms= length of frame in ms
% step_ms = step between two windows in ms
% fs = sample rate 
%
%% OUTPUT 
% Segments : segments of speech extraction
%
function [segments,Signal,Limits,fs]=Vocal_algorithm_dectection(Init,time_record,fs)
    % clearing and closing
%    clear;
%    close all;
    clc;
    
    %% add path
    addpath('../Ressources');
    % variables
    nbin=100 ;  % fixed by default (need to be between 50 and 100 for best accuracy of adaptive threshold)
    weight=2;
    p=0.95;
   % fs=16000; % fixed by default (need to be over 12 000 Hz according to Shanon Theorem)
    step_ms= 5;% fixed by default 
    window_ms = 15; % fixed by default
    time_exclusion=0.100;%ms
    
    % conversion ms to samples
    step_sample =floor(step_ms*10^-3*fs);
    window_sample=floor(window_ms*10^-3*fs);
    
    % Recording 
%     label=strcat('You can speak for ~',num2str(time_record),' s. Do you want to change it ? Y/N [Y]: \n');
%     strp= input(label,'s');
%     if (isempty(strp))
%         strp='Y';
%     end
%     if (strp=='Y')
%         time_record=input('Input a new time of recording : \n');
%     end
%     clc; 

    %% add 02.28.17
%     label1=strcat('No Speak, I analyze your environment');
%     [Init,~]=recorder(label1,time_init);
    %% end add
    label2=strcat('You can speak for ~',num2str(time_record),' s.');
    [Signal,~]=recorder(label2,time_record);
    % Delete 400 pop at the beginning du to microphone opening
    Signal=Signal(400:end);
    
    %% add 02.28.17
%     Init=Init(400:end);
%     Init=Init-mean(Init);
%     Init=Init/max(abs(Init));
    %% end add
  %  Signal=[In; Signal];
    % Pretraitement
    Signal=Signal-mean(Signal);
    Signal=Signal/max(abs(Signal));
    %% tool  %%
    %% Pre-traitment in order to suppress percussive noise
    % Calculation of entropy with our previous envelope for best accuracy
    %% add entropy_noise  and MFCC_noise 02.28.17
    Entropy_noise=entropy_noise(Init, window_ms,step_ms,fs);
    entropy=entropy_estimation(Signal, window_ms,step_ms,fs,0.95,Entropy_noise);
    
    % EndPoint based on Wang and Al. 2011 Algorithm
    endpoint=EndPoint(Signal,window_ms,step_ms,fs,0.9,EndPoint_noise(Init, window_ms, step_ms, fs));

    % zero-crossing-rate 
    %zrc=zero_crossing_rate(Signal,window_ms,step_ms,fs);
    % Spectral flux 
    %flux=spectral_flux(Signal,window_ms, step_ms, fs, p);
    
    % Energy
    energy=short_time_energy(Signal,window_ms, step_ms, fs);
    
    % Treatment EndPoint function
        % threshold
   % th_noise=mean(endpoint(1:20))+3*std(endpoint(1:20));
    th=sigmoide_function(10,endpoint);%variable_threshold(endpoint,th_noise,0.96);
    th_e_noise=mean(entropy(1:20))+3*std(entropy(1:20));
    th_e=variable_threshold(entropy,th_e_noise,0.96);
    
   % th_en=mean(energy(1:20))+3*std(energy(1:20));
   % th_zrc=mean(zrc(1:20))+3*std(zrc(1:20));
    % Flags of EndPoint function
    flags=(endpoint>th)&(entropy>th_e);

    
    %% Envelope of Signal
        % nbFrame 
        nbFrame = floor((numel(Signal)-window_sample)/step_sample);
        % Allocation of memory
        env=zeros(1,nbFrame);
        for w=1:nbFrame
            env(w)=sum(envelope(Signal((1+(w-1)*step_sample):((w-1)*step_sample+window_sample)),5,'rms'));
        end
        env=medfilt1(env,3);
    
    %% Flags and corrective patch
 %   Flags_k=remove_impulsion(entropy, flags);
  %  Flags_k=BeginEndSegments(env,flags);
    Flags_k=flags;
    %% Segments
    [segments, Limits, Fl, rej]=Segmentation_of_voiced_on_input_signal(Flags_k,Signal,weight,window_sample,step_sample,fs);

    %% PLOT %% 
    figure(1)
    subplot(611);
    hold on
    plot(endpoint);
    plot(th);
    title('MFCC feature and threshold');
    hold off ;
    subplot(612);
    plot(Signal);
    title('Input Signal');
    subplot(613);
    hold on
    plot(entropy);
    plot(th_e);
    title('Entropy feature and threshold');
    hold off
    subplot(614);
    hold on
    plot(Fl);
    plot(Flags_k);
    hold off
    legend('end','corr');
    subplot(615);
    plot(env);
    title('SubFrame Envelope');
    

  
    %% Result
     %% PLOT RESULTS
%     figure(2)
%     
%     time = 0:1/fs:(length(Signal)-1) / fs;
%     for i=1:length(segments)
%         hold off;
%         P1 = plot(time, Signal); set(P1, 'Color', [0.7 0.7 0.7]);    
%         hold on;
%         for j=1:length(segments)
%             if (i~=j)
%                 timeTemp = Limits(1,j)/fs:1/fs:Limits(2,j)/fs;
%                 P = plot(timeTemp, segments{j});
%                 set(P, 'Color', [0.4 0.1 0.1]);
%             end
%         end
%         timeTemp = Limits(1,i)/fs:1/fs:Limits(2,i)/fs;
%         P = plot(timeTemp, segments{i});
%         set(P, 'Color', [0.9 0.0 0.0]);
%         axis([0 time(end) min(Signal) max(Signal)]);
%         sound(segments{i}, fs);
%         clc;
%         fprintf('Playing segment %d of %d. Press any key to continue...', i, length(segments));
%         pause
%     end
%     clc
%     hold off;
%     P1 = plot(time, Signal); set(P1, 'Color', [0.7 0.7 0.7]);    
%     hold on;    
%     for i=1:length(segments)
%         for j=1:length(segments)
%             if (i~=j)
%                 timeTemp = Limits(1,j)/fs:1/fs:Limits(2,j)/fs;
%                 P = plot(timeTemp, segments{j});
%                 set(P, 'Color', [0.4 0.1 0.1]);
%             end
%         end
%         axis([0 time(end) min(Signal) max(Signal)]);
%     end
%     title('Signal vs Segments');
%   
    %% DISP %%
%     disp('Default configuration');
%     disp('- - - - - - - - - - - - - - - - - - - - - - - - - - - - -');
%     fprintf('nombre de bin pour le calcul des seuils : %d .\n', nbin);
%     fprintf('Sample rate : %d. \n',fs);
%     fprintf('Time of record : %d. \n',time_record);
%     fprintf('Step forward in ms : %d. \n',step_ms);
%     fprintf('Length of working window in ms : %d. \n',window_ms);
%     fprintf('Number of segments : %d . \n',length(segments));
%     disp('- - - - - - - - - - - - - - - - - - - - - - - - - - - - -');
%     disp('Copyright Quentin MASCRET && Génie électrique et informatique - Université Laval');
%     disp('MAJ 2.1 02.24.2017');

end

