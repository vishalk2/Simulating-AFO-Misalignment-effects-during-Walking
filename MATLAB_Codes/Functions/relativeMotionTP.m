function [AP,PD] = relativeMotionTP(P1_ACS,P2_ACS,P1_OCS,P2_OCS,theta)
    % Function for A-P & P-D Relative Motions for Touch Points
    
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
            AP = ap;
        elseif I1<I2
            AP = -ap;
        else
            AP = ap;
        end
    elseif theta>0
        if I1<I2
            AP = ap;
        elseif I1>I2
            AP = -ap;
        else
            AP = ap;
        end
    else
        PD = 0;
        AP = 0;
    end
end