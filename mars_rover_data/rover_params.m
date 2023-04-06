%% Script to setup parameters for the rover  

% Copyright 2022-2023 The MathWorks, Inc

%% Rover Assembly Params

Rover.Chasis.Top_Frame_R =...
    [   1.0  0  0
    0   0   1.0
    0  -1.0   0 ];

Rover.Chasis.Top_Frame_T = [-1.408435770788863e-09 0.360100000000000 -0.099999999882285];


Rover.Chasis.R_Frame_R =...
    [0   0   1.0
    1.0   0   0
    0   1.0   0];

Rover.Chasis.R_Frame_T = [0.500100000000000 0.170000002063840 0.100000002063841];

Rover.Chasis.L_Frame_R = ...
    [0.0  0  -1.0
    1.0   0.0  0
    0  -1.0   0.0];

Rover.Chasis.L_Frame_T = [-0.500100000000000 0.169999999356227 0.100000001576468];

Rover.Chasis.F4_Frame_R =...
    [1.0  0  0
    0   0   1.0
    0  -1.0   0];

Rover.Chasis.F4_Frame_T = [0 0 0];

Rover.DiffBar.ToChasis_R = ...
    [1.0 0   0
    0   0  -1.0
    0   1.0   0];
Rover.DiffBar.ToChasis_T = [0   0.0401 0] ;

Rover.DiffBar.F3_R = ...
    [1.0                   0                   0
    0   0  -1.0
    0   1.0   0];
Rover.DiffBar.F3_T = [-0.550000005278643  0   0.000000002311580] ;

Rover.DiffBar.F2_R = ...
    [-1.0                   0                   0
    0   0  -1.0
    0  -1.0   0];
Rover.DiffBar.F2_T = [0.549999994090071                   0   0.000000007967969] ;


Rover.Rtg.R = ...
    [1.0000         0         0
    0   -0.8660    0.5000
    0   -0.5000   -0.8660 ];

Rover.Rtg.T = [0.0000    0.3479   -1.0008];


Rover.Rtg_Bridge.T1 = [ -0.4400    0.4987   -0.7821];
Rover.Rtg_Bridge.T2 = [0.4400    0.4987   -0.7821];

Rover.ArmBase.R = ...
    [1.0000         0         0
    0    0.0000    1.0000
    0   -1.0000    0.0000];

Rover.ArmBase.T = [0.3800    0.2500    0.9800];

Rover.HomePose.R = ...
    [1.0000         0         0
    0    0.0000    1.0000
    0   -1.0000    0.0000];
Rover.HomePose.T = [0.3842    0.2251    0.8275];

Rover.Target.R = ...
    [1     0     0
    0     1     0
    0     0     1];
Rover.Target.T = [-0.0495    0.3775    0.8260];

Rover.CameraBase.T = [-0.400 0.3200 0.6500];

% MobilityPrimaryArmR
Rover.MPL.SRJ_R = ...
    [1.0000         0         0
    0    0.0000   -1.0000
    0    1.0000    0.0000
    ];
Rover.MPL.SRJ_T = [-0.5100   -0.0901    0.0600];

Rover.MPL.DR_R =...
    [-1.0000         0         0
    0    0.0000    1.0000
    0    1.0000    0.0000];
Rover.MPL.DR_T = [0.0000    0.0600   -0.2000];

Rover.MPL.LFB_R = ...
    [ 1.0000         0         0
    0   -1.0000         0
    0         0   -1.0000];
Rover.MPL.LFB_T = [0.9950   -0.1950    0.1520];

Rover.MPL.CRJ_R = ...
    [1.0000         0         0
    0    0.0000   -1.0000
    0    1.0000    0.0000
    ];
Rover.MPL.CRJ_T = [ -0.0000    0.1000   -0.0000];
%L
Rover.MPR.SRJ_R = ...
    [1.0000         0         0
    0    0.0000   -1.0000
    0    1.0000    0.0000
    ];
Rover.MPR.SRJ_T = [-0.5100   -0.0901   -0.0600];

Rover.MPR.DL_R =...
    [1.0000         0         0
    0    0.0000    1.0000
    0    -1.0000    0.0000];
Rover.MPR.DL_T = [0.0000    0.0625    0.2000];

Rover.MPR.RFB_R = ...
    [ 1.0000         0         0
    0   1.0000         0
    0         0   1.0000];
Rover.MPR.RFB_T = [0.9950   -0.1950    -0.1520];

Rover.MPR.CRJ_R = ...
    [1.0000         0         0
    0    0.0000   -1.0000
    0    1.0000    0.0000
    ];
Rover.MPR.CRJ_T = [ -0.0000    0.1000   -0.0000];
% MSL

Rover.MSL.PSJ_R = ...
    [1.0000         0         0
         0    0.0000    1.0000
         0   -1.0000    0.0000];
Rover.MSL.PSJ_T = [ 0 0 0];

Rover.MSL.SLB_R =...
    [1.0000         0         0
         0    0.0000    1.0000
         0    1.0000    0.0000];
Rover.MSL.SLB_T =[-0.4900    0.1100   -0.0950];

Rover.MSL.SLM_R = ...
    [1.0000         0         0
         0    0.0000    1.0000
         0   -1.0000    0.0000];
Rover.MSL.SLM_T = [0.5122    0.2901   -0.4162];

% MSR

Rover.MSR.PSJ_R = ...
    [1.0000         0         0
         0    0.0000    1.0000
         0   -1.0000    0.0000];
Rover.MSR.PSJ_T = [ 0 0 0];

Rover.MSR.SRB_R =...
    [ 1.0000         0         0
         0   -1.0000         0
         0         0   -1.0000];

Rover.MSR.SRB_T =[-0.4900    0.1100   0.0950];

Rover.MSR.SRM_R = ...
    [1.0000         0         0
         0    0.0000    1.0000
         0   -1.0000    0.0000];
Rover.MSR.SRM_T = [0.5122    0.2901   0.4162];

% SteeringBracket

Rover.SB.SRJ_R =...
    [0     0     1
     1     0     0
     0     1     0];
Rover.SB.SRJ_T = [0.3201   -0.0200   -0.0000];

Rover.SB.WRJ_R =...
    [1     0     0
     0     0     1
     0     -1     0];
Rover.SB.WRJ_T = [0.0000    0.0601    0.0000];

% Wheel
Rover.Wheel.WRJ_R =...
    [1     0     0
     0     0     1
     0     -1     0];
Rover.Wheel.WRJ_T = [0.0000   -0.0201    0.0000];

%
Rover.Chassis_L = 2;
Rover.Chassis_width = 2;%1.761;
Rover.Wheel_Radius = 0.215; %m
Rover.rover_accel = 0.5; %m/s^2
Rover.t1 = 1; % roverStartTime

%% Wheel Point Cloud


Rover.temp_wpc = load(['mars_rover_data',filesep,'mars_rover_terrain_ptcloud_wheel.mat'],'wheel_point_cloud');
Rover.new_wheel_points = Rover.temp_wpc.wheel_point_cloud ;


%% PID Control Parameters for Wheel Speed Control and Steering Control

Rover.Kp = 1e4;
Rover.Ki = 50 ;
Rover.Kd = 10;
Rover.N = 1000;

Rover.Kp_steer = 100;
Rover.Ki_steer = 1;
Rover.Kd_steer = 0.1;


%% Spatial Contact Force Block

Rover.K = 2e7; 
Rover.D_contact = 1e7;
Rover.TW = 0.5;
Rover.Mu = 0.8;
Rover.Mud = 0.65;
Rover.Cv = 3e-2;

Rover.K_2 = 2e7; 
Rover.D_contact_2 = 1e7;
Rover.TW_2 = 0.5;
Rover.Mu_2 = 0.8;
Rover.Mud_2 = 0.65;
Rover.Cv_2 = 3e-2;

%% Other Params

Rover.steering_damping = 10;
Rover.wheel_damping = 1;
Rover.TrqUpLimit = 500;
Rover.TrqLoLimit = -500;

%% Exercise Specific Params

Rover.start_time = 1;
Rover.cam_pan_flag = 1;
Rover.cam_pan_end_time = 100;
Rover.detection_phaseDelay = 0;
Rover.detection_sample_time= 15;
Rover.detectionThreshold = 0.55;
Rover.regionOfInterest = [15 15 500 400];
Rover.cam_pan_range = [-90 90 ];
Rover.cam_pan = 0;
Rover.cam_pitch = 20; 

rover_path_dl.x = [5 ; 13];
rover_path_dl.y = [24 ; 24];
rover_path_dl.z = [2.1550 ; 3.5076];
point_cloud_path_dl = [5.0000   24.0000    2.1550
   13.0000   24.0000    3.0468];

Exercise.ex1_flag = 0;
Exercise.ex2a_flag = 0;
Exercise.ex2b_flag = 0;
Exercise.ex3_flag = 0;
Exercise.ex4_flag = 0;
% ex2a_flag = 0;
% ex2b_flag = 0;

% Rover.startTimeEx1a = 1e6;
% Rover.simStopTimeEx1a = 250;
% 
% Rover.startTimeEx1b = 1;
% Rover.simStopTimeEx1b = 2e4;
% 
% Rover.startTimeEx2 = 1e6; 
% Rover.simStopTimeEx2 = 250;
% 
% 
% Rover.detection_sample_time = 30;
% 
% Rover.cam_pan_ex1 = [-90 90 ];
% Rover.cam_pitch_ex1 = 10; 
% 
% Rover.cam_pan_ex2 = [-90 90 ];
% Rover.cam_pitch_ex2 = 10; 
% 
% Rover.detection_sample_time_ex2 = 15;
% Rover.detection_phaseDelay_ex2 = 0;
% 
% ex3_flag = 1;
% ex2a_flag = 0;
% ex2b_flag = 0;

