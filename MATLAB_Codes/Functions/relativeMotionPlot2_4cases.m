function relativeMotionPlot2_4cases(LD,RD,motion,apm,step_size,OCS_Disp)
    % Function for plotting relative motions for all 4 standard cases
    % of misalignments

    motion_list = {'Preferred Walking';'Stepping Up';'Stepping Down'};

    % Loading original data
%     leg = cell2mat(LD(1,1));
    timeStamps = cell2mat(LD(1,2));
    MCase = cell2mat(LD(2,1));
    Mis_Type = cell2mat(LD(2,2));
    AP_SP_L = cell2mat(LD(3,1));
    PD_SP_L = cell2mat(LD(3,2));
    AP_TP_L = cell2mat(LD(4,1));
    PD_TP_L = cell2mat(LD(4,2));
%     AP_FSP_L = cell2mat(LD(5,1));
%     PD_FSP_L = cell2mat(LD(5,2));
    AP_FP_L = cell2mat(LD(6,1));
    PD_FP_L = cell2mat(LD(6,2));
    cell_size = size(timeStamps);
    AP_SP_R = cell2mat(RD(3,1));
    PD_SP_R = cell2mat(RD(3,2));
    AP_TP_R = cell2mat(RD(4,1));
    PD_TP_R = cell2mat(RD(4,2));
%     AP_FSP_R = cell2mat(RD(5,1));
%     PD_FSP_R = cell2mat(RD(5,2));
    AP_FP_R = cell2mat(RD(6,1));
    PD_FP_R = cell2mat(RD(6,2));

    % Labels for Legend
    if isequal(MCase,1)
        labels = {'Posterior Misalignment','No Misalignment','Anterior Misalignment'};
    elseif isequal(MCase,2)
        labels = {'Distal Misalignment','No Misalignment','Proximal Misalignment'};
    elseif isequal(MCase,3)
        labels = {'Posterior-Distal Misalignment','No Misalignment','Anterior-Proximal Misalignment'};
    elseif isequal(MCase,4)
        labels = {'Posterior-Proximal Misalignment','No Misalignment','Anterior-Distal Misalignment'};
    end

    % Creating adjusted data
    time_range = zeros(1,length(1:step_size:cell_size(2))+1);
    SP_AP_L = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);
    SP_PD_L = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);
    TP_AP_L = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);
    TP_PD_L = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);
%     FSP_AP_L = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);
%     FSP_PD_L = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);
    FP_AP_L = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);
    FP_PD_L = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);
    SP_AP_R = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);
    SP_PD_R = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);
    TP_AP_R = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);
    TP_PD_R = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);
%     FSP_AP_R = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);
%     FSP_PD_R = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);
    FP_AP_R = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);
    FP_PD_R = zeros(length(OCS_Disp),length(1:step_size:cell_size(2))+1);

    for d=1:length(OCS_Disp)        
        SP_AP_L(d,:) = AP_SP_L(d,[1:step_size:end,end]);
        SP_PD_L(d,:) = PD_SP_L(d,[1:step_size:end,end]);
        TP_AP_L(d,:) = AP_TP_L(d,[1:step_size:end,end]);
        TP_PD_L(d,:) = PD_TP_L(d,[1:step_size:end,end]);
%         FSP_AP_L(d,:) = AP_FSP_L(d,[1:step_size:end,end]);
%         FSP_PD_L(d,:) = PD_FSP_L(d,[1:step_size:end,end]);
        FP_AP_L(d,:) = AP_FP_L(d,[1:step_size:end,end]);
        FP_PD_L(d,:) = PD_FP_L(d,[1:step_size:end,end]);
        SP_AP_R(d,:) = AP_SP_R(d,[1:step_size:end,end]);
        SP_PD_R(d,:) = PD_SP_R(d,[1:step_size:end,end]);
        TP_AP_R(d,:) = AP_TP_R(d,[1:step_size:end,end]);
        TP_PD_R(d,:) = PD_TP_R(d,[1:step_size:end,end]);
%         FSP_AP_R(d,:) = AP_FSP_R(d,[1:step_size:end,end]);
%         FSP_PD_R(d,:) = PD_FSP_R(d,[1:step_size:end,end]);
        FP_AP_R(d,:) = AP_FP_R(d,[1:step_size:end,end]);
        FP_PD_R(d,:) = PD_FP_R(d,[1:step_size:end,end]);
        if d == 1
            time_range(d,:) = timeStamps(d,[1:step_size:end,end]);
        end
    end

    %%% PLOTS
    %---------------------------------------------------------------------%
    % Plot-1 : Strap Points
    % ---------------------
    figure('Name',strcat('Relative Motions Plot','-1'),'NumberTitle','off');
    t=tiledlayout(2,2,'TileSpacing','loose');
    %title(t,{strcat('Strap Points (SP) Relative Motions'), ...
    %    strcat(cell2mat(motion_list(motion))), ...
    %    strcat(Mis_Type), ...
    %    strcat(apm)},'Interpreter','none')

    % Tile-1.1
    nexttile;
    p(1)=plot(time_range,SP_AP_L(1,:),'b-');
    hold on;
    p(2)=plot(time_range,SP_AP_L(2,:),'k-');
    p(3)=plot(time_range,SP_AP_L(3,:),'r-');
    hold off;
    grid on;
    ylim([-10 10])
    %xlabel('Time (s)')
    ylabel('A-P Motion (mm)')
    title('Left Leg')
    % Tile-1.2
    nexttile;
    plot(time_range,SP_AP_R(1,:),'b-');
    hold on;
    plot(time_range,SP_AP_R(2,:),'k-');
    plot(time_range,SP_AP_R(3,:),'r-');
    hold off;
    grid on;
    ylim([-10 10])
    %xlabel('Time (s)')
    title('Right Leg')
    % Tile-2.1
    nexttile;
    plot(time_range,SP_PD_L(1,:),'b-');
    hold on;
    plot(time_range,SP_PD_L(2,:),'k-');
    plot(time_range,SP_PD_L(3,:),'r-');
    hold off;
    grid on;
    ylim([-20 20])
    xlabel('Time (s)')
    ylabel('P-D Motion (mm)')
    % Tile-2.2
    nexttile;
    plot(time_range,SP_PD_R(1,:),'b-');
    hold on;
    plot(time_range,SP_PD_R(2,:),'k-');
    plot(time_range,SP_PD_R(3,:),'r-');
    hold off;
    grid on;
    ylim([-20 20])
    xlabel('Time (s)')
    lg = legend(nexttile(1),p(:,:),labels, ...
        'Orientation','vertical','Location','northoutside');
    lg.Layout.Tile = 'North';
    saveas(gcf,strcat('SP',num2str(MCase),'.png'))

    %---------------------------------------------------------------------%
    % Plot-2 : Touch Points
    % ---------------------
    figure('Name',strcat('Relative Motions Plot','-2'),'NumberTitle','off');
    t=tiledlayout(2,2,'TileSpacing','loose');
    %title(t,{strcat('Touch Points (TP) Relative Motions'), ...
    %    strcat(cell2mat(motion_list(motion))), ...
    %    strcat(Mis_Type), ...
    %    strcat(apm)},'Interpreter','none')

    % Tile-1.1
    nexttile;
    p(1)=plot(time_range,TP_AP_L(1,:),'b-');
    hold on;
    p(2)=plot(time_range,TP_AP_L(2,:),'k-');
    p(3)=plot(time_range,TP_AP_L(3,:),'r-');
    hold off;
    grid on;
    ylim([-10 10])
    %xlabel('Time (s)')
    ylabel('A-P Motion (mm)')
    title('Left Leg')
    % Tile-1.2
    nexttile;
    plot(time_range,TP_AP_R(1,:),'b-');
    hold on;
    plot(time_range,TP_AP_R(2,:),'k-');
    plot(time_range,TP_AP_R(3,:),'r-');
    hold off;
    grid on;
    ylim([-10 10])
    %xlabel('Time (s)')
    title('Right Leg')
    % Tile-2.1
    nexttile;
    plot(time_range,TP_PD_L(1,:),'b-');
    hold on;
    plot(time_range,TP_PD_L(2,:),'k-');
    plot(time_range,TP_PD_L(3,:),'r-');
    hold off;
    grid on;
    ylim([-20 20])
    xlabel('Time (s)')
    ylabel('P-D Motion (mm)')
    % Tile-2.2
    nexttile;
    plot(time_range,TP_PD_R(1,:),'b-');
    hold on;
    plot(time_range,TP_PD_R(2,:),'k-');
    plot(time_range,TP_PD_R(3,:),'r-');
    hold off;
    grid on;
    ylim([-20 20])
    xlabel('Time (s)')
    lg = legend(nexttile(1),p(:,:),labels, ...
        'Orientation','vertical','Location','northoutside');
    lg.Layout.Tile = 'North';
    saveas(gcf,strcat('TP',num2str(MCase),'.png'))

    %---------------------------------------------------------------------%
    % Plot-3 : Foot Points
    % ---------------------
    figure('Name',strcat('Relative Motions Plot','-3'),'NumberTitle','off');
    t=tiledlayout(2,2,'TileSpacing','loose');
    %title(t,{strcat('Foot Points (FP) Relative Motions'), ...
    %    strcat(cell2mat(motion_list(motion))), ...
    %    strcat(Mis_Type), ...
    %    strcat(apm)},'Interpreter','none')

    % Tile-1.1
    nexttile;
    p(1)=plot(time_range,FP_AP_L(1,:),'b-');
    hold on;
    p(2)=plot(time_range,FP_AP_L(2,:),'k-');
    p(3)=plot(time_range,FP_AP_L(3,:),'r-');
    hold off;
    grid on;
    ylim([-10 10])
    %xlabel('Time (s)')
    ylabel('A-P Motion (mm)')
    title('Left Leg')
    % Tile-1.2
    nexttile;
    plot(time_range,FP_AP_R(1,:),'b-');
    hold on;
    plot(time_range,FP_AP_R(2,:),'k-');
    plot(time_range,FP_AP_R(3,:),'r-');
    hold off;
    grid on;
    ylim([-10 10])
    %xlabel('Time (s)')
    title('Right Leg')
    % Tile-2.1
    nexttile;
    plot(time_range,FP_PD_L(1,:),'b-');
    hold on;
    plot(time_range,FP_PD_L(2,:),'k-');
    plot(time_range,FP_PD_L(3,:),'r-');
    hold off;
    grid on;
    ylim([-20 20])
    xlabel('Time (s)')
    ylabel('P-D Motion (mm)')
    % Tile-2.2
    nexttile;
    plot(time_range,FP_PD_R(1,:),'b-');
    hold on;
    plot(time_range,FP_PD_R(2,:),'k-');
    plot(time_range,FP_PD_R(3,:),'r-');
    hold off;
    grid on;
    ylim([-20 20])
    xlabel('Time (s)')
    lg = legend(nexttile(1),p(:,:),labels, ...
        'Orientation','vertical','Location','northoutside');
    lg.Layout.Tile = 'North';
    saveas(gcf,strcat('FP',num2str(MCase),'.png'))

    %---------------------------------------------------------------------%
    close all;
end