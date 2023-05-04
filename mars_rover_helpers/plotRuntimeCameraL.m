function plotRuntimeCameraL(block, surface_ax)

% Function to update camera pose in the scene during simulation.

% Copyright 2022-2023 The MathWorks, Inc

persistent counter_L;

if isempty(counter_L)
    counter_L = 0;
end

if mod(counter_L,2) == 0

    o1 = block.OutputPort(1);
    Camera_Z_ang = o1.Data;
    o2 = block.OutputPort(2);
    Camera_pos = o2.Data;
    o3 = block.OutputPort(3);
    Camera_rot = o3.Data;
    o4 = block.OutputPort(4);
    Camera_target_ang = o4.Data;    
    moveCamera_L(surface_ax,Camera_Z_ang,Camera_pos,Camera_rot,Camera_target_ang);
    pause(0.000005);

end
counter_L = counter_L+1;   

end
