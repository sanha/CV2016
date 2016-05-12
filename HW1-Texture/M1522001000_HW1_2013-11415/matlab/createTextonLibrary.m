% Creating Texton Library Script
%% load random images and apply gabor filtering
dirname = '../random';
d = dir(dirname);

giantFeatureMatrix = [];

for i = 3:length(d)
        if strcmp(d(i).name,'Thumbs.db') ~= 1
            fname = sprintf('%s\\%s',dirname,d(i).name);
            im = imread(fname);
            
            vectors = extractResponseVectors(im);
            for pixel = 1:size(vectors, 1)
                randNum = rand(1);
                if randNum > 0.99
                    giantFeatureMatrix = [giantFeatureMatrix ; vectors(pixel, :)];
                end
            end
        end
end
giantFeatureMatrix = im2double(giantFeatureMatrix);

%% Kmeans clustering
numberofClusters = 25;
[clusterresult clustercenters] = kmeans(giantFeatureMatrix,numberofClusters, 'EmptyAction', 'drop');

%% Storing Texture Library
save ../../result/TextureLibrary.mat clustercenters