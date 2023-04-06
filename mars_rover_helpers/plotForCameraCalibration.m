function plotForCameraCalibration(surface_ax,xg,yg,z_heights,znew,...
                             rover_path_x,...
                             rover_path_y,...
                             rover_path_z,varargin)

% Function to create a checkerboard scene for calibrating the left and
% right virtual cameras.

% Copyright 2022-2023 The MathWorks, Inc

if ~isempty(varargin)
    checkerboard_location = varargin{1}; % should be between 60-80;
end
set(surface_ax,'XColor', 'none','YColor','none','ZColor','none')
movegui(surface_ax,'center');
title(surface_ax,'CameraSensor');
% Set background color
set(surface_ax,'Color',[209 181 169]/255);
% Set equal data unit lengths in all directions
daspect(surface_ax,[1 1 1]);
% Set camera view angle. This parameter tweaks the zoom level
camva(surface_ax,45);
% Plot Surface
hold(surface_ax,'on');
[Xg, Yg] = ndgrid(xg, yg);
  
if ~isempty(varargin)
    [I,map] = imread('checkerboard_image_12squares.png');
    [xg_2,yg_2] = meshgrid(0:10,29.5:39.5);
    z_heights_2 = xg_2;
    xg_2 = zeros(size(yg_2));
    axes(surface_ax)
    warp(xg_2+checkerboard_location(1), yg_2 + checkerboard_location(2),z_heights_2,I);
end


C2 = imread('Mars-surface-1014x487.jpg');
surf( surface_ax ,Xg, Yg, znew-8e-2,flipdim(C2, 1), ...  % Plot surface
         'FaceColor', 'texturemap', 'FaceAlpha',0.1,...
         'EdgeColor', 'none');
 
% Set camera as perspective view
camproj(surface_ax,'perspective')
% Set camera view anlge as manual
set(surface_ax,'CameraViewAngleMode','manual')
hold(surface_ax,'off');

end