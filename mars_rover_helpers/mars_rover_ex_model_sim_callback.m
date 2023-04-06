% Simulation callback script for mars_rover_ex_3 model

% Copyright 2022-2023 The MathWorks, Inc

model = 'mars_rover_ex_model';

if exist('mapp') ~= 1
    mars_rover_app
elseif ~isvalid(mapp)
    mars_rover_app
end

cla(mapp.OutputAxes_1);
cla(mapp.OutputAxes_2);
cla(mapp.OutputAxes_3);
cla(mapp.OutputAxes_4);

plotSurfaceForCamera( mapp.RightNavCamAxes,Terrain.xg,Terrain.yg,Terrain.z_heights,Terrain.znew,...
[roverPath.x,...
roverPath.y,...
roverPath.z]);
plotSurfaceForCamera(mapp.LeftNavCamAxes,Terrain.xg,Terrain.yg,Terrain.z_heights,Terrain.znew,...
[roverPath.x,...
roverPath.y,...
roverPath.z]);

mapp.SimulateButtonEx3.Enable = 'on';
mapp.SimulateButtonEx3.Text = 'Stop';
mapp.statusLabel.Text = 'Running';

blk_R = [model '/Perception/sceneViewer/Right/RCam'];
listner_R =  @(app, event) plotRuntimeCameraR(app,mapp.RightNavCamAxes);
h_R  = add_exec_event_listener(blk_R, ...
'PostOutputs', listner_R);

blk_L = [model '/Perception/sceneViewer/Left/LCam'];
listner_L =  @(app1, event1) plotRuntimeCameraL(app1,mapp.LeftNavCamAxes);
h_L   = add_exec_event_listener(blk_L, ...
'PostOutputs', listner_L);

blk_DL = [model '/Perception/depthEstimation'];
listner_DL =  @(app1, event1) plotRuntimeRockDetection(app1,mapp.RockDetectionAxes);
h_DL   = add_exec_event_listener(blk_DL, ...
'PostOutputs', listner_DL);



clear plotRuntimePose;
blk_pose = [model '/Online Planner/ToApp'];
listner_pose =  @(app, event) plotRuntimePose(app,mapp.OnlinePathPlansAxes);
h_pose  = add_exec_event_listener(blk_pose, ...
'PostOutputs', listner_pose);

mapp.TabGroup.SelectedTab = mapp.RoverCamsTab;

figure(mapp.MarsRoverNavigationAppUIFigure);
