function [TotalP] = CalcTotalP(image1, image2, threshold, convergence_limit)
    p = zeros(6, 1);
    [hight, width] = size(image1);
    
    for iterate = 1:convergence_limit        
        tform = affine2d([1+p(1, 1), p(3, 1), p(5, 1) ; p(2, 1), 1+p(4, 1), p(6, 1); 0 0 1]');
        xWorldLimits = [1 width];
        yWorldLimits = [1 hight];
        refArea = imref2d(size(image1),xWorldLimits,yWorldLimits);
        I_warped = imwarp(image1, tform, 'OutputView', refArea);
        
        mask = (I_warped ~= 0);
        error_image = (image2 .* mask) - I_warped;
        [grad_x, grad_y] = gradient(I_warped);
        
        hessian = zeros(6,6);
        delta_p_suffix = zeros(6, 1);
        for i=1:hight
            if (i >= hight * 0.05) && (i <= hight * 0.95)
                for j=1:width
                    if (j >= width * 0.05) && (j <= width * 0.95)
                        jacobian = [j, 0, i, 0, 1, 0; 0, j, 0, i, 0, 1];
                        hessian_element = [grad_x(i,j), grad_y(i,j)] * jacobian;
                        hessian = hessian + (hessian_element' * hessian_element);
                        delta_p_suffix = delta_p_suffix + (hessian_element' * error_image(i, j));
                    end
                end
            end
        end
        
        delta_p = hessian \ delta_p_suffix;
        p = p - delta_p;
        
        if norm(delta_p) <= threshold
            break
        end
    end
    
    TotalP = p;
end