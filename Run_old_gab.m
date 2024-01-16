
%% Script pour Manip EMGravity
% A executer dans un dossier de 30 essais contenant aussi le dossier de
% data sequence. Le script sort une matrice contenant les données
% cinématiques, essai par essai et triés en fonction de la cible. 

close all
clear all

%% Informations sur le traitement des données
poids_sujet = 62 % 01 = 75; 02 = 63; 03 = 92; 04 = 84; 05 = 62; 06 = 65
lgbras_sujet = 0.74 %01 = 0.75; 02 = 0.76; 03 = 0.8; 04 = 0.78; 05 = 0.74; 06 = 0.76
gvalue = 9.81;
masse_bras = 0.05*poids_sujet;
dist_cdr_cdm = 0.53*lgbras_sujet;
moment_inertie_bras = (0.028*poids_sujet*(0.436*lgbras_sujet)^2)+(0.022*poids_sujet*(0.68*lgbras_sujet)^2);
Low_pass_Freq = 5; %fréquence passe-bas la position
Cut_off = 0.1; %pourcentage du pic de vitesse pour déterminer début et fin du mouvement
Ech_norm_kin = 1000; %Fréquence d'échantillonage du profil de vitesse normalisé en durée 
Frequence_acquisition = 100;%Fréquence d'acquisition du signal cinématique
EMG_ON = 1 %1 pour le process des EMG, 0 pour le désactiver
emg_band_pass_Freq = [30 300] % Passe_bande du filtre EMG
emg_low_pass_Freq = 20 %fréquence passe_bas lors du second filtre du signal emg. 100 est la fréquence habituelle chez les humains (cf script Jérémie)
emg_ech_norm = 1000; %Fréquence d'échantillonage du signal EMG
anticip_kin_amp = 0.1; %Temps en secondes pour avoir la position avant et après le début du mouvement pour le calcul de l'amplitude
anticip = 0.25 %Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée
EMD_Biceps = 0.074 %délai electromécanique
EMD_DA = 0.098 %délai electromécanique
EMD_PM = 0.102 %délai electromécanique
EMD_DP = 0.067 %délai electromécanique
EMD_GR = 0.071 %délai electromécanique
EMD_GD = 0.056 %délai electromécanique
EMD_Triceps = 0.067 %délai electromécanique
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
Nb_emgs = 2 %Spécification du nombre de channels EMG
if type_RMS == 1
    rms_window = 50; %time in ms of the window used to compute sliding root mean square of EMG
elseif type_RMS == 2
    rms_window = 10; %time in ms of the window used to compute skipping root mean square of EMG. This value need to be set so as rms numframe is >= to kin frame. Thus (emgfreq/kinfreq)/((rms_window/1000)*emgfreq)>= 1
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
    % Et les matrices de Torque
    
% %     %% On sort les valeurs d'EMG max pour la normalisation (à commenter
% % si on utilise la normaisation par l'EMGmax dans un essai)
%     
%     load([Dossier '\' 'EMGMaxFlex' '\' 'EMGMaxFlex01'])
%     
%  %   EMG_Biceps = abs(butter_emgs(C3D.EMG.Donnees(:, 1), emg_frequency,  5, emg_band_pass_Freq, 'band-pass', 'false', 'centered'));   
%     EMG_DA = abs(butter_emgs(C3D.EMG.Donnees(:, 1), emg_frequency,  5, emg_band_pass_Freq, 'band-pass', 'false', 'centered'));
%  %   EMG_PM = abs(butter_emgs(C3D.EMG.Donnees(:, 3), emg_frequency,  5, emg_band_pass_Freq, 'band-pass', 'false', 'centered'));
%     
%     % On sort la taille de l'enregistrement
%     
%     [lig_emg_DA, ~]  = size(EMG_DA);
%     
%     % On calcule la RMS sur les signaux
%     
%   %  RMS_Biceps = rms_sliding(EMG_Biceps, lig_emg_biceps, rms_window_step);
%     RMS_DA = rms_sliding(EMG_DA, lig_emg_DA, rms_window_step);
%   %  RMS_PM = rms_sliding(EMG_PM, lig_emg_biceps, rms_window_step);
%     
%     % On sort le Max du signal
%     
%   %  EMGMax_Biceps = max(RMS_Biceps);
%     EMGMax_DA = max(RMS_DA);
%   %  EMGMax_PM = max(RMS_PM);
%     
%     
%     % Pareil pour les extenseurs
%     
%     load([Dossier '\' 'EMGMaxExt' '\' 'EMGMaxExt01'])
%     
%   %  EMG_Triceps = abs(butter_emgs(C3D.EMG.Donnees(:, 7), emg_frequency,  5, emg_band_pass_Freq, 'band-pass', 'false', 'centered'));   
%     EMG_DP = abs(butter_emgs(C3D.EMG.Donnees(:, 2), emg_frequency,  5, emg_band_pass_Freq, 'band-pass', 'false', 'centered'));
%    % EMG_GR = abs(butter_emgs(C3D.EMG.Donnees(:, 5), emg_frequency,  5, emg_band_pass_Freq, 'band-pass', 'false', 'centered'));
%    % EMG_GD = abs(butter_emgs(C3D.EMG.Donnees(:, 6), emg_frequency,  5, emg_band_pass_Freq, 'band-pass', 'false', 'centered'));
%     % On sort la taille de l'enregistrement
%     
%     [lig_emg_DP, ~]  = size(EMG_DP);
%     
%     % On calcule la RMS sur les signaux
%     
% %     RMS_Triceps = rms_sliding(EMG_Triceps, lig_emg_triceps, rms_window_step);
%     RMS_DP = rms_sliding(EMG_DP, lig_emg_DP, rms_window_step);
% %     RMS_GD = rms_sliding(EMG_GD, lig_emg_triceps, rms_window_step);
% %     RMS_GR = rms_sliding(EMG_GR, lig_emg_triceps, rms_window_step);
%     
%     % On sort le Max du signal
%     
% %     EMGMax_Triceps = max(RMS_Triceps);
%     EMGMax_DP = max(RMS_DP);
% %     EMGMax_GR = max(RMS_GR);
% %     EMGMax_GD = max(RMS_GD);

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
       
       %distance_intercible = sqrt((pos_cible_rouge(1)-pos_cible_bleue(1)).^2+(pos_cible_rouge(2)-pos_cible_bleue(2)).^2+(pos_cible_rouge(3)-pos_cible_bleue(3)).^2);
       
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
        posxyz = C3D.Cinematique.Donnees(:, 17:19);
        pos_epaule = C3D.Cinematique.Donnees(:, 1:3);
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

        % On calcule les Torques pour chaque mouvement
        
%         [Torque_1] = gettorques2(Pos_mvmt_1(:, :), Pos_epaule_mvmt_1(:, :), gvalue, masse_bras, dist_cdr_cdm, debut_1, fin_1);
%         [Torque_2] = gettorques2(Pos_mvmt_2(:, :), Pos_epaule_mvmt_2(:, :), gvalue, masse_bras, dist_cdr_cdm, debut_2, fin_2);
            %% On calcule les erreurs par rapport à la cible
            
            
           % if Target_mvmt_1 == 1 | Target_mvmt_1 == 3
                
                %Erreur en distance
                
               %erreur_cible_mvmt_1 = sqrt((pos_cible_rouge(1)-profil_position_1(lig_pos_1, 1)).^2+(pos_cible_rouge(2)-profil_position_1(lig_pos_1, 2)).^2+(pos_cible_rouge(3)-profil_position_1(lig_pos_1, 3)).^2);
               %erreur_cible_mvmt_2 = sqrt((pos_cible_bleue(1)-profil_position_2(lig_pos_2, 1)).^2+(pos_cible_bleue(2)-profil_position_2(lig_pos_2, 2)).^2+(pos_cible_bleue(3)-profil_position_2(lig_pos_2, 3)).^2);
               
               %Erreur Angulaire mouvement 1
               
               %Lgr_epaule_cible_start_1 = sqrt((pos_cible_bleue(1)-profil_position_epaule_1(1, 1)).^2+(pos_cible_bleue(2)-profil_position_epaule_1(1, 2)).^2+(pos_cible_bleue(3)-profil_position_epaule_1(1, 3)).^2);
               %Lgr_epaule_cible_end_1 =  sqrt((pos_cible_rouge(1)-profil_position_epaule_1(lig_pos_epaule_1, 1)).^2+(pos_cible_rouge(2)-profil_position_epaule_1(lig_pos_epaule_1, 2)).^2+(pos_cible_rouge(3)-profil_position_epaule_1(lig_pos_epaule_1, 3)).^2);
               %Angle_epaule_intercible_1 = acos((Lgr_epaule_cible_start_1^2+Lgr_epaule_cible_end_1^2-distance_intercible^2)/(2*Lgr_epaule_cible_start_1*Lgr_epaule_cible_end_1));
               %Angle_epaule_intercible_1 = Angle_epaule_intercible_1*(180/pi);
            %if Angle_epaule_intercible_1<0
             %  Angle_epaule_intercible_1 = -Angle_epaule_intercible_1;
            %end
               
              % erreur_angulaire_mvmt_1 = Angle_epaule_intercible_1-Angle_mvmt_1;
               
               %Erreur angulaire mouvement 2
               
              % Lgr_epaule_cible_start_2 = sqrt((pos_cible_rouge(1)-profil_position_epaule_2(1, 1)).^2+(pos_cible_rouge(2)-profil_position_epaule_2(1, 2)).^2+(pos_cible_rouge(3)-profil_position_epaule_2(1, 3)).^2);
               %Lgr_epaule_cible_end_2 =  sqrt((pos_cible_bleue(1)-profil_position_epaule_2(lig_pos_epaule_2, 1)).^2+(pos_cible_bleue(2)-profil_position_epaule_2(lig_pos_epaule_2, 2)).^2+(pos_cible_bleue(3)-profil_position_epaule_2(lig_pos_epaule_2, 3)).^2);
               %Angle_epaule_intercible_2 = acos((Lgr_epaule_cible_start_2^2+Lgr_epaule_cible_end_2^2-distance_intercible^2)/(2*Lgr_epaule_cible_start_2*Lgr_epaule_cible_end_2));
               %Angle_epaule_intercible_2 = Angle_epaule_intercible_2*(180/pi);
            %if Angle_epaule_intercible_2<0
             %  Angle_epaule_intercible_2 = -Angle_epaule_intercible_2;
            %end
               
              % erreur_angulaire_mvmt_2 = Angle_epaule_intercible_2-Angle_mvmt_2;
               
               
            %else
                %Erreur en distance
                
               %erreur_cible_mvmt_2 = sqrt((pos_cible_rouge(1)-profil_position_2(lig_pos_2, 1)).^2+(pos_cible_rouge(2)-profil_position_2(lig_pos_2, 2)).^2+(pos_cible_rouge(3)-profil_position_2(lig_pos_2, 3)).^2);
               %erreur_cible_mvmt_1 = sqrt((pos_cible_bleue(1)-profil_position_1(lig_pos_1, 1)).^2+(pos_cible_bleue(2)-profil_position_1(lig_pos_1, 2)).^2+(pos_cible_bleue(3)-profil_position_1(lig_pos_1, 3)).^2);
               
               %Erreur Angulaire mouvement 1
               
               %Lgr_epaule_cible_start_1 = sqrt((pos_cible_rouge(1)-profil_position_epaule_1(1, 1)).^2+(pos_cible_rouge(2)-profil_position_epaule_1(1, 2)).^2+(pos_cible_rouge(3)-profil_position_epaule_1(1, 3)).^2);
               %Lgr_epaule_cible_end_1 =  sqrt((pos_cible_bleue(1)-profil_position_epaule_1(lig_pos_epaule_1, 1)).^2+(pos_cible_bleue(2)-profil_position_epaule_1(lig_pos_epaule_1, 2)).^2+(pos_cible_bleue(3)-profil_position_epaule_1(lig_pos_epaule_1, 3)).^2);
              % Angle_epaule_intercible_1 = acos((Lgr_epaule_cible_start_1^2+Lgr_epaule_cible_end_1^2-distance_intercible^2)/(2*Lgr_epaule_cible_start_1*Lgr_epaule_cible_end_1));
             %  Angle_epaule_intercible_1 = Angle_epaule_intercible_1*(180/pi);
            %if Angle_epaule_intercible_1<0
             %  Angle_epaule_intercible_1 = -Angle_epaule_intercible_1;
            %end
               
               %erreur_angulaire_mvmt_1 = Angle_epaule_intercible_1-Angle_mvmt_1;
               
               %Erreur angulaire mouvement 2
               
               %Lgr_epaule_cible_start_2 = sqrt((pos_cible_bleue(1)-profil_position_epaule_2(1, 1)).^2+(pos_cible_bleue(2)-profil_position_epaule_2(1, 2)).^2+(pos_cible_bleue(3)-profil_position_epaule_2(1, 3)).^2);
               %Lgr_epaule_cible_end_2 =  sqrt((pos_cible_rouge(1)-profil_position_epaule_2(lig_pos_epaule_2, 1)).^2+(pos_cible_rouge(2)-profil_position_epaule_2(lig_pos_epaule_2, 2)).^2+(pos_cible_rouge(3)-profil_position_epaule_2(lig_pos_epaule_2, 3)).^2);
               %Angle_epaule_intercible_2 = acos((Lgr_epaule_cible_start_2^2+Lgr_epaule_cible_end_2^2-distance_intercible^2)/(2*Lgr_epaule_cible_start_2*Lgr_epaule_cible_end_2));
               %Angle_epaule_intercible_2 = Angle_epaule_intercible_2*(180/pi);
            %if Angle_epaule_intercible_2<0
               %Angle_epaule_intercible_2 = -Angle_epaule_intercible_2;
            %end
               
             %  erreur_angulaire_mvmt_2 = Angle_epaule_intercible_2-Angle_mvmt_2;
               
            %end
               
       

        
        
              
        
        %% On remplit les matrices de résulats des paramètres cinématiques pour chaque cas
       
          k = 3*i;
          z = k-2;
        
        if data_sequence(i) == 1 | data_sequence(i) == 3
            
%             Donnees_cinematiques.SGT(1:lig_pv1, i) = Torque_1.SGT;
%             Donnees_cinematiques.SGT(1:lig_pv2, i+numel(ListeFichier)) = Torque_2.SGT;
            
%             Donnees_cinematiques.SIT(1:lig_pv1, i) = Torque_1.SIT;
%             Donnees_cinematiques.SIT(1:lig_pv2, i+numel(ListeFichier)) = Torque_2.SIT;
      
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
%     Donnees_EMG.Brutes.Biceps(1:size_emg_data, i) = emg_data(1:size_emg_data, 1);
%     Donnees_EMG.Brutes.DA(1:size_emg_data, i) = emg_data(1:size_emg_data, 2);
%     Donnees_EMG.Brutes.PM(1:size_emg_data, i) = emg_data(1:size_emg_data, 3);
%     Donnees_EMG.Brutes.DP(1:size_emg_data, i) = emg_data(1:size_emg_data, 4);
%     Donnees_EMG.Brutes.GR(1:size_emg_data, i) = emg_data(1:size_emg_data, 5);
%     Donnees_EMG.Brutes.GD(1:size_emg_data, i) = emg_data(1:size_emg_data, 6);
%     Donnees_EMG.Brutes.Triceps(1:size_emg_data, i) = emg_data(1:size_emg_data, 7);
%     
%     % Pour le signal EMG filtré
%     Donnees_EMG.Filtrees.Biceps(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 1);
%     Donnees_EMG.Filtrees.DA_(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 2);
%     Donnees_EMG.Filtrees.PM(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 3);
%     Donnees_EMG.Filtrees.DP(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 4);
%     Donnees_EMG.Filtrees.GR(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 5);
%     Donnees_EMG.Filtrees.GD(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 6);
%     Donnees_EMG.Filtrees.Triceps(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 7);    
%     
%     % Pour le signal rectifié et refiltré
%     Donnees_EMG.Rectifiees.Biceps(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 1);
%     Donnees_EMG.Rectifiees.DA(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 2);
%     Donnees_EMG.Rectifiees.PM(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 3);
%     Donnees_EMG.Rectifiees.DP(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 4);
%     Donnees_EMG.Rectifiees.GR(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 5);
%     Donnees_EMG.Rectifiees.GD(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 6);
%     Donnees_EMG.Rectifiees.Triceps(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 7);    
%     
    % Pour le signal RMS
    
    % Si on veut normaliser par le max de du bloc
%     Donnees_EMG.RMS.Biceps(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 1);
     Donnees_EMG.RMS.DA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 1);
%     Donnees_EMG.RMS.PM(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 3);
     Donnees_EMG.RMS.DP(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 2);
%     Donnees_EMG.RMS.GR(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 5);
%     Donnees_EMG.RMS.GD(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 5);
%     Donnees_EMG.RMS.Triceps(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 7);
%     
%     EMGMax_Biceps = max(max(Donnees_EMG.RMS.Biceps));
     EMGMax_DA = max(max(Donnees_EMG.RMS.DA));
%     EMGMax_PM = max(max(Donnees_EMG.RMS.PM));
     EMGMax_DP = max(max(Donnees_EMG.RMS.DP));
%     EMGMax_GR = max(max(Donnees_EMG.RMS.GR));
%     EMGMax_GD = max(max(Donnees_EMG.RMS.GD));
%     EMGMax_Triceps = max(max(Donnees_EMG.RMS.Triceps));


    
%     Donnees_EMG.RMS.Biceps(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 1)./EMGMax_Biceps;
    Donnees_EMG.RMS.DA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 1);%./EMGMax_DA;
%     Donnees_EMG.RMS.PM(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 3)./EMGMax_PM;
    Donnees_EMG.RMS.DP(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 2);%./EMGMax_DP;
%     Donnees_EMG.RMS.GR(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 5)./EMGMax_GR;
%     Donnees_EMG.RMS.GD(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 5)./EMGMax_GD;
%     Donnees_EMG.RMS.Triceps(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 7)./EMGMax_Triceps;
    
    % Pour le mouvement RMS brut et normalisé et le tonic, on trie les signaux par direction
    
    if data_sequence(i) == 1 | data_sequence(i) == 3
        
%        Donnees_EMG.RMSCut.Biceps(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 1)./EMGMax_Biceps;
        Donnees_EMG.RMSCut.DA(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 1);%./EMGMax_DA;
%        Donnees_EMG.RMSCut.PM(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 3)./EMGMax_PM;
       Donnees_EMG.RMSCut.DP(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 2);%./EMGMax_DP;
%        Donnees_EMG.RMSCut.GR(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 5)./EMGMax_GR;
%        Donnees_EMG.RMSCut.GD(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 6)./EMGMax_GD;
%        Donnees_EMG.RMSCut.Triceps(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 7)./EMGMax_Triceps;
%        
%        Donnees_EMG.RMSCut.Biceps(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 1)./EMGMax_Biceps;
        Donnees_EMG.RMSCut.DA(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 1);%./EMGMax_DA;
%        Donnees_EMG.RMSCut.PM(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 3)./EMGMax_PM;
        Donnees_EMG.RMSCut.DP(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 2);%./EMGMax_DP;
%        Donnees_EMG.RMSCut.GR(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 5)./EMGMax_GR;
%        Donnees_EMG.RMSCut.GD(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 6)./EMGMax_GD;
%        Donnees_EMG.RMSCut.Triceps(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 7)./EMGMax_Triceps;
       
       % Mouvements Normalisés
       
%        Donnees_EMG.RMSCutNorm.Biceps(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 1)./EMGMax_Biceps;
        Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 1);%./EMGMax_DA;
%        Donnees_EMG.RMSCutNorm.PM(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 3)./EMGMax_PM;
        Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 2);%./EMGMax_DP;
%        Donnees_EMG.RMSCutNorm.GR(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 5)./EMGMax_GR;
%        Donnees_EMG.RMSCutNorm.GD(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 6)./EMGMax_GD;
%        Donnees_EMG.RMSCutNorm.Triceps(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 7)./EMGMax_Triceps;
%        
%        Donnees_EMG.RMSCutNorm.Biceps(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 1)./EMGMax_Biceps;
        Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 1);%./EMGMax_DA;
%        Donnees_EMG.RMSCutNorm.PM(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 3)./EMGMax_PM;
        Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 2);%./EMGMax_DP;
%        Donnees_EMG.RMSCutNorm.GR(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 5)./EMGMax_GR;
%        Donnees_EMG.RMSCutNorm.GD(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 6)./EMGMax_GD;
%        Donnees_EMG.RMSCutNorm.Triceps(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 7)./EMGMax_Triceps;
       
       % Pour le tonic au début
       
%        Donnees_EMG.TonicStart.Biceps(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 1)./EMGMax_Biceps;
        Donnees_EMG.TonicStart.DA(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 1);%./EMGMax_DA;
%        Donnees_EMG.TonicStart.PM(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 3)./EMGMax_PM;
        Donnees_EMG.TonicStart.DP(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 2);%./EMGMax_DP;
%        Donnees_EMG.TonicStart.GR(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 5)./EMGMax_GR;
%        Donnees_EMG.TonicStart.GD(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 6)./EMGMax_GD;
%        Donnees_EMG.TonicStart.Triceps(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, 7)./EMGMax_Triceps;
%        
%        Donnees_EMG.TonicStart.Biceps(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 1)./EMGMax_Biceps;
        Donnees_EMG.TonicStart.DA(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 1);%./EMGMax_DA;
%        Donnees_EMG.TonicStart.PM(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 3)./EMGMax_PM;
        Donnees_EMG.TonicStart.DP(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 2);%./EMGMax_DP;
%        Donnees_EMG.TonicStart.GR(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 5)./EMGMax_GR;
%        Donnees_EMG.TonicStart.GD(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 6)./EMGMax_GD;
%        Donnees_EMG.TonicStart.Triceps(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, 7)./EMGMax_Triceps;
       
       % Pour le tonic à la fin
       
%        Donnees_EMG.TonicEnd.Biceps(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 1)./EMGMax_Biceps;
        Donnees_EMG.TonicEnd.DA(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 1);%./EMGMax_DA;
%        Donnees_EMG.TonicEnd.PM(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 3)./EMGMax_PM;
        Donnees_EMG.TonicEnd.DP(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 2);%./EMGMax_DP;
%        Donnees_EMG.TonicEnd.GR(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 5)./EMGMax_GR;
%        Donnees_EMG.TonicEnd.GD(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 6)./EMGMax_GD;
%        Donnees_EMG.TonicEnd.Triceps(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, 7)./EMGMax_Triceps;
%        
%        Donnees_EMG.TonicEnd.Biceps(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 1)./EMGMax_Biceps;
        Donnees_EMG.TonicEnd.DA(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 1);%./EMGMax_DA;
%        Donnees_EMG.TonicEnd.PM(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 3)./EMGMax_PM;
        Donnees_EMG.TonicEnd.DP(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 2);%./EMGMax_DP;
%        Donnees_EMG.TonicEnd.GR(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 5)./EMGMax_GR;
%        Donnees_EMG.TonicEnd.GD(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 6)./EMGMax_GD;
%        Donnees_EMG.TonicEnd.Triceps(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, 7)./EMGMax_Triceps;
       
    else
        
%        Donnees_EMG.RMSCut.Biceps(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 1)./EMGMax_Biceps;
        Donnees_EMG.RMSCut.DA(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 1);%./EMGMax_DA;
%        Donnees_EMG.RMSCut.PM(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 3)./EMGMax_PM;
        Donnees_EMG.RMSCut.DP(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 2);%./EMGMax_DP;
%        Donnees_EMG.RMSCut.GR(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 5)./EMGMax_GR;
%        Donnees_EMG.RMSCut.GD(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 6)./EMGMax_GD;
%        Donnees_EMG.RMSCut.Triceps(1:rms_cut_lig_1, i+numel(ListeFichier)) = rms_cuts_1(1:rms_cut_lig_1, 7)./EMGMax_Triceps;
%        
%        Donnees_EMG.RMSCut.Biceps(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 1)./EMGMax_Biceps;
        Donnees_EMG.RMSCut.DA(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 1);%./EMGMax_DA;
%        Donnees_EMG.RMSCut.PM(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 3)./EMGMax_PM;
        Donnees_EMG.RMSCut.DP(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 2);%./EMGMax_DP;
%        Donnees_EMG.RMSCut.GR(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 5)./EMGMax_GR;
%        Donnees_EMG.RMSCut.GD(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 6)./EMGMax_GD;
%        Donnees_EMG.RMSCut.Triceps(1:rms_cut_lig_2, i) = rms_cuts_2(1:rms_cut_lig_2, 7)./EMGMax_Triceps; 
       
       % Pour les mouvements normalisés
       
%        Donnees_EMG.RMSCutNorm.Biceps(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 1)./EMGMax_Biceps;
        Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 1);%./EMGMax_DA;
%        Donnees_EMG.RMSCutNorm.PM(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 3)./EMGMax_PM;
        Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 2);%./EMGMax_DP;
%        Donnees_EMG.RMSCutNorm.GR(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 5)./EMGMax_GR;
%        Donnees_EMG.RMSCutNorm.GD(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 6)./EMGMax_GD;
%        Donnees_EMG.RMSCutNorm.Triceps(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_1(1:emg_ech_norm, 7)./EMGMax_Triceps;
%        
%        Donnees_EMG.RMSCutNorm.Biceps(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 1)./EMGMax_Biceps;
        Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 1);%./EMGMax_DA;
%        Donnees_EMG.RMSCutNorm.PM(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 3)./EMGMax_PM;
        Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 2);%./EMGMax_DP;
%        Donnees_EMG.RMSCutNorm.GR(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 5)./EMGMax_GR;
%        Donnees_EMG.RMSCutNorm.GD(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 6)./EMGMax_GD;
%        Donnees_EMG.RMSCutNorm.Triceps(1:emg_ech_norm, i) = rms_cuts_norm_2(1:emg_ech_norm, 7)./EMGMax_Triceps; 
       
       % Pour le tonic au début
       
%        Donnees_EMG.TonicStart.Biceps(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 1)./EMGMax_Biceps;
        Donnees_EMG.TonicStart.DA(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 1);%./EMGMax_DA;
%        Donnees_EMG.TonicStart.PM(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 3)./EMGMax_PM;
        Donnees_EMG.TonicStart.DP(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 2);%./EMGMax_DP;
%        Donnees_EMG.TonicStart.GR(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 5)./EMGMax_GR;
%        Donnees_EMG.TonicStart.GD(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 6)./EMGMax_GD;
%        Donnees_EMG.TonicStart.Triceps(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_starts_1(1:tonic_lig_1, 7)./EMGMax_Triceps;
%        
%        Donnees_EMG.TonicStart.Biceps(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 1)./EMGMax_Biceps;
        Donnees_EMG.TonicStart.DA(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 1);%./EMGMax_DA;
%        Donnees_EMG.TonicStart.PM(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 3)./EMGMax_PM;
        Donnees_EMG.TonicStart.DP(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 2);%./EMGMax_DP;
%        Donnees_EMG.TonicStart.GR(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 5)./EMGMax_GR;
%        Donnees_EMG.TonicStart.GD(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 6)./EMGMax_GD;
%        Donnees_EMG.TonicStart.Triceps(1:tonic_lig_2, i) = tonic_starts_2(1:tonic_lig_2, 7)./EMGMax_Triceps;
       
       % Pour le tonic à la fin
       
%        Donnees_EMG.TonicEnd.Biceps(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 1)./EMGMax_Biceps;
        Donnees_EMG.TonicEnd.DA(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 1);%./EMGMax_DA;
%        Donnees_EMG.TonicEnd.PM(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 3)./EMGMax_PM;
        Donnees_EMG.TonicEnd.DP(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 2);%./EMGMax_DP;
%        Donnees_EMG.TonicEnd.GR(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 5)./EMGMax_GR;
%        Donnees_EMG.TonicEnd.GD(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 6)./EMGMax_GD;
%        Donnees_EMG.TonicEnd.Triceps(1:tonic_lig_1, i+numel(ListeFichier)) = tonic_ends_1(1:tonic_lig_1, 7)./EMGMax_Triceps;
%        
%        Donnees_EMG.TonicEnd.Biceps(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 1)./EMGMax_Biceps;
        Donnees_EMG.TonicEnd.DA(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 1);%./EMGMax_DA;
%        Donnees_EMG.TonicEnd.PM(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 3)./EMGMax_PM;
        Donnees_EMG.TonicEnd.DP(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 2);%./EMGMax_DP;
%        Donnees_EMG.TonicEnd.GR(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 5)./EMGMax_GR;
%        Donnees_EMG.TonicEnd.GD(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 6)./EMGMax_GD;
%        Donnees_EMG.TonicEnd.Triceps(1:tonic_lig_2, i) = tonic_ends_2(1:tonic_lig_2, 7)./EMGMax_Triceps;
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
    
%     for f = 1:1000  
%         
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 1) = mean(Donnees_EMG.RMSCutNorm.Biceps(f, 1:numel(ListeFichier)), 2);
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 4) = mean(Donnees_EMG.RMSCutNorm.DA(f, 1:numel(ListeFichier)), 2);
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 7) = mean(Donnees_EMG.RMSCutNorm.PM(f, 1:numel(ListeFichier)), 2);
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 10) = mean(Donnees_EMG.RMSCutNorm.DP(f, 1:numel(ListeFichier)), 2);
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 13) = mean(Donnees_EMG.RMSCutNorm.GR(f, 1:numel(ListeFichier)), 2);
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 16) = mean(Donnees_EMG.RMSCutNorm.GD(f, 1:numel(ListeFichier)), 2);
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 19) = mean(Donnees_EMG.RMSCutNorm.Triceps(f, 1:numel(ListeFichier)), 2);
%         
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 2) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 1)+std(Donnees_EMG.RMSCutNorm.Biceps(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 5) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 4)+std(Donnees_EMG.RMSCutNorm.DA(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 8) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 7)+std(Donnees_EMG.RMSCutNorm.PM(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 11) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 10)+std(Donnees_EMG.RMSCutNorm.DP(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 14) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 13)+std(Donnees_EMG.RMSCutNorm.GR(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 17) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 16)+std(Donnees_EMG.RMSCutNorm.GD(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 20) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 19)+std(Donnees_EMG.RMSCutNorm.Triceps(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 3) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 1)-std(Donnees_EMG.RMSCutNorm.Biceps(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 6) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 4)-std(Donnees_EMG.RMSCutNorm.DA(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 9) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 7)-std(Donnees_EMG.RMSCutNorm.PM(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 12) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 10)-std(Donnees_EMG.RMSCutNorm.DP(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 15) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 13)-std(Donnees_EMG.RMSCutNorm.GR(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 18) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 16)-std(Donnees_EMG.RMSCutNorm.GD(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 21) = Donnees_EMG.RMSCutNorm.ProfilMoyen.R(f, 19)-std(Donnees_EMG.RMSCutNorm.Triceps(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
% 
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 1) = mean(Donnees_EMG.RMSCutNorm.Biceps(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 4) = mean(Donnees_EMG.RMSCutNorm.DA(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 7) = mean(Donnees_EMG.RMSCutNorm.PM(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 10) = mean(Donnees_EMG.RMSCutNorm.DP(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 13) = mean(Donnees_EMG.RMSCutNorm.GR(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 16) = mean(Donnees_EMG.RMSCutNorm.GD(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 19) = mean(Donnees_EMG.RMSCutNorm.Triceps(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
%         
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 2) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 1)+std(Donnees_EMG.RMSCutNorm.Biceps(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 5) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 4)+std(Donnees_EMG.RMSCutNorm.DA(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 8) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 7)+std(Donnees_EMG.RMSCutNorm.PM(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 11) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 10)+std(Donnees_EMG.RMSCutNorm.DP(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 14) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 13)+std(Donnees_EMG.RMSCutNorm.GR(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 17) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 16)+std(Donnees_EMG.RMSCutNorm.GD(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 20) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 19)+std(Donnees_EMG.RMSCutNorm.Triceps(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 3) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 1)-std(Donnees_EMG.RMSCutNorm.Biceps(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 6) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 4)-std(Donnees_EMG.RMSCutNorm.DA(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 9) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 7)-std(Donnees_EMG.RMSCutNorm.PM(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 12) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 10)-std(Donnees_EMG.RMSCutNorm.DP(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 15) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 13)-std(Donnees_EMG.RMSCutNorm.GR(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 18) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 16)-std(Donnees_EMG.RMSCutNorm.GD(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 21) = Donnees_EMG.RMSCutNorm.ProfilMoyen.B(f, 19)-std(Donnees_EMG.RMSCutNorm.Triceps(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%      end
     
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
 % On trie les SGT par direction et par vitesse
 
%  Donnees_cinematiques.SGTR = Donnees_cinematiques.SGT(:, 1:numel(ListeFichier));
%  Donnees_cinematiques.SGTB = Donnees_cinematiques.SGT(:, (numel(ListeFichier)+1):(2*numel(ListeFichier)));
%  
%  Donnees_cinematiques.SGTSort.R = Donnees_cinematiques.SGTR(:, Idx_R);
%  Donnees_cinematiques.SGTSort.B = Donnees_cinematiques.SGTB(:, Idx_B);
%  
%  %On moyenne ensuite les SGT triés
%  
%  Donnees_cinematiques.SGTMean.R =  meantrials(Donnees_cinematiques.SGTSort.R, 3);
%  Donnees_cinematiques.SGTMean.B = meantrials(Donnees_cinematiques.SGTSort.B, 3);

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
     
%      [EMG_traite.Biceps, Tonic.Biceps, Vmean_RMS_R, Vmean_RMS_B] = compute_emg2(Donnees_EMG.RMSCut.Biceps, Donnees_EMG.RMSCutNorm.Biceps, ...
%          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.Biceps, Donnees_EMG.TonicEnd.Biceps, localmax, Vmean_RMS);
%      
      [EMG_traite.DA, Tonic.DA, Vmean_RMS_R, Vmean_RMS_B, Profil_tonic_R.DA, Profil_tonic_B.DA] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.DA, Donnees_EMG.RMSCutNorm.DA, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.DA, Donnees_EMG.TonicEnd.DA, localmax, Idx);
%      
%      [EMG_traite.PM, Tonic.PM, ~, ~] = compute_emg2(Donnees_EMG.RMSCut.PM, Donnees_EMG.RMSCutNorm.PM, ...
%          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.PM, Donnees_EMG.TonicEnd.PM, localmax, Vmean_RMS);
%      
      [EMG_traite.DP, Tonic.DP, ~, ~, Profil_tonic_R.DP, Profil_tonic_B.DP] = compute_emg2_Brasdom_nondom(Donnees_EMG.RMSCut.DP, Donnees_EMG.RMSCutNorm.DP, ...
          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.DP, Donnees_EMG.TonicEnd.DP, localmax, Idx);
%      
%      [EMG_traite.GR, Tonic.GR, ~, ~] = compute_emg2(Donnees_EMG.RMSCut.GR, Donnees_EMG.RMSCutNorm.GR, ...
%          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.GR, Donnees_EMG.TonicEnd.GR, localmax, Vmean_RMS);
%      
%      [EMG_traite.GD, Tonic.GD, ~, ~] = compute_emg2(Donnees_EMG.RMSCut.GD, Donnees_EMG.RMSCutNorm.GD, ...
%          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.GD, Donnees_EMG.TonicEnd.GD, localmax, Vmean_RMS);
%      
%      [EMG_traite.Triceps, Tonic.Triceps, ~, ~] = compute_emg2(Donnees_EMG.RMSCut.Triceps, Donnees_EMG.RMSCutNorm.Triceps, ...
%          emg_low_pass_Freq, emg_frequency, Donnees_EMG.TonicStart.Triceps, Donnees_EMG.TonicEnd.Triceps, localmax, Vmean_RMS);
      
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


%     %% On calcule les paramètres du torque
%     
% %     [ParamTorque] = param_torques(Donnees_cinematiques.SGTMean.B, Donnees_cinematiques.SITMean.B, Frequence_acquisition);
% 
% plot (Donnees_cinematiques.Position_cut_norm(:,1:3*numel(ListeFichier))) 
% 
% reply = input('Continuer ?');
% if reply ~= 0
%     
%     close all
%     plot (Donnees_cinematiques.Position_cut_norm(:,3*numel(ListeFichier)+1:6*numel(ListeFichier)))
%     
% end
% 
% % %  plotstem(EMG_traite.Biceps.nonsmooth.brut.B, Results_EMG.Biceps.B)
% % % % plotstem(EMG_traite.Biceps.nonsmooth.brut.R, Results_EMG.Biceps.R)
% %     plotstem(EMG_traite.DA.nonsmooth.brut.B, Results_EMG.DA.B)
% %     plotstem(EMG_traite.DA.nonsmooth.brut.R, Results_EMG.DA.R)
% % %  plotstem(EMG_traite.PM.nonsmooth.brut.B, Results_EMG.PM.B)
% % % % plotstem(EMG_traite.PM.nonsmooth.brut.R, Results_EMG.PM.R)
% %   plotstem(EMG_traite.DP.nonsmooth.brut.B, Results_EMG.DP.B)
% %   plotstem(EMG_traite.DP.nonsmooth.brut.R, Results_EMG.DP.R)
% % % % plotstem(EMG_traite.GR.nonsmooth.brut.B, Results_EMG.GR.B)
% % %  plotstem(EMG_traite.GR.nonsmooth.brut.R, Results_EMG.GR.R)
% % % % % plotstem(EMG_traite.GD.nonsmooth.brut.B, Results_EMG.GD.B)
% % %  plotstem(EMG_traite.GD.nonsmooth.brut.R, Results_EMG.GD.R)
% % % % % plotstem(EMG_traite.Triceps.nonsmooth.brut.B, Results_EMG.Triceps.B)
% % %  plotstem(EMG_traite.Triceps.nonsmooth.brut.R, Results_EMG.Triceps.R)
% 
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

