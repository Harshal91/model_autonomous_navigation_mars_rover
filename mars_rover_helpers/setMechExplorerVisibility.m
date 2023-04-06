function setMechExplorerVisibility(model,flag)

% Copyright 2022-2023 The MathWorks, Inc

if strcmp(flag,'show')
    flag = true;
else
    flag = false;
end

SM_openFrames = javaMethodEDT('getFrames', 'java.awt.Frame');
for idx = 1:numel(SM_openFrames)
    if strcmp(char(SM_openFrames(idx).getName),'MechEditorDTClientFrame') % For MATLAB Online
        if isempty(string(SM_openFrames(idx).getClient))
            javaMethodEDT('dispose', SM_openFrames(idx));
        elseif contains(string(SM_openFrames(idx).getClient.getName),string(model))
            SM_openFrames(idx).setVisible(flag);
        end
    end
end

end