function [AP,PD] = relativeMotionFP(P1_ACS,P2_ACS,P1_OCS,P2_OCS)
    % Function for A-P & P-D Relative Motions for Foot Points
    
    % Calculating Distances
    P = P2_OCS;
    length_P2s = sqrt((P2_ACS(1)-P2_OCS(1))^2+(P2_ACS(2)-P2_OCS(2))^2);
    A = P1_ACS(2)-P2_ACS(2);
    B = P2_ACS(1)-P1_ACS(1);
    C = P1_ACS(1)*P2_ACS(2)-P2_ACS(1)*P1_ACS(2);
    pd = abs((A*P(1)+B*P(2)+C)/sqrt(A^2 + B^2));
    ap = sqrt(length_P2s^2 - pd^2);

    % Calculating line parameters
    S1 = effectiveSlope(P1_ACS,P2_ACS);
    S2 = effectiveSlope(P1_OCS,P2_OCS);
    I1 = effectiveIntercept(P1_ACS,S1);
    I2 = effectiveIntercept(P1_OCS,S2);

    % Setting signs for relative motion based on line parameters
    % Vertical Separation
    if I1>I2
        PD = -pd;
    elseif I1<I2
        PD = pd;
    else
        PD = pd;
    end
    % Horizontal Separation
    % Intercepts of perpendicular lines
    IP1 = P1_ACS(2) + (P1_ACS(1)/S1);
    IP2 = P1_OCS(2) + (P1_OCS(1)/S2);
    % Points on x-axis where the perpendicular lines intersect x-axis
    X1 = S1*IP1;
    X2 = S2*IP2;
    if X1>X2
        AP = -ap;
    elseif X1<X2
        AP = ap;
    else
        AP = ap;
    end
end