function MFCCs=MFCCsFilter(MFCCsInit)
   %% addpath
   addpath('Tools');
   MFCCs=conv2(MFCCsInit,gaussian1d(2,0.709),'same');
end