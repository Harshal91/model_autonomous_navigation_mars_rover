% Setup event listeners for all the mars rover exercise models

% Copyright 2022-2023 The MathWorks, Inc

plotSurfaceForCamera( mapp.RightNavCamAxes,Terrain.xg,Terrain.yg,Terrain.z_heights,Terrain.znew,...
[roverPath.x,...
roverPath.y,...
roverPath.z]);
plotSurfaceForCamera(mapp.LeftNavCamAxes,Terrain.xg,Terrain.yg,Terrain.z_heights,Terrain.znew,...
[roverPath.x,...
roverPath.y,...
roverPath.z]);

blk_R = 'mars_rover/Perception/sceneViewer/Right/RCam';
listner_R =  @(app, event) plotRuntimeCameraR(app,mapp.RightNavCamAxes);
h_R  = add_exec_event_listener(blk_R, ...
'PostOutputs', listner_R);

blk_L = 'mars_rover/Perception/sceneViewer/Left/LCam';
listner_L =  @(app1, event1) plotRuntimeCameraL(app1,mapp.LeftNavCamAxes);
h_L   = add_exec_event_listener(blk_L, ...
'PostOutputs', listner_L);

blk_DL = 'mars_rover/Perception/depthEstimation';
listner_DL =  @(app1, event1) plotRuntimeRockDetection(app1,mapp.RockDetectionAxes);
h_DL   = add_exec_event_listener(blk_DL, ...
'PostOutputs', listner_DL);

% blk_online_planner = 'mars_rover/Online Planner/Online Planner/pathPlanner';
% listner_planner =  @(app1, event1) plotRuntimePathPlans(app1,mapp.OnlinePathPlansAxes);
% h_plan   = add_exec_event_listener(blk_online_planner, ...
% 'PostOutputs', listner_planner);

% blk_pose = 'mars_rover/Online Planner/ToApp';
% listner_pose =  @(app, event) plotRuntimePose(app,mapp.OnlinePathPlansAxes6);
% h_pose  = add_exec_event_listener(blk_pose, ...
% 'PostOutputs', listner_pose);