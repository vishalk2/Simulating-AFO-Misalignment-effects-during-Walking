function P_ACS = aboutACS(P,theta)
    % Function for computing coordinates of points about ACS

    % Rotation Matrix
    R = [cosd(theta) -sind(theta) 0;
        sind(theta) cosd(theta) 0;
        0 0 1];
    % Point "P" rotated about ACS
    P_ACS = R*P;
end