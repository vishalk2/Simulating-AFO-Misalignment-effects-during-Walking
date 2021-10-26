% Ankle Foot Orthosis
clc;
clear;
close all;

% All Lengths & Distances have units in "mm".
% All Angles have units in "Degrees".
% Theta in CCW direction is considered +ve and in CW direction is -ve.
% Conventions: {Anterior(->) : +ve, Posterior(<-) : -ve, Proximal(^) : +ve, Distal(v) : -ve}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters
theta_range = -20:10:20; % Ankle Dorsiflexion angle range
Disp = -20:5:20; % Misalignment range

% Limb Points (Coordinates : [x y z])
ACS = [0 0 1]'; % Origin
FE = [-61.32 -63.57 1]'; % Foot End
FT = [186.44 -63.57 1]'; % Foot Tip
Knee = [0 400.98 1]'; % Knee

% Orthosis Points (Coordinates : [x y z])
TP1 = [-31.2 183.9 1]'; % Touch Point-1
TP2 = [-31.2 267.7 1]'; % Touch Point-2
SP0 = [0 233.5 1]'; % Strap Point-0
SP1 = [41.2 233.5 1]'; % Strap Point-1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                           Misalignment Cases                        %%%
%%%   Case-1 : Anterior-Posterior Misalignments                         %%%
%%%   Case-2 : Proximal-Distal Misalignments                            %%%
%%%   Case-3 : Posterior Distal - Anterior Proximal Misalignment        %%%
%%%   Case-4 : Posterior Proximal - Anterior Distal Misalignment        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Computation

for MCase=1:4
    switch MCase
        case 1 % Case-1 : Anterior-Posterior Misalignments

            Mis_Type = 'Anterior-Posterior Misalignments';
            SP_res_AP = zeros(9,5);
            SP_res_PD = zeros(9,5);
            TP_res_AP = zeros(9,5);
            TP_res_PD = zeros(9,5);

            for d=1:length(Disp) % Iterating for every Misalignment case

                deltaX = Disp(d); % X-Misalignment
                deltaY = 0; % Y-Misalignment
                OCS = [deltaX deltaY 1]'; % Orthosis Center
                
                AP_SP = zeros(1,5); % Anterior-Posterior Relative Motion for Strap Points for each angle
                PD_SP = zeros(1,5); % Proximal-Distal Relative Motion for Strap Points for each angle
                AP_TP = zeros(1,5); % Anterior-Posterior Relative Motion for Touch Points for each angle
                PD_TP = zeros(1,5); % Proximal-Distal Relative Motion for Touch Points for each angle

                for th=1:length(theta_range) % Iterating for every Ankle Dorsiflexion Angle
                    
                    theta = theta_range(th); % Ankle Dorsiflexion Angle
                    [Knee_ACS,FE_ACS,FT_ACS] = limbMovements(theta,Knee,FE,FT); % Limb segments
                    [SP0_ACS,SP1_ACS,SP0_OCS,SP1_OCS] = strapPoints(-theta,deltaX,deltaY,SP0,SP1); % Strap Points
                    [TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS] = touchPoints(-theta,deltaX,deltaY,TP1,TP2); % Touch Points
                    
                    [AP_SP(th),PD_SP(th)] = relativeMotionSP(SP0_OCS,SP1_ACS,SP1_OCS); % Relative Motion for SP
                    [AP_TP(th),PD_TP(th)] = relativeMotionTP(TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS,theta); % Relative Motion for TP

                    % Illustration Plots                  
                    illustrationPlot(ACS,FE,FT,Knee,SP0_OCS,SP1_ACS,SP1_OCS,Knee_ACS,TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS,deltaX,deltaY,OCS)
                    
                end
                % Relative Motions Values
                SP_res_AP(d,:) = AP_SP;
                SP_res_PD(d,:) = PD_SP;
                TP_res_AP(d,:) = AP_TP;
                TP_res_PD(d,:) = PD_TP;
            end

            % Plotting relative motions
            relativeMotionPlot(SP_res_AP,theta_range,MCase,Mis_Type,[-2,2],'A-P relative motion (mm)','Strap Points')
            relativeMotionPlot(SP_res_PD,theta_range,MCase,Mis_Type,[-10,10],'P-D relative motion (mm)','Strap Points')
            relativeMotionPlot(TP_res_AP,theta_range,MCase,Mis_Type,[-2,2],'A-P relative motion (mm)','Touch Points')
            relativeMotionPlot(TP_res_PD,theta_range,MCase,Mis_Type,[-10,10],'P-D relative motion (mm)','Touch Points')
            
        case 2 % Case-2 : Proximal-Distal Misalignments

            Mis_Type = 'Proximal-Distal Misalignments';
            SP_res_AP = zeros(9,5);
            SP_res_PD = zeros(9,5);
            TP_res_AP = zeros(9,5);
            TP_res_PD = zeros(9,5);

            for d=1:length(Disp) % Iterating for every Misalignment case

                deltaX = 0; % X-Misalignment
                deltaY = Disp(d); % Y-Misalignment
                OCS = [deltaX deltaY 1]'; % Orthosis Center
                
                AP_SP = zeros(1,5); % Anterior-Posterior Relative Motion for Strap Points for each angle
                PD_SP = zeros(1,5); % Proximal-Distal Relative Motion for Strap Points for each angle
                AP_TP = zeros(1,5); % Anterior-Posterior Relative Motion for Touch Points for each angle
                PD_TP = zeros(1,5); % Proximal-Distal Relative Motion for Touch Points for each angle

                for th=1:length(theta_range) % Iterating for every Ankle Dorsiflexion Angle
                    
                    theta = theta_range(th); % Ankle Dorsiflexion Angle
                    [Knee_ACS,FE_ACS,FT_ACS] = limbMovements(theta,Knee,FE,FT); % Limb segments
                    [SP0_ACS,SP1_ACS,SP0_OCS,SP1_OCS] = strapPoints(-theta,deltaX,deltaY,SP0,SP1); % Strap Points
                    [TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS] = touchPoints(-theta,deltaX,deltaY,TP1,TP2); % Touch Points
                    
                    [AP_SP(th),PD_SP(th)] = relativeMotionSP(SP0_OCS,SP1_ACS,SP1_OCS); % Relative Motion for SP
                    [AP_TP(th),PD_TP(th)] = relativeMotionTP(TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS,theta); % Relative Motion for TP

                    % Illustration Plots                  
                    illustrationPlot(ACS,FE,FT,Knee,SP0_OCS,SP1_ACS,SP1_OCS,Knee_ACS,TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS,deltaX,deltaY,OCS)
                    
                end
                % Relative Motions Values
                SP_res_AP(d,:) = AP_SP;
                SP_res_PD(d,:) = PD_SP;
                TP_res_AP(d,:) = AP_TP;
                TP_res_PD(d,:) = PD_TP;
            end

            % Plotting relative motions
            relativeMotionPlot(SP_res_AP,theta_range,MCase,Mis_Type,[-10,10],'A-P relative motion (mm)','Strap Points')
            relativeMotionPlot(SP_res_PD,theta_range,MCase,Mis_Type,[-2,2],'P-D relative motion (mm)','Strap Points')
            relativeMotionPlot(TP_res_AP,theta_range,MCase,Mis_Type,[-10,10],'A-P relative motion (mm)','Touch Points')
            relativeMotionPlot(TP_res_PD,theta_range,MCase,Mis_Type,[-2,2],'P-D relative motion (mm)','Touch Points')

        case 3 % Case-3 : Posterior Distal - Anterior Proximal Misalignment

            Mis_Type = 'PosteriorDistal-AnteriorProximal Misalignments';
            SP_res_AP = zeros(9,5);
            SP_res_PD = zeros(9,5);
            TP_res_AP = zeros(9,5);
            TP_res_PD = zeros(9,5);

            for d=1:length(Disp) % Iterating for every Misalignment case

                deltaX = Disp(d); % X-Misalignment
                deltaY = Disp(d); % Y-Misalignment
                OCS = [deltaX deltaY 1]'; % Orthosis Center
                
                AP_SP = zeros(1,5); % Anterior-Posterior Relative Motion for Strap Points for each angle
                PD_SP = zeros(1,5); % Proximal-Distal Relative Motion for Strap Points for each angle
                AP_TP = zeros(1,5); % Anterior-Posterior Relative Motion for Touch Points for each angle
                PD_TP = zeros(1,5); % Proximal-Distal Relative Motion for Touch Points for each angle

                for th=1:length(theta_range) % Iterating for every Ankle Dorsiflexion Angle
                    
                    theta = theta_range(th); % Ankle Dorsiflexion Angle
                    [Knee_ACS,FE_ACS,FT_ACS] = limbMovements(theta,Knee,FE,FT); % Limb segments
                    [SP0_ACS,SP1_ACS,SP0_OCS,SP1_OCS] = strapPoints(-theta,deltaX,deltaY,SP0,SP1); % Strap Points
                    [TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS] = touchPoints(-theta,deltaX,deltaY,TP1,TP2); % Touch Points
                    
                    [AP_SP(th),PD_SP(th)] = relativeMotionSP(SP0_OCS,SP1_ACS,SP1_OCS); % Relative Motion for SP
                    [AP_TP(th),PD_TP(th)] = relativeMotionTP(TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS,theta); % Relative Motion for TP

                    % Illustration Plots                  
                    illustrationPlot(ACS,FE,FT,Knee,SP0_OCS,SP1_ACS,SP1_OCS,Knee_ACS,TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS,deltaX,deltaY,OCS)
                    
                end
                % Relative Motions Values
                SP_res_AP(d,:) = AP_SP;
                SP_res_PD(d,:) = PD_SP;
                TP_res_AP(d,:) = AP_TP;
                TP_res_PD(d,:) = PD_TP;
            end

            % Plotting relative motions
            relativeMotionPlot(SP_res_AP,theta_range,MCase,Mis_Type,[-10,10],'A-P relative motion (mm)','Strap Points')
            relativeMotionPlot(SP_res_PD,theta_range,MCase,Mis_Type,[-10,10],'P-D relative motion (mm)','Strap Points')
            relativeMotionPlot(TP_res_AP,theta_range,MCase,Mis_Type,[-10,10],'A-P relative motion (mm)','Touch Points')
            relativeMotionPlot(TP_res_PD,theta_range,MCase,Mis_Type,[-10,10],'P-D relative motion (mm)','Touch Points')

        otherwise % Case-4 : Posterior Proximal - Anterior Distal Misalignment

            Mis_Type = 'PosteriorProximal-AnteriorDistal Misalignments';
            SP_res_AP = zeros(9,5);
            SP_res_PD = zeros(9,5);
            TP_res_AP = zeros(9,5);
            TP_res_PD = zeros(9,5);

            for d=1:length(Disp) % Iterating for every Misalignment case

                deltaX = Disp(d); % X-Misalignment
                deltaY = -Disp(d); % Y-Misalignment
                OCS = [deltaX deltaY 1]'; % Orthosis Center
                
                AP_SP = zeros(1,5); % Anterior-Posterior Relative Motion for Strap Points for each angle
                PD_SP = zeros(1,5); % Proximal-Distal Relative Motion for Strap Points for each angle
                AP_TP = zeros(1,5); % Anterior-Posterior Relative Motion for Touch Points for each angle
                PD_TP = zeros(1,5); % Proximal-Distal Relative Motion for Touch Points for each angle

                for th=1:length(theta_range) % Iterating for every Ankle Dorsiflexion Angle
                    
                    theta = theta_range(th); % Ankle Dorsiflexion Angle
                    [Knee_ACS,FE_ACS,FT_ACS] = limbMovements(theta,Knee,FE,FT); % Limb segments
                    [SP0_ACS,SP1_ACS,SP0_OCS,SP1_OCS] = strapPoints(-theta,deltaX,deltaY,SP0,SP1); % Strap Points
                    [TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS] = touchPoints(-theta,deltaX,deltaY,TP1,TP2); % Touch Points
                    
                    [AP_SP(th),PD_SP(th)] = relativeMotionSP(SP0_OCS,SP1_ACS,SP1_OCS); % Relative Motion for SP
                    [AP_TP(th),PD_TP(th)] = relativeMotionTP(TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS,theta); % Relative Motion for TP

                    % Illustration Plots                  
                    illustrationPlot(ACS,FE,FT,Knee,SP0_OCS,SP1_ACS,SP1_OCS,Knee_ACS,TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS,deltaX,deltaY,OCS)
                    
                end
                % Relative Motions Values
                SP_res_AP(d,:) = AP_SP;
                SP_res_PD(d,:) = PD_SP;
                TP_res_AP(d,:) = AP_TP;
                TP_res_PD(d,:) = PD_TP;
            end

            % Plotting relative motions
            relativeMotionPlot(SP_res_AP,theta_range,MCase,Mis_Type,[-10,10],'A-P relative motion (mm)','Strap Points')
            relativeMotionPlot(SP_res_PD,theta_range,MCase,Mis_Type,[-10,10],'P-D relative motion (mm)','Strap Points')
            relativeMotionPlot(TP_res_AP,theta_range,MCase,Mis_Type,[-10,10],'A-P relative motion (mm)','Touch Points')
            relativeMotionPlot(TP_res_PD,theta_range,MCase,Mis_Type,[-10,10],'P-D relative motion (mm)','Touch Points')

    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------------------------------------------------------%
%                          DEFINED FUNCTIONS                              %
%-------------------------------------------------------------------------%

% Function for computing coordinates of points about ACS
function P_ACS = aboutACS(P,theta)

% Rotation Matrix
    R = [cosd(theta) -sind(theta) 0;
        sind(theta) cosd(theta) 0;
        0 0 1];
    P_ACS = R*P; % Point "P" rotated about ACS

end

%-------------------------------------------------------------------------%

% Function for computing coordinates of points about OCS
function P_OCS = aboutOCS(P,theta,deltaX,deltaY)

% Rotation Matrix
R = [cosd(theta) -sind(theta) 0;
    sind(theta) cosd(theta) 0;
    0 0 1];
% Translation / Shift Matrix
T = [1 0 deltaX;
    0 1 deltaY;
    0 0 1];

P_trans = T\P; % Point "P" translated to OCS
P_ortho = R*P_trans; % Point "P" rotated about Orthosis axis
P_OCS = T*P_ortho; % Point "P" translated back to ACS; Mentioned as OCS for ease

end

%-------------------------------------------------------------------------%

% Distance between two points
function dist = effectiveDistance(P1,P2)
    dist = sqrt((P1(1)-P2(1))^2 + (P1(2)-P2(2))^2 + (P1(3)-P2(3))^2);
end

%-------------------------------------------------------------------------%

% Slope of line between two points
function slope = effectiveSlope(P1,P2)
    slope = (P2(2)-P1(2))/(P2(1)-P1(1));
end

%-------------------------------------------------------------------------%

% Intercept of line between two points
function intercept = effectiveIntercept(P1,S)
    intercept = P1(2)-S*P1(1);
end

%-------------------------------------------------------------------------%

% Function for determining limb segments about ACS
function [Knee_ACS,FE_ACS,FT_ACS] = limbMovements(theta,Knee,FE,FT)
    Knee_ACS = aboutACS(Knee,-theta);
    FE_ACS = aboutACS(FE,theta);
    FT_ACS = aboutACS(FT,theta);
end

%-------------------------------------------------------------------------%

% Function for determining Strap Points about ACS & OCS
function [P0_ACS,P1_ACS,P0_OCS,P1_OCS] = strapPoints(theta,deltaX,deltaY,P0,P1)
    P0_ACS = aboutACS(P0,theta);
    P1_ACS = aboutACS(P1,theta);
    P0_OCS = aboutOCS(P0,theta,deltaX,deltaY);
    P1_OCS = aboutOCS(P1,theta,deltaX,deltaY);
end

%-------------------------------------------------------------------------%

% Function for determining Touch Points about ACS & OCS
function [P1_ACS,P2_ACS,P1_OCS,P2_OCS] = touchPoints(theta,deltaX,deltaY,P1,P2)
    P1_ACS = aboutACS(P1,theta);
    P2_ACS = aboutACS(P2,theta);
    P1_OCS = aboutOCS(P1,theta,deltaX,deltaY);
    P2_OCS = aboutOCS(P2,theta,deltaX,deltaY);
end

%-------------------------------------------------------------------------%

% Function for A-P & P-D Relative Motions for Strap & Foot Strap Points
function [AP,PD] = relativeMotionSP(P0_OCS,P1_ACS,P1_OCS)

    % Calculating distances
    MSP = P1_ACS; % Moving Strap Point
    length_P1s = sqrt((P1_ACS(1)-P1_OCS(1))^2+(P1_ACS(2)-P1_OCS(2))^2);
    A = P0_OCS(2)-P1_OCS(2);
    B = P1_OCS(1)-P0_OCS(1);
    C = P0_OCS(1)*P1_OCS(2)-P1_OCS(1)*P0_OCS(2);
    pd = abs((A*MSP(1)+B*MSP(2)+C)/sqrt(A^2 + B^2));
    ap = sqrt(length_P1s^2 - pd^2);

    % Calculating line parameters
    D1 = effectiveDistance(P0_OCS,P1_ACS);
    D2 = effectiveDistance(P0_OCS,P1_OCS);
    S1 = effectiveSlope(P0_OCS,P1_ACS);
    S2 = effectiveSlope(P0_OCS,P1_OCS);

    % Setting signs for relative motion based on line parameters
    % Horizontal Separation
    if D1<D2
        AP = ap;
    elseif D1>D2
        AP = -ap;
    else
        AP = ap;
    end
    % Vertical Separation
    if S1>S2
        PD = -pd;
    elseif S1<S2
        PD = pd;
    else
        PD = pd;
    end

end

%-------------------------------------------------------------------------%

% Function for A-P & P-D Relative Motions for Touch Points
function [AP,PD] = relativeMotionTP(P1_ACS,P2_ACS,P1_OCS,P2_OCS,theta)

    % Calculating Distances
    P = P2_OCS;
    length_P2s = sqrt((P2_ACS(1)-P2_OCS(1))^2+(P2_ACS(2)-P2_OCS(2))^2);
    A = P1_ACS(2)-P2_ACS(2);
    B = P2_ACS(1)-P1_ACS(1);
    C = P1_ACS(1)*P2_ACS(2)-P2_ACS(1)*P1_ACS(2);
    ap = abs((A*P(1)+B*P(2)+C)/sqrt(A^2 + B^2));
    pd = sqrt(length_P2s^2 - ap^2);

    % Calculating line parameters
    S1 = effectiveSlope(P1_ACS,P2_ACS);
    S2 = effectiveSlope(P1_OCS,P2_OCS);
    I1 = effectiveIntercept(P1_ACS,S1);
    I2 = effectiveIntercept(P1_OCS,S2);

    % Setting signs for relative motion based on line parameters
    % Vertical Separation
    if P2_ACS(2)>P2_OCS(2)
        PD = -pd;
    elseif P2_ACS(2)<P2_OCS(2)
        PD = pd;
    else
        PD = pd;
    end
    % Horizontal Separation
    if theta<0
        if I1>I2
            AP = -ap;
        elseif I1<I2
            AP = ap;
        else
            AP = ap;
        end
    elseif theta>0
        if I1<I2
            AP = -ap;
        elseif I1>I2
            AP = ap;
        else
            AP = ap;
        end
    else
        PD = 0;
        AP = 0;
    end
end

%-------------------------------------------------------------------------%

% Function for individual relative motions plot
function relativeMotionPlot(P_res,theta_range,MCase,Mis_Type,YLim,YLabel,Title)
    if MCase==1 || MCase==2
        labels = {'-20 mm','-15 mm','-10 mm','-5 mm','0 mm','5 mm','10 mm','15 mm','20 mm'};
    elseif MCase==3
        labels = {'(-20,-20) mm','(-15,-15) mm','(-10,-10) mm','(-5,-5) mm','(0,0) mm','(5,5) mm','(10,10) mm','(15,15) mm','(20,20) mm'};
    elseif MCase==4
        labels = {'(-20,20) mm','(-15,15) mm','(-10,10) mm','(-5,5) mm','(0,0) mm','(5,-5) mm','(10,-10) mm','(15,-15) mm','(20,-20) mm'};
    end
    figure;
    plot(theta_range,P_res(1,:),'k-o')
    hold on;
    plot(theta_range,P_res(2,:),'k-+')
    plot(theta_range,P_res(3,:),'k-*')
    plot(theta_range,P_res(4,:),'k-x')
    plot(theta_range,P_res(5,:),'k-')
    plot(theta_range,P_res(6,:),'k->')
    plot(theta_range,P_res(7,:),'k-<')
    plot(theta_range,P_res(8,:),'k-^')
    plot(theta_range,P_res(9,:),'k-v')
    xlim([-20 20]),xticks([-20,-10,0,10,20])
    ylim(YLim),yticks([YLim(1) YLim(1)/2 0 YLim(2)/2 YLim(2)])
    grid on;
    xlabel('Ankle Dorsiflexion Angle'),ylabel(YLabel)
    title({strcat('Case-',num2str(MCase)),Mis_Type,['Movement of ',Title]})
    legend(labels,'Location','bestoutside');
    hold off;
end

%-------------------------------------------------------------------------%

% Function for Illustration Plots of Model-1
function illustrationPlot(ACS,FE,FT,Knee,SP0_OCS,SP1_ACS,SP1_OCS,Knee_ACS,TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS,deltaX,deltaY,OCS)

    % Figure(Model,Case,Plot)
    if deltaX == -20 && deltaY == 0 % Posterior Misalignment Case
        figure(111);
        box on
        plot([ACS(1) Knee(1)],[ACS(2) Knee(2)],'color','k','LineWidth',1)
        hold on
        plot([ACS(1),FT(1)],[ACS(2),FT(2)],'color','k','LineWidth',1)
        plot([ACS(1),FE(1)],[ACS(2),FE(2)],'color','k','LineWidth',1)
        plot([FT(1),FE(1)],[FT(2),FE(2)],'color','k','LineWidth',1)
        plot([ACS(1),Knee_ACS(1)],[ACS(2),Knee_ACS(2)],'linestyle','--','color','k','LineWidth',1)
        plot([SP0_OCS(1),SP1_ACS(1)],[SP0_OCS(2),SP1_ACS(2)],'linestyle','-','color','b','LineWidth',1)
        plot([SP0_OCS(1),SP1_OCS(1)],[SP0_OCS(2),SP1_OCS(2)],'linestyle',':','color','r','LineWidth',1.5)
        plot([TP1_ACS(1),TP2_ACS(1)],[TP1_ACS(2),TP2_ACS(2)],'linestyle','-','color','c','LineWidth',1)
        plot([TP1_OCS(1),TP2_OCS(1)],[TP1_OCS(2),TP2_OCS(2)],'linestyle',':','color','m','LineWidth',1.5)
        plot(ACS(1),ACS(2),'y*','LineWidth',1.5)
        plot(OCS(1),OCS(2),'g*','LineWidth',1.5)
        xlim([-150,200]),ylim([-75,420])
        xticks([]),yticks([]);
        title('Posterior Offset')
    elseif deltaX == 20 && deltaY == 0 % Anterior Misalignment Case
        figure(112);
        box on
        plot([ACS(1) Knee(1)],[ACS(2) Knee(2)],'color','k','LineWidth',1)
        hold on
        plot([ACS(1),FT(1)],[ACS(2),FT(2)],'color','k','LineWidth',1)
        plot([ACS(1),FE(1)],[ACS(2),FE(2)],'color','k','LineWidth',1)
        plot([FT(1),FE(1)],[FT(2),FE(2)],'color','k','LineWidth',1)
        plot([ACS(1),Knee_ACS(1)],[ACS(2),Knee_ACS(2)],'linestyle','--','color','k','LineWidth',1)
        plot([SP0_OCS(1),SP1_ACS(1)],[SP0_OCS(2),SP1_ACS(2)],'linestyle','-','color','b','LineWidth',1)
        plot([SP0_OCS(1),SP1_OCS(1)],[SP0_OCS(2),SP1_OCS(2)],'linestyle',':','color','r','LineWidth',1.5)
        plot([TP1_ACS(1),TP2_ACS(1)],[TP1_ACS(2),TP2_ACS(2)],'linestyle','-','color','c','LineWidth',1)
        plot([TP1_OCS(1),TP2_OCS(1)],[TP1_OCS(2),TP2_OCS(2)],'linestyle',':','color','m','LineWidth',1.5)
        plot(ACS(1),ACS(2),'y*','LineWidth',1.5)
        plot(OCS(1),OCS(2),'g*','LineWidth',1.5)
        xlim([-150,200]),ylim([-75,420])
        xticks([]),yticks([]);
        title('Anterior Offset')
    elseif deltaX == 0 && deltaY == -20 % Distal Misalignment Case
        figure(121);
        box on        
        plot([ACS(1) Knee(1)],[ACS(2) Knee(2)],'color','k','LineWidth',1)
        hold on
        plot([ACS(1),FT(1)],[ACS(2),FT(2)],'color','k','LineWidth',1)
        plot([ACS(1),FE(1)],[ACS(2),FE(2)],'color','k','LineWidth',1)
        plot([FT(1),FE(1)],[FT(2),FE(2)],'color','k','LineWidth',1)
        plot([ACS(1),Knee_ACS(1)],[ACS(2),Knee_ACS(2)],'linestyle','--','color','k','LineWidth',1)
        plot([SP0_OCS(1),SP1_ACS(1)],[SP0_OCS(2),SP1_ACS(2)],'linestyle','-','color','b','LineWidth',1)
        plot([SP0_OCS(1),SP1_OCS(1)],[SP0_OCS(2),SP1_OCS(2)],'linestyle',':','color','r','LineWidth',1.5)
        plot([TP1_ACS(1),TP2_ACS(1)],[TP1_ACS(2),TP2_ACS(2)],'linestyle','-','color','c','LineWidth',1)
        plot([TP1_OCS(1),TP2_OCS(1)],[TP1_OCS(2),TP2_OCS(2)],'linestyle',':','color','m','LineWidth',1.5)
        plot(ACS(1),ACS(2),'y*','LineWidth',1.5)
        plot(OCS(1),OCS(2),'g*','LineWidth',1.5)
        xlim([-150,200]),ylim([-75,420])
        xticks([]),yticks([]);
        title('Distal Offset')
    elseif deltaX == 0 && deltaY == 20 % Proximal Misalignment Case
        figure(122);
        box on
        plot([ACS(1) Knee(1)],[ACS(2) Knee(2)],'color','k','LineWidth',1)
        hold on
        plot([ACS(1),FT(1)],[ACS(2),FT(2)],'color','k','LineWidth',1)
        plot([ACS(1),FE(1)],[ACS(2),FE(2)],'color','k','LineWidth',1)
        plot([FT(1),FE(1)],[FT(2),FE(2)],'color','k','LineWidth',1)
        plot([ACS(1),Knee_ACS(1)],[ACS(2),Knee_ACS(2)],'linestyle','--','color','k','LineWidth',1)
        plot([SP0_OCS(1),SP1_ACS(1)],[SP0_OCS(2),SP1_ACS(2)],'linestyle','-','color','b','LineWidth',1)
        plot([SP0_OCS(1),SP1_OCS(1)],[SP0_OCS(2),SP1_OCS(2)],'linestyle',':','color','r','LineWidth',1.5)
        plot([TP1_ACS(1),TP2_ACS(1)],[TP1_ACS(2),TP2_ACS(2)],'linestyle','-','color','c','LineWidth',1)
        plot([TP1_OCS(1),TP2_OCS(1)],[TP1_OCS(2),TP2_OCS(2)],'linestyle',':','color','m','LineWidth',1.5)
        plot(ACS(1),ACS(2),'y*','LineWidth',1.5)
        plot(OCS(1),OCS(2),'g*','LineWidth',1.5)
        xlim([-150,200]),ylim([-75,420])
        xticks([]),yticks([]);
        title('Proximal Offset')
    elseif deltaX == -20 && deltaY == -20 % Posterior-Distal Misalignment Case
        figure(131);
        box on
        plot([ACS(1) Knee(1)],[ACS(2) Knee(2)],'color','k','LineWidth',1)
        hold on
        plot([ACS(1),FT(1)],[ACS(2),FT(2)],'color','k','LineWidth',1)
        plot([ACS(1),FE(1)],[ACS(2),FE(2)],'color','k','LineWidth',1)
        plot([FT(1),FE(1)],[FT(2),FE(2)],'color','k','LineWidth',1)
        plot([ACS(1),Knee_ACS(1)],[ACS(2),Knee_ACS(2)],'linestyle','--','color','k','LineWidth',1)
        plot([SP0_OCS(1),SP1_ACS(1)],[SP0_OCS(2),SP1_ACS(2)],'linestyle','-','color','b','LineWidth',1)
        plot([SP0_OCS(1),SP1_OCS(1)],[SP0_OCS(2),SP1_OCS(2)],'linestyle',':','color','r','LineWidth',1.5)
        plot([TP1_ACS(1),TP2_ACS(1)],[TP1_ACS(2),TP2_ACS(2)],'linestyle','-','color','c','LineWidth',1)
        plot([TP1_OCS(1),TP2_OCS(1)],[TP1_OCS(2),TP2_OCS(2)],'linestyle',':','color','m','LineWidth',1.5)
        plot(ACS(1),ACS(2),'y*','LineWidth',1.5)
        plot(OCS(1),OCS(2),'g*','LineWidth',1.5)
        xlim([-150,200]),ylim([-75,420])
        xticks([]),yticks([]);
        title('Posterior-Distal Offset')
    elseif deltaX == 20 && deltaY == 20 % Anterior-Proximal Misalignment Case
        figure(132);
        box on
        plot([ACS(1) Knee(1)],[ACS(2) Knee(2)],'color','k','LineWidth',1)
        hold on
        plot([ACS(1),FT(1)],[ACS(2),FT(2)],'color','k','LineWidth',1)
        plot([ACS(1),FE(1)],[ACS(2),FE(2)],'color','k','LineWidth',1)
        plot([FT(1),FE(1)],[FT(2),FE(2)],'color','k','LineWidth',1)
        plot([ACS(1),Knee_ACS(1)],[ACS(2),Knee_ACS(2)],'linestyle','--','color','k','LineWidth',1)
        plot([SP0_OCS(1),SP1_ACS(1)],[SP0_OCS(2),SP1_ACS(2)],'linestyle','-','color','b','LineWidth',1)
        plot([SP0_OCS(1),SP1_OCS(1)],[SP0_OCS(2),SP1_OCS(2)],'linestyle',':','color','r','LineWidth',1.5)
        plot([TP1_ACS(1),TP2_ACS(1)],[TP1_ACS(2),TP2_ACS(2)],'linestyle','-','color','c','LineWidth',1)
        plot([TP1_OCS(1),TP2_OCS(1)],[TP1_OCS(2),TP2_OCS(2)],'linestyle',':','color','m','LineWidth',1.5)
        plot(ACS(1),ACS(2),'y*','LineWidth',1.5)
        plot(OCS(1),OCS(2),'g*','LineWidth',1.5)
        xlim([-150,200]),ylim([-75,420])
        xticks([]),yticks([]);
        title('Anterior-Proximal Offset')
    elseif deltaX == -20 && deltaY == 20 % Posterior-Proximal Misalignment Case
        figure(141);
        box on
        plot([ACS(1) Knee(1)],[ACS(2) Knee(2)],'color','k','LineWidth',1)
        hold on
        plot([ACS(1),FT(1)],[ACS(2),FT(2)],'color','k','LineWidth',1)
        plot([ACS(1),FE(1)],[ACS(2),FE(2)],'color','k','LineWidth',1)
        plot([FT(1),FE(1)],[FT(2),FE(2)],'color','k','LineWidth',1)
        plot([ACS(1),Knee_ACS(1)],[ACS(2),Knee_ACS(2)],'linestyle','--','color','k','LineWidth',1)
        plot([SP0_OCS(1),SP1_ACS(1)],[SP0_OCS(2),SP1_ACS(2)],'linestyle','-','color','b','LineWidth',1)
        plot([SP0_OCS(1),SP1_OCS(1)],[SP0_OCS(2),SP1_OCS(2)],'linestyle',':','color','r','LineWidth',1.5)
        plot([TP1_ACS(1),TP2_ACS(1)],[TP1_ACS(2),TP2_ACS(2)],'linestyle','-','color','c','LineWidth',1)
        plot([TP1_OCS(1),TP2_OCS(1)],[TP1_OCS(2),TP2_OCS(2)],'linestyle',':','color','m','LineWidth',1.5)
        plot(ACS(1),ACS(2),'y*','LineWidth',1.5)
        plot(OCS(1),OCS(2),'g*','LineWidth',1.5)
        xlim([-150,200]),ylim([-75,420])
        xticks([]),yticks([]);
        title('Posterior-Proximal Offset')
    elseif deltaX == 20 && deltaY == -20 % Anterior-Distal Misalignment Case
        figure(142);
        box on
        plot([ACS(1) Knee(1)],[ACS(2) Knee(2)],'color','k','LineWidth',1)
        hold on
        plot([ACS(1),FT(1)],[ACS(2),FT(2)],'color','k','LineWidth',1)
        plot([ACS(1),FE(1)],[ACS(2),FE(2)],'color','k','LineWidth',1)
        plot([FT(1),FE(1)],[FT(2),FE(2)],'color','k','LineWidth',1)
        plot([ACS(1),Knee_ACS(1)],[ACS(2),Knee_ACS(2)],'linestyle','--','color','k','LineWidth',1)
        plot([SP0_OCS(1),SP1_ACS(1)],[SP0_OCS(2),SP1_ACS(2)],'linestyle','-','color','b','LineWidth',1)
        plot([SP0_OCS(1),SP1_OCS(1)],[SP0_OCS(2),SP1_OCS(2)],'linestyle',':','color','r','LineWidth',1.5)
        plot([TP1_ACS(1),TP2_ACS(1)],[TP1_ACS(2),TP2_ACS(2)],'linestyle','-','color','c','LineWidth',1)
        plot([TP1_OCS(1),TP2_OCS(1)],[TP1_OCS(2),TP2_OCS(2)],'linestyle',':','color','m','LineWidth',1.5)
        plot(ACS(1),ACS(2),'y*','LineWidth',1.5)
        plot(OCS(1),OCS(2),'g*','LineWidth',1.5)
        xlim([-150,200]),ylim([-75,420])
        xticks([]),yticks([]);
        title('Anterior-Distal Offset')
    else
        % Plot Nothing
    end
end
