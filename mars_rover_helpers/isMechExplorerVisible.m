function flag = isMechExplorerVisible(model)
% Copyright 2022-2023 The MathWorks, Inc

SM_openFrames = javaMethodEDT('getFrames', 'java.awt.Frame');
for idx = 1:numel(SM_openFrames)
    if strcmp(char(SM_openFrames(idx).getName),'MechEditorDTClientFrame') % For MATLAB Online
        if isempty(string(SM_openFrames(idx).getClient))
            javaMethodEDT('dispose', SM_openFrames(idx));
        elseif contains(string(SM_openFrames(idx).getClient.getName),string(model))
            flag = true;
            return;
        else
            flag = false;
        end
    else
        flag = false;
    end
end

end