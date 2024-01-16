clear all;

R2 = Donnees_to_export;
clearvars -except BraD BraG Assis R1 R2
%%%%%%%%%%%%%%%%%%%%%%%
%         BRAS
%%%%%%%%%%%%%%%%%%%%%%%
%% BRAS TEMPS CUMULE D'INACTIVATION
% Lever
BRAS_T_Lever(1,:) = BraG.Tps_cum_inac_Lever(1:1,:);   % On ne prend que le bras droit
BRAS_T_Lever(2,:) = BraD.Tps_cum_inac_Lever(1:1,:);
M_BRAS.T_Lever(1,:) = BRAS_T_Lever(2,:)./max(abs(BRAS_T_Lever(2,:))); % On ne prend que le bras droit
   
% Baisser
BRAS_T_Baisser(1,:) = BraG.Tps_cum_inac_Baisser(1:1,:);
BRAS_T_Baisser(2,:) = BraD.Tps_cum_inac_Baisser(1:1,:);
M_BRAS.T_Baisser(1,:) = BRAS_T_Baisser(2,:)./max(abs(BRAS_T_Baisser(2,:))); % On ne prend que le bras droit


%% BRAS TEMPS AMPLITUDE 
% Lever
BRAS_A_Lever(1,:) = BraG.AmpLever(1:1,:);  % On ne prend que le DA
BRAS_A_Lever(2,:) = BraD.AmpLever(1:1,:);  
M_BRAS.A_Lever = BRAS_A_Lever(2,:)./max(abs(BRAS_A_Lever(2,:))); % On ne prend que le bras droit

% Baisser
BRAS_A_Baisser(1,:) = BraG.AmpBaisser(1:1,:);
BRAS_A_Baisser(2,:) = BraD.AmpBaisser(1:1,:);
M_BRAS.A_Baisser = BRAS_A_Baisser(2,:)./max(abs(BRAS_A_Baisser(2,:))); % On ne prend que le bras droit


%% BRAS TEMPS FREQ 
% Lever
BRAS_F_Lever(1,:) = BraG.FreqLever(1:1,:);  % On ne prend que le bras droit
BRAS_F_Lever(2,:) = BraD.FreqLever(1:1,:);
M_BRAS.F_Lever = BRAS_F_Lever(2,:)./max(abs(BRAS_F_Lever(2,:))); % On ne prend que le bras droit

% Baisser
BRAS_F_Baisser(1,:) = BraG.FreqBaisser(1:1,:);
BRAS_F_Baisser(2,:) = BraD.FreqBaisser(1:1,:);
M_BRAS.F_Baisser = BRAS_F_Baisser(2,:)./max(abs(BRAS_F_Baisser(2,:))); % On ne prend que le bras droit





%%%%%%%%%%%%%%%%%%%%%%%
%          WB
%%%%%%%%%%%%%%%%%%%%%%%
%% Whole body TEMPS CUMULE D'INACTIVATION
%Se lever
WB_T_SeLever(1,:)  = mean(Assis.Tps_cum_inac_SeLever([5 7 9],:));
WB_T_SeLever(2,:) = mean(R1.Tps_cum_inac_SeLever([5 7 9],:));
WB_T_SeLever(3,:)  = mean(R2.Tps_cum_inac_SeLever([5 7 9],:));
M_WB.T_SeLever(1,:) = WB_T_SeLever(1,:)./max(abs(WB_T_SeLever(1,:))); % On prend les deux côtés

%Se rassoir
WB_T_SeRassoir(1,:)  = mean(Assis.Tps_cum_inac_SeRassoir([5 7 9],:));
WB_T_SeRassoir(2,:) = mean(R1.Tps_cum_inac_SeRassoir([5 7 9],:));
WB_T_SeRassoir(3,:)  = mean(R2.Tps_cum_inac_SeRassoir([5 7 9],:));
M_WB.T_SeRassoir(1,:) = WB_T_SeRassoir(1,:)./max(abs(WB_T_SeRassoir(1,:))); % On prend les deux côtés


%% Whole body AMPLITUDE
%Se lever
WB_A_SeLever(1,:)  = mean(Assis.Amp_SeLever([5 7 9],:));
WB_A_SeLever(2,:) = mean(R1.Amp_SeLever([5 7 9],:));
WB_A_SeLever(3,:)  = mean(R2.Amp_SeLever([5 7 9],:));
M_WB.A_SeLever = WB_A_SeLever(1,:)./max(abs(WB_A_SeLever(1,:))); % On prend les deux côtés

%Se rassoir
WB_A_SeRassoir(1,:)  = mean(Assis.Amp_SeRassoir([5 7 9],:));
WB_A_SeRassoir(2,:) = mean(R1.Amp_SeRassoir([5 7 9],:));
WB_A_SeRassoir(3,:)  = mean(R2.Amp_SeRassoir([5 7 9],:));
M_WB.A_SeRassoir = WB_A_SeRassoir(1,:)./max(abs(WB_A_SeRassoir(1,:))); % On prend les deux côtés


%% Whole body FREQUENCE
%Se lever
WB_F_SeLever(1,:)  = mean(Assis.Freq_SeLever([5 7 9],:));
WB_F_SeLever(2,:) = mean(R1.Freq_SeLever([5 7 9],:));
WB_F_SeLever(3,:)  = mean(R2.Freq_SeLever([5 7 9],:));
M_WB.F_SeLever = WB_F_SeLever(1,:)./max(abs(WB_F_SeLever(1,:))); % On prend les deux côtés

%Se rassoir
WB_F_SeRassoir(1,:)  = mean(Assis.Freq_SeRassoir([5 7 9],:));
WB_F_SeRassoir(2,:) = mean(R1.Freq_SeRassoir([5 7 9],:));
WB_F_SeRassoir(3,:)  = mean(R2.Freq_SeRassoir([5 7 9],:));
M_WB.F_SeRassoir = WB_F_SeRassoir(1,:)./max(abs(WB_F_SeRassoir(1,:))); % On prend les deux côtés





 plot(classementR1(1,:));hold on
  plot(classementR1(2,:));hold on
%   plot(classementR1(3,:));hold on
%   plot(classementR1(4,:));
  legend('R1','R2','Assis','BrasG')

  scatter(classementR1(1,:),classementR1(4,:))

  scatter(VR2,VBrasG)
  R = corrcoef(classementR1(1,:),classementR1(4,:))