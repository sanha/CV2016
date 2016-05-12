function [Z] = PhotometricStereo(TargetImageName, RefImageName, NumberOfImages, isRefASphere)
    targetOV = [];
    refOV = [];
    maskThreshold = 50;  
    for i=1:3
        pure_t_OV_rgb = createObjectVectors(TargetImageName, NumberOfImages, i);
        t_OV_rgb = Masking(TargetImageName, pure_t_OV_rgb, maskThreshold);
        targetOV = [targetOV; t_OV_rgb];
        pure_r_OV_rgb = createObjectVectors(RefImageName, NumberOfImages, i);
        r_OV_rgb = Masking(RefImageName, pure_r_OV_rgb, maskThreshold);
        refOV = [refOV; r_OV_rgb];
    end
    idx = kdtreeidx2(refOV, targetOV);
      
    if isRefASphere == 1
        refNormal = CreateSphereNormal(RefImageName, maskThreshold);
    else
        refNormal = CreateCylinderNormal(RefImageName, maskThreshold);
    end
    
    maskfname = sprintf('%smask.png',TargetImageName);
    im = imread(maskfname);
    [hight, width] = size(im);
    normal = zeros(1, hight * width, 3);
    for i=1:hight * width
        normal(1,i,:) = refNormal(1, idx(i), :);
    end
    normal = reshape(normal, [hight, width, 3]);
    maskedNormal = NormalMasking(normal, im, maskThreshold);
    
    nrows = 2^11;
    ncols = 2^11;
    [Ni,Z] = integrability2(maskedNormal,[], nrows,ncols);
    
    figure
    mesh(Z)
    light('Position',[0 0 1],'Style','local')
    axis equal
    if strcmp(TargetImageName, 'bottle')
        colormap summer
    else 
        colormap default
    end
end

