function [threshold]=adaptive_threshold(Signal,window_reshape, nbin) %{th_high, maxim%}
    % first high threshold 
    moy_signal=mean(Signal,2);
    Signal(Signal>moy_signal)=min(Signal);
    Signal(Signal==moy_signal)=min(Signal);
    % First split of input Signal
    nbFrame_reshape = floor(numel(Signal)/window_reshape);
    
    % checking
    if (nbFrame_reshape*window_reshape~=numel(Signal))
        Signal=[Signal , zeros(1,((nbFrame_reshape+1)*window_reshape)-numel(Signal))];
        nbFrame_reshape=nbFrame_reshape+1;
    end
    Signal=reshape(Signal,window_reshape,[]);
    maxima= zeros(1,nbFrame_reshape);
    for v=1:nbFrame_reshape
        maxima(v)=max(Signal(:,1));
    end
    [h,c]=hist(maxima,nbin);
    h=h./sum(h);
    h(isnan(h))=0;
    threshold=sum((h.*c).');

%     for w=1:nbFrame_reshape
%         threshold(1+(w-1)*window_reshape:(w-1)*window_reshape+window_reshape)=th_high(w);
%     end
%    threshold=threshold(1:Signal_length);
end