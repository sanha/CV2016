function [class] = classify(im)
% Take single image and classify it among 5 classes.
% calculate euclidian distance between histograms.
    load ../../result/TextureLibrary.mat
    load ../../result/Histograms.mat
    
    histMatrix = [Canvas_histogram, Chips_histogram, Grass_histogram, Seeds_histogram, Straw_histogram];
    
    classString = cell(1,5);
    classString{1,1} = 'Canvas';
    classString{1,2} = 'Chips';
    classString{1,3} = 'Grass';
    classString{1,4} = 'Seeds';
    classString{1,5} = 'Straw';
    
    im = im2double(im);
    singleHist = createSingleHistogram(im, clustercenters);
    
    [min_val, min_idx] = min(dist(singleHist, histMatrix));
    class = classString{1, min_idx};