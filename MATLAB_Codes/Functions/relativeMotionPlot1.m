function relativeMotionPlot1(LD,Mis_Type,motion)

    motion_list = {'Preferred Walking';'Stepping Up';'Stepping Down'};
    % Loading data
    leg = cell2mat(LD(1,1));
    timeStamps = cell2mat(LD(1,2));
    AP_SP = cell2mat(LD(2,1));
    PD_SP = cell2mat(LD(2,2));
    AP_TP = cell2mat(LD(3,1));
    PD_TP = cell2mat(LD(3,2));
%     AP_FSP = cell2mat(LD(4,1));
%     PD_FSP = cell2mat(LD(4,2));
    AP_FP = cell2mat(LD(5,1));
    PD_FP = cell2mat(LD(5,2));

    % Plot
    figure('Name',strcat(leg,'_leg','- Relative Motions Plot'),'NumberTitle','off');
    t=tiledlayout(2,3,'TileSpacing','loose');
    title(t,{strcat(leg,'-limb Relative Motions'), ...
        strcat('Motion Type ::',cell2mat(motion_list(motion))), ...
        strcat('Misalignment Type ::',Mis_Type)})

    % Tile-1.1
    nexttile;
    plot(timeStamps,AP_SP,'r-')
    xlabel('Time (s)')
    ylabel('A-P Motion (mm)')
    title('SP')

    % Tile-1.2
    nexttile;
    plot(timeStamps,AP_TP,'b-')
    xlabel('Time (s)')
    title('TP')

    % Tile-1.3
%     nexttile;
%     plot(timeStamps,AP_FSP,'c-')
%     xlabel('Time (s)')
%     title('FSP')

    % Tile-1.4
    nexttile;
    plot(timeStamps,AP_FP,'m-')
    xlabel('Time (s)')
    title('FP')

    %Tile-2.1
    nexttile
    plot(timeStamps,PD_SP,'r-')
    xlabel('Time (s)')
    ylabel('P-D Motion (mm)')

    % Tile-2.2
    nexttile
    plot(timeStamps,PD_TP,'b-')
    xlabel('Time (s)')

    % Tile-2.3
%     nexttile
%     plot(timeStamps,PD_FSP,'c-')
%     xlabel('Time (s)')

    % Tile-2.4
    nexttile
    plot(timeStamps,PD_FP,'m-')
    xlabel('Time (s)')
end