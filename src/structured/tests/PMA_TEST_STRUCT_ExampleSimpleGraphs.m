%--------------------------------------------------------------------------
% PMA_TEST_STRUCT_ExampleSimpleGraphs.m
% Create or loading graph examples
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Additional contributor: Shangtingli on Github
% Link: https://github.com/danielrherber/pm-architectures-project
%--------------------------------------------------------------------------
function [C,R,P,S,FinalGraphs] = PMA_TEST_STRUCT_ExampleSimpleGraphs(example,opts)

% current folder
folder = mfoldername(mfilename('fullpath'),'');

switch example
    %----------------------------------------------------------------------
    % Real Scenario with 1 planetary gear
    case 1
    fullname = [folder 'Bayrak1.mat'];
    try
        Info = load(fullname);
        C = Info.C;
        P = Info.P;
        S = Info.S;
        R = Info.R;
        FinalGraphs = Info.FinalGraphs;
        clearvars Info
    catch
        R.min = [1 0 1 0 1 0 0]'; % replicates min vector
        R.max = [2 1 1 1 1 1 1]';
        C = {'M','E','V','G','P','A','B'};
        P = [1 1 1 1 3 3 4];
        S = [0 0 0 0 1 0 0];
        NSC.simple = 1; % unique edges
        NSC.directA = ones(length(P));
        NSC.directA(6,6) = 0; % no A-A
        NSC.directA(7,7) = 0; % no B-B
        NSC.directA(7,6) = 0; % no B-A
        FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);
        save(fullname,'C','R','P','S','FinalGraphs');
    end
    %----------------------------------------------------------------------
    % Real Scenario with 2 planetary gears
    case 2
    fullname = [folder 'Bayrak2.mat'];
    try
        Info = load(fullname);
        C = Info.C;
        P = Info.P;
        S = Info.S;
        R = Info.R;
        FinalGraphs = Info.FinalGraphs;
        clearvars Info
    catch
        R.min = [1 0 1 0 1 0 0]'; % replicates min vector
        R.max = [2 1 1 1 2 1 1]';
        C = {'M','E','V','G','P','A','B'};
        P = [1 1 1 1 3 3 4];
        S = [0 0 0 0 1 0 0];
        NSC.simple = 1; % unique edges
        NSC.directA = ones(length(P));
        NSC.directA(6,6) = 0; % no A-A
        NSC.directA(7,7) = 0; % no B-B
        NSC.directA(7,6) = 0; % no B-A
        FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);
        save(fullname,'C','R','P','S','FinalGraphs');
    end
    %----------------------------------------------------------------------
    % Modified Scenario 1 with 1 planetary gears. All ports > 1 components
    % are designated as structured components
    case 3
    fullname = [folder 'BayrakModified1.mat'];
    try
        Info = load(fullname);
        C = Info.C;
        P = Info.P;
        S = Info.S;
        R = Info.R;
        FinalGraphs = Info.FinalGraphs;
        clearvars Info
    catch
        R.min = [1 0 1 0 1 0 0]'; % replicates min vector
        R.max = [2 1 1 1 1 1 1]';
        C = {'M','E','V','G','P','A','B'};
        P = [1 1 1 1 3 3 4];
        S = [0 0 0 0 1 1 1];
        NSC.simple = 1; % unique edges
        NSC.directA = ones(length(P));
        NSC.directA(6,6) = 0; % no A-A
        NSC.directA(7,7) = 0; % no B-B
        NSC.directA(7,6) = 0; % no B-A
        FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);
        save(fullname,'C','R','P','S','FinalGraphs');
    end
    %----------------------------------------------------------------------
    % Modified Scenario 2 with 1 planetary gears. All ports > 1 components
    % are designated as structured components. All ports = 1 components are
    % designated the same label.
    case 4
    try
        fullname = [folder 'BayrakModified2.mat'];
        Info = load(fullname);
        C = Info.C;
        P = Info.P;
        S = Info.S;
        FinalGraphs = Info.FinalGraphs;
        clearvars Info
    catch
        R.min = [2 1 0 0]'; % replicates min vector
        R.max = [5 1 1 1]';
        C = {'M','P','A','B'};
        P = [1 3 3 4];
        S = [0 1 1 1];
        NSC.simple = 1;
        FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);
        save(fullname,'C','R','P','S','FinalGraphs');
    end
    %----------------------------------------------------------------------
    % Modified Scenario 1 with 2 planetary gears. All ports > 1 components
    % are designated as structured components
    case 5
    fullname = [folder 'BayrakModified3.mat'];
    try
        Info = load(fullname);
        C = Info.C;
        P = Info.P;
        S = Info.S;
        R = Info.R;
        FinalGraphs = Info.FinalGraphs;
        clearvars Info
    catch
        R.min = [1 0 1 0 1 0 0]'; % replicates min vector
        R.max = [2 1 1 1 2 1 1]';
        C = {'M','E','V','G','P','A','B'};
        P = [1 1 1 1 3 3 4];
        S = [0 0 0 0 1 1 1];
        NSC.simple = 1; % unique edges
        NSC.directA = ones(length(P));
        NSC.directA(6,6) = 0; % no A-A
        NSC.directA(7,7) = 0; % no B-B
        NSC.directA(7,6) = 0; % no B-A
        FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);
        save(fullname,'C','R','P','S','FinalGraphs');
    end
    %----------------------------------------------------------------------
    % Modified Scenario 2 with 2 planetary gears. All ports > 1 components
    % are designated as structured components. All ports = 1 components are
    % designated the same label.
    case 6
    try
        fullname = [folder 'BayrakModified4.mat'];
        Info = load(fullname);
        C = Info.C;
        P = Info.P;
        S = Info.S;
        R = Info.R;
        FinalGraphs = Info.FinalGraphs;
        clearvars Info
    catch
        R.min = [2 1 0 0]'; % replicates min vector
        R.max = [5 2 1 1]';
        C = {'M','P','A','B'};
        P = [1 3 3 4];
        S = [0 1 1 1];
        NSC.simple = 1;
        FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);
        save(fullname,'C','R','P','S','FinalGraphs');
    end
    %----------------------------------------------------------------------
    % All components are structured
    case 7
    fullname = [folder 'BayrakModified5.mat'];
    try
        Info = load(fullname);
        C = Info.C;
        P = Info.P;
        S = Info.S;
        R = Info.R;
        FinalGraphs = Info.FinalGraphs;
        clearvars Info
    catch
        R.min = [1 0 1 0 1 0 0]'; % replicates min vector
        R.max = [2 1 1 1 1 1 1]';
        C = {'M','E','V','G','P','A','B'};
        P = [1 1 1 1 3 3 4];
        S = [1 1 1 1 1 1 1];
        NSC.simple = 1; % unique edges
        NSC.directA = ones(length(P));
        NSC.directA(6,6) = 0; % no A-A
        NSC.directA(7,7) = 0; % no B-B
        NSC.directA(7,6) = 0; % no B-A
        FinalGraphs = PMA_UniqueFeasibleGraphs(C,R,P,NSC,opts);
        save(fullname,'C','R','P','S','FinalGraphs');
    end
    %----------------------------------------------------------------------
end

end