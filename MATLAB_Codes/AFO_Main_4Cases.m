%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                     %%%
%%% > Simulating Ankle-Joint Misalignment effects with AFOs during -    %%%
%%%   - Stepping Up Motion                                              %%%
%%%   - Stepping Down Motion                                            %%%
%%%   - Preferred Walking                                               %%%
%%% > Authors : K.Badari Vishal; Ganesh M. Bapat                        %%%
%%%               ---------------------------------------               %%%
%%% > Data taken from "An Extensive Set of Kinematic & Kinetic Data for %%%
%%%   Individuals with Intact Limbs & Transfemoral Prosthesis Users".   %%%
%%%   DOI : https://doi.org/10.1155/2020/8864854                        %%%
%%%               ---------------------------------------               %%%
%%% > MATLAB Code                                                       %%%
%%%   - Edited by : K.Badari Vishal, 3rd April 2022                     %%%
%%%   - Last Edited by : K.Badari Vishal, 11th August 2022              %%%
%%%               ---------------------------------------               %%%
%%% > Analysis Details                                                  %%%
%%%   - All Lengths & Distances are taken in "mm".                      %%%
%%%   - All Angles are taken in "Degrees".                              %%%
%%%   - Theta in Counter Clock-wise(CCW) direction is considered "+ve". %%%
%%%   - Theta in Clock-wise(CW) direction is "-ve".                     %%%
%%%   - Conventions:                                                    %%%
%%%      ~ Anterior (->)  : +ve                                         %%%
%%%      ~ Posterior (<-) : -ve                                         %%%
%%%      ~ Proximal (^)   : +ve                                         %%%
%%%      ~ Distal (v)     : -ve                                         %%%
%%%               ---------------------------------------               %%%
%%%                           Misalignment Cases                        %%%
%%%               ---------------------------------------               %%%
%%%   Case-1 : Anterior-Posterior Misalignments                         %%%
%%%   Case-2 : Proximal-Distal Misalignments                            %%%
%%%   Case-3 : Posterior Distal - Anterior Proximal Misalignments       %%%
%%%   Case-4 : Posterior Proximal - Anterior Distal Misalignments       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear;
close all;

addpath('Data')
addpath('Functions')

OCS_Disp = -15:15:15; % OCS misalignment range (-15mm, 0mm, 15mm)

% Selecting Motion Type
disp('Initializing...')
disp('-')
motion = motion_type();

% If motion type is not selected, end the program.
if motion == 0
    disp('Motion Type is not selected.')
    disp('Program terminated.')
    return
else
    disp('Motion Input complete.')
    disp('-')
end

% Loading respective Datasets
disp('Loading Datasets...')
disp('-')
[apmDataset,limbAnglesDataset,timeStamps,index,apm] = load_Dataset(motion);
if isequal(apmDataset,0)
    disp('No Dataset selected!')
    disp('Program terminated.')
    return
else
    disp('Datasets Loaded.')
    disp('-')
end

% Analysis & Computation
% LLD : Left Limb Data
% RLD : Right Limb Data
disp('Performing Analysis...')
disp('-')
[LLD1,LLD2,LLD3,LLD4] = afoMotionAnalysis_4cases(apmDataset,limbAnglesDataset,timeStamps,index,OCS_Disp,'Left',motion);
[RLD1,RLD2,RLD3,RLD4] = afoMotionAnalysis_4cases(apmDataset,limbAnglesDataset,timeStamps,index,OCS_Disp,'Right',motion);

% Statistical Analysis
[SD1,SD2,SD3,SD4] = statisticalAnalysis_4cases(LLD1,LLD2,LLD3,LLD4,RLD1,RLD2,RLD3,RLD4);
disp('Analysis Completed.')
disp('-')

% Plotting
%relativeMotionPlot_4cases(LLD1,RLD1,motion,apm,1,OCS_Disp)
%relativeMotionPlot_4cases(LLD2,RLD2,motion,apm,1,OCS_Disp)
%relativeMotionPlot_4cases(LLD3,RLD3,motion,apm,1,OCS_Disp)
%relativeMotionPlot_4cases(LLD4,RLD4,motion,apm,1,OCS_Disp)

%relativeMotionPlot2_4cases(LLD1,RLD1,motion,apm,1,OCS_Disp)
%relativeMotionPlot2_4cases(LLD2,RLD2,motion,apm,1,OCS_Disp)
%relativeMotionPlot2_4cases(LLD3,RLD3,motion,apm,1,OCS_Disp)
%relativeMotionPlot2_4cases(LLD4,RLD4,motion,apm,1,OCS_Disp)

%relativeMotionPlot3_4cases(LLD1,RLD1,motion,apm,1,OCS_Disp)
%relativeMotionPlot3_4cases(LLD2,RLD2,motion,apm,1,OCS_Disp)
%relativeMotionPlot3_4cases(LLD3,RLD3,motion,apm,1,OCS_Disp)
%relativeMotionPlot3_4cases(LLD4,RLD4,motion,apm,1,OCS_Disp)

% Compressing Images
% zip(strcat(num2str(motion),'_',apm),'*.png')
% delete *.png

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%---------------------------------------------------------------------%%%
%%%                          DEFINED FUNCTIONS                          %%%
%%%---------------------------------------------------------------------%%%

%-------------------------------------------------------------------------%
% Function for user input of Motion type

function motion = motion_type()
    motion_list = {'Preferred Walking';'Stepping Up';'Stepping Down'};
    [index,tf] = listdlg('PromptString',{['Following is the table ' ...
        'showing different'], ...
        'motion types considered in this analysis.', ...
        'Select any motion type for further analysis:'}, ...
        'SelectionMode','single','ListString',motion_list, ...
        'ListSize',[250,80],'Name','Motion Type Selection');
    if tf == 1
        motion = index;
    elseif tf == 0
        motion = 0;
    end
end

%-------------------------------------------------------------------------%
% Function for loading Data

function [apmDataset,limbAnglesDataset,timeStamps,index,apm] = load_Dataset(motion)
    % apmDataset : Anthropometric Dataset
    % limbAnglesDataset : Shank and Foot angles dataset
    % timeStamps : Time limits for each dataset

    % Data Sets used
    data_sets = {'PreferredWalking.xlsx';'SteppingUp.xlsx';
        'SteppingDown.xlsx'};

    % Loading datasets for respective motion and participant
    if isequal(motion,1) % Preferred Walking

        % Dataset names & ranges
        sheet_names = {'AB01_Trial_1';'AB01_Trial_2';
            'AB02_Trial_1';'AB02_Trial_2';
            'AB03_Trial_1';'AB03_Trial_2';
            'AB04_Trial_1';'AB04_Trial_2';
            'AB05_Trial_1';'AB05_Trial_2'};
        data_range = {'AX2:BA3101';'AX2:BA3101';
            'AX2:BA3101';'AX2:BA3101';
            'AX2:BA1351';'AX2:BA1337';
            'AX2:BA2378';'AX2:BA2378';
            'AX2:BA2465';'AX2:BA2656'};
        timeStamps_range = {'A2:A3101';'A2:A3101';
            'A2:A3101';'A2:A3101';
            'A2:A1351';'A2:A1337';
            'A2:A2378';'A2:A2378';
            'A2:A2465';'A2:A2656'};

        % Choosing respective Motion Trial
        [index,tf] = listdlg('PromptString',{'Choose any trial dataset for', ...
            'the given motion type:'},'SelectionMode','single', ...
            'ListString',sheet_names, ...
            'ListSize',[250,250],'Name','Motion Trial Selection');
        apm = cell2mat(sheet_names(index));
        if tf == 0
            apmDataset = 0;
            limbAnglesDataset = 0;
            timeStamps = 0;
        elseif tf == 1
            apmDataset = readcell(cell2mat(data_sets(motion)), ...
                'Sheet',apm(1:4),'Range','A8:G19');
            limbAnglesDataset = readcell(cell2mat(data_sets(motion)), ...
                'Sheet',char(sheet_names(index)), ...
                'Range',char(data_range(index)));
            timeStamps = readcell(cell2mat(data_sets(motion)), ...
                'Sheet',char(sheet_names(index)), ...
                'Range',char(timeStamps_range(index)));
        end

    elseif isequal(motion,2) % Stepping Up

        % Dataset names & ranges
        sheet_names = {'AB01_Trial_1';'AB01_Trial_2';
            'AB02_Trial_1';'AB02_Trial_2';
            'AB03_Trial_1';'AB03_Trial_2';
            'AB04_Trial_1';'AB04_Trial_2';
            'AB05_Trial_1';'AB05_Trial_2'};
        data_range = {'AX2:BA562';'AX2:BA585';
            'AX2:BA514';'AX2:BA819';
            'AX2:BA606';'AX2:BA509';
            'AX2:BA524';'AX2:BA636';
            'AX2:BA494';'AX2:BA590'};
        timeStamps_range = {'A2:A562';'A2:A585';
            'A2:A514';'A2:A819';
            'A2:A606';'A2:A509';
            'A2:A524';'A2:A636';
            'A2:A494';'A2:A590'};

        % Choosing respective Motion Trial
        [index,tf] = listdlg('PromptString',{'Choose any trial dataset for', ...
            'the given motion type:'},'SelectionMode','single', ...
            'ListString',sheet_names, ...
            'ListSize',[250,250],'Name','Motion Trial Selection');
        apm = cell2mat(sheet_names(index));
        if tf == 0
            apmDataset = 0;
            limbAnglesDataset = 0;
            timeStamps = 0;
        elseif tf == 1
            apmDataset = readcell(cell2mat(data_sets(motion)), ...
                'Sheet',apm(1:4),'Range','A8:G19');
            limbAnglesDataset = readcell(cell2mat(data_sets(motion)), ...
                'Sheet',char(sheet_names(index)), ...
                'Range',char(data_range(index)));
            timeStamps = readcell(cell2mat(data_sets(motion)), ...
                'Sheet',char(sheet_names(index)), ...
                'Range',char(timeStamps_range(index)));
        end

    elseif isequal(motion,3) % Stepping Down

        % Dataset names & ranges
        sheet_names = {'AB01_Trial_1';'AB01_Trial_2';
            'AB02_Trial_1';'AB02_Trial_2';
            'AB03_Trial_1';'AB03_Trial_2';
            'AB04_Trial_1';'AB04_Trial_2';
            'AB05_Trial_1';'AB05_Trial_2'};
        data_range = {'AX2:BA549';'AX2:BA489';
            'AX2:BA507';'AX2:BA536';
            'AX2:BA508';'AX2:BA479';
            'AX2:BA525';'AX2:BA522';
            'AX2:BA635';'AX2:BA529'};
        timeStamps_range = {'A2:A549';'A2:A489';
            'A2:A507';'A2:A536';
            'A2:A508';'A2:A479';
            'A2:A525';'A2:A522';
            'A2:A635';'A2:A529'};

        % Choosing respective Motion Trial
        [index,tf] = listdlg('PromptString',{'Choose any trial dataset for', ...
            'the given motion type:'},'SelectionMode','single', ...
            'ListString',sheet_names, ...
            'ListSize',[250,250],'Name','Motion Trial Selection');
        apm = cell2mat(sheet_names(index));
        if tf == 0
            apmDataset = 0;
            limbAnglesDataset = 0;
            timeStamps = 0;
        elseif tf == 1
            apmDataset = readcell(cell2mat(data_sets(motion)), ...
                'Sheet',apm(1:4),'Range','A8:G19');
            limbAnglesDataset = readcell(cell2mat(data_sets(motion)), ...
                'Sheet',char(sheet_names(index)), ...
                'Range',char(data_range(index)));
            timeStamps = readcell(cell2mat(data_sets(motion)), ...
                'Sheet',char(sheet_names(index)), ...
                'Range',char(timeStamps_range(index)));
        end
    else
        apmDataset = 0;
        limbAnglesDataset = 0;
        timeStamps = 0;
    end
end

%-------------------------------------------------------------------------%