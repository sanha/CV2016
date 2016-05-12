function [Moving_image] = SubtractDominantMotion(image1, image2)  
    threshold = 0.05;
    convergence_limit = 20;
    p = CalcTotalP(image1, image2, threshold, convergence_limit);
    
    [hight, width] = size(image1);
    tform = affine2d([1+p(1, 1), p(3, 1), p(5, 1) ; p(2, 1), 1+p(4, 1), p(6, 1); 0 0 1]');
    xWorldLimits = [1 width];
    yWorldLimits = [1 hight];
    refArea = imref2d(size(image1),xWorldLimits,yWorldLimits);
    I_warped = imwarp(image1, tform, 'OutputView', refArea);
    
    mask = (I_warped ~= 0);
    error_image = (image2 .* mask) - I_warped;
    
    Moving_image = hysthresh(abs(error_image), 20, 10);
end