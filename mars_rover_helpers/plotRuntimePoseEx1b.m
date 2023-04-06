function plotRuntimePoseEx1b(block,ax)

% Function to plot Rover pose during simulation for exercise 1.

% Copyright 2022-2023 The MathWorks, Inc

outport1 = block.OutputPort(1);
outport2 = block.OutputPort(2);
outport3 = block.OutputPort(3);
outport4 = block.OutputPort(4);
outport5 = block.OutputPort(5);
outport6 = block.OutputPort(6);

pose = outport1.Data;
originalPath = outport2.Data;
originalPath(:,3) = 6;
% newPath = outport3.Data;
% newPath(:,3) = 6;
% obsLocation =outport4.Data;
xg = outport3.Data;
yg = outport4.Data;
z_heights = outport5.Data;
znew = outport6.Data;

persistent counter_pose  marker_h;

if isempty(counter_pose)
    counter_pose = 1;    
    cla(ax);
    hold(ax,'on')    
    % Set background color
    set(ax,'Color',[209 181 169]/255);
    daspect(ax,[1 1 1])
    % Plot Surface
    [Xg, Yg] = ndgrid(xg, yg);

    surf( ax ,Xg, Yg, znew-8e-2,'FaceAlpha',1,'EdgeAlpha',0.3,...
        'FaceColor',[0.702 0.3216 0.1059]*0.8,'edgecolor','none','DisplayName','Terrain data')

    surf( ax ,Xg, Yg, z_heights,'FaceAlpha',1,'EdgeAlpha',0.1,...
        'FaceColor',([187 109 63]/255)*1.1,'edgecolor','none','DisplayName','Terrain data');

    material(ax,"dull")
    % Set camera as perspective view
    camproj(ax,'perspective')
    % Set camera view anlge as manual
    light(ax,'Style','infinite')
    lighting(ax,'gouraud')
    
    p1 = plot3(ax,originalPath(:,1),originalPath(:,2),originalPath(:,3),'--','LineWidth',1.5,'Color',[0 0 1],'DisplayName','Original planned path');
    p2 = plot3(ax,originalPath(1,1),originalPath(1,2),originalPath(1,3),'s','MarkerSize',10,'LineWidth',2,'Color',[1 0 1],'DisplayName','Start location');
    p3 = plot3(ax,originalPath(end,1),originalPath(end,2),originalPath(end,3),'O','MarkerSize',15,'LineWidth',2,'Color',[0 1 0],'DisplayName','Goal location');     
    
    marker_h = plot3(ax,pose(1),pose(2),6,'s','MarkerSize',12,'LineWidth',3,'Color',[1.0 1.0 0.8],'DisplayName','Rover');    
    legend(ax,[p1,p2,p3,marker_h],'Location','north','NumColumns',2)
    hold(ax,'off')
    view(ax,2)  
end




marker_h.XData = pose(1);
marker_h.YData = pose(2);
marker_h.ZData = 6;
pause(0.005)

%
% refPath = outport1.Data;
% plot(ax,refPath(1),refPath(2),'*','MarkerSize',10);
% pause(0.005)

end