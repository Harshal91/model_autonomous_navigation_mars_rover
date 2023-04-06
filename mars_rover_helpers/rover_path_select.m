function [goal_loc,roverPath,sample_position,pointCloud] = rover_path_select(pathNum)

% Function to select presaved paths.

% Copyright 2022-2023 The MathWorks, Inc

%% Rover Path
load(['mars_rover_data',filesep,'roverPath1.mat']);
load(['mars_rover_data',filesep,'roverPath2.mat']);
switch pathNum
    case 1
%          roverPath = roverPath;
    case 2
         roverPath = rover_path2;
    otherwise
         load(['mars_rover_data',filesep,'rover_path.mat']);         
         
end

goal_loc = [roverPath.x(end) roverPath.y(end)];
sample_position = roverPath.sampleLoc;
% Points for visualizing the waypoints
pointCloud = [roverPath.x  roverPath.y roverPath.z];
end