% Simulation callback script for mars_rover_ex1a model

% Copyright 2022-2023 The MathWorks, Inc

model = 'mars_rover_cam';
if ~exist('mapp') 
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

blk_R = [model '/Perception/sceneViewer/Right/RCam'];
listner_R =  @(app, event) plotRuntimeCameraR(app,mapp.RightNavCamAxes);
h_R  = add_exec_event_listener(blk_R, ...
    'PostOutputs', listner_R);

blk_L = [model '/Perception/sceneViewer/Left/LCam'];
listner_L =  @(app1, event1) plotRuntimeCameraL(app1,mapp.LeftNavCamAxes);
h_L   = add_exec_event_listener(blk_L, ...
    'PostOutputs', listner_L);

mapp.TabGroup.SelectedTab = mapp.RoverCamsTab;
mapp.statusLabel.Text = 'Running';
mapp.SimulateButtonEx1a.Enable = 'on';
mapp.SimulateButtonEx1a.Text = 'Stop';

% SM_openFrames = javaMethodEDT('getFrames', 'java.awt.Frame');
% for idx = 1:numel(SM_openFrames)
%     if strcmp(char(SM_openFrames(idx).getName),'MechEditorDTClientFrame')
%         if strcmp(char(SM_openFrames(idx).getClient),'Mechanics Explorer-sm_mars_rover')
%             javaMethodEDT('hide', SM_openFrames(idx));
%         end
%     end
% end
figure(mapp.MarsRoverNavigationAppUIFigure);