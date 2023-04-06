function [trainIdx, valIdx] = validationSplit(data, th)
% This function gets the list of files and split them into validation and
% test, considering that we have Left and Right images that are pretty much
% in the same scene. This means that both should be taken to train OR
% validation at the same time.

% Set validation partition to 2.5%. Keep in mind that we have stereo
% images, which means that we need to remove both Left and Right images for
% validation. This means that, in the end, we will have somewhere between
% 2.5 and 5% of validation data.

% Copyright 2022-2023 The MathWorks, Inc

valPartition = rand(size(data, 1), 1) < th;

% Find the unique names of each file
uniqueValFilenames = arrayfun(@filePathSplitter, data.Filename(valPartition));

% Get the complete list of files and handpick the validation files
existingFilenames = string(data.Filename);
valIdx = zeros(size(existingFilenames));
for i = 1:numel(uniqueValFilenames)
    valIdx = valIdx + contains(existingFilenames , uniqueValFilenames(i));
end

valIdx = valIdx > 0;
trainIdx = valIdx == 0;
end

function filename = filePathSplitter(x)
x = string(x);
% Paths have the following structure: /path1/path2/filename.png
% We separate them into: {path1, path2, filename.png}.
partialSplit = split(x, '/');

% We just want the last item of the partialSplit variable (e.g.
% filename.png).
filename = partialSplit {end};

% We clean the filename, which includes some information about the
% Right/Left channel.
filename = split(filename, "_");
filename = strrep(filename{end}, ".png", "");
end
