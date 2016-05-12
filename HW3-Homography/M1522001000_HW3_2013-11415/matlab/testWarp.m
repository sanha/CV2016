% testing warpImage for wdc
wdc1 = imread('wdc1.jpg');
wdc2 = imread('wdc2.jpg');
load ./points.mat
H_wdc = computeH(points1', points2');

%%
Iin = wdc1;
Iref = wdc2;
H = H_wdc;

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
%%
wdc1 = imread('wdc1.jpg');
wdc2 = imread('wdc2.jpg');
load ./points.mat
H_wdc = computeH(points1', points2');

Iin = wdc1;
Iref = wdc2;
H = H_wdc;

    [warp_wh, merge_wh, warp_rel, merge_rel] = warpFrame(Iin, Iref, H);
    Iwarp = zeros(warp_wh(2), warp_wh(1), 3);
    Imerge = zeros(merge_wh(2), merge_wh(1), 3);
    H_pinv = pinv(H);
    
    % fill warp image
    [h w] = size(Iin(:,:,1));
    for i=1:int64(warp_wh(2))
        for j=1:int64(warp_wh(1))
            cord_orig = H_pinv * double([j - warp_rel(1);i - warp_rel(2);1]);
            cord_norm = cord_orig(1:2) / cord_orig(3);
            if (cord_norm(1) < 1) || (cord_norm(1) > w) || (cord_norm(2) < 1) || (cord_norm(2) > h)
                Iwarp(i,j,:) = 0; 
            else
                Iwarp(i,j,:) = Iin(uint64(cord_norm(2)), uint64(cord_norm(1)), :);
            end
        end
    end
    tmp = Iwarp(:,:,1);
    
    %% normalize matrix
    pixels = size(Iwarp(:,:,1),1) * size(Iwarp(:,:,1),2);
    Iwarp(:,:,1) = Iwarp(:,:,1) ./ max(reshape(Iwarp(:,:,1),[1 pixels]));
    Iwarp(:,:,2) = Iwarp(:,:,2) ./ max(reshape(Iwarp(:,:,2),[1 pixels]));
    Iwarp(:,:,3) = Iwarp(:,:,3) ./ max(reshape(Iwarp(:,:,3),[1 pixels]));
    
    tmp = Iwarp(:,:,1);
    
%%
[Iwarp Imerge] = warpImage(wdc1, wdc2, H_wdc);

imtool(Iwarp);
imtool(Imerge);
%save ../result/wdc1_warped.jpg Iwarp
%save ../result/wdc_merged.jpg Imerge

%% testing warpImage for crop
crop1 = imread('crop1.jpg');
crop2 = imread('crop2.jpg');
load ./cc1.mat
load ./cc2.mat
H_crop = computeH(cc1, cc2);

[Iwarp_crop Imerge_crop] = warpImage(crop1, crop2, H_crop);

imtool(Iwarp_crop);
imtool(Imerge_crop);
%save ../result/crop1_warped.jpg Iwarp_crop
%save ../result/crop_merged.jpg Imerge_crop