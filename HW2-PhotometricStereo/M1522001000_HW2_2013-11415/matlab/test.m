    %%    
    TargetImageName = 'bottle';
    RefImageName = 'sphere';
    NumberOfImages = 8;
    isRefASphere = 1;
    
    PhotometricStereo(TargetImageName, RefImageName, NumberOfImages, isRefASphere);
    
    %%
    TargetImageName = 'velvet';
    RefImageName = 'vcylinder';
    NumberOfImages = 14;
    isRefASphere = 0;
    
    PhotometricStereo(TargetImageName, RefImageName, NumberOfImages, isRefASphere);
    
    %%
    TargetImageName = 'wavy';
    RefImageName = 'wcylinder';
    NumberOfImages = 14;
    isRefASphere = 0;
    
    PhotometricStereo(TargetImageName, RefImageName, NumberOfImages, isRefASphere);