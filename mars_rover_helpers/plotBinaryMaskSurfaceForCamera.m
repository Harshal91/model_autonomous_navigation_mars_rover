function plotBinaryMaskSurfaceForCamera(surface_ax,xg,yg,z_heights,znew,...
                             rover_path_x,...
                             rover_path_y,...
                             rover_path_z)

% Function to create a binary mask for the rocks and the scene for creating
% training data for the DL network

% Copyright 2022-2023 The MathWorks, Inc

set(surface_ax,'XColor', 'none','YColor','none','ZColor','none')
movegui(surface_ax,'center');
title(surface_ax,'CameraSensor');
% Set background color
set(surface_ax,'Color',[209 181 169]*0/255);
% Set equal data unit lengths in all directions
daspect(surface_ax,[1 1 1]);
% Set camera view angle. This parameter tweaks the zoom level
camva(surface_ax,45);
% Plot Surface
hold(surface_ax,'on');
[Xg, Yg] = ndgrid(xg, yg);

xgnew = linspace(min(xg),max(xg),300);
ygnew = linspace(min(yg),max(yg),300);

[Xq,Yq] = ndgrid(xgnew,ygnew);
Vq = interpn(Xg,Yg,z_heights,Xq,Yq,'cubic');
Vq_2 = interpn(Xg,Yg,znew,Xq,Yq,'cubic');

surf( surface_ax ,Xq, Yq, Vq_2-8e-2,'FaceAlpha',1,'EdgeAlpha',0.3,...
    'DisplayName','Terrain Points','FaceColor',[1 1 1],'edgecolor','none')

surf( surface_ax ,Xq, Yq, Vq,'FaceAlpha',1,'EdgeAlpha',0.1,...
    'DisplayName','Terrain Points','FaceColor',([187 109 63]/255)*0,'edgecolor','none');
   
lighting(surface_ax,'gouraud')
material(surface_ax,"dull")

% Set camera as perspective view
camproj(surface_ax,'perspective')
% Set camera view anlge as manual
set(surface_ax,'CameraViewAngleMode','manual')
%  light(surface_ax,'Style','infinite')
% Plot planned rover path
hold(surface_ax,'off');

end