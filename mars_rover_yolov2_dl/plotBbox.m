function plotBbox(img, bbox)
% This function receives an image and inserts on it a set of bounding
% boxes. Then, it prints the image.

% Copyright 2022-2023 The MathWorks, Inc

annotatedImage = insertShape(img,"Rectangle",bbox);
annotatedImage = imresize(annotatedImage,2);
imshow(annotatedImage)
end