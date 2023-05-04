function [disparityMap,points3D] = stereoVision(I_left,I_right,stereoParams)

% Function to perform stereovision on left and right camera frames.

% Copyright 2022-2023 The MathWorks, Inc

[frameLeftRect, frameRightRect, reprojectionMatrix] =...
    rectifyStereoImages(I_left,I_right,stereoParams,'linear');

frameLeftGray  = rgb2gray(frameLeftRect);
frameRightGray = rgb2gray(frameRightRect);

disparityMap = disparitySGM(frameLeftGray, frameRightGray);
disparityMap = fillmissing(disparityMap,'nearest',2);
points3D = reconstructScene(disparityMap, reprojectionMatrix);

% Convert to meters and create a pointCloud object
points3D = points3D ./ 1000;
end