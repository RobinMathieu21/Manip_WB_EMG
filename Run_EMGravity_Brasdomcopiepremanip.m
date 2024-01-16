    
%% Script pour Manip EMGravity
% A executer dans un dossier de 30 essais contenant aussi le dossier de
% data sequence. Le script sort une matrice contenant les données
% cinématiques, essai par essai et triés en fonction de la cible. 

close all
clear all

%% Informations sur le traitement des données
Low_pass_Freq = 5; %fréquence passe-bas la position
Cut_off = 0.1; %pourcentage du pic de vitesse pour déterminer début et fin du mouvement
Ech_norm_kin = 1000; %Fréquence d'échantillonage du profil de vitesse normalisé en durée 
Frequence_acquisition = 200;%Fréquence d'acquisition du signal cinématique
emg_band_pass_Freq = [30 300] % Passe_bande du filtre EMG
emg_low_pass_Freq = 20 %fréquence passe_bas lors du second filtre du signal emg. 100 est la fréquence habituelle chez les humains (cf script Jérémie)
emg_ech_norm = 1000; %Fréquence d'échantillonage du signal EMG
anticip_kin_amp = 0.1; %Temps en secondes pour avoir la position avant et après le début du mouvement pour le calcul de l'amplitude
anticip = 0.25 %Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée
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
Nb_emgs = 6 %Spécification du nombre de channels EMG (Il y en a 14, mais pour le bras la 3 et la 4 nous interressent)
if type_RMS == 1
    rms_window = 50; %time in ms of the window used to compute sliding root mean square of EMG
end
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
       
       % On sort la position des 2 cibles, la distance entre les 2
       
       cible_rouge = C3D.Cinematique.Donnees(:, 29:31);
       pos_cible_rouge = mean(cible_rouge);
       
       cible_bleue = C3D.Cinematique.Donnees(:, 21:23);
       pos_cible_bleue = mean(cible_bleue);
       
       % Je trouve quelle est la cible rouge et quelle est la bleue en auto
       
       cible_rouge_test = pos_cible_rouge;
       cible_bleue_test = pos_cible_bleue;
       ht_cb_bleue = pos_cible_bleue(1, 3);
       ht_cb_rouge = pos_cible_rouge(1, 3);
       
       if ht_cb_rouge < ht_cb_bleue
           pos_cible_rouge = cible_bleue_test;
           pos_cible_bleue = cible_rouge_test;
       end

        %On crée une matrice de la position du doigt et de l'épaule
        posxyz = C3D.Cinematique.Donnees(:, 81:83);
        pos_epaule = C3D.Cinematique.Donnees(:, 61:63);   %%%% BRAS DROIT
%         posxyz = C3D.Cinematique.Donnees(:, 57:59);
%         pos_epaule = C3D.Cinematique.Donnees(:, 41:43); %%%% BRAS GAUCHE
%         posxyz = C3D.Cinematique.Donnees(:, 85:87);
%         pos_epaule = C3D.Cinematique.Donnees(:, 61:63);   %%%% chloe bras droit
%         posxyz = C3D.Cinematique.Donnees(:, 57:59);
%         pos_epaule = C3D.Cinematique.Donnees(:, 37:39);   %%%% chloe bras gauche

%a_muscle = 1;
a_muscle = 3;
% MUSCLE_1 = 3; % POUR DELTO A DROIT
% MUSCLE_2 = 4; % POUR DELTO P DROIT
MUSCLE_1 = 5; % POUR DELTO A gauche
MUSCLE_2 = 6; % POUR DELTO P gauche
        [posxyz_lig, ~] = size(posxyz);
        
        %On filtre le signal de position
        posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
        posfiltre_epaule = butter_emgs(pos_epaule, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
       
        %On coupe le signal de vitesse pour avoir 2 plages contenant chacune un mouvement
       
        if data_sequence(i) == 1 | data_sequence(i) == 2
           plot(posfiltre(:, 3))
           [Cut] = ginput(3);
        else
            plot(posfiltre(:, 1))
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
        [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_1, profil_vitesse_1_norm, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, Vmoy_1, Param_C_1, Amp_1, Angle_mvmt_1, erreur_cible_bleue_1, erreur_cible_rouge_1, Nbmaxloc_1, debut_1, fin_1, Amp_reel_1, Angle_reel_1, profil_accel_1] = compute_kinematics_BrasDom_nondom(Pos_mvmt_1, Pos_epaule_mvmt_1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin, anticip_kin_amp, pos_cible_bleue, pos_cible_rouge);
        
        % Second Mouvement
        [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_2, profil_vitesse_2_norm, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, Vmoy_2, Param_C_2, Amp_2, Angle_mvmt_2, erreur_cible_bleue_2, erreur_cible_rouge_2, Nbmaxloc_2, debut_2, fin_2, Amp_reel_2, Angle_reel_2, profil_accel_2] = compute_kinematics_BrasDom_nondom(Pos_mvmt_2, Pos_epaule_mvmt_2, Frequence_acquisition, 1, Cut_off, Ech_norm_kin, anticip_kin_amp, pos_cible_bleue, pos_cible_rouge);

       
        
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
                        
            Donnees_cinematiques.Results_trial_by_trial(i, 15) = Nbmaxloc_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 15) = Nbmaxloc_2 ;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 13) = erreur_cible_bleue_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 13) = erreur_cible_rouge_2 ;
                     
            
        else
                       
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
            
            Donnees_cinematiques.Results_trial_by_trial(i, 15) = Nbmaxloc_2;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 15) = Nbmaxloc_1 ;
            
            Donnees_cinematiques.Results_trial_by_trial(i, 13) = erreur_cible_bleue_2;
           Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 13) = erreur_cible_rouge_1 ;
            
           % Donnees_cinematiques.Results_trial_by_trial(i, 14) = erreur_angulaire_mvmt_2;
           %Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 14) = erreur_angulaire_mvmt_1 ;
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
        
        ligantpos1 = offset_1-onset_1+26;
        ligantpos2 = offset_2-onset_2+26;
        
        if data_sequence(i) == 1 | data_sequence(i) == 3
            antvelocity_B = zeros(ligantpos1, 1);
            antvelocity_R = zeros(ligantpos2, 1);
        antvelocity_B(1:ligantpos1, 1) = sqrt(derive(posfiltre(onset_1-25:offset_1, 1), 2).^2+derive(posfiltre(onset_1-25:offset_1, 2), 2).^2+derive(posfiltre(onset_1-25:offset_1, 3), 2).^2)./(1/Frequence_acquisition);
        antvelocity_R(1:ligantpos2, 1) = sqrt(derive(posfiltre(onset_2-25:offset_2, 1), 2).^2+derive(posfiltre(onset_2-25:offset_2, 2), 2).^2+derive(posfiltre(onset_2-25:offset_2, 3), 2).^2)./(1/Frequence_acquisition);
        
        Donnees_cinematiques.antvelocity.B(1:ligantpos1, i) = antvelocity_B;
        Donnees_cinematiques.antvelocity.R(1:ligantpos2, i) = antvelocity_R;
        else
            antvelocity_B = zeros(ligantpos2, 1);
            antvelocity_R = zeros(ligantpos1, 1);
        antvelocity_B(1:ligantpos2, 1) = sqrt(derive(posfiltre(onset_2-25:offset_2, 1), 2).^2+derive(posfiltre(onset_2-25:offset_2, 2), 2).^2+derive(posfiltre(onset_2-25:offset_2, 3), 2).^2)./(1/Frequence_acquisition);
        antvelocity_R(1:ligantpos1, 1) = sqrt(derive(posfiltre(onset_1-25:offset_1, 1), 2).^2+derive(posfiltre(onset_1-25:offset_1, 2), 2).^2+derive(posfiltre(onset_1-25:offset_1, 3), 2).^2)./(1/Frequence_acquisition);
        
        Donnees_cinematiques.antvelocity.B(1:ligantpos2, i) = antvelocity_B;
        Donnees_cinematiques.antvelocity.R(1:ligantpos1, i) = antvelocity_R;
        end
        
        
        


%On calcule les paramètres emg du premier mouvement
%onset_1 = 1;
%offset_1 = length(emg_data)/2;
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
Donnees_EMG.Brutes.DA(1:size_emg_data, i) = emg_data(1:size_emg_data, MUSCLE_1);
Donnees_EMG.Brutes.DP(1:size_emg_data, i) = emg_data(1:size_emg_data, MUSCLE_2);
%     
%     % Pour le signal EMG filtré
Donnees_EMG.Filtrees.DA(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, MUSCLE_1);
Donnees_EMG.Filtrees.DP(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, MUSCLE_2);  
%     
%     % Pour le signal rectifié et refiltré
Donnees_EMG.Rectifiees.DA(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, MUSCLE_1);
Donnees_EMG.Rectifiees.DP(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, MUSCLE_2);
%     
    % Pour le signal RMS
    
    % Si on veut normaliser par le max de du bloc
Donnees_EMG.RMS.DA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_1);
Donnees_EMG.RMS.DP(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_2);

%     
EMGMax_DA = max(max(Donnees_EMG.RMS.DA));
EMGMax_DP = max(max(Donnees_EMG.RMS.DP));
    
Donnees_EMG.RMS.DA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.RMS.DP(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_2)./EMGMax_DP;
    
    % Pour le mouvement RMS brut et normalisé et le tonic, on trie les signaux par direction
    
    if data_sequence(i) == 1 | data_sequence(i) == 3
        
Donnees_EMG.RMSCut.DA(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.RMSCut.DP(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, MUSCLE_2)./EMGMax_DP;
%        
Donnees_EMG.RMSCut.DA(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.RMSCut.DP(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, MUSCLE_2)./EMGMax_DP;
       
       % Mouvements Normalisés
       
Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, MUSCLE_2)./EMGMax_DP;
%        
Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, MUSCLE_2)./EMGMax_DP;
       
       % Pour le tonic au début
       
Donnees_EMG.TonicStart.DA(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.TonicStart.DP(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, MUSCLE_2)./EMGMax_DP;
%        
Donnees_EMG.TonicStart.DA(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.TonicStart.DP(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, MUSCLE_2)./EMGMax_DP;
       
       % Pour le tonic à la fin
       
Donnees_EMG.TonicEnd.DA(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.TonicEnd.DP(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, MUSCLE_2)./EMGMax_DP;
%        

Donnees_EMG.TonicEnd.DA(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.TonicEnd.DP(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, MUSCLE_2)./EMGMax_DP;
       
    else
        
Donnees_EMG.RMSCut.DA(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.RMSCut.DP(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, MUSCLE_2)./EMGMax_DP;
%        
Donnees_EMG.RMSCut.DA(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.RMSCut.DP(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, MUSCLE_2)./EMGMax_DP;
       
       % Pour les mouvements normalisés
       
Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, MUSCLE_2)./EMGMax_DP;
%        
Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, MUSCLE_2)./EMGMax_DP;

       
       % Pour le tonic au début
       
Donnees_EMG.TonicStart.DA(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.TonicStart.DP(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, MUSCLE_2)./EMGMax_DP;
%        
Donnees_EMG.TonicStart.DA(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.TonicStart.DP(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, MUSCLE_2)./EMGMax_DP;
  
       % Pour le tonic à la fin
       
Donnees_EMG.TonicEnd.DA(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.TonicEnd.DP(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, MUSCLE_2)./EMGMax_DP;
      
Donnees_EMG.TonicEnd.DA(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, MUSCLE_1)./EMGMax_DA;
Donnees_EMG.TonicEnd.DP(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, MUSCLE_2)./EMGMax_DP;

    end
    
     end
       
% %       % Si on veut normaliser par le max de du bloc, on calcule l'EMGmax
% %       % pour chaque muscle
% %       
EMGMax_DA = max(max(Donnees_EMG.RMS.DA));
EMGMax_DP = max(max(Donnees_EMG.RMS.DP));

      
      % On normalise tous les essais et les tonics par cette valeur
      
Donnees_EMG.RMSCut.DA = (Donnees_EMG.RMSCut.DA)./EMGMax_DA;
Donnees_EMG.RMSCut.DP = (Donnees_EMG.RMSCut.DP)./EMGMax_DP;
      
Donnees_EMG.TonicStart.DA = (Donnees_EMG.TonicStart.DA)./EMGMax_DA;
Donnees_EMG.TonicStart.DP = (Donnees_EMG.TonicStart.DP)./EMGMax_DP;
      
Donnees_EMG.TonicEnd.DA = (Donnees_EMG.TonicEnd.DA)./EMGMax_DA;
Donnees_EMG.TonicEnd.DP = (Donnees_EMG.TonicEnd.DP)./EMGMax_DP;
    
      % On rajoute un profil moyen avec erreur standard sur le rms_cut_norm
    
     for f = 1:1000  
%         
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 1) = mean(Donnees_EMG.RMSCutNorm.DA(f, 1:numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 4) = mean(Donnees_EMG.RMSCutNorm.DP(f, 1:numel(ListeFichier)), 2);
%         
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 2) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 1)+std(Donnees_EMG.RMSCutNorm.DA(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 5) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 4)+std(Donnees_EMG.RMSCutNorm.DP(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 3) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 1)-std(Donnees_EMG.RMSCutNorm.DA(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 6) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 4)-std(Donnees_EMG.RMSCutNorm.DP(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
% 
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 1) = mean(Donnees_EMG.RMSCutNorm.DA(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 4) = mean(Donnees_EMG.RMSCutNorm.DP(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
%         
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 2) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 1)+std(Donnees_EMG.RMSCutNorm.DA(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 5) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 4)+std(Donnees_EMG.RMSCutNorm.DP(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 3) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 1)-std(Donnees_EMG.RMSCutNorm.DA(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 6) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 4)-std(Donnees_EMG.RMSCutNorm.DP(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));

     end
     
Donnees_cinematiques.Meanstd_target(1, :) = mean(Donnees_cinematiques.Results_trial_by_trial(1:numel(ListeFichier), :));
Donnees_cinematiques.Meanstd_target(2, :) = mean(Donnees_cinematiques.Results_trial_by_trial((numel(ListeFichier)+1):(2*numel(ListeFichier)), :));
Donnees_cinematiques.Meanstd_target(3, :) = std(Donnees_cinematiques.Results_trial_by_trial(1:numel(ListeFichier), :));
Donnees_cinematiques.Meanstd_target(4, :) = std(Donnees_cinematiques.Results_trial_by_trial((numel(ListeFichier)+1):(2*numel(ListeFichier)), :));
     
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

 
 % J'en profite pour créer un tableau avec les données cinématiques
 % moyennées par 3
 
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
%      
[EMG_traite.DA, Tonic.DA, Vmean_RMS_R, Vmean_RMS_B, Profil_tonic_R.DA, Profil_tonic_B.DA] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.DA, Donnees_EMG.RMSCutNorm.DA, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.DA, Donnees_EMG.TonicEnd.DA, localmax, Idx);
%      
[EMG_traite.DP, Tonic.DP, ~, ~, Profil_tonic_R.DP, Profil_tonic_B.DP] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.DP, Donnees_EMG.RMSCutNorm.DP, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.DP, Donnees_EMG.TonicEnd.DP, localmax, Idx);

     % On calcule maintenant les paramètres EMG pour chaque muscle à partir
     % du phasique
     
end
     
[nb_ligne,nb_col] = size(Donnees_cinematiques.Vel_cut_norm);
%%%%%%%%%%%%%%%%%%%%%%%%%

for muscle=a_muscle : a_muscle+1
muscle = muscle+2;
if muscle == 3 || muscle == 5
    a=1; b=3; c=0;d=50; e=375;f=700;
else
    a=4; b=6; c= 750; d=50; e=375;f=700;
end
muscle
Titre = append('Vers le bas : ',string(C3D.EMG.Labels(muscle)),' (',string(C3D.NomSujet()),')');
figure('Name',Titre,'NumberTitle','off');
set(gcf,'position',[c,d,e,f])

subplot(4,1,1)%%%
plot(Donnees_cinematiques.Vel_cut_norm(:,1:nb_col/2),'DisplayName','Donnees_cinematiques.Vel_cut_norm(:,nb_col/2)')
title('Vitesse du marqueur doigt')
subplot(4,1,2)%%%
plot(Donnees_cinematiques.Results_trial_by_trial(:,2),'DisplayName','Donnees_cinematiques.Results_trial_by_trial(:,2)')
title('Durée des mouvements')  

subplot(4,1,3)%%%
plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,a:b),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,a:b)')
title('Profil moyen : EMG RMS cut normalisé en temps')
subplot(4,1,4)%%%
r=[0.1:0.1:1000];y = zeros(length(r),1);
if muscle ==3 || muscle == 5
    plot(EMG_traite.DA.smooth.R,'DisplayName','EMG_traite.DA.smooth.R');hold on;
else
    plot(EMG_traite.DP.smooth.R,'DisplayName','EMG_traite.DP.smooth.R');hold on;
end
plot(r,y,'r');
title('Phasic (calculé par interpolation linéaire entre début et fin)')
end

%%%%%% MVT VERS LE haut
for muscle=a_muscle : a_muscle+1
muscle = muscle+2;
if muscle == 3 || muscle == 5
    a=1; b=3; c=375;d=50; e=375;f=700;
else
    a=4; b=6; c= 1125; d=50; e=375;f=700;
end
muscle
Titre = append('Vers le haut : ',string(C3D.EMG.Labels(muscle)),' (',string(C3D.NomSujet()),')');
figure('Name',Titre,'NumberTitle','off');
set(gcf,'position',[c,d,e,f])

subplot(4,1,1)%%%
plot(Donnees_cinematiques.Vel_cut_norm(:,1+nb_col/2:nb_col),'DisplayName','Donnees_cinematiques.Vel_cut_norm(:,1+nb_col/2:nb_col)')
title('Vitesse du marqueur doigt')
subplot(4,1,2)%%%
plot(Donnees_cinematiques.Results_trial_by_trial(:,2),'DisplayName','Donnees_cinematiques.Results_trial_by_trial(:,2)')
title('Durée des mouvements')  

subplot(4,1,3)%%%
plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,a:b),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,a:b)')
title('Profil moyen : EMG RMS cut normalisé en temps')
subplot(4,1,4)%%%
r=[0.1:0.1:1000];y = zeros(length(r),1);
if muscle ==3 || muscle == 5
    plot(EMG_traite.DA.smooth.B,'DisplayName','EMG_traite.DA.smooth.B');hold on;
else
    plot(EMG_traite.DP.smooth.B,'DisplayName','EMG_traite.DP.smooth.B');hold on;
end
plot(r,y,'r');
title('Phasic (calculé par interpolation linéaire entre début et fin)')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%ù
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

