function plotRuntimeRockDetection(block, surface_ax)

% Function to plot Rock Detections during simulation

% Copyright 2022-2023 The MathWorks, Inc

outport1 = block.OutputPort(1);

I = outport1.Data;
surface_ax.ImageSource = I;
% imshow(I,'parent',surface_ax)
pause(0.000005);

end
