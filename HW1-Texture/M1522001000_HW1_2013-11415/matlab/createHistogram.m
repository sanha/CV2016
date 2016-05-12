% Plot histogram for each picture class
%% load images and calculate histogram
load ../../result/TextureLibrary.mat

dirString = cell(1,5);
dirString{1,1} = 'Canvas';
dirString{1,2} = 'Chips';
dirString{1,3} = 'Grass';
dirString{1,4} = 'Seeds';
dirString{1,5} = 'Straw';

histCell = cell(1,5);

for i = 1:size(dirString,2)
    dirname = ['../train',dirString{1,i}];
    d = dir(dirname);

    histSum = zeros(1, size(clustercenters,1));

    for j = 3:length(d)
            if strcmp(d(j).name,'Thumbs.db') ~= 1
                fname = sprintf('%s\\%s',dirname,d(j).name);
                im = im2double(imread(fname));

                singleHist = createSingleHistogram(im, clustercenters);
                histSum = histSum + singleHist;
            end
    end

    histCell{1,i} = histSum ./ sum(histSum);
end

%% save histograms to .mat file
Canvas_histogram = histCell{1,1}';
Chips_histogram = histCell{1,2}';
Grass_histogram = histCell{1,3}';
Seeds_histogram = histCell{1,4}';
Straw_histogram = histCell{1,5}';
save ../../result/Histograms.mat Canvas_histogram Chips_histogram Grass_histogram ...
    Seeds_histogram Straw_histogram