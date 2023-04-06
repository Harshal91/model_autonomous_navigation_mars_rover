function moveCamera_L(surface_ax,Camera_Z_ang,Camera_pos,Camera_rot,Camera_target_ang)

% Function to move MATLAB figure camera in a given scene.
% Copyright 2022-2023 The MathWorks, Inc

% Update the MATLAB Figure camera UP vector. This is should
% match the +Z vector direction on the CameraTransform subsystem in SM. This can
% be computed as
% Zup_CamSensor_MATLAB = Camera_rot * [0 0 1];
camup(surface_ax,Camera_rot*[0 0 1]');

% Update MATLAB Figure Camera position using the xyz positions of the SM camera
campos(surface_ax,Camera_pos);

% Compute the Camera Target position.
xTarget = Camera_pos(1) + Camera_pos(3)*cos(Camera_Z_ang)/tand(Camera_target_ang);
yTarget = Camera_pos(2) + Camera_pos(3)*sin(Camera_Z_ang)/tand(Camera_target_ang);
camtarget(surface_ax,[xTarget,yTarget,0])

end