function [Iwarp, Imerge] = warpImage(Iin, Iref, H)
%warping image
%   Iin: input image
%   Iref: reference image
%   H: Homography
%   Iwarp: img that input image warped to be in the frame of ref img.
%   Imerge: a single mosaci image with a larger filed of view.
    % construct frame
    [warp_wh, merge_wh, warp_rel, merge_rel] = warpFrame(Iin, Iref, H);
    Iwarp = zeros(warp_wh(2), warp_wh(1), 3);
    Imerge = zeros(merge_wh(2), merge_wh(1), 3);
    H_pinv = pinv(H);
    
    % fill warp image
    [h w] = size(Iin(:,:,1));
    for i=1:warp_wh(2)
        for j=1:warp_wh(1)
            cord_orig = H_pinv * double([j - warp_rel(1);i - warp_rel(2);1]);
            cord_norm = cord_orig(1:2) / cord_orig(3);
            if (cord_norm(1) < 1) || (cord_norm(1) > w) || (cord_norm(2) < 1) || (cord_norm(2) > h)
                Iwarp(i,j,:) = 0; 
            else
                Iwarp(i,j,:) = Iin(uint64(cord_norm(2)), uint64(cord_norm(1)), :);
            end
        end
    end
    % normalize matrix
    pixels = size(Iwarp(:,:,1),1) * size(Iwarp(:,:,1),2);
    Iwarp(:,:,1) = Iwarp(:,:,1) ./ max(reshape(Iwarp(:,:,1),[1 pixels]));
    Iwarp(:,:,2) = Iwarp(:,:,2) ./ max(reshape(Iwarp(:,:,2),[1 pixels]));
    Iwarp(:,:,3) = Iwarp(:,:,3) ./ max(reshape(Iwarp(:,:,3),[1 pixels]));
    
    % fill merge image
    [h w] = size(Iin(:,:,1));
    [h_r w_r] = size(Iref(:,:,1));
    for i=1:merge_wh(2)
        for j=1:merge_wh(1)
            if (i > merge_rel(2)) && (i <= merge_rel(2) + h_r) && (j > merge_rel(1)) && (j <= merge_rel(1) + w_r)
                Imerge(i,j,:) = Iref(i - merge_rel(2), j - merge_rel(1), :);
            else
                cord_orig = H_pinv * double([j - merge_rel(1);i - merge_rel(2);1]);
                cord_norm = cord_orig(1:2) / cord_orig(3);
                if (cord_norm(1) < 1) || (cord_norm(1) > w) || (cord_norm(2) < 1) || (cord_norm(2) > h)
                    Imerge(i,j,:) = 0; 
                else
                    Imerge(i,j,:) = Iin(uint64(cord_norm(2)), uint64(cord_norm(1)), :);
                end
            end
        end
    end
    % normalize matrix
    pixels = size(Imerge(:,:,1),1) * size(Imerge(:,:,1),2);
    Imerge(:,:,1) = Imerge(:,:,1) ./ max(reshape(Imerge(:,:,1),[1 pixels]));
    Imerge(:,:,2) = Imerge(:,:,2) ./ max(reshape(Imerge(:,:,2),[1 pixels]));
    Imerge(:,:,3) = Imerge(:,:,3) ./ max(reshape(Imerge(:,:,3),[1 pixels]));
end