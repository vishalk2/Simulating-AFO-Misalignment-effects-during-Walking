function [AP,PD] = relativeMotionSP(P0_OCS,P1_ACS,P1_OCS)
    % Function for A-P & P-D Relative Motions for Strap & Foot Strap Points
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
        if S1>0 && S2<0
            PD = pd;
        else
            PD = -pd;
        end
    elseif S1<S2
        if S1<0 && S2>0
            PD = -pd;
        else
            PD = pd;
        end
    else
        PD = pd;
    end
end