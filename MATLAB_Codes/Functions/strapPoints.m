function [P0_ACS,P1_ACS,P0_OCS,P1_OCS] = strapPoints(theta,deltaX,deltaY,P0,P1)
    % Function for determining Strap & Foot-Strap Points about ACS & OCS
    P0_ACS = aboutACS(P0,theta);
    P1_ACS = aboutACS(P1,theta);
    P0_OCS = aboutOCS(P0,theta,deltaX,deltaY);
    P1_OCS = aboutOCS(P1,theta,deltaX,deltaY);
end