function entropy=spectral_entropy(buffer, nfft)
    % need to optimize this function 
    % Histogramme
      PDF=periodogram(buffer,[],nfft);
      PDF=PDF./sum(sum(PDF));
    % normalize histogram
      log_pi=log2(PDF+eps);
      pi=PDF+eps;
      entropy=-sum((pi.*log_pi).');

end