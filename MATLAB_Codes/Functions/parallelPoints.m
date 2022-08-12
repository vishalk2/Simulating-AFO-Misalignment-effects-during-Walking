function [P1_ACS,P2_ACS,P1_OCS,P2_OCS] = parallelPoints(theta,deltaX,deltaY,P1,P2)
    % Function for determining Touch & Foot Points about ACS & OCS
    P1_ACS = aboutACS(P1,theta);
    P2_ACS = aboutACS(P2,theta);
    P1_OCS = aboutOCS(P1,theta,deltaX,deltaY);
    P2_OCS = aboutOCS(P2,theta,deltaX,deltaY);
end