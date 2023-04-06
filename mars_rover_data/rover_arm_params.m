%% Script to setup parameters for the rover arm 

% Copyright 2022-2023 The MathWorks, Inc

%% Arm Joint Params
Arm.D = 0.5;
Arm.D2 = 0.5;

%% Arm PID Gains
Arm.Kp_arm = 200;
Arm.Ki_arm = 50;
Arm.Kd_arm = 20;

%% Arm Assembly Params
%============= RigidTransforms =============%
Arm.HomePos.R = ...
    [1.0000         0         0
         0    1.0000         0
         0         0    1.0000];
Arm.HomePos.T = [0.0042    0.1525   -0.0249];

Arm.R_disc_Link1 = 5; %cm

Arm.Link1.translation = [-15000 12000 3250];  % mm
Arm.Link1.angle = 0;  % rad
Arm.Link1.axis = [0 0 0];

Arm.Link2(1).translation = [-83300 -7627 -3250];  % mm
Arm.Link2(1).angle = 0;  % rad
Arm.Link2(1).axis = [0 0 0];


Arm.Link2(2).translation = [-15000 -7627 750];  % mm
Arm.Link2(2).angle = pi;  % rad
Arm.Link2(2).axis = [1 0 0];


Arm.Link3(1).translation = [-18700 -7627 8750];  % mm
Arm.Link3(1).angle = 0;  % rad
Arm.Link3(1).axis = [0.091717735705432957 -0.99578504555806036 -5.8733215973969995e-18];

Arm.Link3(2).translation = [-83300 -7627 4750];  % mm
Arm.Link3(2).angle = 0;  % rad
Arm.Link3(2).axis = [0 0 0];
