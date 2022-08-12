function P_OCS = aboutOCS(P,theta,deltaX,deltaY)
    % Function for computing coordinates of points about OCS

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