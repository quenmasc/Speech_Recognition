function [segments,Limits, Flags, rejection]= Segmentation_of_voiced_on_input_signal(Flags, Signal, weight,window_sample,step_sample,fs)
    
    % variables 
    time_rejection=0.050 ; %(100 ms)
    rejection=0;
    
    % COnversion
    Autorisation =(find(Flags==1)); 
    Flags=correction_flag(Flags,weight);
     % nbFrame 
        nbFrame = floor((numel(Signal)-window_sample)/step_sample);
        % Allocation of memory
        env=zeros(1,nbFrame);
        for w=1:nbFrame
            env(w)=sum(envelope(Signal((1+(w-1)*step_sample):((w-1)*step_sample+window_sample)),5,'rms'));
        end
      %  env=medfilt1(env,3);
    Flags=BeginEndSegments(env,Flags);
    %% find position of each "1" in the logical matrix %%
    % allocation %
    Limits=zeros(2,numel(Autorisation));
    
    % Initialization %
    count=1;
    
    % Loop %
    for w=1:length(Flags)-1
        if (Flags(w)==1)
            if (Limits(1,count)~=0)
                Limits(2,count)=(w-1)*step_sample+window_sample;
            else
                Limits(1,count)=1+(w-1)*step_sample;
            end
        end
        if (w>2)
            if(Limits(2,count)~=0 && Flags(w-1)==1 && Flags(w)==0)
                count=count+1;
            end
        end
    end
    Limits(Limits==0) = [];
    Limits=reshape(Limits,2,[]);
    Vect_test=Limits(2,:)-Limits(1,:);
    for i=1:length(Vect_test)
        if(Vect_test(i)<=fs*time_rejection)
            Limits(1,i)=0;
            Limits(2,i)=0;
            rejection=rejection+1;
        end
    end
    Limits(Limits==0) = [];
    Limits=reshape(Limits,2,[]);
    j=size(Limits,2);
    i=1;
    while(i<j)
        if (Limits(1,i+1)-Limits(2,i)<fs*0.200)
            Limits(2,i)=Limits(2,i+1);
            Limits(1,i+1)=0;
            Limits(2,i+1)=0;
            Limits(Limits==0)=[];
            Limits=reshape(Limits,2,[]);
            j=j-1;
        else
            i=i+1;
        end
        
    end
   
    %% Create segments of voice extraction
    % allocation %
    segments = {zeros(length(Limits))};
    % Loop %
    for w=1:size(Limits,2)
        segments{w} = Signal(Limits(1,w):Limits(2,w)); 
    end
end
