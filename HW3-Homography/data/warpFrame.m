function [warp_wh, merge_wh, warp_rel, merge_rel] = warpFrame(img_mov, img_ref, H)
%make new frame for img warping according to H
    % compute warped vertex
    [h w] = size(img_mov(:, :, 1));
    vertex_mov = [1 w w 1; h h 1 1; 1 1 1 1];
    vertex_warp = H * vertex_mov;
    vertex_norm = zeros(2, 4);
    for i=1:4
        vertex_norm(:,i) = vertex_warp(1:2,i) / vertex_warp(3,i);
    end
    % construct warp frame
    warp_max = max(vertex_norm');
    warp_min = min(vertex_norm');
    warp_wh = int64(warp_max - warp_min);
    warp_rel = [1 1] - warp_min;
    
    % contsruct merge frame
    [h w] = size(img_ref(:, :, 1));
    vertex_ref = [1 w w 1; h h 1 1];
    vertex_total = [vertex_norm vertex_ref];
    merge_max = max(vertex_total');
    merge_min = min(vertex_total');
    merge_wh = int64(merge_max - merge_min);
    
    merge_rel = int64([1 1] - merge_min);
end

