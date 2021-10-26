% Ankle Foot Orthosis
clc;
clear;
close all;

% All Lengths & Distances have units in "mm".
% All Angles have units in "Degrees".
% Theta in CCW direction is considered +ve and in CW direction is -ve.
% Conventions: {Anterior(->) : +ve, Posterior(<-) : -ve, Proximal(^) : +ve, Distal(v) : -ve}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Inputs

% Limb Points (Coordinates : [x y z]': 3x1)
ACS = [0 0 1]'; % Origin
FE = [-61.32 -63.57 1]'; % Foot End
FT = [186.44 -63.57 1]'; % Foot Tip
Knee_Height = 400.98; % Knee Height

% Orthosis Points (Coordinates : [x y z])
TP1 = [-31.2 183.9 1]'; % Touch Point-1
TP2 = [-31.2 267.7 1]'; % Touch Point-2
SP0 = [0 233.5 1]'; % Strap Point-0
SP1 = [41.2 233.5 1]'; % Strap Point-1

% Graphical Input for Limb Motion
ipd1 = msgbox({'- Given figure consists of an arc that depicts a constrained Knee movement from -20 to 20 degrees range.' ...
    '','- Click on/in the arc range to select a certain angle on which further analysis is based.' ...
    '',['- If clicked out of range, the input auto-corrects itself in its length and in its angle to either -20 or 20 degrees ' ...
    'accordingly.']},'Input-1','warn');
plot([ACS(1),FE(1)],[ACS(2),FE(2)],'k-')
hold on;
plot([ACS(1),FT(1)],[ACS(2),FT(2)],'k-')
plot(ACS(1),ACS(2),'go','MarkerSize',5)
plot([FT(1),FE(1)],[FT(2),FE(2)],'k-')
xticks([]),yticks([])
Limb_arc = arc(0,0,Knee_Height,pi/9); % Ankle Dorsiflexion Range
xlim([-200,200]),ylim([-75,450])
[X,Y] = ginput(1); % Input for Knee Points
Knee = knee(Knee_Height,X,Y);
plot(Knee(1),Knee(2),'ko','MarkerSize',5)
plot([ACS(1),Knee(1)],[ACS(2),Knee(2)],'k-')
ACS_circle = arc(0,0,20,2*pi); % OCS Misalignment Range
xlim([-200,200]),ylim([-75,450])
xticks([]),yticks([])

% Graphical Input for Misalignment
ipd2 = msgbox({'- Given circle in red is a constrained selection range for Orthotic Coordinate System (OCS) center.' ...
    '','- Click a point on/in the circle to select OCS center accordingly.' ...
    '',['- If clicked out of range, the input auto-corrects itself & selects the outermost point on the circle ' ...
    'at the same angle of clicked input.']},'Input-2','warn');
[X,Y] = ginput(1); % Takes input of OCS
[deltaX,deltaY] = ocsPoints(X,Y);
plot(deltaX,deltaY,'bo','MarkerSize',5)
legend('Limb','','ACS','','','Knee Joint','','','OCS','Location','bestoutside')
OCS = [deltaX deltaY 1]'; % Orthosis Center
theta = atand(Knee(1)/Knee(2)); % Dorsiflexion Angle
hold off;

% Motion Type & Misalignment Type
[Limb_Motion,Misalignment_Type] = motion(theta,deltaX,deltaY);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Computation

%%% 1.Coordinates of Points about ACS
% Here "theta" is taken "-ve" as a clock-wise movement is seen in this case
SP0_ACS = aboutACS(SP0,-theta);
SP1_ACS = aboutACS(SP1,-theta);
TP1_ACS = aboutACS(TP1,-theta);
TP2_ACS = aboutACS(TP2,-theta);
Knee_ACS = Knee;

%%% 2.Coordinates of Points about OCS
% Here "theta" is taken "-ve" as a clock-wise movement is seen in this case
SP0_OCS = aboutOCS(SP0,-theta,deltaX,deltaY);
SP1_OCS = aboutOCS(SP1,-theta,deltaX,deltaY);
TP1_OCS = aboutOCS(TP1,-theta,deltaX,deltaY);
TP2_OCS = aboutOCS(TP2,-theta,deltaX,deltaY);

%%% 3.Line Parameters
% Line parameters of SPs about ACS
[Distance_SP_ACS,Slope_SP_ACS,Intercept_SP_ACS] = lineParameters(SP0_OCS,SP1_ACS);
% Line parameters of SPs about OCS
[Distance_SP_OCS,Slope_SP_OCS,Intercept_SP_OCS] = lineParameters(SP0_OCS,SP1_OCS);
% Line parameters of TPs about ACS
[Distance_TP_ACS,Slope_TP_ACS,Intercept_TP_ACS] = lineParameters(TP1_ACS,TP2_ACS);
% Line parameters of TPs about OCS
[Distance_TP_OCS,Slope_TP_OCS,Intercept_TP_OCS] = lineParameters(TP1_OCS,TP2_OCS);

%-------------------------------------------------------------------------%

%%%%% Results

% 1.1 Direction of Calf Band Travel w.r.t Direction of Ankle Motion
Calf_Band_Travel = strapMovement(Distance_SP_ACS,Distance_SP_OCS,Slope_SP_ACS,Slope_SP_OCS);

% 1.2 Anterior-Posterior & Proximal-Distal Relative Motions (in mm)
[AP_SP,PD_SP] = relativeMotionSP(SP0_OCS,SP1_ACS,SP1_OCS,Distance_SP_ACS,Distance_SP_OCS,Slope_SP_ACS,Slope_SP_OCS);

% 1.3 Strap Points movement illustration plot
illustrationPlotSP(SP0_OCS,SP1_ACS,SP1_OCS,[-150,150],[150,300],'Strap');

% 1.4 Resulant Pressure On Leg
Res_Pressure_Leg = pressurePointLeg(theta,Intercept_TP_ACS,Intercept_TP_OCS);

% 1.5 Anterior-Posterior & Proximal-Distal Relative Motions (in mm)
[AP_TP,PD_TP] = relativeMotionTP(TP1_ACS,TP2_ACS,TP2_OCS,theta,Intercept_TP_ACS,Intercept_TP_OCS);

% 1.6 Touch Points movement illustration plot
illustrationPlotP(TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS,[-150,150],[100,300],'Touch');

%-------------------------------------------------------------------------%

%%%%% Simulation Model
figure;
plot([ACS(1),FE(1)],[ACS(2),FE(2)],'k-','LineWidth',1)
hold on;
plot([ACS(1),FT(1)],[ACS(2),FT(2)],'k-','LineWidth',1)
plot([ACS(1),Knee_ACS(1)],[ACS(2),Knee_ACS(2)],'k-','LineWidth',1)
plot([FT(1),FE(1)],[FT(2),FE(2)],'k-','LineWidth',1)
plot([SP0_OCS(1),SP1_ACS(1)],[SP0_OCS(2),SP1_ACS(2)],'b:','LineWidth',2)
plot([SP0_OCS(1),SP1_OCS(1)],[SP0_OCS(2),SP1_OCS(2)],'r-','LineWidth',1)
plot([TP1_ACS(1),TP2_ACS(1)],[TP1_ACS(2),TP2_ACS(2)],'m:','LineWidth',2)
plot([TP1_OCS(1),TP2_OCS(1)],[TP1_OCS(2),TP2_OCS(2)],'c-','LineWidth',1)
plot(ACS(1),ACS(2),'yo','LineWidth',1.5)
plot(OCS(1),OCS(2),'go','LineWidth',1.5)
title('Simulation Model-1')
xlim([-150,200]),ylim([-75,420])
xticks([]),yticks([]);
legend('Limb','','','','SP-ACS','SP-OCS','TP-ACS','TP-OCS','ACS','OCS',"Location","best")
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Outputs
disp(['Misalignment Type : ',Misalignment_Type])
disp(['Limb Motion : ',Limb_Motion])
disp(['A-P relative motion of SPs : ',num2str(AP_SP),' mm.'])
disp(['P-D relative motion of SPs : ',num2str(PD_SP),' mm.'])
disp(['Calf Band Travel : ',Calf_Band_Travel])
disp(['A-P relative motion of TPs : ',num2str(AP_TP),' mm.'])
disp(['P-D relative motion of TPs : ',num2str(PD_TP),' mm.'])
disp(['Resultant Pressure Point on Leg : ',Res_Pressure_Leg])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------------------------------------------------------%
%                          DEFINED FUNCTIONS                              %
%-------------------------------------------------------------------------%

% Function for determining Motion & Misalignment Type
function [Limb_Motion,Misalignment_Type] = motion(theta,deltaX,deltaY)
    % Limb Motion with reference to Ankle Dorsiflexion angle
    if theta<0
        Limb_Motion = 'Plantar flexion';
    elseif theta>0
        Limb_Motion = 'Dorsiflexion';
    else
        Limb_Motion = 'Neutral';
    end
    
    % Misalignment type with reference to deltaX
    if deltaX>0
        X_Misalignment = 'Anterior';
    elseif deltaX<0
        X_Misalignment = 'Posterior';
    else
        X_Misalignment = '';
    end
    
    % Misalignment type with reference to deltaY
    if deltaY>0
        Y_Misalignment = 'Proximal';
    elseif deltaY<0
        Y_Misalignment = 'Distal';
    else
        Y_Misalignment = '';
    end
    
    % Misalignment type with reference to deltaX & deltaY
    if strlength(X_Misalignment)==0 && strlength(Y_Misalignment)==0
        Misalignment_Type = 'None';
    else
        Misalignment_Type = [X_Misalignment,' ',Y_Misalignment];
    end
end

%-------------------------------------------------------------------------%

% Arc / Circle
function Arc = arc(x,y,r,theta)
    hold on;
    th = -theta+(pi/2):pi/50:theta+(pi/2);
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    Arc = plot(xunit, yunit,'r-','MarkerSize',2);
end

%-------------------------------------------------------------------------%

% Defining Knee Points
function KneePoints = knee(Knee_Height,X,Y)
    R = Knee_Height;
    th = atand(X/Y);
    if X>=-R*sind(20) && X<=R*sind(20)
        if th<-20
            KneePoints = [R*sind(-20) R*cosd(-20) 1]';
        elseif th>20
            KneePoints = [R*sind(20) R*cosd(20) 1]';
        else
            KneePoints = [R*sind(th) R*cosd(th) 1]';
        end
    elseif X<-R*sind(20)
        KneePoints = [R*sind(-20) R*cosd(-20) 1]';
    elseif X>R*sind(20)
        KneePoints = [R*sind(20) R*cosd(20) 1]';
    end
end

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

% Function for determining line parameters
function [D,S,I] = lineParameters(P1,P2)
    D = sqrt((P1(1)-P2(1))^2 + (P1(2)-P2(2))^2 + (P1(3)-P2(3))^2); % Distance
    S = (P2(2)-P1(2))/(P2(1)-P1(1)); % Slope
    I = P1(2)-S*P1(1); % Intercept
end

%-------------------------------------------------------------------------%

% Function for determining Strap Movement
function SM = strapMovement(D1,D2,S1,S2)
    % Horizontal Separation
    if D1<D2
        SM_H = 'Anterior';
    elseif D1>D2
        SM_H = 'Posterior';
    else
        SM_H = '';
    end
    % Vertical Separation
    if S1>S2
        SM_V = 'Distal';
    elseif S1<S2
        SM_V = 'Proximal';
    else
        SM_V = '';
    end
    SM = [SM_H,' ',SM_V];
end

%-------------------------------------------------------------------------%

% Function for A-P & P-D Relative Motions for Strap & Foot Strap Points
function [AP,PD] = relativeMotionSP(P0_OCS,P1_ACS,P1_OCS,D1,D2,S1,S2)
    MSP = P1_ACS; % Moving Strap Point
    length_P1s = sqrt((P1_ACS(1)-P1_OCS(1))^2+(P1_ACS(2)-P1_OCS(2))^2);
    A = P0_OCS(2)-P1_OCS(2);
    B = P1_OCS(1)-P0_OCS(1);
    C = P0_OCS(1)*P1_OCS(2)-P1_OCS(1)*P0_OCS(2);
    pd = abs((A*MSP(1)+B*MSP(2)+C)/sqrt(A^2 + B^2));
    ap = sqrt(length_P1s^2 - pd^2);
    % Sign convention for Relative Motions
    % Horizontal Separation
    if D1<=D2
        AP = ap;
    elseif D1>D2
        AP = -ap;
    end
    % Vertical Separation
    if S1>S2
        PD = -pd;
    elseif S1<=S2
        PD = pd;
    end
end

%-------------------------------------------------------------------------%

% Function for A-P & P-D Relative Motions for Touch Points
function [AP,PD] = relativeMotionTP(P1_ACS,P2_ACS,P2_OCS,theta,I1,I2)
    P = P2_OCS;
    length_P2s = sqrt((P2_ACS(1)-P2_OCS(1))^2+(P2_ACS(2)-P2_OCS(2))^2);
    A = P1_ACS(2)-P2_ACS(2);
    B = P2_ACS(1)-P1_ACS(1);
    C = P1_ACS(1)*P2_ACS(2)-P2_ACS(1)*P1_ACS(2);
    ap = abs((A*P(1)+B*P(2)+C)/sqrt(A^2 + B^2));
    pd = sqrt(length_P2s^2 - ap^2);
    % Sign convention for Relative Motions
    % Vertical Separation
    if P2_ACS(2)>P2_OCS(2)
        PD = -pd;
    elseif P2_ACS(2)<=P2_OCS(2)
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

% Function for illustration plots of Strap & Foot-strap points
function illustrationPlotSP(P0_OCS,P1_ACS,P1_OCS,XLim,YLim,points)

    figure;
    plot([P0_OCS(1),P1_ACS(1)],[P0_OCS(2),P1_ACS(2)],'b:','LineWidth',2)
    hold on;
    plot([P0_OCS(1),P1_OCS(1)],[P0_OCS(2),P1_OCS(2)],'r-','LineWidth',1)
    xlim(XLim),ylim(YLim)
    title(['Movement of ',points,' points'])
    grid on;
    legend('About Limb','About Orthosis',"Location","best")
    hold off;

end

%-------------------------------------------------------------------------%

% Function for illustration plots of Foot & Touch points
function illustrationPlotP(P1_ACS,P2_ACS,P1_OCS,P2_OCS,XLim,YLim,points)

    figure;
    plot([P1_ACS(1),P2_ACS(1)],[P1_ACS(2),P2_ACS(2)],'b:','LineWidth',2)
    hold on;
    plot([P1_OCS(1),P2_OCS(1)],[P1_OCS(2),P2_OCS(2)],'r-','LineWidth',1)
    xlim(XLim),ylim(YLim)
    title(['Movement of ',points,' points'])
    grid on;
    legend('About Limb','About Orthosis',"Location","best")
    hold off;

end

%-------------------------------------------------------------------------%

% Resultant Pressure Point on Leg
function Res_Pressure = pressurePointLeg(theta,I1,I2)
    if theta<0
        if I1>I2
            Res_Pressure = 'Anterior';
        elseif I1<I2
            Res_Pressure = 'Posterior';
        else
            Res_Pressure = 'None';
        end
    elseif theta>0
        if I1<I2
            Res_Pressure = 'Anterior';
        elseif I1>I2
            Res_Pressure = 'Posterior';
        else
            Res_Pressure = 'None';
        end
    else
        Res_Pressure = 'None';
    end
end

%-------------------------------------------------------------------------%

% OCS Points
function [deltaX,deltaY] = ocsPoints(X,Y)
    R = 20; % Radius of OCS Circle
    R_ = sqrt(X^2 + Y^2);
    th = abs(atand(Y/X));
    if R_<=R
        deltaX = X;
        deltaY = Y;
    elseif R_>R
        if X>=0 && Y>=0
            deltaX = R*cosd(th);
            deltaY = R*sind(th);
        elseif X>=0 && Y<=0
            deltaX = R*cosd(th);
            deltaY = -R*sind(th);
        elseif X<=0 && Y<=0
            deltaX = -R*cosd(th);
            deltaY = -R*sind(th);
        elseif X<=0 && Y>=0
            deltaX = -R*cosd(th);
            deltaY = R*sind(th);
        end
    end
end