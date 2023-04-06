function obstacleWorldXYZ = transformObsCoordinatesToWorld(obstacleCoordinates,rover_translation,rover_orientation,cam_base_angle,cam_target_angle)

% Function to transform obstacle coordinates from Camera Frame to World
% Frame

% Copyright 2022-2023 The MathWorks, Inc

for i = 1:size(obstacleCoordinates,1)

    P_wf_ref = [rover_translation(1) rover_translation(2) rover_translation(3)];
    R_wf_ref = eul2rotm([deg2rad(rover_orientation(1)),deg2rad(rover_orientation(2)),deg2rad(rover_orientation(3))],'XYZ');

    P_ref_cbB = [0.65 -0.4 0.32];
    R_ref_cbB = [0 0 1; 1 0 0; 0 1 0];

    R_cbB_cbF =eul2rotm([0 -deg2rad(cam_base_angle) 0],'XYZ');
    P_cbF_ctRevB = [0.0025        0.821  -2.0564e-09];
    R_cbF_ctRevB = [0 0 1; -1 0 0; 0 -1 0];

    R_ctRevB_ctRevF = eul2rotm([0 0 deg2rad(cam_target_angle)],'XYZ');
    P_ctRevF_lcam = [ -0.03         -0.1       0.1425];
    R_ctRevF_lcam = [0 0 -1; -1 0 0; 0 1 0];

    %% Transform the obstacles to Rover and World Coordinates

    % Points expressed in left camera origin frame X - right, Y- down , Z- in page
    Pib = double(obstacleCoordinates(i,:))';

    % Rotmat bewtween multibody left camera frame and image frame
    Rci = [0 0 1 ; -1 0 0; 0 -1 0];

    % Obstacle location in multibody camera frame
    Pcb = Rci*Pib;

    % Transform obstacle location to Rover chassis ref frame
    P_ctRevF_b = P_ctRevF_lcam' + R_ctRevF_lcam*Pcb;
    P_ctRevB_b = R_ctRevB_ctRevF*P_ctRevF_b;

    P_cbF_b = P_cbF_ctRevB' + R_cbF_ctRevB*P_ctRevB_b;
    P_cbB_b = R_cbB_cbF*P_cbF_b;

    P_ref_b = P_ref_cbB' + R_ref_cbB*P_cbB_b;

    % Transform obstacle location to world frame (needed for binary occupancy grid)
    P_wf_ref = P_wf_ref' + R_wf_ref*P_ref_b;
    obstacleWorldXYZ(i,:) = P_wf_ref;

end

end