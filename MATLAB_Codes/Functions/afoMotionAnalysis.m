function relativeMotionData = afoMotionAnalysis(apmDataset,limbAnglesDataset,timeStamps,index,deltaX,deltaY,leg,motion)
    % Function for the whole motion analysis of legs with an AFO

    % Loading Limb & Orthosis Points (Coordinates : [x,y,z])
    if strcmp(leg,'Left')
        ACS = cell2mat(apmDataset(1,2:4))';
        FHEE = cell2mat(apmDataset(2,2:4))';
        FMT5 = cell2mat(apmDataset(3,2:4))';
        KNEE = cell2mat(apmDataset(4,2:4))';
        SP0 = cell2mat(apmDataset(5,2:4))';
        SP1 = cell2mat(apmDataset(6,2:4))';
        TP1 = cell2mat(apmDataset(7,2:4))';
        TP2 = cell2mat(apmDataset(8,2:4))';
        FSP0 = cell2mat(apmDataset(9,2:4))';
        FSP1 = cell2mat(apmDataset(10,2:4))';
        FP1 = cell2mat(apmDataset(11,2:4))';
        FP2 = cell2mat(apmDataset(12,2:4))';
    elseif strcmp(leg,'Right')
        ACS = cell2mat(apmDataset(1,5:7))';
        FHEE = cell2mat(apmDataset(2,5:7))';
        FMT5 = cell2mat(apmDataset(3,5:7))';
        KNEE = cell2mat(apmDataset(4,5:7))';
        SP0 = cell2mat(apmDataset(5,5:7))';
        SP1 = cell2mat(apmDataset(6,5:7))';
        TP1 = cell2mat(apmDataset(7,5:7))';
        TP2 = cell2mat(apmDataset(8,5:7))';
        FSP0 = cell2mat(apmDataset(9,5:7))';
        FSP1 = cell2mat(apmDataset(10,5:7))';
        FP1 = cell2mat(apmDataset(11,5:7))';
        FP2 = cell2mat(apmDataset(12,5:7))';
    end

    % Getting respective motion's data range and adjusting the dataset
    data_range = getDataRange(motion,index,leg);
    data_range = strsplit(data_range,':');
    dr1 = cell2mat(data_range(1));
    dr2 = cell2mat(data_range(2));
    limbAnglesDataset = limbAnglesDataset(str2double(dr1(3:end))-1:str2double(dr2(3:end))-1,:);
    timeStamps = cell2mat(timeStamps(str2double(dr1(3:end))-1:str2double(dr2(3:end))-1,:))';
    cellArray_size = length(limbAnglesDataset);

    % Loding storage arrays for A-P & P-D relative motion calculations
    AP_SP = zeros(1,cellArray_size); % Anterior-Posterior Relative Motion for Strap Points for each angle
    PD_SP = zeros(1,cellArray_size); % Proximal-Distal Relative Motion for Strap Points for each angle
    AP_TP = zeros(1,cellArray_size); % Anterior-Posterior Relative Motion for Touch Points for each angle
    PD_TP = zeros(1,cellArray_size); % Proximal-Distal Relative Motion for Touch Points for each angle
    AP_FSP = zeros(1,cellArray_size);% Anterior-Posterior Relative Motion for Foot Strap Points for each angle
    PD_FSP = zeros(1,cellArray_size);% Proximal-Distal Relative Motion for Foot Strap Points for each angle
    AP_FP = zeros(1,cellArray_size); % Anterior-Posterior Relative Motion for Foot Points for each angle
    PD_FP = zeros(1,cellArray_size); % Proximal-Distal Relative Motion for Foot Points for each angle    

    % Shank and Foot Angles
    if strcmp(leg,'Left')
        shank_angles = cell2mat(limbAnglesDataset(:,1));
        foot_angles = cell2mat(limbAnglesDataset(:,2));
    elseif strcmp(leg,'Right')
        shank_angles = cell2mat(limbAnglesDataset(:,3));
        foot_angles = cell2mat(limbAnglesDataset(:,4));
    end

    % Computation
    t0 = timeStamps(1);
    for th=1:cellArray_size

        theta_shank = shank_angles(th);
        theta_foot = foot_angles(th);

        [KNEE_ACS,FHEE_ACS,FMT5_ACS] = limbMovements(theta_shank,theta_foot,KNEE,FHEE,FMT5); % Limb segments
        [SP0_ACS,SP1_ACS,SP0_OCS,SP1_OCS] = strapPoints(theta_shank,deltaX,deltaY,SP0,SP1); % Strap Points
        [TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS] = parallelPoints(theta_shank,deltaX,deltaY,TP1,TP2); % Touch Points
        [FSP0_ACS,FSP1_ACS,FSP0_OCS,FSP1_OCS] = strapPoints(theta_foot,deltaX,deltaY,FSP0,FSP1); % Foot Strap Points
        [FP1_ACS,FP2_ACS,FP1_OCS,FP2_OCS] = parallelPoints(theta_foot,deltaX,deltaY,FP1,FP2); % Foot Points        

        [AP_SP(th),PD_SP(th)] = relativeMotionSP(SP0_OCS,SP1_ACS,SP1_OCS); % Relative Motion for SP
        [AP_TP(th),PD_TP(th)] = relativeMotionTP(TP1_ACS,TP2_ACS,TP1_OCS,TP2_OCS,theta_shank); % Relative Motion for TP
        [AP_FSP(th),PD_FSP(th)] = relativeMotionSP(FSP0_OCS,FSP1_ACS,FSP1_OCS); % Relative Motion for FSP
        [AP_FP(th),PD_FP(th)] = relativeMotionFP(FP1_ACS,FP2_ACS,FP1_OCS,FP2_OCS); % Relative Motion for FP        

        timeStamps(th) = timeStamps(th)-t0;
    end
    relativeMotionData = {leg,timeStamps;AP_SP,PD_SP;AP_TP,PD_TP;AP_FSP,PD_FSP;AP_FP,PD_FP};
end