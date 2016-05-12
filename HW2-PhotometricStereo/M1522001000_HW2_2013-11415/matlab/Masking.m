function [masked_mat] = Masking(ImageName, ov_mat, maskThreshold)
%filtering background by appling mask file
%   ov_mat: Num of images X Pixels
    maskfname = sprintf('%smask.png',ImageName);
    im = (imread(maskfname) >= maskThreshold);
    mask = reshape(im, [1,size(im,1) * size(im,2)]);
    
    mask_mat = [];
    for i=1:size(ov_mat, 1)
        mask_mat = [mask_mat; mask];
    end
    
    mask_mat = im2double(mask_mat);
    ov_mat = im2double(ov_mat);
    
    masked_mat = ov_mat .* mask_mat;
end

