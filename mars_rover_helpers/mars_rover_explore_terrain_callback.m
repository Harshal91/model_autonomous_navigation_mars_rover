classdef mars_rover_explore_terrain_callback
% Callback code for the Terrain block in mars_rover_explore.slx model

% Copyright 2022-2023 The MathWorks, Inc

    methods(Static)
        % Use the code browser on the left to add the callbacks.
        function surface_type(callbackContext)

            maskValue = get_param(gcb,'MaskValues');
            if strcmp(maskValue{1},'Flat Terrain')
               set_param(gcb,'LabelModeActiveChoice', 'Flat_Terrain')
            else
               set_param(gcb,'LabelModeActiveChoice', 'Uneven_Terrain')
            end

        end
    end
end