function mars_rover_plot_rover_path_fn(plot_ax,sm_mars_rover_out,roverPath)

%% Script to plot the rover path

% Copyright 2022-2023 The MathWorks, Inc
cla(plot_ax)
if exist('sm_mars_rover_out') == 0
    sm_mars_rover_out = sim("sm_mars_rover");
end

x = roverPath.x;
y = roverPath.y;

x_data = sm_mars_rover_out.logsout.getElement('RoverPosX');
y_data = sm_mars_rover_out.logsout.getElement('RoverPosY');
xout = x_data.Values.Data;
yout = y_data.Values.Data;

obs_detected = sm_mars_rover_out.logsout.getElement('detectedObs');
new_PlannedPath = sm_mars_rover_out.logsout.getElement('newPlannedPath');
obs_d = [];
nPlan = [];

for i = 1:size(obs_detected.Values.Data,3)
    idx = find(obs_detected.Values.Data(:,:,i),1);
    obs_d = [obs_d; obs_detected.Values.Data(idx,:,i)];
end

nPlan = new_PlannedPath.Values.Data;
% Find unique paths
[s1,s2,s3] = size(nPlan);
nPlan_r = reshape(nPlan,s1*s2,s3,1)';
nPlan_ru = unique(nPlan_r,'rows','stable');
nPlan_u = reshape(nPlan_ru',s1,s2,[]);

hold(plot_ax,'on');
plot(plot_ax,roverPath.x, roverPath.y,'b--o','LineWidth',0.5,'DisplayName','Original Path')
plot(plot_ax,roverPath.x(1),roverPath.y(1),'s','MarkerSize',10,'LineWidth',2,'Color',[1 0 1],'DisplayName','Start location');
plot(plot_ax,roverPath.x(end),roverPath.y(end),'O','MarkerSize',20,'LineWidth',2,'Color',[0 1 0],'DisplayName','Goal location');

if ~isempty(obs_d)
    obs_d = unique(obs_d,'rows');
    plot(plot_ax,obs_d(:,1),obs_d(:,2),'rO','LineWidth',2,'MarkerSize',15,'DisplayName','Detected Rocks');
end

if size(nPlan_u,3)>1
    for i = 2:size(nPlan_u,3)
        plot(plot_ax,nPlan_u(:,1,i),nPlan_u(:,2,i),'--o','LineWidth',0.5,'DisplayName',['New Planned Path ' num2str(i-1)],'Color',[1/i 0.5/i 0.5/i]);
    end
end

plot(plot_ax,xout,yout,'-','LineWidth',2.5,'DisplayName','ActualPath','Color',[0.1 0.6745 0.1882]);

legend(plot_ax,'Location','Best');
xlabel(plot_ax,'X (m)');
ylabel(plot_ax,'Y (m)');
axis(plot_ax,'equal');

title(plot_ax,'Rover Path Comparison in XY plane');
hold(plot_ax,'off');

end

