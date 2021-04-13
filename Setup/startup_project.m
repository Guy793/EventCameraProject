% This script defines a project shortcut. 
%
% To get a handle to the current project use the following function:
%
% project = simulinkproject();
%
% You can use the fields of project to get information about the currently 
% loaded project. 
%
% See: help simulinkproject


%% Load PROJECT 
project     = simulinkproject();
projectRoot = project.RootFolder;

%% Open Root Model:
% open('modelname');

%% Add to Python Path
pyLibraryFolder = fullfile(projectRoot,'Functions','Python');
insert(py.sys.path, int64(0), pyLibraryFolder)

%% Setting explicit folder for project generated code instead of being generated to "current folder" (which is default):

myCacheFolder = fullfile(projectRoot, 'Cash');
myCodeFolder  = fullfile(projectRoot, 'Code');

Simulink.fileGenControl('set',...
    'CacheFolder', myCacheFolder,...
    'CodeGenFolder', myCodeFolder,...
    'createDir', true);

%% clear variables from workspace
clear project projectRoot myCacheFolder myCodeFolder;