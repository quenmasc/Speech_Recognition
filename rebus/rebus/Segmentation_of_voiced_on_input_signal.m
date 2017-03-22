function [segments,Limits, Flags]= Segmentation_of_voiced_on_input_signal(Flags, Signal, weight,window_sample,step_sample)
    Autorisation =(find(Flags==1));
    Flags=+Flags;
    Rejected=0;
%     for i=1:(length(Flags)-weight)
%         if(Flags(i:i+weight-1)==ones(1,weight))
%             Flags(i)=Flags(i);
%         else
%             Flags(i)=0;
%             Rejected=Rejected+1;
%         end
%     end
    for i=weight:(length(Flags)-weight)
        nber_one =length(find(Flags(i-weight+1:i+weight-1)==1));
        nber_zero =length(find(Flags(i-weight+1:i+weight-1)==0));
        if (nber_one<nber_zero)
            Flags(i)=0;
        else
            Flags(i)=1;
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
end
