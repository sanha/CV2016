function [refNormal] = CreateCylinderNormal(RefImageName, maskThreshold)
%create normal of reference cylinder
%   refNormal: 1 X # of pixels X 3
    maskfname = sprintf('%smask.png',RefImageName);
    im = imread(maskfname);
    [hight, width] = size(im);
    
    [centerX, centerY, radius] = FindCylinderCenter(im, maskThreshold);
    refNormal = zeros(hight, width, 3);
    
    for i=1:hight
        for j=1:width
            relX = j - centerX;
            relY = centerY - i;
            refNormal(i,j,:) = [relX / radius, 0, sqrt(abs(radius^2 - relX^2)) / radius];
        end
    end
    
    maskedRefNormal = NormalMasking(refNormal, im, maskThreshold);
    refNormal = reshape(maskedRefNormal, [1, hight * width, 3]);
end

