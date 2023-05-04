% Simulation callback script for mars_rover_ex_2 model

% Copyright 2022-2023 The MathWorks, Inc

model = 'mars_rover_dl';
if ~exist('mapp') 
    mars_rover_app
elseif ~isvalid(mapp)
    mars_rover_app
end


plotSurfaceForCamera( mapp.RightNavCamAxes,Terrain.xg,Terrain.yg,Terrain.z_heights,Terrain.znew);
plotSurfaceForCamera(mapp.LeftNavCamAxes,Terrain.xg,Terrain.yg,Terrain.z_heights,Terrain.znew);

mapp.SimulateButtonEx2.Enable = 'on';
mapp.SimulateButtonEx2.Text = 'Stop';
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


mapp.TabGroup.SelectedTab = mapp.RoverCamsTab;
figure(mapp.MarsRoverNavigationAppUIFigure);
% [18.9,18.1]
%[19.9,17.7]