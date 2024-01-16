
%% Script pour Manip EMGravity
% A executer dans un dossier de 30 essais contenant aussi le dossier de
% data sequence. Le script sort une matrice contenant les données
% cinématiques, essai par essai et triés en fonction de la cible. 

close all
clear all

%% Informations sur le traitement des données
poids_sujet = 53 
lgbras_sujet = 0.53 
gvalue = 9.81;
masse_bras = 0.05*poids_sujet;
dist_cdr_cdm = 0.53*lgbras_sujet;
moment_inertie_bras = (0.028*poids_sujet*(0.436*lgbras_sujet)^2)+(0.022*poids_sujet*(0.68*lgbras_sujet)^2);
Low_pass_Freq = 5; %fréquence passe-bas la position
Cut_off = 0.1; %pourcentage du pic de vitesse pour déterminer début et fin du mouvement
Ech_norm_kin = 1000; %Fréquence d'échantillonage du profil de vitesse normalisé en durée 
Frequence_acquisition = 200;%Fréquence d'acquisition du signal cinématique
EMG_ON = 1 %1 pour le process des EMG, 0 pour le désactiver
emg_band_pass_Freq = [30 300] % Passe_bande du filtre EMG
emg_low_pass_Freq = 20 %fréquence passe_bas lors du second filtre du signal emg. 100 est la fréquence habituelle chez les humains (cf script Jérémie)
emg_ech_norm = 1000; %Fréquence d'échantillonage du signal EMG
anticip_kin_amp = 0.1; %Temps en secondes pour avoir la position avant et après le début du mouvement pour le calcul de l'amplitude
anticip = 0.45 %Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée
EMD = 0.076 % délai electromécanique moyen de tous les muscles
anticip_tonic = 250 % Durée (en ms) pour avoir le dernier point du tonic avant le mouvement et le premier point du tonic après le mouvement
duration_tonic = 250 % Durée (en ms) de moyennage du tonic
anticip_phasic_smooth = 500 %time in ms to recut smooth phasic so as to get rid of the first and last values which are too much influenced (exactly the same actually) by the non smoothed values, we only do this to compute EMG variables more easily.
type_RMS = 1; % 1 pour sliding et 2 pour skipping
emg_frequency = 1000; %Fréquence d'acquisition du signal EMG
Nb_averaged_trials = 2; % Indicate the number of EMG traces to be averaged 

Min_emg_duration = 0.05% Durée minimale en s pour detecter les bouffées d'activation EMG (positives ou négatives)
Min_emg_duration_end = 0.03% Durée minimale en s pour detecter la fin des bouffées d'activation EMG (positives ou négatives)
ICvalue = 1.96; % Valeur pour déterminer le début des bouffées lors de la détection automatique, à parir de l'écart type du tonic. Utiliser 1.96 pour 95% et 2.576 pour 99% de l'intervalle de confiance.
ICvalueK = 1.96;
Tresholdvalue = 0.02; % Valeur à dépasser pour la détection automatique des bouffées, ce qui permet d'éluder le cas où la bouffée est détectée trop tôt à cause d'une trop faible variabilité dans le tonic.
Cutoff_emg = 0.05 % Pourcentage du pic à partir duquel on détermine l'onset et l'offset de la bouffée EMG
Nb_emgs = 14 %Spécification du nombre de channels EMG
rms_window = 200; %time in ms of the window used to compute sliding root mean square of EMG
rms_window_step = (rms_window/1000)*emg_frequency;
emg_div_kin_freq = emg_frequency/Frequence_acquisition; %used to synchronized emg cutting (for sliding rms) with regard to kinematics
emgrms_div_kin_freq = emg_div_kin_freq/rms_window_step; %used to synchronized emg cutting (for skipping rms) with regard to kinematics

%% Importation des données

%On selectionne le repertoire
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');

if (Dossier ~= 0) %Si on clique sur un dossier
   
   %On charge la séquence de mouvements
   load ([Dossier '\' 'data_sequence' '\' 'data_sequence']);
    
    Extension = '*.mat'; %Traite tous les .mat
    
    %On construit le chemin
    Chemin = fullfile(Dossier, Extension);
    
    %On construit la liste des fichiers
    ListeFichier = dir(Chemin);

    %% On crée les matrices de résultats
    
    Donnees_EMG = {};
    Donnees_cinematiques = {};
    EMG_traite = {};
    Tonic = {};

    %% On procède au balayage fichier par fichier
     for i = 1: numel(ListeFichier)
        i
       Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
        
       load (Fichier_traite);
       
        %On crée une matrice de la position du doigt et de l'épaule
        posxyz = C3D.Cinematique.Donnees(:, 61:63);
        pos_epaule = C3D.Cinematique.Donnees(:, 61:63);
        [posxyz_lig, ~] = size(posxyz);
        
        %On filtre le signal de position
        posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
        posfiltre_epaule = butter_emgs(pos_epaule, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
       
        %On coupe le signal de vitesse pour avoir 2 plages contenant chacune un mouvement
       
        if data_sequence(i) == 1 | data_sequence(i) == 2
           plot(posfiltre(:, 3))
           [Cut] = ginput(3);
        else
            plot(posfiltre(:, 3))
            [Cut] = ginput(3);
        end
        
        Plage_mvmt_1_start = round(Cut(1,1));
        Plage_mvmt_1_end = round(Cut(2,1));
        
        Plage_mvmt_2_start = round(Cut(2,1));
        Plage_mvmt_2_end = round(Cut(3,1));
        
        [Pos_mvmt_1] = posfiltre(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
        [Pos_mvmt_2] = posfiltre(Plage_mvmt_2_start:Plage_mvmt_2_end, :);  
        
        [Pos_epaule_mvmt_1] = posfiltre_epaule(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
        [Pos_epaule_mvmt_2] = posfiltre_epaule(Plage_mvmt_2_start:Plage_mvmt_2_end, :);
        
      
        %On attribue une cible aux 2 mouvements
        
        if data_sequence(i) == 1
            Target_mvmt_1 = 1;
            Target_mvmt_2 = 2;
            
        elseif data_sequence(i) == 2
            Target_mvmt_1 = 2;
            Target_mvmt_2 = 1;
            
        elseif data_sequence(i) == 3
            Target_mvmt_1 = 3;
            Target_mvmt_2 = 4;
            
        elseif data_sequence(i) == 4
            Target_mvmt_1 = 4;
            Target_mvmt_2 = 3;
        end
            
        
        %% On calcule les paramètres cinématiques des 2 mouvements
        
        % Premier Mouvement
        [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_1, profil_vitesse_1_norm, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, Vmoy_1, Param_C_1, Amp_1, Angle_mvmt_1, Nbmaxloc_1, debut_1, fin_1, Amp_reel_1, Angle_reel_1, profil_accel_1] = compute_kinematics_BrasDom_nondom(Pos_mvmt_1, Pos_epaule_mvmt_1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin, anticip_kin_amp);
        
        % Second Mouvement
        [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_2, profil_vitesse_2_norm, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, Vmoy_2, Param_C_2, Amp_2, Angle_mvmt_2, Nbmaxloc_2, debut_2, fin_2, Amp_reel_2, Angle_reel_2, profil_accel_2] = compute_kinematics_BrasDom_nondom(Pos_mvmt_2, Pos_epaule_mvmt_2, Frequence_acquisition, 1, Cut_off, Ech_norm_kin, anticip_kin_amp);

       
        
        %% On remplit les matrices de résulats des paramètres cinématiques pour chaque cas
       
          k = 3*i;
          z = k-2;
        
        if data_sequence(i) == 1 | data_sequence(i) == 3
            
            Donnees_cinematiques.Position_cut_brut(1:lig_pos_1, z:k) = profil_position_1;
            Donnees_cinematiques.Position_cut_brut(1:lig_pos_2, z+3*numel(ListeFichier):k+3*numel(ListeFichier)) = profil_position_2;
            
            Donnees_cinematiques.Position_cut_norm(:, z:k) = profil_position_1_norm;
            Donnees_cinematiques.Position_cut_norm(:, z+3*numel(ListeFichier):k+3*numel(ListeFichier)) = profil_position_2_norm;
            
            Donnees_cinematiques.Vel_cut_brut(1:lig_pv1, i) = profil_vitesse_1;
            Donnees_cinematiques.Vel_cut_brut(1:lig_pv2, i+numel(ListeFichier)) = profil_vitesse_2;           
        
            Donnees_cinematiques.Vel_cut_norm(:, i) = profil_vitesse_1_norm;
            Donnees_cinematiques.Vel_cut_norm(:, i+numel(ListeFichier)) = profil_vitesse_2_norm;
            
            Donnees_cinematiques.AccelCut.R(1:lig_pv1, i) = profil_accel_1;
            Donnees_cinematiques.AccelCut.B(1:lig_pv2, i) = profil_accel_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 1) = Target_mvmt_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 1) = Target_mvmt_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 2) = MD_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 2) = MD_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 3) = rD_PA_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 3) = rD_PA_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 4) = rD_PV_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 4) =  rD_PV_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 5) = rD_PD_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 5) =  rD_PD_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 6) = PA_max_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 6) =  PA_max_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 8) = PD_max_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 8) =  PD_max_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 7) = pv1_max;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 7) =  pv2_max;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 9) = Vmoy_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 9) =  Vmoy_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 10) = Param_C_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 10) =  Param_C_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 11) = Amp_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 11) =  Amp_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 12) = Angle_mvmt_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 12) =  Angle_mvmt_2;
            
%             Donnees_cinematiques.Results_trial_by_trial(i, 13) = Amp_reel_1;
%             Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 13) = Amp_reel_2 ;
%             
%             Donnees_cinematiques.Results_trial_by_trial(i, 14) = Angle_reel_1;
%             Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 14) = Angle_reel_2 ;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 15) = Nbmaxloc_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 15) = Nbmaxloc_2 ;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 13) = erreur_cible_bleue_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 13) = erreur_cible_rouge_2 ;
            
            %Donnees_cinematiques.Results_trial_by_trial(i, 14) = erreur_angulaire_mvmt_1;
            %Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 14) = erreur_angulaire_mvmt_2 ;
            
            
        else
            
%             Donnees_cinematiques.SGT(1:lig_pv1, i+numel(ListeFichier)) = Torque_1.SGT;
%             Donnees_cinematiques.SGT(1:lig_pv2, i) = Torque_2.SGT;
            
%             Donnees_cinematiques.SIT(1:lig_pv1, i+numel(ListeFichier)) = Torque_1.SIT;
%             Donnees_cinematiques.SIT(1:lig_pv2, i) = Torque_2.SIT;
            
            Donnees_cinematiques.Position_cut_brut(1:lig_pos_1, z+3*numel(ListeFichier):k+3*numel(ListeFichier)) = profil_position_1;
            Donnees_cinematiques.Position_cut_brut(1:lig_pos_2, z:k) = profil_position_2;
            
            Donnees_cinematiques.Position_cut_norm(:, z+3*numel(ListeFichier):k+3*numel(ListeFichier)) = profil_position_1_norm;
            Donnees_cinematiques.Position_cut_norm(:, z:k) = profil_position_2_norm;
            
            Donnees_cinematiques.Vel_cut_brut(1:lig_pv1, i+numel(ListeFichier)) = profil_vitesse_1;
            Donnees_cinematiques.Vel_cut_brut(1:lig_pv2, i) = profil_vitesse_2;           
        
            Donnees_cinematiques.Vel_cut_norm(:, i+numel(ListeFichier)) = profil_vitesse_1_norm;
            Donnees_cinematiques.Vel_cut_norm(:, i) = profil_vitesse_2_norm;
            
            Donnees_cinematiques.AccelCut.B(1:lig_pv1, i) = profil_accel_1;
            Donnees_cinematiques.AccelCut.R(1:lig_pv2, i) = profil_accel_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 1) = Target_mvmt_1;
            Donnees_cinematiques.Results_trial_by_trial(i, 1) = Target_mvmt_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 2) = MD_1;
            Donnees_cinematiques.Results_trial_by_trial(i, 2) = MD_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 3) = rD_PA_1;
            Donnees_cinematiques.Results_trial_by_trial(i, 3) = rD_PA_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 4) = rD_PV_1;
            Donnees_cinematiques.Results_trial_by_trial(i, 4) =  rD_PV_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 5) = rD_PD_1;
            Donnees_cinematiques.Results_trial_by_trial(i, 5) =  rD_PD_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 6) = PA_max_1;
            Donnees_cinematiques.Results_trial_by_trial(i, 6) =  PA_max_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 8) = PD_max_1;
            Donnees_cinematiques.Results_trial_by_trial(i, 8) =  PD_max_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 7) = pv1_max;
            Donnees_cinematiques.Results_trial_by_trial(i, 7) =  pv2_max;
            
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 9) = Vmoy_1;
            Donnees_cinematiques.Results_trial_by_trial(i, 9) =  Vmoy_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 10) = Param_C_1;
            Donnees_cinematiques.Results_trial_by_trial(i, 10) =  Param_C_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 11) = Amp_1;
            Donnees_cinematiques.Results_trial_by_trial(i, 11) =  Amp_2;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 12) = Angle_mvmt_2;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 12) =  Angle_mvmt_1;
            
%             Donnees_cinematiques.Results_trial_by_trial(i, 13) = Amp_reel_2;
%             Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 13) = Amp_reel_1 ;
%             
%             Donnees_cinematiques.Results_trial_by_trial(i, 14) = Angle_reel_2;
%             Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 14) = Angle_reel_1 ;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 15) = Nbmaxloc_2;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 15) = Nbmaxloc_1 ;
        end
        
         
        
         %% Calcul des paramètres electromyographiques
         
%On calcule la taille de la matrice contenant les EMG
size_emg_data = posxyz_lig*emg_div_kin_freq;

% On crée la matrice contenant les EMG

emg_data = C3D.EMG.Donnees;
emg_data(:, 1) = C3D.EMG.Donnees(:, 1);
emg_data(:, 2) = C3D.EMG.Donnees(:, 2);

%calcule le début et la fin du mouvement sur l'ensemble du signal
%cinématique

onset_1 = (debut_1+Plage_mvmt_1_start);
offset_1 = (fin_1+Plage_mvmt_1_start);
onset_2 = (debut_2+Plage_mvmt_2_start);
offset_2 = (fin_2+Plage_mvmt_2_start);

% On sauvegarde un profil de position plus large pour trouver le
        % lag de la bouffée EMG par la suite
        
        ligantpos1 = offset_1-onset_1+1;
        ligantpos2 = offset_2-onset_2+1;
        
        if data_sequence(i) == 1 | data_sequence(i) == 3
            antvelocity_B = zeros(ligantpos1, 1);
            antvelocity_R = zeros(ligantpos2, 1);
        antvelocity_B(1:ligantpos1, 1) = sqrt(derive(posfiltre(onset_1:offset_1, 1), 2).^2+derive(posfiltre(onset_1:offset_1, 2), 2).^2+derive(posfiltre(onset_1:offset_1, 3), 2).^2)./(1/Frequence_acquisition);
        antvelocity_R(1:ligantpos2, 1) = sqrt(derive(posfiltre(onset_2:offset_2, 1), 2).^2+derive(posfiltre(onset_2:offset_2, 2), 2).^2+derive(posfiltre(onset_2:offset_2, 3), 2).^2)./(1/Frequence_acquisition);
        
        Donnees_cinematiques.antvelocity.B(1:ligantpos1, i) = antvelocity_B;
        Donnees_cinematiques.antvelocity.R(1:ligantpos2, i) = antvelocity_R;
        else
            antvelocity_B = zeros(ligantpos2, 1);
            antvelocity_R = zeros(ligantpos1, 1);
        antvelocity_B(1:ligantpos2, 1) = sqrt(derive(posfiltre(onset_2:offset_2, 1), 2).^2+derive(posfiltre(onset_2:offset_2, 2), 2).^2+derive(posfiltre(onset_2:offset_2, 3), 2).^2)./(1/Frequence_acquisition);
        antvelocity_R(1:ligantpos1, 1) = sqrt(derive(posfiltre(onset_1:offset_1, 1), 2).^2+derive(posfiltre(onset_1:offset_1, 2), 2).^2+derive(posfiltre(onset_1:offset_1, 3), 2).^2)./(1/Frequence_acquisition);
        
        Donnees_cinematiques.antvelocity.B(1:ligantpos2, i) = antvelocity_B;
        Donnees_cinematiques.antvelocity.R(1:ligantpos1, i) = antvelocity_R;
        end
        
%On calcule les paramètres emg du premier mouvement
[rms_cuts_1, rms_cuts_norm_1, ~, ...
    ~, ~, tonic_starts_1, tonic_ends_1, ...
    rms_cut_lig_1, ~, ~, ...
    ~, ~, tonic_lig_1] = compute_emg(emg_data, Nb_emgs, emg_frequency, ...
    emg_band_pass_Freq, emg_low_pass_Freq, type_RMS, rms_window_step, onset_1, offset_1, ...
    emg_div_kin_freq,  anticip,emg_ech_norm, anticip_tonic, duration_tonic, emgrms_div_kin_freq);

% On calcule les pramètres EMG du second mouvement

[rms_cuts_2, rms_cuts_norm_2, emg_rms, ...
    emg_filt, emg_rect_filt, tonic_starts_2, tonic_ends_2, ...
    rms_cut_lig_2, emg_data_filtre_rms_lig, emg_data_filtre_lig, ...
    emg_data_filtre_rect_second_lig, anticip_rms, tonic_lig_2] = compute_emg(emg_data, Nb_emgs, emg_frequency, ...
    emg_band_pass_Freq, emg_low_pass_Freq, type_RMS, rms_window_step, onset_2, offset_2, ...
    emg_div_kin_freq,  anticip,emg_ech_norm, anticip_tonic, duration_tonic, emgrms_div_kin_freq);


        
        %% On construit les matrices de résultats des EMG
        
%         % Pour le signal EMG brut
Donnees_EMG.Brutes.RAS(1:size_emg_data, i) = emg_data(1:size_emg_data, 1);
Donnees_EMG.Brutes.ESL1(1:size_emg_data, i) = emg_data(1:size_emg_data, 2);
Donnees_EMG.Brutes.DA(1:size_emg_data, i) = emg_data(1:size_emg_data, 3);
Donnees_EMG.Brutes.DP(1:size_emg_data, i) = emg_data(1:size_emg_data, 4);
Donnees_EMG.Brutes.DAG(1:size_emg_data, i) = emg_data(1:size_emg_data, 5);
Donnees_EMG.Brutes.DPG(1:size_emg_data, i) = emg_data(1:size_emg_data, 6);
Donnees_EMG.Brutes.ST(1:size_emg_data, i) = emg_data(1:size_emg_data, 7);
Donnees_EMG.Brutes.BF(1:size_emg_data, i) = emg_data(1:size_emg_data, 8);
Donnees_EMG.Brutes.RF(1:size_emg_data, i) = emg_data(1:size_emg_data, 9);
Donnees_EMG.Brutes.VL(1:size_emg_data, i) = emg_data(1:size_emg_data, 10);
Donnees_EMG.Brutes.TA(1:size_emg_data, i) = emg_data(1:size_emg_data, 11);
Donnees_EMG.Brutes.SOL(1:size_emg_data, i) = emg_data(1:size_emg_data, 12);
Donnees_EMG.Brutes.GM(1:size_emg_data, i) = emg_data(1:size_emg_data, 13);
Donnees_EMG.Brutes.ESD7(1:size_emg_data, i) = emg_data(1:size_emg_data, 14);
%     
%     % Pour le signal EMG filtré
Donnees_EMG.Filtrees.RAS(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 1);
Donnees_EMG.Filtrees.ESL1(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 2);
Donnees_EMG.Filtrees.DA(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 3);
Donnees_EMG.Filtrees.DP(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 4);
Donnees_EMG.Filtrees.DAG(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 5);
Donnees_EMG.Filtrees.DPG(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 6);
Donnees_EMG.Filtrees.ST(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 7);
Donnees_EMG.Filtrees.BF(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 8);
Donnees_EMG.Filtrees.RF(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 9);
Donnees_EMG.Filtrees.VL(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 10);
Donnees_EMG.Filtrees.TA(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 11);
Donnees_EMG.Filtrees.SOL(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 12);
Donnees_EMG.Filtrees.GM(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 13);
Donnees_EMG.Filtrees.ESD7(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 14);   
%     
%     % Pour le signal rectifié et refiltré
Donnees_EMG.Rectifiees.RAS(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 1);
Donnees_EMG.Rectifiees.ESL1(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 2);
Donnees_EMG.Rectifiees.DA(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 3);
Donnees_EMG.Rectifiees.DP(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 4);
Donnees_EMG.Rectifiees.DAG(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 5);
Donnees_EMG.Rectifiees.DPG(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 6);
Donnees_EMG.Rectifiees.ST(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 7);
Donnees_EMG.Rectifiees.BF(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 8);
Donnees_EMG.Rectifiees.RF(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 9);
Donnees_EMG.Rectifiees.VL(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 10);
Donnees_EMG.Rectifiees.TA(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 11);
Donnees_EMG.Rectifiees.SOL(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 12);
Donnees_EMG.Rectifiees.GM(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 13);
Donnees_EMG.Rectifiees.ESD7(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 14);
%     
    % Pour le signal RMS
    
    % Si on veut normaliser par le max de du bloc
Donnees_EMG.RMS.RAS(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 1);
Donnees_EMG.RMS.ESL1(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 2);
Donnees_EMG.RMS.DA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 3);
Donnees_EMG.RMS.DP(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 4);
Donnees_EMG.RMS.DAG(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 5);
Donnees_EMG.RMS.DPG(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 6);
Donnees_EMG.RMS.ST(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 7);
Donnees_EMG.RMS.BF(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 8);
Donnees_EMG.RMS.RF(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 9);
Donnees_EMG.RMS.VL(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 10);
Donnees_EMG.RMS.TA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 11);
Donnees_EMG.RMS.SOL(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 12);
Donnees_EMG.RMS.GM(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 13);
Donnees_EMG.RMS.ESD7(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 14);
%     
EMGMax_RAS = max(max(Donnees_EMG.RMS.RAS));
EMGMax_ESL1 = max(max(Donnees_EMG.RMS.ESL1));
EMGMax_DA = max(max(Donnees_EMG.RMS.DA));
EMGMax_DP = max(max(Donnees_EMG.RMS.DP));
EMGMax_DAG = max(max(Donnees_EMG.RMS.DAG));
EMGMax_DPG = max(max(Donnees_EMG.RMS.DPG));
EMGMax_ST = max(max(Donnees_EMG.RMS.ST));
EMGMax_BF = max(max(Donnees_EMG.RMS.BF));
EMGMax_RF = max(max(Donnees_EMG.RMS.RF));
EMGMax_VL = max(max(Donnees_EMG.RMS.VL));
EMGMax_TA = max(max(Donnees_EMG.RMS.TA));
EMGMax_SOL = max(max(Donnees_EMG.RMS.SOL));
EMGMax_GM = max(max(Donnees_EMG.RMS.GM));
EMGMax_ESD7 = max(max(Donnees_EMG.RMS.ESD7));


Donnees_EMG.RMS.RAS(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 1)./EMGMax_RAS;   
Donnees_EMG.RMS.ESL1(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 2)./EMGMax_ESL1;
Donnees_EMG.RMS.DA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 3)./EMGMax_DA;
Donnees_EMG.RMS.DP(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 4)./EMGMax_DP;
Donnees_EMG.RMS.DAG(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 5)./EMGMax_DAG;
Donnees_EMG.RMS.DPG(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 6)./EMGMax_DPG;
Donnees_EMG.RMS.ST(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 7)./EMGMax_ST;
Donnees_EMG.RMS.BF(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 8)./EMGMax_BF;
Donnees_EMG.RMS.RF(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 9)./EMGMax_RF;
Donnees_EMG.RMS.VL(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 10)./EMGMax_VL;
Donnees_EMG.RMS.TA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 11)./EMGMax_TA;
Donnees_EMG.RMS.SOL(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 12)./EMGMax_SOL;
Donnees_EMG.RMS.GM(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 13)./EMGMax_GM;
Donnees_EMG.RMS.ESD7(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 14)./EMGMax_ESD7;
    
    % Pour le mouvement RMS brut et normalisé et le tonic, on trie les signaux par direction
    
    if data_sequence(i) == 1 | data_sequence(i) == 3

Donnees_EMG.RMSCut.RAS(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 1)./EMGMax_RAS;
Donnees_EMG.RMSCut.ESL1(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 2)./EMGMax_ESL1;
Donnees_EMG.RMSCut.DA(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 3)./EMGMax_DA;
Donnees_EMG.RMSCut.DP(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 4)./EMGMax_DP;
Donnees_EMG.RMSCut.DAG(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 5)./EMGMax_DAG;
Donnees_EMG.RMSCut.DPG(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 6)./EMGMax_DPG;
Donnees_EMG.RMSCut.ST(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 7)./EMGMax_ST;
Donnees_EMG.RMSCut.BF(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 8)./EMGMax_BF;
Donnees_EMG.RMSCut.RF(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 9)./EMGMax_RF;
Donnees_EMG.RMSCut.VL(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 10)./EMGMax_VL;
Donnees_EMG.RMSCut.TA(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 11)./EMGMax_TA;
Donnees_EMG.RMSCut.SOL(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 12)./EMGMax_SOL;
Donnees_EMG.RMSCut.GM(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 13)./EMGMax_GM;
Donnees_EMG.RMSCut.ESD7(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 14)./EMGMax_ESD7;
%   

Donnees_EMG.RMSCut.RAS(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 1)./EMGMax_RAS;
Donnees_EMG.RMSCut.ESL1(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 2)./EMGMax_ESL1;
Donnees_EMG.RMSCut.DA(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 3)./EMGMax_DA;
Donnees_EMG.RMSCut.DP(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 4)./EMGMax_DP;
Donnees_EMG.RMSCut.DAG(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 5)./EMGMax_DAG;
Donnees_EMG.RMSCut.DPG(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 6)./EMGMax_DPG;
Donnees_EMG.RMSCut.ST(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 7)./EMGMax_ST;
Donnees_EMG.RMSCut.BF(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 8)./EMGMax_BF;
Donnees_EMG.RMSCut.RF(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 9)./EMGMax_RF;
Donnees_EMG.RMSCut.VL(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 10)./EMGMax_VL;
Donnees_EMG.RMSCut.TA(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 11)./EMGMax_TA;
Donnees_EMG.RMSCut.SOL(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 12)./EMGMax_SOL;
Donnees_EMG.RMSCut.GM(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 13)./EMGMax_GM;
Donnees_EMG.RMSCut.ESD7(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 14)./EMGMax_ESD7;
       
       % Mouvements Normalisés
Donnees_EMG.RMSCutNorm.RAS(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 1)./EMGMax_RAS;     
Donnees_EMG.RMSCutNorm.ESL1(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 2)./EMGMax_ESL1;
Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 3)./EMGMax_DA;
Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 4)./EMGMax_DP;
Donnees_EMG.RMSCutNorm.DAG(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 5)./EMGMax_DAG;
Donnees_EMG.RMSCutNorm.DPG(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 6)./EMGMax_DPG;
Donnees_EMG.RMSCutNorm.ST(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 7)./EMGMax_ST;
Donnees_EMG.RMSCutNorm.BF(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 8)./EMGMax_BF;
Donnees_EMG.RMSCutNorm.RF(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 9)./EMGMax_RF;
Donnees_EMG.RMSCutNorm.VL(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 10)./EMGMax_VL;
Donnees_EMG.RMSCutNorm.TA(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 11)./EMGMax_TA;
Donnees_EMG.RMSCutNorm.SOL(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 12)./EMGMax_SOL;
Donnees_EMG.RMSCutNorm.GM(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 13)./EMGMax_GM;
Donnees_EMG.RMSCutNorm.ESD7(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 14)./EMGMax_ESD7;
%    
Donnees_EMG.RMSCutNorm.RAS(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 1)./EMGMax_RAS;
Donnees_EMG.RMSCutNorm.ESL1(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 2)./EMGMax_ESL1;
Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 3)./EMGMax_DA;
Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 4)./EMGMax_DP;
Donnees_EMG.RMSCutNorm.DAG(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 5)./EMGMax_DAG;
Donnees_EMG.RMSCutNorm.DPG(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 6)./EMGMax_DPG;
Donnees_EMG.RMSCutNorm.ST(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 7)./EMGMax_ST;
Donnees_EMG.RMSCutNorm.BF(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 8)./EMGMax_BF;
Donnees_EMG.RMSCutNorm.RF(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 9)./EMGMax_RF;
Donnees_EMG.RMSCutNorm.VL(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 10)./EMGMax_VL;
Donnees_EMG.RMSCutNorm.TA(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 11)./EMGMax_TA;
Donnees_EMG.RMSCutNorm.SOL(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 12)./EMGMax_SOL;
Donnees_EMG.RMSCutNorm.GM(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 13)./EMGMax_GM;
Donnees_EMG.RMSCutNorm.ESD7(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 14)./EMGMax_ESD7;
       
       % Pour le tonic au début
Donnees_EMG.TonicStart.RAS(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 1)./EMGMax_RAS;      
Donnees_EMG.TonicStart.ESL1(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 2)./EMGMax_ESL1;
Donnees_EMG.TonicStart.DA(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 3)./EMGMax_DA;
Donnees_EMG.TonicStart.DP(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 4)./EMGMax_DP;
Donnees_EMG.TonicStart.DAG(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 5)./EMGMax_DAG;
Donnees_EMG.TonicStart.DPG(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 6)./EMGMax_DPG;
Donnees_EMG.TonicStart.ST(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 7)./EMGMax_ST;
Donnees_EMG.TonicStart.BF(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 8)./EMGMax_BF;
Donnees_EMG.TonicStart.RF(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 9)./EMGMax_RF;
Donnees_EMG.TonicStart.VL(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 10)./EMGMax_VL;
Donnees_EMG.TonicStart.TA(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 11)./EMGMax_TA;
Donnees_EMG.TonicStart.SOL(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 12)./EMGMax_SOL;
Donnees_EMG.TonicStart.GM(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 13)./EMGMax_GM;
Donnees_EMG.TonicStart.ESD7(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 14)./EMGMax_ESD7;

%        
Donnees_EMG.TonicStart.RAS(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 1)./EMGMax_RAS;
Donnees_EMG.TonicStart.ESL1(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 2)./EMGMax_ESL1;
Donnees_EMG.TonicStart.DA(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 3)./EMGMax_DA;
Donnees_EMG.TonicStart.DP(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 4)./EMGMax_DP;
Donnees_EMG.TonicStart.DAG(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 5)./EMGMax_DAG;
Donnees_EMG.TonicStart.DPG(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 6)./EMGMax_DPG;
Donnees_EMG.TonicStart.ST(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 7)./EMGMax_ST;
Donnees_EMG.TonicStart.BF(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 8)./EMGMax_BF;
Donnees_EMG.TonicStart.RF(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 9)./EMGMax_RF;
Donnees_EMG.TonicStart.VL(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 10)./EMGMax_VL;
Donnees_EMG.TonicStart.TA(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 11)./EMGMax_TA;
Donnees_EMG.TonicStart.SOL(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 12)./EMGMax_SOL;
Donnees_EMG.TonicStart.GM(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 13)./EMGMax_GM;
Donnees_EMG.TonicStart.ESD7(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 14)./EMGMax_ESD7;
       
       % Pour le tonic à la fin
Donnees_EMG.TonicEnd.RAS(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 1)./EMGMax_RAS;       
Donnees_EMG.TonicEnd.ESL1(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 2)./EMGMax_ESL1;
Donnees_EMG.TonicEnd.DA(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 3)./EMGMax_DA;
Donnees_EMG.TonicEnd.DP(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 4)./EMGMax_DP;
Donnees_EMG.TonicEnd.DAG(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 5)./EMGMax_DAG;
Donnees_EMG.TonicEnd.DPG(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 6)./EMGMax_DPG;
Donnees_EMG.TonicEnd.ST(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 7)./EMGMax_ST;
Donnees_EMG.TonicEnd.BF(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 8)./EMGMax_BF;
Donnees_EMG.TonicEnd.RF(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 9)./EMGMax_RF;
Donnees_EMG.TonicEnd.VL(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 10)./EMGMax_VL;
Donnees_EMG.TonicEnd.TA(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 11)./EMGMax_TA;
Donnees_EMG.TonicEnd.SOL(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 12)./EMGMax_SOL;
Donnees_EMG.TonicEnd.GM(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 13)./EMGMax_GM;
Donnees_EMG.TonicEnd.ESD7(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 14)./EMGMax_ESD7;
        

Donnees_EMG.TonicEnd.RAS(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 1)./EMGMax_RAS;
Donnees_EMG.TonicEnd.ESL1(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 2)./EMGMax_ESL1;
Donnees_EMG.TonicEnd.DA(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 3)./EMGMax_DA;
Donnees_EMG.TonicEnd.DP(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 4)./EMGMax_DP;
Donnees_EMG.TonicEnd.DAG(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 5)./EMGMax_DAG;
Donnees_EMG.TonicEnd.DPG(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 6)./EMGMax_DPG;
Donnees_EMG.TonicEnd.ST(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 7)./EMGMax_ST;
Donnees_EMG.TonicEnd.BF(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 8)./EMGMax_BF;
Donnees_EMG.TonicEnd.RF(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 9)./EMGMax_RF;
Donnees_EMG.TonicEnd.VL(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 10)./EMGMax_VL;
Donnees_EMG.TonicEnd.TA(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 11)./EMGMax_TA;
Donnees_EMG.TonicEnd.SOL(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 12)./EMGMax_SOL;
Donnees_EMG.TonicEnd.GM(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 13)./EMGMax_GM;
Donnees_EMG.TonicEnd.ESD7(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 14)./EMGMax_ESD7;
       
    else
        
Donnees_EMG.RMSCut.RAS(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 1)./EMGMax_RAS;
Donnees_EMG.RMSCut.ESL1(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 2)./EMGMax_ESL1;
Donnees_EMG.RMSCut.DA(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 3)./EMGMax_DA;
Donnees_EMG.RMSCut.DP(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 4)./EMGMax_DP;
Donnees_EMG.RMSCut.DAG(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 5)./EMGMax_DAG;
Donnees_EMG.RMSCut.DPG(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 6)./EMGMax_DPG;
Donnees_EMG.RMSCut.ST(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 7)./EMGMax_ST;
Donnees_EMG.RMSCut.BF(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 8)./EMGMax_BF;
Donnees_EMG.RMSCut.RF(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 9)./EMGMax_RF;
Donnees_EMG.RMSCut.VL(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 10)./EMGMax_VL;
Donnees_EMG.RMSCut.TA(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 11)./EMGMax_TA;
Donnees_EMG.RMSCut.SOL(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 12)./EMGMax_SOL;
Donnees_EMG.RMSCut.GM(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 13)./EMGMax_GM;
Donnees_EMG.RMSCut.ESD7(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 14)./EMGMax_ESD7;
        
Donnees_EMG.RMSCut.RAS(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 1)./EMGMax_RAS;
Donnees_EMG.RMSCut.ESL1(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 2)./EMGMax_ESL1;
Donnees_EMG.RMSCut.DA(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 3)./EMGMax_DA;
Donnees_EMG.RMSCut.DP(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 4)./EMGMax_DP;
Donnees_EMG.RMSCut.DAG(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 5)./EMGMax_DAG;
Donnees_EMG.RMSCut.DPG(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 6)./EMGMax_DPG;
Donnees_EMG.RMSCut.ST(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 7)./EMGMax_ST;
Donnees_EMG.RMSCut.BF(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 8)./EMGMax_BF;
Donnees_EMG.RMSCut.RF(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 9)./EMGMax_RF;
Donnees_EMG.RMSCut.VL(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 10)./EMGMax_VL;
Donnees_EMG.RMSCut.TA(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 11)./EMGMax_TA;
Donnees_EMG.RMSCut.SOL(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 12)./EMGMax_SOL;
Donnees_EMG.RMSCut.GM(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 13)./EMGMax_GM;
Donnees_EMG.RMSCut.ESD7(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 14)./EMGMax_ESD7;
       
       % Pour les mouvements normalisés
       
Donnees_EMG.RMSCutNorm.RAS(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 1)./EMGMax_RAS;
Donnees_EMG.RMSCutNorm.ESL1(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 2)./EMGMax_ESL1;
Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 3)./EMGMax_DA;
Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 4)./EMGMax_DP;
Donnees_EMG.RMSCutNorm.DAG(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 5)./EMGMax_DAG;
Donnees_EMG.RMSCutNorm.DPG(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 6)./EMGMax_DPG;
Donnees_EMG.RMSCutNorm.ST(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 7)./EMGMax_ST;
Donnees_EMG.RMSCutNorm.BF(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 8)./EMGMax_BF;
Donnees_EMG.RMSCutNorm.RF(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 9)./EMGMax_RF;
Donnees_EMG.RMSCutNorm.VL(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 10)./EMGMax_VL;
Donnees_EMG.RMSCutNorm.TA(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 11)./EMGMax_TA;
Donnees_EMG.RMSCutNorm.SOL(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 12)./EMGMax_SOL;
Donnees_EMG.RMSCutNorm.GM(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 13)./EMGMax_GM;
Donnees_EMG.RMSCutNorm.ESD7(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 14)./EMGMax_ESD7;
        

Donnees_EMG.RMSCutNorm.RAS(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 1)./EMGMax_RAS;
Donnees_EMG.RMSCutNorm.ESL1(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 2)./EMGMax_ESL1;
Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 3)./EMGMax_DA;
Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 4)./EMGMax_DP;
Donnees_EMG.RMSCutNorm.DAG(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 5)./EMGMax_DAG;
Donnees_EMG.RMSCutNorm.DPG(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 6)./EMGMax_DPG;
Donnees_EMG.RMSCutNorm.ST(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 7)./EMGMax_ST;
Donnees_EMG.RMSCutNorm.BF(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 8)./EMGMax_BF;
Donnees_EMG.RMSCutNorm.RF(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 9)./EMGMax_RF;
Donnees_EMG.RMSCutNorm.VL(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 10)./EMGMax_VL;
Donnees_EMG.RMSCutNorm.TA(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 11)./EMGMax_TA;
Donnees_EMG.RMSCutNorm.SOL(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 12)./EMGMax_SOL;
Donnees_EMG.RMSCutNorm.GM(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 13)./EMGMax_GM;
Donnees_EMG.RMSCutNorm.ESD7(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 14)./EMGMax_ESD7;
      
       % Pour le tonic au début
       
Donnees_EMG.TonicStart.RAS(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 1)./EMGMax_RAS;
Donnees_EMG.TonicStart.ESL1(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 2)./EMGMax_ESL1;
Donnees_EMG.TonicStart.DA(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 3)./EMGMax_DA;
Donnees_EMG.TonicStart.DP(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 4)./EMGMax_DP;
Donnees_EMG.TonicStart.DAG(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 5)./EMGMax_DAG;
Donnees_EMG.TonicStart.DPG(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 6)./EMGMax_DPG;
Donnees_EMG.TonicStart.ST(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 7)./EMGMax_ST;
Donnees_EMG.TonicStart.BF(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 8)./EMGMax_BF;
Donnees_EMG.TonicStart.RF(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 9)./EMGMax_RF;
Donnees_EMG.TonicStart.VL(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 10)./EMGMax_VL;
Donnees_EMG.TonicStart.TA(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 11)./EMGMax_TA;
Donnees_EMG.TonicStart.SOL(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 12)./EMGMax_SOL;
Donnees_EMG.TonicStart.GM(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 13)./EMGMax_GM;
Donnees_EMG.TonicStart.ESD7(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 14)./EMGMax_ESD7;
%        

Donnees_EMG.TonicStart.RAS(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 1)./EMGMax_RAS;
Donnees_EMG.TonicStart.ESL1(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 2)./EMGMax_ESL1;
Donnees_EMG.TonicStart.DA(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 3)./EMGMax_DA;
Donnees_EMG.TonicStart.DP(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 4)./EMGMax_DP;
Donnees_EMG.TonicStart.DAG(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 5)./EMGMax_DAG;
Donnees_EMG.TonicStart.DPG(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 6)./EMGMax_DPG;
Donnees_EMG.TonicStart.ST(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 7)./EMGMax_ST;
Donnees_EMG.TonicStart.BF(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 8)./EMGMax_BF;
Donnees_EMG.TonicStart.RF(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 9)./EMGMax_RF;
Donnees_EMG.TonicStart.VL(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 10)./EMGMax_VL;
Donnees_EMG.TonicStart.TA(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 11)./EMGMax_TA;
Donnees_EMG.TonicStart.SOL(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 12)./EMGMax_SOL;
Donnees_EMG.TonicStart.GM(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 13)./EMGMax_GM;
Donnees_EMG.TonicStart.ESD7(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 14)./EMGMax_ESD7;
       
       % Pour le tonic à la fin
       
Donnees_EMG.TonicEnd.RAS(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 1)./EMGMax_RAS;
Donnees_EMG.TonicEnd.ESL1(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 2)./EMGMax_ESL1;
Donnees_EMG.TonicEnd.DA(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 3)./EMGMax_DA;
Donnees_EMG.TonicEnd.DP(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 4)./EMGMax_DP;
Donnees_EMG.TonicEnd.DAG(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 5)./EMGMax_DAG;
Donnees_EMG.TonicEnd.DPG(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 6)./EMGMax_DPG;
Donnees_EMG.TonicEnd.ST(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 7)./EMGMax_ST;
Donnees_EMG.TonicEnd.BF(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 8)./EMGMax_BF;
Donnees_EMG.TonicEnd.RF(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 9)./EMGMax_RF;
Donnees_EMG.TonicEnd.VL(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 10)./EMGMax_VL;
Donnees_EMG.TonicEnd.TA(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 11)./EMGMax_TA;
Donnees_EMG.TonicEnd.SOL(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 12)./EMGMax_SOL;
Donnees_EMG.TonicEnd.GM(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 13)./EMGMax_GM;
Donnees_EMG.TonicEnd.ESD7(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 14)./EMGMax_ESD7;
%   

Donnees_EMG.TonicEnd.RAS(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 1)./EMGMax_RAS;
Donnees_EMG.TonicEnd.ESL1(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 2)./EMGMax_ESL1;
Donnees_EMG.TonicEnd.DA(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 3)./EMGMax_DA;
Donnees_EMG.TonicEnd.DP(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 4)./EMGMax_DP;
Donnees_EMG.TonicEnd.DAG(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 5)./EMGMax_DAG;
Donnees_EMG.TonicEnd.DPG(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 6)./EMGMax_DPG;
Donnees_EMG.TonicEnd.ST(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 7)./EMGMax_ST;
Donnees_EMG.TonicEnd.BF(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 8)./EMGMax_BF;
Donnees_EMG.TonicEnd.RF(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 9)./EMGMax_RF;
Donnees_EMG.TonicEnd.VL(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 10)./EMGMax_VL;
Donnees_EMG.TonicEnd.TA(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 11)./EMGMax_TA;
Donnees_EMG.TonicEnd.SOL(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 12)./EMGMax_SOL;
Donnees_EMG.TonicEnd.GM(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 13)./EMGMax_GM;
Donnees_EMG.TonicEnd.ESD7(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 14)./EMGMax_ESD7;

    end
    
     end
       
% %       % Si on veut normaliser par le max de du bloc, on calcule l'EMGmax
% %       % pour chaque muscle
% %       
        EMGMax_RAS = max(max(Donnees_EMG.RMS.RAS));
        EMGMax_ESL1 = max(max(Donnees_EMG.RMS.ESL1));
        EMGMax_DA = max(max(Donnees_EMG.RMS.DA));
        EMGMax_DP = max(max(Donnees_EMG.RMS.DP));
        EMGMax_DAG = max(max(Donnees_EMG.RMS.DAG));
        EMGMax_DPG = max(max(Donnees_EMG.RMS.DPG));
        EMGMax_ST = max(max(Donnees_EMG.RMS.ST));
        EMGMax_BF = max(max(Donnees_EMG.RMS.BF));
        EMGMax_RF = max(max(Donnees_EMG.RMS.RF));
        EMGMax_VL = max(max(Donnees_EMG.RMS.VL));
        EMGMax_TA = max(max(Donnees_EMG.RMS.TA));
        EMGMax_SOL = max(max(Donnees_EMG.RMS.SOL));
        EMGMax_GM = max(max(Donnees_EMG.RMS.GM));
        EMGMax_ESD7 = max(max(Donnees_EMG.RMS.ESD7));

      
      % On normalise tous les essais et les tonics par cette valeur
      
      Donnees_EMG.RMSCut.RAS = (Donnees_EMG.RMSCut.RAS)./EMGMax_RAS;
      Donnees_EMG.RMSCut.ESL1 = (Donnees_EMG.RMSCut.ESL1)./EMGMax_ESL1;
      Donnees_EMG.RMSCut.DA = (Donnees_EMG.RMSCut.DA)./EMGMax_DA;
      Donnees_EMG.RMSCut.DP = (Donnees_EMG.RMSCut.DP)./EMGMax_DP;
      Donnees_EMG.RMSCut.DAG = (Donnees_EMG.RMSCut.DAG)./EMGMax_DAG;
      Donnees_EMG.RMSCut.DPG = (Donnees_EMG.RMSCut.DPG)./EMGMax_DPG;
      Donnees_EMG.RMSCut.ST = (Donnees_EMG.RMSCut.ST)./EMGMax_ST;
      Donnees_EMG.RMSCut.BF = (Donnees_EMG.RMSCut.BF)./EMGMax_BF;
      Donnees_EMG.RMSCut.RF = (Donnees_EMG.RMSCut.RF)./EMGMax_RF;
      Donnees_EMG.RMSCut.VL = (Donnees_EMG.RMSCut.VL)./EMGMax_VL;
      Donnees_EMG.RMSCut.TA = (Donnees_EMG.RMSCut.TA)./EMGMax_TA;
      Donnees_EMG.RMSCut.SOL = (Donnees_EMG.RMSCut.SOL)./EMGMax_SOL;
      Donnees_EMG.RMSCut.GM = (Donnees_EMG.RMSCut.GM)./EMGMax_GM;
      Donnees_EMG.RMSCut.ESD7 = (Donnees_EMG.RMSCut.ESD7)./EMGMax_ESD7;
      
      Donnees_EMG.TonicStart.RAS = (Donnees_EMG.TonicStart.RAS)./EMGMax_RAS;
      Donnees_EMG.TonicStart.ESL1 = (Donnees_EMG.TonicStart.ESL1)./EMGMax_ESL1;
      Donnees_EMG.TonicStart.DA = (Donnees_EMG.TonicStart.DA)./EMGMax_DA;
      Donnees_EMG.TonicStart.DP = (Donnees_EMG.TonicStart.DP)./EMGMax_DP;
      Donnees_EMG.TonicStart.DAG = (Donnees_EMG.TonicStart.DAG)./EMGMax_DAG;
      Donnees_EMG.TonicStart.DPG = (Donnees_EMG.TonicStart.DPG)./EMGMax_DPG;
      Donnees_EMG.TonicStart.ST = (Donnees_EMG.TonicStart.ST)./EMGMax_ST;
      Donnees_EMG.TonicStart.BF = (Donnees_EMG.TonicStart.BF)./EMGMax_BF;
      Donnees_EMG.TonicStart.RF = (Donnees_EMG.TonicStart.DA)./EMGMax_RF;
      Donnees_EMG.TonicStart.VL = (Donnees_EMG.TonicStart.DP)./EMGMax_VL;
      Donnees_EMG.TonicStart.TA = (Donnees_EMG.TonicStart.TA)./EMGMax_TA;
      Donnees_EMG.TonicStart.SOL = (Donnees_EMG.TonicStart.SOL)./EMGMax_SOL;
      Donnees_EMG.TonicStart.GM = (Donnees_EMG.TonicStart.GM)./EMGMax_GM;
      Donnees_EMG.TonicStart.ESD7 = (Donnees_EMG.TonicStart.ESD7)./EMGMax_ESD7;
      
      Donnees_EMG.TonicEnd.RAS = (Donnees_EMG.TonicEnd.RAS)./EMGMax_RAS;
      Donnees_EMG.TonicEnd.ESL1 = (Donnees_EMG.TonicEnd.ESL1)./EMGMax_ESL1;
      Donnees_EMG.TonicEnd.DA = (Donnees_EMG.TonicEnd.DA)./EMGMax_DA;
      Donnees_EMG.TonicEnd.DP = (Donnees_EMG.TonicEnd.DP)./EMGMax_DP;
      Donnees_EMG.TonicEnd.DAG = (Donnees_EMG.TonicEnd.DAG)./EMGMax_DAG;
      Donnees_EMG.TonicEnd.DPG = (Donnees_EMG.TonicEnd.DPG)./EMGMax_DPG;
      Donnees_EMG.TonicEnd.ST = (Donnees_EMG.TonicEnd.ST)./EMGMax_ST;
      Donnees_EMG.TonicEnd.BF = (Donnees_EMG.TonicEnd.BF)./EMGMax_BF;
      Donnees_EMG.TonicEnd.RF = (Donnees_EMG.TonicEnd.RF)./EMGMax_RF;
      Donnees_EMG.TonicEnd.VL = (Donnees_EMG.TonicEnd.VL)./EMGMax_VL;
      Donnees_EMG.TonicEnd.TA = (Donnees_EMG.TonicEnd.TA)./EMGMax_TA;
      Donnees_EMG.TonicEnd.SOL = (Donnees_EMG.TonicEnd.SOL)./EMGMax_SOL;
      Donnees_EMG.TonicEnd.GM = (Donnees_EMG.TonicEnd.GM)./EMGMax_GM;
      Donnees_EMG.TonicEnd.ESD7 = (Donnees_EMG.TonicEnd.ESD7)./EMGMax_ESD7;
    
      % On rajoute un profil moyen avec erreur standard sur le rms_cut_norm
    
     for f = 1:1000  
%         
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 1) = mean(Donnees_EMG.RMSCutNorm.RAS(f, 1:numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 4) = mean(Donnees_EMG.RMSCutNorm.ESL1(f, 1:numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 7) = mean(Donnees_EMG.RMSCutNorm.DA(f, 1:numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 10) = mean(Donnees_EMG.RMSCutNorm.DP(f, 1:numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 13) = mean(Donnees_EMG.RMSCutNorm.DAG(f, 1:numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 16) = mean(Donnees_EMG.RMSCutNorm.DPG(f, 1:numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 19) = mean(Donnees_EMG.RMSCutNorm.ST(f, 1:numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 22) = mean(Donnees_EMG.RMSCutNorm.BF(f, 1:numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 25) = mean(Donnees_EMG.RMSCutNorm.RF(f, 1:numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 28) = mean(Donnees_EMG.RMSCutNorm.VL(f, 1:numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 31) = mean(Donnees_EMG.RMSCutNorm.TA(f, 1:numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 34) = mean(Donnees_EMG.RMSCutNorm.SOL(f, 1:numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 37) = mean(Donnees_EMG.RMSCutNorm.GM(f, 1:numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 40) = mean(Donnees_EMG.RMSCutNorm.ESD7(f, 1:numel(ListeFichier)), 2);
%         
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 2) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 1)+std(Donnees_EMG.RMSCutNorm.RAS(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 5) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 4)+std(Donnees_EMG.RMSCutNorm.ESL1(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 8) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 7)+std(Donnees_EMG.RMSCutNorm.DA(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 11) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 10)+std(Donnees_EMG.RMSCutNorm.DP(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 14) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 13)+std(Donnees_EMG.RMSCutNorm.DAG(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 17) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 16)+std(Donnees_EMG.RMSCutNorm.DPG(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 20) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 19)+std(Donnees_EMG.RMSCutNorm.ST(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 23) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 22)+std(Donnees_EMG.RMSCutNorm.BF(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 26) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 25)+std(Donnees_EMG.RMSCutNorm.RF(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 29) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 28)+std(Donnees_EMG.RMSCutNorm.VL(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 32) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 31)+std(Donnees_EMG.RMSCutNorm.TA(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 35) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 34)+std(Donnees_EMG.RMSCutNorm.SOL(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 38) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 37)+std(Donnees_EMG.RMSCutNorm.GM(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 41) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 40)+std(Donnees_EMG.RMSCutNorm.ESD7(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 3) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 1)-std(Donnees_EMG.RMSCutNorm.RAS(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 6) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 4)-std(Donnees_EMG.RMSCutNorm.ESL1(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 9) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 7)-std(Donnees_EMG.RMSCutNorm.DA(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 12) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 10)-std(Donnees_EMG.RMSCutNorm.DP(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 15) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 13)-std(Donnees_EMG.RMSCutNorm.DAG(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 18) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 16)-std(Donnees_EMG.RMSCutNorm.DPG(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 21) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 19)-std(Donnees_EMG.RMSCutNorm.ST(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 24) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 22)-std(Donnees_EMG.RMSCutNorm.BF(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 27) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 25)-std(Donnees_EMG.RMSCutNorm.RF(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 30) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 28)-std(Donnees_EMG.RMSCutNorm.VL(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 33) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 31)-std(Donnees_EMG.RMSCutNorm.TA(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 36) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 34)-std(Donnees_EMG.RMSCutNorm.SOL(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 39) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 37)-std(Donnees_EMG.RMSCutNorm.GM(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 42) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 40)-std(Donnees_EMG.RMSCutNorm.ESD7(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
% 
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 1) = mean(Donnees_EMG.RMSCutNorm.RAS(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 4) = mean(Donnees_EMG.RMSCutNorm.ESL1(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 7) = mean(Donnees_EMG.RMSCutNorm.DA(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 10) = mean(Donnees_EMG.RMSCutNorm.DP(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 13) = mean(Donnees_EMG.RMSCutNorm.DAG(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 16) = mean(Donnees_EMG.RMSCutNorm.DPG(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 19) = mean(Donnees_EMG.RMSCutNorm.ST(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 22) = mean(Donnees_EMG.RMSCutNorm.BF(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 25) = mean(Donnees_EMG.RMSCutNorm.RF(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 28) = mean(Donnees_EMG.RMSCutNorm.VL(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 31) = mean(Donnees_EMG.RMSCutNorm.TA(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 34) = mean(Donnees_EMG.RMSCutNorm.SOL(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 37) = mean(Donnees_EMG.RMSCutNorm.GM(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 40) = mean(Donnees_EMG.RMSCutNorm.ESD7(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
%         
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 2) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 1)+std(Donnees_EMG.RMSCutNorm.RAS(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 5) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 4)+std(Donnees_EMG.RMSCutNorm.ESL1(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 8) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 7)+std(Donnees_EMG.RMSCutNorm.DA(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 11) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 10)+std(Donnees_EMG.RMSCutNorm.DP(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 14) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 13)+std(Donnees_EMG.RMSCutNorm.DAG(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 17) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 16)+std(Donnees_EMG.RMSCutNorm.DPG(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 20) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 19)+std(Donnees_EMG.RMSCutNorm.ST(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 23) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 22)+std(Donnees_EMG.RMSCutNorm.BF(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 26) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 25)+std(Donnees_EMG.RMSCutNorm.RF(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 29) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 28)+std(Donnees_EMG.RMSCutNorm.VL(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 32) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 31)+std(Donnees_EMG.RMSCutNorm.TA(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 35) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 34)+std(Donnees_EMG.RMSCutNorm.SOL(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 38) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 37)+std(Donnees_EMG.RMSCutNorm.GM(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 41) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 40)+std(Donnees_EMG.RMSCutNorm.ESD7(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 3) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 1)-std(Donnees_EMG.RMSCutNorm.RAS(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 6) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 4)-std(Donnees_EMG.RMSCutNorm.ESL1(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 9) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 7)-std(Donnees_EMG.RMSCutNorm.DA(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 12) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 10)-std(Donnees_EMG.RMSCutNorm.DP(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 15) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 13)-std(Donnees_EMG.RMSCutNorm.DAG(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 18) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 16)-std(Donnees_EMG.RMSCutNorm.DPG(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 21) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 19)-std(Donnees_EMG.RMSCutNorm.ST(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 24) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 22)-std(Donnees_EMG.RMSCutNorm.BF(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 27) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 25)-std(Donnees_EMG.RMSCutNorm.RF(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 30) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 28)-std(Donnees_EMG.RMSCutNorm.VL(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 33) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 31)-std(Donnees_EMG.RMSCutNorm.TA(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 36) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 34)-std(Donnees_EMG.RMSCutNorm.SOL(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 39) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 37)-std(Donnees_EMG.RMSCutNorm.GM(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 42) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 40)-std(Donnees_EMG.RMSCutNorm.ESD7(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
      end
     
% % % % % % % %      Donnees_cinematiques.Meanstd_target(1, :) = mean(Donnees_cinematiques.Results_trial_by_trial(1:numel(ListeFichier), :));
% % % % % % % %      Donnees_cinematiques.Meanstd_target(2, :) = mean(Donnees_cinematiques.Results_trial_by_trial((numel(ListeFichier)+1):(2*numel(ListeFichier)), :));
% % % NEW % % % %      Donnees_cinematiques.Meanstd_target(3, :) = std(Donnees_cinematiques.Results_trial_by_trial(1:numel(ListeFichier), :));
% % % % % % % %      Donnees_cinematiques.Meanstd_target(4, :) = std(Donnees_cinematiques.Results_trial_by_trial((numel(ListeFichier)+1):(2*numel(ListeFichier)), :));

%%% PLOT GRAPHS CUISSES  
figure('Name','Signaux EMG muscles de la cuisse','NumberTitle','off');
subplot(2,4,1)
plot(mean(Donnees_EMG.RMSCutNorm.ST(:,3:4),2),'DisplayName','mean(Donnees_EMG.RMSCutNorm.ST(:,3:4),2)')
title('Subplot 5 (se lever): ST')
subplot(2,4,2)
plot(mean(Donnees_EMG.RMSCutNorm.BF(:,3:4),2),'DisplayName','mean(Donnees_EMG.RMSCutNorm.BF(:,3:4),2)')
title('Subplot 6 (se lever): BF')
subplot(2,4,3)
plot(mean(Donnees_EMG.RMSCutNorm.RF(:,3:4),2),'DisplayName','mean(Donnees_EMG.RMSCutNorm.RF(:,3:4),2)')
title('Subplot 7 (se lever): RF')
subplot(2,4,4)
plot(mean(Donnees_EMG.RMSCutNorm.VL(:,3:4),2),'DisplayName','mean(Donnees_EMG.RMSCutNorm.VL(:,3:4),2)')
title('Subplot 8 (se lever): VL')

subplot(2,4,5)
plot(mean(Donnees_cinematiques.Vel_cut_norm(:,3:4),2),'DisplayName','mean(Donnees_cinematiques.Vel_cut_norm(:,3:4),2)')
title('Vitesse du marqueur epaule')
subplot(2,4,6)
plot(mean(Donnees_cinematiques.Vel_cut_norm(:,3:4),2),'DisplayName','mean(Donnees_cinematiques.Vel_cut_norm(:,3:4),2)')
title('Vitesse du marqueur epaule')
subplot(2,4,7)
plot(mean(Donnees_cinematiques.Vel_cut_norm(:,3:4),2),'DisplayName','mean(Donnees_cinematiques.Vel_cut_norm(:,3:4),2)')
title('Vitesse du marqueur epaule')
subplot(2,4,8)
plot(mean(Donnees_cinematiques.Vel_cut_norm(:,3:4),2),'DisplayName','mean(Donnees_cinematiques.Vel_cut_norm(:,3:4),2)')
title('Vitesse du marqueur epaule')


%%% PLOT GRAPHS CUISSES  
figure('Name','Signaux EMG muscles de la cuisse','NumberTitle','off');
subplot(2,4,1)
plot(mean(Donnees_EMG.RMSCutNorm.ST(:,1:2),2),'DisplayName','mean(Donnees_EMG.RMSCutNorm.ST(:,1:2),2)')
title('Subplot 5 (se rassoir): ST')
subplot(2,4,2)
plot(mean(Donnees_EMG.RMSCutNorm.BF(:,1:2),2),'DisplayName','mean(Donnees_EMG.RMSCutNorm.BF(:,1:2),2)')
title('Subplot 6 (se rassoir): BF')
subplot(2,4,3)
plot(mean(Donnees_EMG.RMSCutNorm.RF(:,1:2),2),'DisplayName','mean(Donnees_EMG.RMSCutNorm.RF(:,1:2),2)')
title('Subplot 7 (se rassoir): RF')
subplot(2,4,4)
plot(mean(Donnees_EMG.RMSCutNorm.VL(:,1:2),2),'DisplayName','mean(Donnees_EMG.RMSCutNorm.VL(:,1:2),2)')
title('Subplot 8 (se rassoir): VL')

subplot(2,4,5)
plot(mean(Donnees_cinematiques.Vel_cut_norm(:,1:2),2),'DisplayName','mean(Donnees_cinematiques.Vel_cut_norm(:,1:2),2)')
title('Vitesse marqueur épaule mvt BTS')
subplot(2,4,6)
plot(mean(Donnees_cinematiques.Vel_cut_norm(:,1:2),2),'DisplayName','mean(Donnees_cinematiques.Vel_cut_norm(:,1:2),2)')
title('Vitesse marqueur épaule mvt BTS')
subplot(2,4,7)
plot(mean(Donnees_cinematiques.Vel_cut_norm(:,1:2),2),'DisplayName','mean(Donnees_cinematiques.Vel_cut_norm(:,1:2),2)')
title('Vitesse marqueur épaule mvt BTS')
subplot(2,4,8)
plot(mean(Donnees_cinematiques.Vel_cut_norm(:,1:2),2),'DisplayName','mean(Donnees_cinematiques.Vel_cut_norm(:,1:2),2)')
title('Vitesse marqueur épaule mvt BTS')


% %%% PLOT GRAPHS BRAS  
% figure('Name','Signaux EMG muscles des bras','NumberTitle','off');
% subplot(2,4,1)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,7:9),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,7:9)')
% title('Subplot 5 (se baisser): DA')
% subplot(2,4,2)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,10:12),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,10:12)')
% title('Subplot 6 (se baisser): DP')
% subplot(2,4,3)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,13:15),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,13:15)')
% title('Subplot 7 (se baisser): DAG')
% subplot(2,4,4)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,16:18),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,16:18)')
% title('Subplot 8 (se baisser): DPG')
% subplot(2,4,5)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,7:9),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,7:9)')
% title('Subplot 1 (se relever): DA')
% subplot(2,4,6)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,10:12),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,10:12)')
% title('Subplot 2 (se relever): DP')
% subplot(2,4,7)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,13:15),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,13:15)')
% title('Subplot 3 (se relever): DAG')
% subplot(2,4,8)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,16:18),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,16:18)')
% title('Subplot 4 (se relever): DPG')
% 
% %%% PLOT GRAPHS TRONCS
% figure('Name','Signaux EMG muscles des tronc','NumberTitle','off');
% subplot(2,3,1)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,1:3),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,1:3)')
% title('Subplot 4 (se baisser): RAS')
% subplot(2,3,2)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,4:6),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,4:6)')
% title('Subplot 5 (se baisser): ErecL1')
% subplot(2,3,3)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,40:42),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,40:42)')
% title('Subplot 6 (se baisser): ErecD1')
% subplot(2,3,4)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,1:3),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,1:3)')
% title('Subplot 1 (se relever): RAS')
% subplot(2,3,5)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,4:6),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,4:6)')
% title('Subplot 2 (se relever): ErecL1')
% subplot(2,3,6)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,40:42),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,40:42)')
% title('Subplot 3 (se relever): ErecD1')
% 
% 
% %%% PLOT GRAPHS CUISSES  
% figure('Name','Signaux EMG muscles de la cuisse','NumberTitle','off');
% subplot(2,4,1)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,19:21),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,19:21)')
% title('Subplot 5 (se baisser): ST')
% subplot(2,4,2)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,22:24),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,22:24)')
% title('Subplot 6 (se baisser): BF')
% subplot(2,4,3)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,25:27),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,25:27)')
% title('Subplot 7 (se baisser): RF')
% subplot(2,4,4)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,28:30),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,28:30)')
% title('Subplot 8 (se baisser): VL')
% subplot(2,4,5)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,19:21),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,19:21)')
% title('Subplot 1 (se relever): ST')
% subplot(2,4,6)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,22:24),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,22:24)')
% title('Subplot 2 (se relever): BF')
% subplot(2,4,7)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,25:27),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,25:27)')
% title('Subplot 3 (se relever): RF')
% subplot(2,4,8)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,28:30),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,28:30)')
% title('Subplot 4 (se relever): VL')
% 
% %%% PLOT GRAPHS JAMBES
% figure('Name','Signaux EMG muscles de la jambe','NumberTitle','off');
% subplot(2,3,1)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,34:36),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,34:36)')
% title('Subplot 4 (se baisser): SOL')
% subplot(2,3,2)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,37:39),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,37:39)')
% title('Subplot 5 (se baisser): GM')
% subplot(2,3,3)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,31:33),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,31:33)')
% title('Subplot 6 (se baisser): TA')
% subplot(2,3,4)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,34:36),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,34:36)')
% title('Subplot 1 (se relever): SOL')
% subplot(2,3,5)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,37:39),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,37:39)')
% title('Subplot 2 (se relever): GM')
% subplot(2,3,6)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,31:33),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,31:33)')
% title('Subplot 3 (se relever): TA')


    %% Partie qui permet de trier les essais par vitesse, de les moyenner par trois et de recalculer les paramètres cinématiques dessus
 
 SortVmean_R = Donnees_cinematiques.Results_trial_by_trial(1:numel(ListeFichier), 9);
 SortVmean_B = Donnees_cinematiques.Results_trial_by_trial((numel(ListeFichier)+1):(2*numel(ListeFichier)), 9);
 [~, Idx_R] = sort(SortVmean_R);
 [~, Idx_B] = sort(SortVmean_B);
 
 % On sauve l'index pour trier aussi les phasiques
 Idx = {};
 Idx.R = Idx_R;
 Idx.B = Idx_B;
 Idx.Vmean_R = SortVmean_R(Idx_R);
 Idx.Vmean_B = SortVmean_B(Idx_B);
 Idx.EMD = EMD*emg_frequency;
 Idx.anticip = anticip*emg_frequency;
 Idx.Nb_averaged_trials = Nb_averaged_trials;
 % J'ajoute dans la matrice un booléen pour savoir si on est en condition
 % horizontale ou verticale. On pondèrera le tonic avec la valeur de Torque
 % uniquement en condition verticale
 if data_sequence(i) == 1 | data_sequence(i) == 2
     Idx.data_sequence = 1;
     
 else 
     Idx.data_sequence = 0;
     
 end
 
 Donnees_cinematiques.VelCutSort.R = Donnees_cinematiques.Vel_cut_brut(:, 1:numel(ListeFichier));
 Donnees_cinematiques.VelCutSort.B = Donnees_cinematiques.Vel_cut_brut(:, (numel(ListeFichier)+1):(2*numel(ListeFichier)));

 Donnees_cinematiques.VelCutSort.R = Donnees_cinematiques.VelCutSort.R(:, Idx_R);
 Donnees_cinematiques.VelCutSort.B = Donnees_cinematiques.VelCutSort.B(:, Idx_B);
 
 [ligR, colR] = size(Donnees_cinematiques.VelCutSort.R);
 [ligB, colB] = size(Donnees_cinematiques.VelCutSort.B);
 % On remplace les zéros des profils de vitesse par des Nan pour un
 % meilleur signal dérivé
 
 for w = 1:colR
     for v = 1:ligR
         
         if Donnees_cinematiques.VelCutSort.R(v, w) == 0
             Donnees_cinematiques.VelCutSort.R(v, w) = NaN;
         end
     end
 end
 
 for w = 1:colB
     for v = 1:ligB
         
         if Donnees_cinematiques.VelCutSort.B(v, w) == 0
             Donnees_cinematiques.VelCutSort.B(v, w) = NaN;
         end
     end
 end
 
 Donnees_cinematiques.Param_R = Donnees_cinematiques.Results_trial_by_trial(1:numel(ListeFichier), :);
 Donnees_cinematiques.Param_B = Donnees_cinematiques.Results_trial_by_trial((numel(ListeFichier)+1):(2*numel(ListeFichier)), :);
 
 Donnees_cinematiques.Param_R = Donnees_cinematiques.Param_R(Idx_R, :);
 Donnees_cinematiques.Param_B = Donnees_cinematiques.Param_B(Idx_B, :);
 ind_m = 1;
 for ind = 1:Nb_averaged_trials:numel(ListeFichier)-Nb_averaged_trials+1
 
     Donnees_cinematiques.Param_R_Mean(ind_m, :) = mean(Donnees_cinematiques.Param_R(ind:ind+Nb_averaged_trials-1, :));
     Donnees_cinematiques.Param_B_Mean(ind_m, :) = mean(Donnees_cinematiques.Param_B(ind:ind+Nb_averaged_trials-1, :));
     ind_m = ind_m+1;
 end
 
 % On ajoute T-PA, T-PV et T-PV-END
 
 for ind = 1:colR/Nb_averaged_trials
     Donnees_cinematiques.Param_R_Mean(ind, 13) = Donnees_cinematiques.Param_R_Mean(ind, 2)*Donnees_cinematiques.Param_R_Mean(ind, 3);
     Donnees_cinematiques.Param_B_Mean(ind, 13) = Donnees_cinematiques.Param_B_Mean(ind, 2)*Donnees_cinematiques.Param_B_Mean(ind, 3);
     
     Donnees_cinematiques.Param_R_Mean(ind, 14) = Donnees_cinematiques.Param_R_Mean(ind, 2)*Donnees_cinematiques.Param_R_Mean(ind, 4);
     Donnees_cinematiques.Param_B_Mean(ind, 14) = Donnees_cinematiques.Param_B_Mean(ind, 2)*Donnees_cinematiques.Param_B_Mean(ind, 4);

     Donnees_cinematiques.Param_R_Mean(ind, 15) = Donnees_cinematiques.Param_R_Mean(ind, 2)-Donnees_cinematiques.Param_R_Mean(ind, 14);
     Donnees_cinematiques.Param_B_Mean(ind, 15) = Donnees_cinematiques.Param_B_Mean(ind, 2)-Donnees_cinematiques.Param_B_Mean(ind, 14);
 
 end
 Donnees_cinematiques.Param_R_Mean = real(Donnees_cinematiques.Param_R_Mean);
  Donnees_cinematiques.Param_B_Mean = real(Donnees_cinematiques.Param_B_Mean);
 % On crée une matrice des profils d'accél triés
 
 Donnees_cinematiques.accelsort.R = Donnees_cinematiques.AccelCut.R(:, Idx_R);
 Donnees_cinematiques.accelsort.B = Donnees_cinematiques.AccelCut.B(:, Idx_B);
 
 % On crée des profils de vitesse et d'accel moyens
 
 Profil_vitesse_moy_R = meantrials(Donnees_cinematiques.VelCutSort.R, Nb_averaged_trials);
 Profil_vitesse_moy_B = meantrials(Donnees_cinematiques.VelCutSort.B, Nb_averaged_trials);
 
 
 Profil_accel_moy_R = meantrials(Donnees_cinematiques.accelsort.R, Nb_averaged_trials);
 Profil_accel_moy_B = meantrials(Donnees_cinematiques.accelsort.B, Nb_averaged_trials);
 
 
 [lig_pa_R, ~] = size(Profil_accel_moy_R);
 [lig_pa_B, ~] = size(Profil_accel_moy_B);
 
 Donnees_cinematiques.SITMean.R = Profil_accel_moy_R./(1000*moment_inertie_bras);
 Donnees_cinematiques.SITMean.B = Profil_accel_moy_R./(1000*moment_inertie_bras);
 
 Donnees_cinematiques.SITMean.R = Donnees_cinematiques.SITMean.R./lgbras_sujet;
 Donnees_cinematiques.SITMean.B = Donnees_cinematiques.SITMean.B./lgbras_sujet;
 
 % On fait pareil avec les profils avec l'anticipation

 Donnees_cinematiques.antvelocity.R = Donnees_cinematiques.antvelocity.R(:, Idx_R);
 Donnees_cinematiques.antvelocity.B = Donnees_cinematiques.antvelocity.B(:, Idx_B);
 
 Donnees_cinematiques.antaccel.B = derive(Donnees_cinematiques.antvelocity.B, 1)./(1/Frequence_acquisition);
 Donnees_cinematiques.antaccel.R = derive(Donnees_cinematiques.antvelocity.R, 1)./(1/Frequence_acquisition);
 
 Profil_vitesse_ant_R = meantrials(Donnees_cinematiques.antvelocity.R, Nb_averaged_trials);
 Profil_vitesse_ant_B = meantrials(Donnees_cinematiques.antvelocity.B, Nb_averaged_trials);
 
 Profil_accel_ant_R = meantrials(Donnees_cinematiques.antaccel.R, Nb_averaged_trials);
 Profil_accel_ant_B = meantrials(Donnees_cinematiques.antaccel.B, Nb_averaged_trials);
 
 % On calcule les paramètres cinématiques sur les profils triés et moyennés
 
 for k = 1:colR/Nb_averaged_trials
     
     Donnees_cinematiques.Profils_means.Results.R(k, 1) = max(Profil_accel_moy_R(:, k));
     Donnees_cinematiques.Profils_means.Results.B(k, 1) = max(Profil_accel_moy_B(:, k));
     
     Donnees_cinematiques.Profils_means.Results.R(k, 7) = min(Profil_accel_moy_R(:, k));
     Donnees_cinematiques.Profils_means.Results.B(k, 7) = min(Profil_accel_moy_B(:, k));
     
     Donnees_cinematiques.Profils_means.Results.R(k, 2) = max(Profil_vitesse_moy_R(:, k));
     Donnees_cinematiques.Profils_means.Results.B(k, 2) = max(Profil_vitesse_moy_B(:, k));
        
     [~, ind_pa_R] = max(Profil_accel_moy_R(:, k));
     [~, ind_pa_B] = max(Profil_accel_moy_B(:, k));
     
     [~, ind_pv_R] = max(Profil_vitesse_moy_R(:, k));
     [~, ind_pv_B] = max(Profil_vitesse_moy_B(:, k));
     
     Donnees_cinematiques.Profils_means.Results.R(k, 3) = ind_pa_R/Frequence_acquisition;
     Donnees_cinematiques.Profils_means.Results.B(k, 3) = ind_pa_B/Frequence_acquisition;
     
     Donnees_cinematiques.Profils_means.Results.R(k, 4) = ind_pv_R/Frequence_acquisition;
     Donnees_cinematiques.Profils_means.Results.B(k, 4) = ind_pv_B/Frequence_acquisition;
     
     a = ind_pv_R;
     
     while Profil_vitesse_moy_R(a, k) > Profil_vitesse_moy_R(1, k) && a<ligR
         a = a+1;
     end
     
     b = ind_pv_B;
     
     while Profil_vitesse_moy_B(b, k) > Profil_vitesse_moy_B(1, k) && b<ligB
         b = b+1;
     end
     
     
     Donnees_cinematiques.Profils_means.Results.R(k, 5) = a/Frequence_acquisition;
     Donnees_cinematiques.Profils_means.Results.B(k, 5) = b/Frequence_acquisition;
     
     Mean_Baseline_Vitesse_R = mean(Donnees_cinematiques.antvelocity.R(10:20, k));
     Mean_Baseline_Vitesse_B = mean(Donnees_cinematiques.antvelocity.B(10:20, k));
     
     Std_Baseline_Vitesse_R = std(Donnees_cinematiques.antvelocity.R(10:20, k));
     Std_Baseline_Vitesse_B = std(Donnees_cinematiques.antvelocity.B(10:20, k));
     
     g = ind_pv_R+25;
     
     while Profil_vitesse_ant_R(g, k) > Mean_Baseline_Vitesse_R+ICvalueK*Std_Baseline_Vitesse_R && g>1
         g = g-1;
         
     end
     
     d = ind_pv_B+25;
     
     while Profil_vitesse_ant_B(d, k) > Mean_Baseline_Vitesse_B+ICvalueK*Std_Baseline_Vitesse_B && d>1
         d = d-1;
         
     end
     
     Donnees_cinematiques.Profils_means.Results.R(k, 6) = g*10;
     Donnees_cinematiques.Profils_means.Results.B(k, 6) = d*10;
     
     
 end 
     
     %% On effectue le second process des Données EMG pour chaque muscle
     
     % On sort les localmax pour enlever les essais à supprimer
     
     localmax = Donnees_cinematiques.Results_trial_by_trial(:, 15);
     
     % On sort la vitesse moyenne du mouvement correspondant à un signal
     % RMS
     
     Vmean_RMS  = Donnees_cinematiques.Results_trial_by_trial(:, 9);
     
     % On calcule le phasique pour chaque muscle
      [EMG_traite.DA, Tonic.DA, Vmean_RMS_R, Vmean_RMS_B, Profil_tonic_R.DA, Profil_tonic_B.DA] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.DA, Donnees_EMG.RMSCutNorm.DA, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.DA, Donnees_EMG.TonicEnd.DA, localmax, Idx);
      [EMG_traite.DP, Tonic.DP, ~, ~, Profil_tonic_R.DP, Profil_tonic_B.DP] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.DP, Donnees_EMG.RMSCutNorm.DP, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.DP, Donnees_EMG.TonicEnd.DP, localmax, Idx);
      [EMG_traite.ST, Tonic.ST, ~, ~, Profil_tonic_R.ST, Profil_tonic_B.ST] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.ST, Donnees_EMG.RMSCutNorm.ST, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.ST, Donnees_EMG.TonicEnd.ST, localmax, Idx);
      [EMG_traite.BF, Tonic.BF, ~, ~, Profil_tonic_R.BF, Profil_tonic_B.BF] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.BF, Donnees_EMG.RMSCutNorm.BF, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.BF, Donnees_EMG.TonicEnd.BF, localmax, Idx);
      [EMG_traite.SOL, Tonic.SOL, ~, ~, Profil_tonic_R.SOL, Profil_tonic_B.SOL] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.SOL, Donnees_EMG.RMSCutNorm.SOL, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.SOL, Donnees_EMG.TonicEnd.SOL, localmax, Idx);
      [EMG_traite.RF, Tonic.RF, ~, ~, Profil_tonic_R.RF, Profil_tonic_B.RF] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.RF, Donnees_EMG.RMSCutNorm.RF, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.RF, Donnees_EMG.TonicEnd.RF, localmax, Idx);
      [EMG_traite.RAS, Tonic.RAS, ~, ~, Profil_tonic_R.RAS, Profil_tonic_B.RAS] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.RAS, Donnees_EMG.RMSCutNorm.RAS, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.RAS, Donnees_EMG.TonicEnd.RAS, localmax, Idx);
      [EMG_traite.ESL1, Tonic.ESL1, ~, ~, Profil_tonic_R.ESL1, Profil_tonic_B.ESL1] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.ESL1, Donnees_EMG.RMSCutNorm.ESL1, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.ESL1, Donnees_EMG.TonicEnd.ESL1, localmax, Idx);
      [EMG_traite.DAG, Tonic.DAG, ~, ~, Profil_tonic_R.DAG, Profil_tonic_B.DAG] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.DAG, Donnees_EMG.RMSCutNorm.DAG, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.DAG, Donnees_EMG.TonicEnd.DAG, localmax, Idx);
      [EMG_traite.DPG, Tonic.DPG, ~, ~, Profil_tonic_R.DPG, Profil_tonic_B.DPG] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.DPG, Donnees_EMG.RMSCutNorm.DPG, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.DPG, Donnees_EMG.TonicEnd.DPG, localmax, Idx);
      [EMG_traite.VL, Tonic.VL, ~, ~, Profil_tonic_R.VL, Profil_tonic_B.VL] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.VL, Donnees_EMG.RMSCutNorm.VL, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.VL, Donnees_EMG.TonicEnd.VL, localmax, Idx);
      [EMG_traite.TA, Tonic.TA, ~, ~, Profil_tonic_R.TA, Profil_tonic_B.TA] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.TA, Donnees_EMG.RMSCutNorm.TA, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.TA, Donnees_EMG.TonicEnd.TA, localmax, Idx);
      [EMG_traite.GM, Tonic.GM, ~, ~, Profil_tonic_R.GM, Profil_tonic_B.GM] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.GM, Donnees_EMG.RMSCutNorm.GM, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.GM, Donnees_EMG.TonicEnd.GM, localmax, Idx);
      [EMG_traite.ESD7, Tonic.ESD7, ~, ~, Profil_tonic_R.ESD7, Profil_tonic_B.ESD7] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.ESD7, Donnees_EMG.RMSCutNorm.ESD7, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.ESD7, Donnees_EMG.TonicEnd.ESD7, localmax, Idx);
      
      
% %%% PLOT GRAPHS BRAS  
% figure('Name','Signaux EMG muscles des bras','NumberTitle','off');
% subplot(2,4,1)
% plot(EMG_traite.DA.nonsmooth.brut.B,'DisplayName','EMG_traite.DA.nonsmooth.brut.B')
% title('Subplot 5 (se baisser): DA')
% subplot(2,4,2)
% plot(EMG_traite.DP.nonsmooth.brut.B,'DisplayName','EMG_traite.DP.nonsmooth.brut.B')
% title('Subplot 6 (se baisser): DP')
% subplot(2,4,3)
% plot(EMG_traite.DAG.nonsmooth.brut.B,'DisplayName','EMG_traite.DAG.nonsmooth.brut.B')
% title('Subplot 7 (se baisser): DAG')
% subplot(2,4,4)
% plot(EMG_traite.DPG.nonsmooth.brut.B,'DisplayName','EMG_traite.DPG.nonsmooth.brut.B')
% title('Subplot 8 (se baisser): DPG')
% subplot(2,4,5)
% plot(EMG_traite.DA.nonsmooth.brut.R,'DisplayName','EMG_traite.DA.nonsmooth.brut.R')
% title('Subplot 1 (se relever): DA')
% subplot(2,4,6)
% plot(EMG_traite.DP.nonsmooth.brut.R,'DisplayName','EMG_traite.DP.nonsmooth.brut.R')
% title('Subplot 2 (se relever): DP')
% subplot(2,4,7)
% plot(EMG_traite.DAG.nonsmooth.brut.R,'DisplayName','EMG_traite.DAG.nonsmooth.brut.R')
% title('Subplot 3 (se relever): DAG')
% subplot(2,4,8)
% plot(EMG_traite.DPG.nonsmooth.brut.R,'DisplayName','EMG_traite.DPG.nonsmooth.brut.R')
% title('Subplot 4 (se relever): DPG')
% 
% %%% PLOT GRAPHS TRONCS
% figure('Name','Signaux EMG muscles des tronc','NumberTitle','off');
% subplot(2,3,1)
% plot(EMG_traite.RAS.nonsmooth.brut.B,'DisplayName','EMG_traite.RAS.nonsmooth.brut.B')
% title('Subplot 4 (se baisser): RAS')
% subplot(2,3,2)
% plot(EMG_traite.ESL1.nonsmooth.brut.B,'DisplayName','EMG_traite.ESL1.nonsmooth.brut.B')
% title('Subplot 5 (se baisser): ErecL1')
% subplot(2,3,3)
% plot(EMG_traite.ESD7.nonsmooth.brut.B,'DisplayName','EMG_traite.ESD7.nonsmooth.brut.B')
% title('Subplot 6 (se baisser): ErecD1')
% subplot(2,3,4)
% plot(EMG_traite.RAS.nonsmooth.brut.R,'DisplayName','EMG_traite.RAS.nonsmooth.brut.R')
% title('Subplot 1 (se relever): RAS')
% subplot(2,3,5)
% plot(EMG_traite.ESL1.nonsmooth.brut.R,'DisplayName','EMG_traite.ESL1.nonsmooth.brut.R')
% title('Subplot 2 (se relever): ErecL1')
% subplot(2,3,6)
% plot(EMG_traite.ESD7.nonsmooth.brut.R,'DisplayName','EMG_traite.ESD7.nonsmooth.brut.R')
% title('Subplot 3 (se relever): ErecD1')
% 
% 
% %%% PLOT GRAPHS CUISSES  
% figure('Name','Signaux EMG muscles de la cuisse','NumberTitle','off');
% subplot(2,4,1)
% plot(EMG_traite.ST.nonsmooth.brut.B,'DisplayName','EMG_traite.ST.nonsmooth.brut.B')
% title('Subplot 5 (se baisser): ST')
% subplot(2,4,2)
% plot(EMG_traite.BF.nonsmooth.brut.B,'DisplayName','EMG_traite.BF.nonsmooth.brut.B')
% title('Subplot 6 (se baisser): BF')
% subplot(2,4,3)
% plot(EMG_traite.RF.nonsmooth.brut.B,'DisplayName','EMG_traite.RF.nonsmooth.brut.B')
% title('Subplot 7 (se baisser): RF')
% subplot(2,4,4)
% plot(EMG_traite.VL.nonsmooth.brut.B,'DisplayName','EMG_traite.VL.nonsmooth.brut.B')
% title('Subplot 8 (se baisser): VL')
% subplot(2,4,5)
% plot(EMG_traite.ST.nonsmooth.brut.R,'DisplayName','EMG_traite.ST.nonsmooth.brut.R')
% title('Subplot 1 (se relever): ST')
% subplot(2,4,6)
% plot(EMG_traite.BF.nonsmooth.brut.R,'DisplayName','EMG_traite.BF.nonsmooth.brut.R')
% title('Subplot 2 (se relever): BF')
% subplot(2,4,7)
% plot(EMG_traite.RF.nonsmooth.brut.R,'DisplayName','EMG_traite.RF.nonsmooth.brut.R')
% title('Subplot 3 (se relever): RF')
% subplot(2,4,8)
% plot(EMG_traite.VL.nonsmooth.brut.R,'DisplayName','EMG_traite.VL.nonsmooth.brut.R')
% title('Subplot 4 (se relever): VL')
% 
% %%% PLOT GRAPHS JAMBES
% figure('Name','Signaux EMG muscles de la jambe','NumberTitle','off');
% subplot(2,3,1)
% plot(EMG_traite.SOL.nonsmooth.brut.B,'DisplayName','EMG_traite.SOL.nonsmooth.brut.B')
% title('Subplot 4 (se baisser): SOL')
% subplot(2,3,2)
% plot(EMG_traite.GM.nonsmooth.brut.B,'DisplayName','EMG_traite.GM.nonsmooth.brut.B')
% title('Subplot 5 (se baisser): GM')
% subplot(2,3,3)
% plot(EMG_traite.TA.nonsmooth.brut.B,'DisplayName','EMG_traite.TA.nonsmooth.brut.B')
% title('Subplot 6 (se baisser): TA')
% subplot(2,3,4)
% plot(EMG_traite.SOL.nonsmooth.brut.R,'DisplayName','EMG_traite.SOL.nonsmooth.brut.R')
% title('Subplot 1 (se relever): SOL')
% subplot(2,3,5)
% plot(EMG_traite.GM.nonsmooth.brut.R,'DisplayName','EMG_traite.GM.nonsmooth.brut.R')
% title('Subplot 2 (se relever): GM')
% subplot(2,3,6)
% plot(EMG_traite.TA.nonsmooth.brut.R,'DisplayName','EMG_traite.TA.nonsmooth.brut.R')
% title('Subplot 3 (se relever): TA')


%%%%%%%%%%
%%%%%%%%%%
% PLOT RMS CUT SIGNALS
%%%%%%%%%%
%%%%%%%%%%





     % On calcule maintenant les paramètres EMG pour chaque muscle à partir
     % du phasique
     
%      [Results_EMG.Biceps] = param_EMG2(EMG_traite.Biceps, Tonic.Biceps, Min_emg_duration, emg_frequency, anticip, ICvalue, Tresholdvalue, Vmean_RMS_R, Vmean_RMS_B, Cutoff_emg, Donnees_cinematiques.Profils_means.Results.R, Donnees_cinematiques.Profils_means.Results.B, 1, EMD);
      [Results_EMG.DA] = param_EMG2_Brasdom_nondom(EMG_traite.DA, Tonic.DA, Min_emg_duration, emg_frequency, anticip, ICvalue, Tresholdvalue, Vmean_RMS_R, Vmean_RMS_B, Cutoff_emg, Donnees_cinematiques.Param_R_Mean, Donnees_cinematiques.Param_B_Mean, 1, EMD, Profil_tonic_R.DA, Profil_tonic_B.DA);
%      [Results_EMG.PM] = param_EMG2(EMG_traite.PM, Tonic.PM, Min_emg_duration, emg_frequency, anticip, ICvalue, Tresholdvalue, Vmean_RMS_R, Vmean_RMS_B, Cutoff_emg, Donnees_cinematiques.Profils_means.Results.R, Donnees_cinematiques.Profils_means.Results.B, 1, EMD);
      [Results_EMG.DP] = param_EMG2_Brasdom_nondom(EMG_traite.DP, Tonic.DP, Min_emg_duration, emg_frequency, anticip, ICvalue, Tresholdvalue, Vmean_RMS_R, Vmean_RMS_B, Cutoff_emg, Donnees_cinematiques.Param_R_Mean, Donnees_cinematiques.Param_B_Mean, 2, EMD, Profil_tonic_R.DP, Profil_tonic_B.DP);
%      [Results_EMG.GR] = param_EMG2(EMG_traite.GR, Tonic.GR, Min_emg_duration, emg_frequency, anticip, ICvalue, Tresholdvalue, Vmean_RMS_R, Vmean_RMS_B, Cutoff_emg, Donnees_cinematiques.Profils_means.Results.R, Donnees_cinematiques.Profils_means.Results.B, 2, EMD);
%      [Results_EMG.GD] = param_EMG2(EMG_traite.GD, Tonic.GD, Min_emg_duration, emg_frequency, anticip, ICvalue, Tresholdvalue, Vmean_RMS_R, Vmean_RMS_B, Cutoff_emg, Donnees_cinematiques.Profils_means.Results.R, Donnees_cinematiques.Profils_means.Results.B, 2, EMD);
%      [Results_EMG.Triceps] = param_EMG2(EMG_traite.Triceps, Tonic.Triceps, Min_emg_duration, emg_frequency, anticip, ICvalue, Tresholdvalue, Vmean_RMS_R, Vmean_RMS_B, Cutoff_emg, Donnees_cinematiques.Profils_means.Results.R, Donnees_cinematiques.Profils_means.Results.B, 2, EMD);
     end


Donnees_cinematiques.Results_trial_by_trial = real(Donnees_cinematiques.Results_trial_by_trial);

% je charge les paramètres EMG sur la première direction
Results = {};
Results.DA(1:8, 15:26) = Results_EMG.DA.R(1:8, 1:12);
Results.DP(1:8, 15:26) = Results_EMG.DP.R(1:8, 1:12);

% Et sur la deuxième

Results.DA(1:8, 1:12) = Results_EMG.DA.B(1:8, 1:12);
Results.DP(1:8, 1:12) = Results_EMG.DP.B(1:8, 1:12);

%MD
Results.DA(1:8, 27) = Donnees_cinematiques.Param_R_Mean(1:8, 2);
Results.DP(1:8, 27) = Donnees_cinematiques.Param_R_Mean(1:8, 2);


Results.DA(1:8, 13) = Donnees_cinematiques.Param_B_Mean(1:8, 2);
Results.DP(1:8, 13) = Donnees_cinematiques.Param_B_Mean(1:8, 2);

%% On sauvegarde les données cinématiques, les profils RMS, les profils phasiques et les paramètres EMG

save([Dossier '\' 'Kin.mat'], 'Donnees_cinematiques');
save([Dossier '\' 'Phasique.mat'], 'EMG_traite');
save([Dossier '\' 'RMS.mat'], 'Donnees_EMG');
save([Dossier '\' 'Param_EMG.mat'], 'Results_EMG');

