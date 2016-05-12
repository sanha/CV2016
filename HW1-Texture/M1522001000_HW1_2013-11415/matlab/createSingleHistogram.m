function [singleHist] = createSingleHistogram(image, textureLibrary)
% Take single image and texton library and make non-normalized histogram.
% This function return 1*N vector, which of N means the number of library
% classes.
    singleHist = zeros(1, size(textureLibrary,1));
    vectors = extractResponseVectors(image);
    [min_val, min_idx] = min(dist(textureLibrary, vectors'));
    
    for i=1:size(min_idx, 2)
        singleHist(1, min_idx(i)) = singleHist(1, min_idx(i)) + 1;
    end