function [KNEE_ACS,FHEE_ACS,FMT5_ACS] = limbMovements(theta_shank,theta_foot,KNEE,FHEE,FMT5)
    % Function for determining limb segments about ACS
    KNEE_ACS = aboutACS(KNEE,theta_shank);
    FHEE_ACS = aboutACS(FHEE,theta_foot);
    FMT5_ACS = aboutACS(FMT5,theta_foot);
end