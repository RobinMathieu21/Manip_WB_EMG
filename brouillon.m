

plot(signal_mvt_lent_R_trans(:,2));hold on;
plot(signal_mvt_lent_R);hold on;
plot(signal_mvt_lent_R_trans_rot(:,2));hold on;
plot(emg_phasique_combined_R);
legend('trans','mvt_lent','tran rot','PHASIC')

plot(signal_mvt_lent_B_trans(:,2));hold on;
plot(signal_mvt_lent_B);hold on;
plot(signal_mvt_lent_B_trans_rot(:,2));hold on; 
plot(emg_phasique_combined_B);
legend('trans','mvt_lent','tran rot','PHASIC')



plot(RMS_B_norm2);hold on;plot(signal_mvt_lent_B_trans_rot(:,2))




i = 1 ;% 4 pour vers le bas et 1 pour vers le haut

plot(Donnees_EMG.Phasic.TonicLent.DA.ProfilMoyen(:,i));hold on;
plot(Donnees_EMG.Phasic.Classique.DA.ProfilMoyen(:,i));hold on;
plot(Donnees_EMG.Phasic.Combined.DA.ProfilMoyen(:,i)); 
legend('Lent','Classique','Combined')

j = 4;
plot(Donnees_EMG.Phasic.TonicLent.DP.ProfilMoyen(:,j));hold on;
plot(Donnees_EMG.Phasic.Classique.DP.ProfilMoyen(:,j));hold on;
plot(Donnees_EMG.Phasic.Combined.DP.ProfilMoyen(:,j)); 
legend('Lent','Classique','Combined')

i=6;
RMS = Donnees_EMG(i).RMSCut;
RMS_R_norm2 = Donnees_EMG(i).RMSCutNormProfilMoyen.Se_lever;
RMS_B_norm2 = Donnees_EMG(i).RMSCutNormProfilMoyen.Se_rassoir;
tonic_debut = Donnees_EMG(i).Tonic_start;
tonic_fin = Donnees_EMG(i).Tonic_end;
signal_mvt_lent_R_complet = Donnees_EMG_TL(i).RMSCutNormProfilMoyen.Se_lever;
signal_mvt_lent_B_complet = Donnees_EMG_TL(i).RMSCutNormProfilMoyen.Se_rassoir;
Phasic_lent =Donnees_EMG(i).Phasic.TonicLent;


for f=1:1000
    emg_phasique_combined_R_moy(f,1) = mean(emg_phasique_combined_R(f,1:6));
    emg_phasique_combined_B_moy(f,1) = mean(emg_phasique_combined_B(f,1:6));
end












