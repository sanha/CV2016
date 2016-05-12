function [centerX, centerY, radius] = FindCylinderCenter(im, maskThreshold)
%find reference sphere image's center and radius
    top = 0;
    bottom = 0;
    xFlag = 0;
    xStart = 0;
    xFinish = 0;
    
    for i=1:size(im,1)
        for j=1:size(im,2)
            if (xFlag == 0) & (im(i,j) > maskThreshold)
                xFlag = 1;
                top = i;
                xStart = j;
            elseif (xFlag == 1) & (im(i,j) <= maskThreshold)
                xEnd = j-1;
                break
            end
        end
        if xFlag == 1
            break
        end
    end
    centerX = (xStart + xEnd)/2;
    
    for i=1:size(im,1)
        if im(size(im,1) - i + 1,int64(centerX)) > maskThreshold
            bottom = size(im,1) - i + 1;
            break
        end
    end

    if (top == 0) | (bottom == 0)
        'there are no sphere!'
        centerX = 0;
        centerY = 0;
        radius = 0;
    else
        radius = (xEnd - xStart)/2;
        centerY = (top + bottom)/2;
    end
end

