function [I, obstacleWorldXYZ,obstacleDistance] = mars_rover_stereo_vision(I_left,I_right,bboxes_set,rover_translation,rover_orientation,cam_base_angle,cam_target_angle);
% Function to perform the stereo vision for the rover cameras. It takes in
% left and right camera frames, bounding boxes for the detected obstacle and
% the current rover pose to first calculate the location of the obstacles wrt
% to the rover's left nav cam and then transforms it wrt to the inertial
% world frame of the binary occupancy map.

% Copyright 2022-2023 The MathWorks, Inc

stereo = load('stereoParamsFinal.mat','stereoParamsFinal');
stereoParams = stereo.stereoParamsFinal;

 [disparityMap,points3D] = stereoVision(I_left,I_right,stereoParams);

%%

[I, obstacleCoordinates,obstacleDistance] = estimateDepth(I_left,disparityMap,points3D,bboxes_set);

%% Transforms for calculations

obstacleWorldXYZ = transformObsCoordinatesToWorld(obstacleCoordinates,rover_translation,rover_orientation,cam_base_angle,cam_target_angle);

end