%% Script to setup parameters for the camera assembly 

% Copyright 2022-2023 The MathWorks, Inc

%Initialize the RigidTransform structure array by filling in null values.
cameraData.RigidTransform(9).translation = [0.0 0.0 0.0];
cameraData.RigidTransform(9).angle = 0.0;
cameraData.RigidTransform(9).axis = [0.0 0.0 0.0];
cameraData.RigidTransform(9).ID = '';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
cameraData.RigidTransform(1).translation = [4000.0001314757724 45090.002288818345 35000.000550032448]/100;  % mm
cameraData.RigidTransform(1).angle = 2.0943951023931953;  % rad
cameraData.RigidTransform(1).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
cameraData.RigidTransform(1).ID = 'B[rsm_lower_mast-2:-:rsm_outer_ring-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
cameraData.RigidTransform(2).translation = [3999.9995753794733 42090.002288818352 35000.000152076434]/100;  % mm
cameraData.RigidTransform(2).angle = 2.0943951023931948;  % rad
cameraData.RigidTransform(2).axis = [-0.57735026918962562 -0.57735026918962651 -0.57735026918962518];
cameraData.RigidTransform(2).ID = 'F[rsm_lower_mast-2:-:rsm_outer_ring-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
cameraData.RigidTransform(3).translation = [0 10000.000242324732 35000.001118951295]/100;  % mm
cameraData.RigidTransform(3).angle = 2.0943951023931953;  % rad
cameraData.RigidTransform(3).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
cameraData.RigidTransform(3).ID = 'B[rsm_lower_mast-2:-:mars_2020_model_rsm_base-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
cameraData.RigidTransform(4).translation = [-4000 22000.000378647339 -0.00020563638463499956]/100;  % mm
cameraData.RigidTransform(4).angle = 2.0943951023931953;  % rad
cameraData.RigidTransform(4).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
cameraData.RigidTransform(4).ID = 'F[rsm_lower_mast-2:-:mars_2020_model_rsm_base-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
cameraData.RigidTransform(5).translation = [3989.3624153324936 42990.000000000007 34981.574964235289]/100;  % mm
cameraData.RigidTransform(5).angle = 2.0943951023931953;  % rad
cameraData.RigidTransform(5).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
cameraData.RigidTransform(5).ID = 'B[rsm_upper_mast-1:-:rsm_outer_ring-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
cameraData.RigidTransform(6).translation = [3999.9995753797166 46190.000762939439 35000.000152076158]/100;  % mm
cameraData.RigidTransform(6).angle = 2.2944173693763714;  % rad
cameraData.RigidTransform(6).axis = [-0.45088258502186335 -0.631151683244211 -0.63115168324421111];
cameraData.RigidTransform(6).ID = 'F[rsm_upper_mast-1:-:rsm_outer_ring-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
cameraData.RigidTransform(7).translation = [7.1054273576010019e-12 59000.000993677546 35000.003039368828]/100;  % mm
cameraData.RigidTransform(7).angle = 2.0943951023931953;  % rad
cameraData.RigidTransform(7).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
cameraData.RigidTransform(7).ID = 'B[rsm_upper_mast-1:-:rsm_head-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
cameraData.RigidTransform(8).translation = [-4052.8860092163068 71000.000443876605 -0.00077094727180337941]/100;  % mm
cameraData.RigidTransform(8).angle = 2.0943951023931962;  % rad
cameraData.RigidTransform(8).axis = [0.57735026918962595 0.57735026918962595 0.57735026918962551];
cameraData.RigidTransform(8).ID = 'F[rsm_upper_mast-1:-:rsm_head-1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
cameraData.RigidTransform(9).translation = [49101.528614598625 -34150.920905934181 19960.431547172571]/100;  % mm
cameraData.RigidTransform(9).angle = 0;  % rad
cameraData.RigidTransform(9).axis = [0 0 0];
cameraData.RigidTransform(9).ID = 'RootGround[mars_2020_model_rsm_base-1]';


%============= Solid =============%
%Center of Mass (CoM) %Moments of Inertia (MoI) %Product of Inertia (PoI)

%Initialize the Solid structure array by filling in null values.
cameraData.Solid(5).mass = 0.0;
cameraData.Solid(5).CoM = [0.0 0.0 0.0];
cameraData.Solid(5).MoI = [0.0 0.0 0.0];
cameraData.Solid(5).PoI = [0.0 0.0 0.0];
cameraData.Solid(5).color = [0.0 0.0 0.0];
cameraData.Solid(5).opacity = 0.0;
cameraData.Solid(5).ID = '';

%Inertia Type - Custom
%Visual Properties - Simple
cameraData.Solid(1).mass = 403410.66807286249;  % kg
cameraData.Solid(1).CoM = [4.0000000004193801 10.111946021827089 35.00000111713657];  % m
cameraData.Solid(1).MoI = [4810006.9541257201 3779509.7744762823 5346172.0682575572];  % kg*m^2
cameraData.Solid(1).PoI = [0.025610491057805166 9.5944118447427712e-11 -0.0059185225038811936];  % kg*m^2
cameraData.Solid(1).color = [0.792156862745098 0.81960784313725488 0.93333333333333335];
cameraData.Solid(1).opacity = 1;
cameraData.Solid(1).ID = 'rsm_lower_mast*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
cameraData.Solid(2).mass = 2382.034306888288;  % kg
cameraData.Solid(2).CoM = [3.9999998683750735 43.079325552279187 35.000000364855161];  % m
cameraData.Solid(2).MoI = [35996.08635034717 57529.969777370468 35996.086350347214];  % kg*m^2
cameraData.Solid(2).PoI = [0.00049383204427821655 -4.6439570512042183e-11 0.00068000513182705038];  % kg*m^2
cameraData.Solid(2).color = [0.792156862745098 0.81960784313725488 0.93333333333333335];
cameraData.Solid(2).opacity = 1;
cameraData.Solid(2).ID = 'rsm_outer_ring*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
cameraData.Solid(3).mass = 382776.49776505685;  % kg
cameraData.Solid(3).CoM = [3.9999859058156222 58.978795293133579 34.999978623235194];  % m
cameraData.Solid(3).MoI = [3038949.1155035766 3496444.1283247923 3624138.3310951856];  % kg*m^2
cameraData.Solid(3).PoI = [-149.38330594076831 -0.099286314664186748 -86.231337421024776];  % kg*m^2
cameraData.Solid(3).color = [0.792156862745098 0.81960784313725488 0.93333333333333335];
cameraData.Solid(3).opacity = 1;
cameraData.Solid(3).ID = 'rsm_upper_mast*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
cameraData.Solid(4).mass = 201061.96012441389;  % kg
cameraData.Solid(4).CoM = [-0.0028855016142938848 71.00000146633289 -4.5495413870176776e-07];  % m
cameraData.Solid(4).MoI = [1608495.9233529335 6519098.973319659 6519098.9733198499];  % kg*m^2
cameraData.Solid(4).PoI = [-6.4960954448222347e-08 0.33673128822105924 1.0895585396089156];  % kg*m^2
cameraData.Solid(4).color = [0.792156862745098 0.81960784313725488 0.93333333333333335];
cameraData.Solid(4).opacity = 1;
cameraData.Solid(4).ID = 'rsm_head*:*Default';

%Inertia Type - Custom
%Visual Properties - Simple
cameraData.Solid(5).mass = 202690.5085512175;  % kg
cameraData.Solid(5).CoM = [-2.0999423881805511e-07 21.823191531694061 -2.2016798973509802e-07];  % m
cameraData.Solid(5).MoI = [2411866.9712559427 5940029.2005020622 6701187.7424028572];  % kg*m^2
cameraData.Solid(5).PoI = [0.0079223430914036937 -0.016408881098513302 -0.460936358460458];  % kg*m^2
cameraData.Solid(5).color = [0.792156862745098 0.81960784313725488 0.93333333333333335];
cameraData.Solid(5).opacity = 1;
cameraData.Solid(5).ID = 'mars_2020_model_rsm_base*:*Default';


%============= Joint =============%
%X Revolute Primitive (Rx) %Y Revolute Primitive (Ry) %Z Revolute Primitive (Rz)
%X Prismatic Primitive (Px) %Y Prismatic Primitive (Py) %Z Prismatic Primitive (Pz) %Spherical Primitive (S)
%Constant Velocity Primitive (CV) %Lead Screw Primitive (LS)
%Position Target (Pos)

%Initialize the RevoluteJoint structure array by filling in null values.
cameraData.RevoluteJoint(3).Rz.Pos = 0.0;
cameraData.RevoluteJoint(3).ID = '';

cameraData.RevoluteJoint(1).Rz.Pos = 4.9578674314210174;  % deg
cameraData.RevoluteJoint(1).ID = '[rsm_lower_mast-2:-:rsm_outer_ring-1]';

cameraData.RevoluteJoint(2).Rz.Pos = -0.42817098535597553;  % deg
cameraData.RevoluteJoint(2).ID = '[rsm_lower_mast-2:-:mars_2020_model_rsm_base-1]';

cameraData.RevoluteJoint(3).Rz.Pos = 1.3658480953381427;  % deg
cameraData.RevoluteJoint(3).ID = '[rsm_upper_mast-1:-:rsm_head-1]';

