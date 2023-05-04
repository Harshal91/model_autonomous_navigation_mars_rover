function plotSurfaceForCamera(surface_ax,xg,yg,z_heights,znew,varargin)

% Function to plot the scene as seen by the cameras in MATLAB.

% Copyright 2022-2023 The MathWorks, Inc

cla(surface_ax)

if ~isempty(varargin)
    rover_path = varargin{1};
    % Plot planned rover path
    hold (surface_ax,'on')
    plot3(surface_ax,rover_path(:,1),rover_path(:,2),rover_path(:,3),'b*','LineWidth',1,'Color',[0 0 1],'DisplayName','Path')
    plot3(surface_ax,rover_path(end,1),rover_path(end,2),rover_path(end,3),'o','MarkerSize',15,'Color',[0 0 1])
    hold (surface_ax,'off')

end

set(surface_ax,'XColor', 'none','YColor','none','ZColor','none')
% movegui(surface_ax,'center');
title(surface_ax,'CameraSensor');
% Set background color
set(surface_ax,'Color',[209 181 169]/255);
% Set equal data unit lengths in all directions
daspect(surface_ax,[1 1 1]);
% Set camera view angle. This parameter tweaks the zoom level
camva(surface_ax,40);
% Plot Surface
hold(surface_ax,'on');
[Xg, Yg] = ndgrid(xg, yg);

surf( surface_ax ,Xg, Yg, znew-8e-2,'FaceAlpha',1,'EdgeAlpha',0.3,...
    'DisplayName','Terrain Points','FaceColor',[0.702 0.3216 0.1059]*0.8,'edgecolor','none')

surf( surface_ax ,Xg, Yg, z_heights,'FaceAlpha',1,'EdgeAlpha',0.1,...
    'DisplayName','Terrain Points','FaceColor',([187 109 63]/255)*1.1,'edgecolor','none');

material(surface_ax,"dull")
% Set camera as perspective view
camproj(surface_ax,'perspective')
% Set camera view anlge as manual
set(surface_ax,'CameraViewAngleMode','manual')
light(surface_ax,'Style','infinite')
lighting(surface_ax,'gouraud')

hold(surface_ax,'off');
pause(0.005);

end