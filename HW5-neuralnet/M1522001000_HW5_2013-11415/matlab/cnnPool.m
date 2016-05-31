function pooledFeatures = cnnPool(poolDim, convolvedFeatures)
%cnnPool Pools the given convolved features
%
% Parameters:
%  poolDim - dimension of pooling region
%  convolvedFeatures - convolved features to pool (as given by cnnConvolve)
%                      convolvedFeatures(featureNum, imageNum, imageRow, imageCol)
%
% Returns:
%  pooledFeatures - matrix of pooled features in the form
%                   pooledFeatures(featureNum, imageNum, poolRow, poolCol)
%     

numImages = size(convolvedFeatures, 2);
numFeatures = size(convolvedFeatures, 1);
convolvedDim = size(convolvedFeatures, 3);

pooledFeatures = zeros(numFeatures, numImages, floor(convolvedDim / poolDim), floor(convolvedDim / poolDim));

% -------------------- YOUR CODE HERE --------------------
% Instructions:
%   Now pool the convolved features in regions of poolDim x poolDim,
%   to obtain the 
%   numFeatures x numImages x (convolvedDim/poolDim) x (convolvedDim/poolDim) 
%   matrix pooledFeatures, such that
%   pooledFeatures(featureNum, imageNum, poolRow, poolCol) is the 
%   value of the featureNum feature for the imageNum image pooled over the
%   corresponding (poolRow, poolCol) pooling region 
%   (see http://ufldl/wiki/index.php/Pooling )
%   
%   Use mean pooling here.
% -------------------- YOUR CODE HERE --------------------
pooledDim = floor(convolvedDim / poolDim);
for imageNum = 1:numImages
  for featureNum = 1:numFeatures
    pooledFeature = zeros(pooledDim);
    for regionRow = 1:pooledDim
      imRow = (regionRow - 1) * poolDim + 1;
      imRowEnd = imRow + poolDim - 1;
      for regionCol = 1:pooledDim
        imCol = (regionCol - 1) * poolDim + 1;
        imColEnd = imCol + poolDim - 1;
        region = convolvedFeatures(featureNum, imageNum, imRow:imRowEnd, imCol:imColEnd);
        pooledFeature(regionRow, regionCol) = mean(mean(region));
      end
    end
    pooledFeatures(featureNum, imageNum, :, :) = pooledFeature;
  end
end

end

