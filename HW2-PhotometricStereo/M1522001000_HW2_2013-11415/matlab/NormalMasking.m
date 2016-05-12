function [maskedNormal] = NormalMasking(normal, mask, maskThreshold)
%filtering background of referencd image normal by appling mask file
%   refNormal: hight X width X 3
    hight = size(mask,1);
    width = size(mask,2);
    for i=1:hight
        for j=1:width
            if mask(i, j) <= maskThreshold
                normal(i, j, :) = [0, 0, 0];
            end
        end
    end
 
    maskedNormal = normal;
end

