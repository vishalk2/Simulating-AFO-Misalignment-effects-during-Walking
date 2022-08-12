function [RMD1,RMD2,RMD3,RMD4] = afoMotionAnalysis_4cases(apmDataset,limbAnglesDataset,timeStamps,index,OCS_Disp,leg,motion)
    % Function for the whole motion analysis of legs with an AFO for 4
    % different cases of misalignment
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%                           Misalignment Cases                        %%%
    %%%   Case-1 : Anterior-Posterior Misalignments                         %%%
    %%%   Case-2 : Proximal-Distal Misalignments                            %%%
    %%%   Case-3 : Posterior Distal - Anterior Proximal Misalignments       %%%
    %%%   Case-4 : Posterior Proximal - Anterior Distal Misalignments       %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    Disp_size = length(OCS_Disp);

    % Computation
    for MCase=1:4
        switch MCase
            case 1 % Case-1 : Anterior-Posterior Misalignments

                Mis_Type = 'Anterior-Posterior Misalignments';
                SP_res_AP = zeros(Disp_size,cellArray_size);
                SP_res_PD = zeros(Disp_size,cellArray_size);
                TP_res_AP = zeros(Disp_size,cellArray_size);
                TP_res_PD = zeros(Disp_size,cellArray_size);
                FSP_res_AP = zeros(Disp_size,cellArray_size);
                FSP_res_PD = zeros(Disp_size,cellArray_size);
                FP_res_AP = zeros(Disp_size,cellArray_size);
                FP_res_PD = zeros(Disp_size,cellArray_size);

                for d=1:Disp_size
                    deltaX = OCS_Disp(d);
                    deltaY = 0;

                    AP_SP = zeros(1,cellArray_size);
                    PD_SP = zeros(1,cellArray_size);
                    AP_TP = zeros(1,cellArray_size);
                    PD_TP = zeros(1,cellArray_size);
                    AP_FSP = zeros(1,cellArray_size);
                    PD_FSP = zeros(1,cellArray_size);
                    AP_FP = zeros(1,cellArray_size);
                    PD_FP = zeros(1,cellArray_size);

                    % Shank and Foot Angles
                    if strcmp(leg,'Left')
                        shank_angles = cell2mat(limbAnglesDataset(:,1));
                        foot_angles = cell2mat(limbAnglesDataset(:,2));
                    elseif strcmp(leg,'Right')
                        shank_angles = cell2mat(limbAnglesDataset(:,3));
                        foot_angles = cell2mat(limbAnglesDataset(:,4));
                    end
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
                    SP_res_AP(d,:) = AP_SP;
                    SP_res_PD(d,:) = PD_SP;
                    TP_res_AP(d,:) = AP_TP;
                    TP_res_PD(d,:) = PD_TP;
                    FSP_res_AP(d,:) = AP_FSP;
                    FSP_res_PD(d,:) = PD_FSP;
                    FP_res_AP(d,:) = AP_FP;
                    FP_res_PD(d,:) = PD_FP;                    
                end
                RMD1 = {leg,timeStamps;MCase,Mis_Type;
                    SP_res_AP,SP_res_PD;TP_res_AP,TP_res_PD;
                    FSP_res_AP,FSP_res_PD;FP_res_AP,FP_res_PD};

            case 2 % Proximal-Distal Misalignments

                Mis_Type = 'Proximal-Distal Misalignments';
                SP_res_AP = zeros(Disp_size,cellArray_size);
                SP_res_PD = zeros(Disp_size,cellArray_size);
                TP_res_AP = zeros(Disp_size,cellArray_size);
                TP_res_PD = zeros(Disp_size,cellArray_size);
                FSP_res_AP = zeros(Disp_size,cellArray_size);
                FSP_res_PD = zeros(Disp_size,cellArray_size);
                FP_res_AP = zeros(Disp_size,cellArray_size);
                FP_res_PD = zeros(Disp_size,cellArray_size);

                for d=1:Disp_size
                    deltaX = 0;
                    deltaY = OCS_Disp(d);

                    AP_SP = zeros(1,cellArray_size);
                    PD_SP = zeros(1,cellArray_size);
                    AP_TP = zeros(1,cellArray_size);
                    PD_TP = zeros(1,cellArray_size);
                    AP_FSP = zeros(1,cellArray_size);
                    PD_FSP = zeros(1,cellArray_size);
                    AP_FP = zeros(1,cellArray_size);
                    PD_FP = zeros(1,cellArray_size);

                    % Shank and Foot Angles
                    if strcmp(leg,'Left')
                        shank_angles = cell2mat(limbAnglesDataset(:,1));
                        foot_angles = cell2mat(limbAnglesDataset(:,2));
                    elseif strcmp(leg,'Right')
                        shank_angles = cell2mat(limbAnglesDataset(:,3));
                        foot_angles = cell2mat(limbAnglesDataset(:,4));
                    end
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
                    SP_res_AP(d,:) = AP_SP;
                    SP_res_PD(d,:) = PD_SP;
                    TP_res_AP(d,:) = AP_TP;
                    TP_res_PD(d,:) = PD_TP;
                    FSP_res_AP(d,:) = AP_FSP;
                    FSP_res_PD(d,:) = PD_FSP;
                    FP_res_AP(d,:) = AP_FP;
                    FP_res_PD(d,:) = PD_FP;                    
                end
                RMD2 = {leg,timeStamps;MCase,Mis_Type;
                    SP_res_AP,SP_res_PD;TP_res_AP,TP_res_PD;
                    FSP_res_AP,FSP_res_PD;FP_res_AP,FP_res_PD};

            case 3 % Case-3 : Posterior Distal - Anterior Proximal Misalignments

                Mis_Type = 'PosteriorDistal-AnteriorProximal Misalignments';
                SP_res_AP = zeros(Disp_size,cellArray_size);
                SP_res_PD = zeros(Disp_size,cellArray_size);
                TP_res_AP = zeros(Disp_size,cellArray_size);
                TP_res_PD = zeros(Disp_size,cellArray_size);
                FSP_res_AP = zeros(Disp_size,cellArray_size);
                FSP_res_PD = zeros(Disp_size,cellArray_size);
                FP_res_AP = zeros(Disp_size,cellArray_size);
                FP_res_PD = zeros(Disp_size,cellArray_size);

                for d=1:Disp_size
                    deltaX = OCS_Disp(d);
                    deltaY = OCS_Disp(d);

                    AP_SP = zeros(1,cellArray_size);
                    PD_SP = zeros(1,cellArray_size);
                    AP_TP = zeros(1,cellArray_size);
                    PD_TP = zeros(1,cellArray_size);
                    AP_FSP = zeros(1,cellArray_size);
                    PD_FSP = zeros(1,cellArray_size);
                    AP_FP = zeros(1,cellArray_size);
                    PD_FP = zeros(1,cellArray_size);

                    % Shank and Foot Angles
                    if strcmp(leg,'Left')
                        shank_angles = cell2mat(limbAnglesDataset(:,1));
                        foot_angles = cell2mat(limbAnglesDataset(:,2));
                    elseif strcmp(leg,'Right')
                        shank_angles = cell2mat(limbAnglesDataset(:,3));
                        foot_angles = cell2mat(limbAnglesDataset(:,4));
                    end
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
                    SP_res_AP(d,:) = AP_SP;
                    SP_res_PD(d,:) = PD_SP;
                    TP_res_AP(d,:) = AP_TP;
                    TP_res_PD(d,:) = PD_TP;
                    FSP_res_AP(d,:) = AP_FSP;
                    FSP_res_PD(d,:) = PD_FSP;
                    FP_res_AP(d,:) = AP_FP;
                    FP_res_PD(d,:) = PD_FP;                    
                end
                RMD3 = {leg,timeStamps;MCase,Mis_Type;
                    SP_res_AP,SP_res_PD;TP_res_AP,TP_res_PD;
                    FSP_res_AP,FSP_res_PD;FP_res_AP,FP_res_PD};

            otherwise % Case-4 : Posterior Proximal - Anterior Distal Misalignments

                Mis_Type = 'PosteriorProximal-AnteriorDistal Misalignments';
                SP_res_AP = zeros(Disp_size,cellArray_size);
                SP_res_PD = zeros(Disp_size,cellArray_size);
                TP_res_AP = zeros(Disp_size,cellArray_size);
                TP_res_PD = zeros(Disp_size,cellArray_size);
                FSP_res_AP = zeros(Disp_size,cellArray_size);
                FSP_res_PD = zeros(Disp_size,cellArray_size);
                FP_res_AP = zeros(Disp_size,cellArray_size);
                FP_res_PD = zeros(Disp_size,cellArray_size);

                for d=1:Disp_size
                    deltaX = OCS_Disp(d);
                    deltaY = -OCS_Disp(d);

                    AP_SP = zeros(1,cellArray_size);
                    PD_SP = zeros(1,cellArray_size);
                    AP_TP = zeros(1,cellArray_size);
                    PD_TP = zeros(1,cellArray_size);
                    AP_FSP = zeros(1,cellArray_size);
                    PD_FSP = zeros(1,cellArray_size);
                    AP_FP = zeros(1,cellArray_size);
                    PD_FP = zeros(1,cellArray_size);

                    % Shank and Foot Angles
                    if strcmp(leg,'Left')
                        shank_angles = cell2mat(limbAnglesDataset(:,1));
                        foot_angles = cell2mat(limbAnglesDataset(:,2));
                    elseif strcmp(leg,'Right')
                        shank_angles = cell2mat(limbAnglesDataset(:,3));
                        foot_angles = cell2mat(limbAnglesDataset(:,4));
                    end
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
                    SP_res_AP(d,:) = AP_SP;
                    SP_res_PD(d,:) = PD_SP;
                    TP_res_AP(d,:) = AP_TP;
                    TP_res_PD(d,:) = PD_TP;
                    FSP_res_AP(d,:) = AP_FSP;
                    FSP_res_PD(d,:) = PD_FSP;
                    FP_res_AP(d,:) = AP_FP;
                    FP_res_PD(d,:) = PD_FP;                    
                end
                RMD4 = {leg,timeStamps;MCase,Mis_Type;
                    SP_res_AP,SP_res_PD;TP_res_AP,TP_res_PD;
                    FSP_res_AP,FSP_res_PD;FP_res_AP,FP_res_PD};
        end
    end
end