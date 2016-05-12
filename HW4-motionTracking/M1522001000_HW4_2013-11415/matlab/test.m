%% main script
dir_car = '../data/frames';

%input parameter
sigma = 2;
num_frames = 100;

path_to_car_sequence = dir_car;

    %numimages = 700;
    numimages = 20;
    mkdir('./output/');

    fname = sprintf('%s/%d.jpg',path_to_car_sequence,0);
    F = double(imread(fname));

    % Select the region of interest
    figure; imshow(uint8(F));
    title('first input image');
    [tempX,tempY] = ginput(2);  % get two points from the user
    close;
    roi=zeros(size(F));
    roi(tempY(1):tempY(2),tempX(1):tempX(2)) = 1 ;
    roi_x = min([tempX(1), tempX(2)]);
    roi_y = min([tempY(1), tempY(2)]);
    roi_w = abs(tempX(2) - tempX(1) + 1);
    roi_h = abs(tempY(2) - tempY(1) + 1);
    
    [whole_h, whole_w] = size(F);
    
    image2 = imgaussfilt(F, sigma);
    for i=1:numimages
        sprintf('Image No. %d',i)
        
        image1 = imcrop(image2, [roi_x, roi_y, roi_w, roi_h]);
        fname = sprintf('%s/%d.jpg',path_to_car_sequence,i);
        image2 = imgaussfilt(double(imread(fname)), sigma);
            
        count=0;
        %maxIterations = 3; % maximum number of iterations
        maxIterations = 30; % maximum number of iterations
        eps = 0.01;        % accuracty desired in terms of pixel-width
        
        u = 0; v = 0;
        du=1;dv=1;  %initialize to dummy values
        [hight, width] = size(image1);
        
        im2crop = imcrop(image2,  [roi_x, roi_y, roi_w, roi_h]);
        
        % stopping criterion for the Newton-Raphson like iteration:
        % either the frame shift is less than 'eps' of pixel width
        % or maxIterations have been done
        while ((abs(du) > eps || abs(dv) > eps) && count < maxIterations)
            count=count+1;
            %im2crop = imcrop(image2,  [roi_x+u, roi_y+v, roi_w, roi_h]);
            
            % Implement your code
            tform = affine2d([1, 0,  u; 0, 1, v; 0 0 1]');
            xWorldLimits = [1 width];
            yWorldLimits = [1 hight];
            refArea = imref2d(size(image1),xWorldLimits,yWorldLimits);
            I_warped = imwarp(image1, tform, 'OutputView', refArea);
            
            mask = (I_warped ~= 0);
            error_image = (im2crop .* mask) - I_warped;
            [grad_x, grad_y] = gradient(I_warped);

            hessian = zeros(2,2);
            delta_p_suffix = zeros(2,1);
            for y=1:hight
                if (y >= hight * 0.05) && (y <= hight * 0.95)
                    for x=1:width
                        if (x >= width * 0.05) && (x <= width * 0.95)
                            grad = [grad_x(y,x), grad_y(y,x)];
                            hessian = hessian + (grad' * grad);
                            delta_p_suffix = delta_p_suffix + (grad' * error_image(y, x));
                        end
                    end
                end
            end

            delta_p = hessian \ delta_p_suffix;
            du = delta_p(1,1);
            dv = delta_p(2,1);
            u = u - du;
            v = v - dv;
        end
        sprintf('No. of iterations: %d',count)
        
        [u v]
        %[du dv]
        
        roi_x = roi_x + u;
        if roi_x < 0 
            roi_x = 0;
        elseif roi_x > whole_w - roi_w
            roi_x = whole_w - roi_w;
        end
        roi_y = roi_y + v;
        if roi_y < 0 
            roi_y = 0;
        elseif roi_y > whole_h - roi_h
            roi_y = whole_h - roi_h;
        end
        roi=zeros(size(F));
        roi(roi_y:roi_y+roi_h, roi_x:roi_x+roi_w) = 1 ;
        
        %Make your code, draw result and save in output folder.
        if i ~= 1
            close;
        end
        
        fig = figure;
        imshowpair(image2, image2);
        hold on;
        rectangle('Position', [roi_x, roi_y, roi_w, roi_h]);
        frame = getframe(fig); 
        imwrite( frame.cdata, ['./output/tracker_' num2str(i) '.png']);    
    end
    
    %%
        %imshowpair(image2, image2);
        imshowpair(im2crop, im2crop);
        imshowpair(I_warped, I_warped);