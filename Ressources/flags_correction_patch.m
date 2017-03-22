function Flags=flags_correction_patch(Flags, fs,time_exlusion)
    % variables locales 
    Flags=+Flags;
    weight=2;
  
    for i=weight:(length(Flags)-weight)
        nber_one =length(find(Flags(i-weight+1:i+weight-1)==1));
        nber_zero =length(find(Flags(i-weight+1:i+weight-1)==0));
        if (nber_one<nber_zero)
            if(Flags(i)==0)
                Flags(i)=Flags(i);
            else
                Flags(i)=0;
            end
        else
            if (Flags(i)==1)
                Flags(i)=Flags(i);
            else
                Flags(i)=1;
            end
        end
    end
end