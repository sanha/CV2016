function [ObjVec] = createObjectVectors(ImageName, NumberOfImages, ColorIndex)
%Create an object vector corresponding image
%   ImageNmae: Seed name of sequence of images as a string
%   NumberOfImages: The # of images in the image sequence.
%   ColorIndex: The color index for calculating the object vector. 1 to 3.
    ObjVec = [];

    for i=1:NumberOfImages
        fname = sprintf('%s%i.png',ImageName,i);
        imrgb = imread(fname);
        im = reshape(imrgb(:,:,ColorIndex), [1,size(imrgb,1) * size(imrgb,2)]);
        ObjVec = [ObjVec; im];
    end
end

