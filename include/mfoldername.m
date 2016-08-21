%-------------------------------------------------------------------
% mfoldername.m
% Creates a path to easily save or load your results no matter where your
% function is located
%--------------------------------------------------------------------------
% [path_name] = mfoldername(fun_path,extra_path)
% fun_path  : function path_name (either dynamic using mfilename('fullpath') or
%             static using the name of a function in your current path)
% extra_path: additional directory that you would like to add to the path,
%             e.g. 'Saved_Data' so you can save your results in a folder
%             named 'Saved_Data' in the same path_name as your function (similar 
%             loading data from a specific folder)
%--------------------------------------------------------------------------
% Two general examples:
% 1. You want the current function or script path in new folder
% -The name of this function can change and still function correctly
% -Will create the extra folder for you if it does not already exist
% 
%      path_name = mfoldername(mfilename('fullpath'),'Saved_Data');
% 
% 2. You want a specific function or script path in the function folder
%
%      path_name = mfoldername('Test_mfoldername','');
%
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 2/19/2013
% 06/09/2013 v1.1 Documentation changes and example to reflect the functions 
%                 ability to aid with loading data
% 01/04/2016 v1.4 Name change to mfoldername
% 01/11/2016 v2.0 Complete rewrite based on Jan Simon's suggestions
%--------------------------------------------------------------------------
function [path_name] = mfoldername(fun_path,extra_path)

    full_fun_path = which(fun_path); % obtain full function path

    if isempty(full_fun_path) % error if empty
        error(['Error::Function Missing. ',fun_path,' not found! Check if the function is in your path'])
    end

    % create complete path name with separator at the end
    path_name = fullfile(fileparts(full_fun_path), extra_path, filesep);
    
    % check if the folder exists
    if (exist(path_name,'dir') == 0) && (~strcmp(extra_path,''))
        mkdir(path_name) % create the folder
    end

end