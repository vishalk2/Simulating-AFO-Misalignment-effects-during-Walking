function relativeMotionPlot2(LLD,RLD,Mis_Type,motion)
    motion_list = {'Preferred Walking';'Stepping Up';'Stepping Down'};
    % Loading data
    L_leg = cell2mat(LLD(1,1));
    timeStamps = cell2mat(LLD(1,2));
    AP_SP_L = cell2mat(LLD(2,1));
    PD_SP_L = cell2mat(LLD(2,2));
    AP_TP_L = cell2mat(LLD(3,1));
    PD_TP_L = cell2mat(LLD(3,2));
%     AP_FSP_L = cell2mat(LLD(4,1));
%     PD_FSP_L = cell2mat(LLD(4,2));
    AP_FP_L = cell2mat(LLD(5,1));
    PD_FP_L = cell2mat(LLD(5,2));
    R_leg = cell2mat(RLD(1,1));
    AP_SP_R = cell2mat(RLD(2,1));
    PD_SP_R = cell2mat(RLD(2,2));
    AP_TP_R = cell2mat(RLD(3,1));
    PD_TP_R = cell2mat(RLD(3,2));
%     AP_FSP_R = cell2mat(RLD(4,1));
%     PD_FSP_R = cell2mat(RLD(4,2));
    AP_FP_R = cell2mat(RLD(5,1));
    PD_FP_R = cell2mat(RLD(5,2));

    % Plot
    figure('Name','Relative Motions Plot','NumberTitle','off');
    t=tiledlayout(2,3,'TileSpacing','loose');
    title(t,{'A-P & P-D Relative Motions', ...
        strcat('Motion Type ::',cell2mat(motion_list(motion))), ...
        strcat('Misalignment Type ::',Mis_Type)})

    % Tile-1.1
    nexttile;
    p(1) = plot(timeStamps,AP_SP_L,'r-');
    hold on;
    p(2) = plot(timeStamps,AP_SP_R,'b--');
    hold off;
    xlabel('Time (s)')
    ylabel('A-P Motion (mm)')
    title('SP')

    % Tile-1.2
    nexttile;
    plot(timeStamps,AP_TP_L,'r-')
    hold on;
    plot(timeStamps,AP_TP_R,'b--')
    hold off;
    xlabel('Time (s)')
    title('TP')

    % Tile-1.3
%     nexttile;
%     plot(timeStamps,AP_FSP_L,'r-')
%     hold on;
%     plot(timeStamps,AP_FSP_R,'b--')
%     hold off;
%     xlabel('Time (s)')
%     title('FSP')

    % Tile-1.4
    nexttile;
    plot(timeStamps,AP_FP_L,'r-')
    hold on;
    plot(timeStamps,AP_FP_R,'b--')
    hold off;
    xlabel('Time (s)')
    title('FP')

    %Tile-2.1
    nexttile
    plot(timeStamps,PD_SP_L,'r-')
    hold on;
    plot(timeStamps,PD_SP_R,'b--')
    hold off;
    xlabel('Time (s)')
    ylabel('P-D Motion (mm)')

    % Tile-2.2
    nexttile
    plot(timeStamps,PD_TP_L,'r-')
    hold on;
    plot(timeStamps,PD_TP_R,'b--')
    hold off;
    xlabel('Time (s)')

    % Tile-2.3
%     nexttile
%     plot(timeStamps,PD_FSP_L,'r-')
%     hold on;
%     plot(timeStamps,PD_FSP_R,'b--')
%     hold off;
%     xlabel('Time (s)')

    % Tile-2.4
    nexttile
    plot(timeStamps,PD_FP_L,'r-')
    hold on;
    plot(timeStamps,PD_FP_R,'b--')
    hold off;
    xlabel('Time (s)')

    lg = legend(nexttile(1),p(:,:),{strcat(L_leg,'-leg'),strcat(R_leg,'-leg')}, ...
        'Orientation','vertical','Location','northoutside');
    lg.Layout.Tile = 'North';
end