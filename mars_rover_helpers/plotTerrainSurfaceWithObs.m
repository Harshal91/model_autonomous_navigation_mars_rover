function  handles = plotTerrainSurfaceWithObs(ax,xg,yg,z_heights,...
                                              terrain_points_obs,...
                                              sharp_rocks_pts,...
                                              round_rocks_pts,...
                                              loose_rocks_pts,varargin)

% Function to plot obstacle data on the surface plot.

% Copyright 2022-2023 The MathWorks, Inc

if isempty(varargin)
rocks_select = {'Sharp Embedded Rocks'};
else
    rocks_select = varargin{1};
end
p1 = [];
p2 = [];
p3 = [];
p4 = [];
[Xg, Yg] = ndgrid(xg, yg);


axis(ax,'equal');
hold(ax,'on')

 set(ax,'Color',[209 181 169]/255)
 surf(ax,Xg, Yg, z_heights,'EdgeAlpha',0.1,'FaceColor',[187 109 63]/255*1.3,...
     'DisplayName','Terrain Points');

p1 =  plot3(ax,terrain_points_obs(:,1),terrain_points_obs(:,2),...
     terrain_points_obs(:,3),'.','LineWidth',0.1,...
     'Color','Black','DisplayName','Known Terrain Obstacles'); % plot slope obs
 
if ismember('Sharp Embedded Rocks',rocks_select)
 p2 = plot3(ax,sharp_rocks_pts(:,1),sharp_rocks_pts(:,2),sharp_rocks_pts(:,3),'^',...
     'LineWidth',2,'MarkerSize',2,'Color','Black','DisplayName','Sharp Rocks'); % rocks
end

if ismember('Round Embedded Rocks',rocks_select)
 p3 = plot3(ax,round_rocks_pts(:,1),round_rocks_pts(:,2),round_rocks_pts(:,3),'o',...
     'LineWidth',2,'MarkerSize',2,'Color',[238,130,238]/255*0.8,'DisplayName','Unknown Terrain Obstacles'); % rocks
end

if ismember('Ditches',rocks_select)
 p4 = plot3(ax,loose_rocks_pts(:,1),loose_rocks_pts(:,2),loose_rocks_pts(:,3),'*',...
     'LineWidth',2,'MarkerSize',2,'Color','Black','DisplayName','Ditches'); % rocks
end

light(ax,'Style','infinite')
lighting(ax,'gouraud')
material(ax,'dull')

hold(ax,'off');
ax.XAxis.Limits = [min(xg) max(xg)];
ax.YAxis.Limits = [min(yg) max(yg)];
view(ax,3);

handles.p1 = p1;
handles.p2 = p2;
handles.p3 = p3;
handles.p4 = p4;
end