function [refNormal] = CreateSphereNormal(RefImageName, maskThreshold)
%create normal of reference sphere
%   refNormal: 1 X # of pixels X 3
    maskfname = sprintf('%smask.png',RefImageName);
    im = imread(maskfname);
    [hight, width] = size(im);
    
    [centerX, centerY, radius] = FindSphereCenter(im, maskThreshold);
    refNormal = zeros(hight, width, 3);
    
    for i=1:hight
        for j=1:width
            relX = j - centerX;
            relY = centerY - i;
            refNormal(i,j,:) = [relX / radius, relY / radius, sqrt(abs(radius^2 - relX^2 - relY^2)) / radius];
        end
    end
    
    maskedRefNormal = NormalMasking(refNormal, im, maskThreshold);
    refNormal = reshape(maskedRefNormal, [1, hight * width, 3]);
end

