function [SD1,SD2,SD3,SD4] = statisticalAnalysis_4cases(LLD1,LLD2,LLD3,LLD4,RLD1,RLD2,RLD3,RLD4)

    SD1 = statsAnal(LLD1,RLD1);
    SD2 = statsAnal(LLD2,RLD2);
    SD3 = statsAnal(LLD3,RLD3);
    SD4 = statsAnal(LLD4,RLD4);

    function SD = statsAnal(LLD,RLD)

        AP_SP_L = cell2mat(LLD(3,1));
        PD_SP_L = cell2mat(LLD(3,2));
        AP_SP_R = cell2mat(RLD(3,1));
        PD_SP_R = cell2mat(RLD(3,2));
        AP_TP_L = cell2mat(LLD(4,1));
        PD_TP_L = cell2mat(LLD(4,2));
        AP_TP_R = cell2mat(RLD(4,1));
        PD_TP_R = cell2mat(RLD(4,2));
        AP_FP_L = cell2mat(LLD(6,1));
        PD_FP_L = cell2mat(LLD(6,2));
        AP_FP_R = cell2mat(RLD(6,1));
        PD_FP_R = cell2mat(RLD(6,2));

        SD = {[mean(AP_SP_L(1,:)),std(AP_SP_L(1,:))],[mean(PD_SP_L(1,:)),std(PD_SP_L(1,:))],...
            [mean(AP_SP_R(1,:)),std(AP_SP_R(1,:))],[mean(PD_SP_R(1,:)),std(PD_SP_R(1,:))],...
            [mean(AP_TP_L(1,:)),std(AP_TP_L(1,:))],[mean(PD_TP_L(1,:)),std(PD_TP_L(1,:))],...
            [mean(AP_TP_R(1,:)),std(AP_TP_R(1,:))],[mean(PD_TP_R(1,:)),std(PD_TP_R(1,:))],...
            [mean(AP_FP_L(1,:)),std(AP_FP_L(1,:))],[mean(PD_FP_L(1,:)),std(PD_FP_L(1,:))],...
            [mean(AP_FP_R(1,:)),std(AP_FP_R(1,:))],[mean(PD_FP_R(1,:)),std(PD_FP_R(1,:))];
            [mean(AP_SP_L(3,:)),std(AP_SP_L(3,:))],[mean(PD_SP_L(3,:)),std(PD_SP_L(3,:))],...
            [mean(AP_SP_R(3,:)),std(AP_SP_R(3,:))],[mean(PD_SP_R(3,:)),std(PD_SP_R(3,:))],...
            [mean(AP_TP_L(3,:)),std(AP_TP_L(3,:))],[mean(PD_TP_L(3,:)),std(PD_TP_L(3,:))],...
            [mean(AP_TP_R(3,:)),std(AP_TP_R(3,:))],[mean(PD_TP_R(3,:)),std(PD_TP_R(3,:))],...
            [mean(AP_FP_L(3,:)),std(AP_FP_L(3,:))],[mean(PD_FP_L(3,:)),std(PD_FP_L(3,:))],...
            [mean(AP_FP_R(3,:)),std(AP_FP_R(3,:))],[mean(PD_FP_R(3,:)),std(PD_FP_R(3,:))]};
    end
end