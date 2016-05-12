function [vectors] = extractResponseVectors(Image)
% Take Image and apply the Gabor filter bank onto it.
% vectors is an MxN matrix, where N is the number of Gabor filters in the  
% bank, and M is the total numbers of pixels in an image.
% I chose 10 as S and K, so filter bank size N would be 10*10 = 100
    W = 0.52;
    S = 10;
    K = 10;
    U_h = .4;
    U_l = .1;
    filterSize = 19;
    
    filters = gaborBank(S, K, U_h, U_l, W, filterSize);
    vectors = [];
    
    for i=1:S
        for j=1:K
            filteredImg = imfilter(Image, filters{i, j});
            vector = reshape(filteredImg, [size(filteredImg,1) * size(filteredImg,2) 1]);
            vectors = [vectors vector];
        end
    end
    