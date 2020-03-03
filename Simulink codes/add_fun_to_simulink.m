% Add a MATLAB Function block to a model and populate the block with MATLAB
% code.
%
% Copyright 2018 The Mathworks, Inc.

open_system('Unequal_load_sharing.slx');
libraryBlockPath = 'simulink/User-Defined Functions/MATLAB Function';
newBlockPath = 'Unequal_load_sharing/Transfer_Path';
% Add a MATLAB Function to the model
add_block(libraryBlockPath, newBlockPath);
% In memory, open models and their parts are represented by a hierarchy of
% objects. The root object is slroot. This line of the script returns the
% object that represents the new MATLAB Function block:
blockHandle = find(slroot, '-isa', 'Stateflow.EMChart', 'Path', newBlockPath);
% The Script property of the object contains the contents of the block,
% represented as a character vector. This line of the script loads the
% contents of the file myAdd.m into the Script property:
blockHandle.Script = fileread('Transfer_Path.m');
% Alternatively, you can specify the code directly in a character vector.
% For example: 
% blockHandle.Script = 'function c = fcn (a, b)';