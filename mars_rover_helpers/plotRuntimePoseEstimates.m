function plotRuntimePoseEstimates(block,ax)

% Function to plot Rover pose estimation during simulation.

% Copyright 2022-2023 The MathWorks, Inc

outport1 = block.OutputPort(1);
outport2 = block.OutputPort(2);

refPath = outport1.Data;
estimatedXYPosition = outport2.Data;

persistent counter_est ;

if isempty(counter_est)
hold(ax,'on')
plot(ax,refPath(:,1),refPath(:,2),'b--','LineWidth',1.5);
plot(ax,estimatedXYPosition(1),estimatedXYPosition(2),'r.','MarkerSize',10);
hold(ax,'off')
legend(ax,{'Planned Egress Path','Estimated Rover XY position'},'AutoUpdate','off')
counter_est = 1;
title(ax,'Estimated Rover XY Position')
xlabel(ax,'X(m)')
ylabel(ax,'Y(m)')
axis(ax,'equal')
end

hold(ax,'on')
plot(ax,estimatedXYPosition(1),estimatedXYPosition(2),'r.','MarkerSize',10);
hold(ax,'off')
counter_est =counter_est +1;


end