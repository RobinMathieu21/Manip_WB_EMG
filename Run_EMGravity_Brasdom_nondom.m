 
%% Script principal pour manip mvts whole body
% A executer pour post-traiter les donn�es obtenues lors des manips whole
% body. Ce script est � utiliser pour les donn�es BRAS

close all
clear all

%% Informations sur le traitement des donn�es
Bras_Droit = true; % CHOISIR LE BRAS
MVT_LENT = true;
% Parametres 
Low_pass_Freq = 5; %fr�quence passe-bas la position
Cut_off = 0.1; %pourcentage du pic de vitesse pour d�terminer d�but et fin du mouvement
Ech_norm_kin = 1000; %Fr�quence d'�chantillonage du profil de vitesse normalis� en dur�e 
Frequence_acquisition = 200; %Fr�quence d'acquisition du signal cin�matique
emg_band_pass_Freq = [30 300]; % Passe_bande du filtre EMG
emg_low_pass_Freq = 20; %fr�quence passe_bas lors du second filtre du signal emg. 100 est la fr�quence habituelle chez les humains (cf script J�r�mie)
emg_ech_norm = 1000; %Fr�quence d'�chantillonage du signal EMG
add_for_ant = 25; % Nb images � ajouter � la cin�matique pour d�tecter bouff�es EMG UTILE POUR VISUALISATION
%anticip_kin_amp = 0.1; %Temps en secondes pour avoir la position avant et apr�s le d�but du mouvement pour le calcul de l'amplitude
anticip = 0.25; %Temps � soustraire lors du recoupage du rms_cut pour trouver le d�but de la bouff�e
EMD = 0.076; % d�lai electrom�canique moyen de tous les muscles
anticip_tonic = 250; % Dur�e (en ms) pour avoir le dernier point du tonic avant le mouvement et le premier point du tonic apr�s le mouvement
duration_tonic = 250; % Dur�e (en ms) de moyennage du tonic
%anticip_phasic_smooth = 500; %time in ms to recut smooth phasic so as to get rid of the first and last values which are too much influenced (exactly the same actually) by the non smoothed values, we only do this to compute EMG variables more easily.
type_RMS = 1; % 1 pour sliding et 2 pour skipping
emg_frequency = 1000; %Fr�quence d'acquisition du signal EMG
Nb_averaged_trials = 2; % Indicate the number of EMG traces to be averaged 
limite_en_temps = 0.01; % Limite en temps pour qu'une phase d'inactivation soit consider�e comme telle

%Min_emg_duration = 0.05;% Dur�e minimale en s pour detecter les bouff�es d'activation EMG (positives ou n�gatives)
%Min_emg_duration_end = 0.03;% Dur�e minimale en s pour detecter la fin des bouff�es d'activation EMG (positives ou n�gatives)
ICvalue = 1.96; % Valeur pour d�terminer le d�but des bouff�es lors de la d�tection automatique, � parir de l'�cart type du tonic. Utiliser 1.96 pour 95% et 2.576 pour 99% de l'intervalle de confiance.
ICvalueK = 1.96;
Tresholdvalue = 0.02; % Valeur � d�passer pour la d�tection automatique des bouff�es, ce qui permet d'�luder le cas o� la bouff�e est d�tect�e trop t�t � cause d'une trop faible variabilit� dans le tonic.
Cutoff_emg = 0.05; % Pourcentage du pic � partir duquel on d�termine l'onset et l'offset de la bouff�e EMG
Nb_emgs = 6; %Sp�cification du nombre de channels EMG (Il y en a 16, mais pour les bras les 1, 2, 3 et 4 nous interessent)
if type_RMS == 1
    rms_window = 200; %time in ms of the window used to compute sliding root mean square of EMG
end
rms_window_step = (rms_window/1000)*emg_frequency;
emg_div_kin_freq = emg_frequency/Frequence_acquisition; %used to synchronized emg cutting (for sliding rms) with regard to kinematics
emgrms_div_kin_freq = emg_div_kin_freq/rms_window_step; %used to synchronized emg cutting (for skipping rms) with regard to kinematics

%% Importation des donn�es

%On selectionne le repertoire
disp('Selectionnez le Dossier regroupant les essais rapides');
[Dossier] = uigetdir ('Selectionnez le Dossier o� ex�cuter le Script');

if (Dossier ~= 0) %Si on clique sur un dossier
    
    Extension = '*.mat'; %Traite tous les .mat
    
    %On construit le chemin
    Chemin = fullfile(Dossier, Extension);
    
    %On construit la liste des fichiers
    ListeFichier = dir(Chemin);

    %% On cr�e les matrices de r�sultats
    
    Donnees_EMG = {};
    Donnees_cinematiques = {};
    EMG_traite = {};
    Tonic = {};
    Premiere_fois = true; % Pour n'effecteur certaines actions de lecture des labels qu'une seule fois
    disp('POST TRAITEMENT MOUVEMENTS RAPIDES -- BRAS')
    disp(append('Il y a ', string(numel(ListeFichier)),' fichiers � analyser.'));
    %% On proc�de au balayage fichier par fichier
     for i = 1: numel(ListeFichier)
       disp(append("i = "+i));
       Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
        
       load (Fichier_traite);
       
       if Bras_Droit == true             % POUR LE COTE DROIT
           marqueurShoulder = 'RSHO';  marqueurFinger = 'RFIN'; a_muscle = 1;
        MUSCLE_1 = 1; % POUR DELTO A DROIT
        MUSCLE_2 = 2; % POUR DELTO P DROIT

       else                               % POUR LE COTE GAUCHE 
           marqueurShoulder = 'LSHO';  marqueurFinger = 'LFIN'; a_muscle = 3;
        MUSCLE_1 = 3; % POUR DELTO A gauche
        MUSCLE_2 = 4; % POUR DELTO P gauche
       end


       if Premiere_fois %% Boucle pour trouver les coordonn�es du marqueur de l'�paule et du doigt
            j=0; marqueur = 'a';
            while ~strcmp(marqueur,marqueurShoulder)
                j=j+1;
                marqueur = C3D.Cinematique.Labels(j);  
            end
            disp(append('Le marqueur ', marqueurShoulder,' est le num�ro ',string(j)));
            j = j*4-1;

            j2=0; marqueur2 = 'a';
            while ~strcmp(marqueur2,marqueurFinger)
                j2=j2+1;
                marqueur2 = C3D.Cinematique.Labels(j2);  
            end
            disp(append('Le marqueur ', marqueurFinger,' est le num�ro ',string(j2)));
            j2 = j2*4-1;
        
            Premiere_fois = false;
       end

        %On cr�e une matrice de la position du doigt et de l'�paule
        posxyz = C3D.Cinematique.Donnees(:, j2-2:j2);
        pos_epaule = C3D.Cinematique.Donnees(:, j-2:j);   
        
        [posxyz_lig, ~] = size(posxyz);
        
        %On filtre le signal de position
        posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
        posfiltre_epaule = butter_emgs(pos_epaule, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
       
        %On coupe le signal de vitesse pour avoir 2 plages contenant chacune un mouvement

        plot(posfiltre(:, 3))
        [Cut] = ginput(3);

        Plage_mvmt_1_start = round(Cut(1,1));
        Plage_mvmt_1_end = round(Cut(2,1));
        
        Plage_mvmt_2_start = round(Cut(2,1));
        Plage_mvmt_2_end = round(Cut(3,1));
        
        [Pos_mvmt_1] = posfiltre(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
        [Pos_mvmt_2] = posfiltre(Plage_mvmt_2_start:Plage_mvmt_2_end, :);  
        
        [Pos_epaule_mvmt_1] = posfiltre_epaule(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
        [Pos_epaule_mvmt_2] = posfiltre_epaule(Plage_mvmt_2_start:Plage_mvmt_2_end, :);
        
      
        %On attribue une cible aux 2 mouvements
                              
        
        %% On calcule les param�tres cin�matiques des 2 mouvements
        
        % Premier Mouvement
        [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_1, vitesse1, profil_vitesse_1_norm, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, Vmoy_1, Param_C_1, Amp_1, Angle_mvmt_1, Nbmaxloc_1, debut_1, fin_1, Amp_reel_1, Angle_reel_1, profil_accel_1] = compute_kinematics_BrasDom_nondom(Pos_mvmt_1, Pos_epaule_mvmt_1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin);
        
        % Second Mouvement
        [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_2,vitesse2, profil_vitesse_2_norm, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, Vmoy_2, Param_C_2, Amp_2, Angle_mvmt_2, Nbmaxloc_2, debut_2, fin_2, Amp_reel_2, Angle_reel_2, profil_accel_2] = compute_kinematics_BrasDom_nondom(Pos_mvmt_2, Pos_epaule_mvmt_2, Frequence_acquisition, 1, Cut_off, Ech_norm_kin);

       
        
        %% On remplit les matrices de r�sulats des param�tres cin�matiques pour chaque cas
       
          k = 3*i;
          z = k-2;
            
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
                         
         %% Calcul des param�tres electromyographiques
         
%On calcule la taille de la matrice contenant les EMG
size_emg_data = posxyz_lig*emg_div_kin_freq;

% On cr�e la matrice contenant les EMG

emg_data = C3D.EMG.Donnees;

%calcule le d�but et la fin du mouvement sur l'ensemble du signal
%cin�matique

onset_1 = (debut_1+Plage_mvmt_1_start);
offset_1 = (fin_1+Plage_mvmt_1_start);
onset_2 = (debut_2+Plage_mvmt_2_start);
offset_2 = (fin_2+Plage_mvmt_2_start);

% On sauvegarde un profil de position plus large pour trouver le
        % lag de la bouff�e EMG par la suite
        
ligantpos1 = offset_1-onset_1+add_for_ant+1;
ligantpos2 = offset_2-onset_2+add_for_ant+1;

antvelocity_B = sqrt(derive(posfiltre(onset_1-add_for_ant:offset_1, 1), 2).^2+derive(posfiltre(onset_1-add_for_ant:offset_1, 2), 2).^2+derive(posfiltre(onset_1-add_for_ant:offset_1, 3), 2).^2)./(1/Frequence_acquisition);
antvelocity_R = sqrt(derive(posfiltre(onset_2-add_for_ant:offset_2, 1), 2).^2+derive(posfiltre(onset_2-add_for_ant:offset_2, 2), 2).^2+derive(posfiltre(onset_2-add_for_ant:offset_2, 3), 2).^2)./(1/Frequence_acquisition);

Donnees_cinematiques.antvelocity.B(1:ligantpos1, i) = antvelocity_B;
Donnees_cinematiques.antvelocity.R(1:ligantpos2, i) = antvelocity_R;
                
%On calcule les param�tres emg du premier mouvement

[rms_cuts_1, rms_cuts_norm_1, ~, ...
    ~, ~, tonic_starts_1, tonic_ends_1, ...
    rms_cut_lig_1, ~, ~, ...
    ~, ~, tonic_lig_1] = compute_emg(emg_data, Nb_emgs, emg_frequency, ...
    emg_band_pass_Freq, emg_low_pass_Freq, type_RMS, rms_window_step, onset_1, offset_1, ...
    emg_div_kin_freq,  anticip,emg_ech_norm, anticip_tonic, duration_tonic, emgrms_div_kin_freq);

% On calcule les pram�tres EMG du second mouvement

[rms_cuts_2, rms_cuts_norm_2, emg_rms, ...
    emg_filt, emg_rect_filt, tonic_starts_2, tonic_ends_2, ...
    rms_cut_lig_2, emg_data_filtre_rms_lig, emg_data_filtre_lig, ...
    emg_data_filtre_rect_second_lig, anticip_rms, tonic_lig_2] = compute_emg(emg_data, Nb_emgs, emg_frequency, ...
    emg_band_pass_Freq, emg_low_pass_Freq, type_RMS, rms_window_step, onset_2, offset_2, ...
    emg_div_kin_freq,  anticip,emg_ech_norm, anticip_tonic, duration_tonic, emgrms_div_kin_freq);


        
        %% On construit les matrices de r�sultats des EMG
        
%         % Pour le signal EMG brut
Donnees_EMG.Brutes.DA(1:size_emg_data, i) = emg_data(1:size_emg_data, MUSCLE_1);
Donnees_EMG.Brutes.DP(1:size_emg_data, i) = emg_data(1:size_emg_data, MUSCLE_2);
%     
%     % Pour le signal EMG filtr�
Donnees_EMG.Filtrees.DA(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, MUSCLE_1);
Donnees_EMG.Filtrees.DP(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, MUSCLE_2);  
%     
%     % Pour le signal rectifi� et refiltr�
Donnees_EMG.Rectifiees.DA(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, MUSCLE_1);
Donnees_EMG.Rectifiees.DP(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, MUSCLE_2);
%     
    % Pour le signal RMS
    
    % Si on veut normaliser par le max de du bloc
Donnees_EMG.RMS.DA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_1);
Donnees_EMG.RMS.DP(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_2);

%     
EMGMax_DA = max(max(Donnees_EMG.RMS.DA));
disp(append('EMGMax_DA = ',string(EMGMax_DA)));
EMGMax_DP = max(max(Donnees_EMG.RMS.DP));
    
Donnees_EMG.RMS.DA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG.RMS.DP(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_2);%./EMGMax_DP;
Donnees_EMG.RMSpasnorm.DA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_1);
Donnees_EMG.RMSpasnorm.DP(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_2);
    
    % Pour le mouvement RMS brut et normalis� et le tonic, on trie les signaux par direction
    
        
Donnees_EMG.RMSCut.DA(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG.RMSCut.DP(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, MUSCLE_2);%./EMGMax_DP;
%        
Donnees_EMG.RMSCut.DA(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG.RMSCut.DP(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, MUSCLE_2);%./EMGMax_DP;
       
       % Mouvements Normalis�s
       
Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, MUSCLE_2);%./EMGMax_DP;
%        
Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, MUSCLE_2);%./EMGMax_DP;
       
       % Pour le tonic au d�but
       
Donnees_EMG.TonicStart.DA(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG.TonicStart.DP(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, MUSCLE_2);%./EMGMax_DP;
%        
Donnees_EMG.TonicStart.DA(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG.TonicStart.DP(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, MUSCLE_2);%./EMGMax_DP;
       
       % Pour le tonic � la fin
       
Donnees_EMG.TonicEnd.DA(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG.TonicEnd.DP(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, MUSCLE_2);%./EMGMax_DP;
%        

Donnees_EMG.TonicEnd.DA(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG.TonicEnd.DP(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, MUSCLE_2);%./EMGMax_DP;
       

    
     end
       
    
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
     


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Partie qui permet de trier les essais par vitesse, de les moyenner par trois et de recalculer les param�tres cin�matiques dessus
 
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
 MD_R_to_be_sorted = Donnees_cinematiques.Results_trial_by_trial(1:numel(ListeFichier),2);
 MD_B_to_be_sorted = Donnees_cinematiques.Results_trial_by_trial(numel(ListeFichier)+1:end,2);
 Idx.MD_R = MD_R_to_be_sorted(Idx_R);
 Idx.MD_B = MD_B_to_be_sorted(Idx_B);

%  % J'ajoute dans la matrice un bool�en pour savoir si on est en condition
%  % horizontale ou verticale. On pond�rera le tonic avec la valeur de Torque
%  % uniquement en condition verticale
% 
%  Donnees_cinematiques.VelCutSort.R = Donnees_cinematiques.Vel_cut_brut(:, 1:numel(ListeFichier));
%  Donnees_cinematiques.VelCutSort.B = Donnees_cinematiques.Vel_cut_brut(:, (numel(ListeFichier)+1):(2*numel(ListeFichier)));
% 
%  Donnees_cinematiques.VelCutSort.R = Donnees_cinematiques.VelCutSort.R(:, Idx_R);
%  Donnees_cinematiques.VelCutSort.B = Donnees_cinematiques.VelCutSort.B(:, Idx_B);
%  
%  [ligR, colR] = size(Donnees_cinematiques.VelCutSort.R);
%  [ligB, colB] = size(Donnees_cinematiques.VelCutSort.B);
%  % On remplace les z�ros des profils de vitesse par des Nan pour un
%  % meilleur signal d�riv�
%  
%  for w = 1:colR
%      for v = 1:ligR
%          
%          if Donnees_cinematiques.VelCutSort.R(v, w) == 0
%              Donnees_cinematiques.VelCutSort.R(v, w) = NaN;
%          end
%      end
%  end
%  
%  for w = 1:colB
%      for v = 1:ligB
%          
%          if Donnees_cinematiques.VelCutSort.B(v, w) == 0
%              Donnees_cinematiques.VelCutSort.B(v, w) = NaN;
%          end
%      end
%  end
% 
%  
%  % J'en profite pour cr�er un tableau avec les donn�es cin�matiques
%  % moyenn�es par 3
%  
%  Donnees_cinematiques.Param_R = Donnees_cinematiques.Results_trial_by_trial(1:numel(ListeFichier), :);
%  Donnees_cinematiques.Param_B = Donnees_cinematiques.Results_trial_by_trial((numel(ListeFichier)+1):(2*numel(ListeFichier)), :);
%  
%  
%  Donnees_cinematiques.Param_R = Donnees_cinematiques.Param_R(Idx_R, :);
%  Donnees_cinematiques.Param_B = Donnees_cinematiques.Param_B(Idx_B, :);
% 
%  ind_m = 1;
%  for ind = 1:Nb_averaged_trials:numel(ListeFichier)-Nb_averaged_trials+1
%  
%      Donnees_cinematiques.Param_R_Mean(ind_m, :) = mean(Donnees_cinematiques.Param_R(ind:ind+Nb_averaged_trials-1, :));
%      Donnees_cinematiques.Param_B_Mean(ind_m, :) = mean(Donnees_cinematiques.Param_B(ind:ind+Nb_averaged_trials-1, :));
%      ind_m = ind_m+1;
%  end
%  
%  % On ajoute T-PA, T-PV et T-PV-END
%  
%  for ind = 1:colR/Nb_averaged_trials
%      Donnees_cinematiques.Param_R_Mean(ind, 13) = Donnees_cinematiques.Param_R_Mean(ind, 2)*Donnees_cinematiques.Param_R_Mean(ind, 3);
%      Donnees_cinematiques.Param_B_Mean(ind, 13) = Donnees_cinematiques.Param_B_Mean(ind, 2)*Donnees_cinematiques.Param_B_Mean(ind, 3);
%      
%      Donnees_cinematiques.Param_R_Mean(ind, 14) = Donnees_cinematiques.Param_R_Mean(ind, 2)*Donnees_cinematiques.Param_R_Mean(ind, 4);
%      Donnees_cinematiques.Param_B_Mean(ind, 14) = Donnees_cinematiques.Param_B_Mean(ind, 2)*Donnees_cinematiques.Param_B_Mean(ind, 4);
% 
%      Donnees_cinematiques.Param_R_Mean(ind, 15) = Donnees_cinematiques.Param_R_Mean(ind, 2)-Donnees_cinematiques.Param_R_Mean(ind, 14);
%      Donnees_cinematiques.Param_B_Mean(ind, 15) = Donnees_cinematiques.Param_B_Mean(ind, 2)-Donnees_cinematiques.Param_B_Mean(ind, 14);
%  
%  end
%  Donnees_cinematiques.Param_R_Mean = real(Donnees_cinematiques.Param_R_Mean);
%   Donnees_cinematiques.Param_B_Mean = real(Donnees_cinematiques.Param_B_Mean);
%  % On cr�e une matrice des profils d'acc�l tri�s
%  
%  Donnees_cinematiques.accelsort.R = Donnees_cinematiques.AccelCut.R(:, Idx_R);
%  Donnees_cinematiques.accelsort.B = Donnees_cinematiques.AccelCut.B(:, Idx_B);
%  
%  % On cr�e des profils de vitesse et d'accel moyens
%  
%  Profil_vitesse_moy_R = meantrials(Donnees_cinematiques.VelCutSort.R, Nb_averaged_trials);
%  Profil_vitesse_moy_B = meantrials(Donnees_cinematiques.VelCutSort.B, Nb_averaged_trials);
%  
%  
%  Profil_accel_moy_R = meantrials(Donnees_cinematiques.accelsort.R, Nb_averaged_trials);
%  Profil_accel_moy_B = meantrials(Donnees_cinematiques.accelsort.B, Nb_averaged_trials);
%  
%  
%  [lig_pa_R, ~] = size(Profil_accel_moy_R);
%  [lig_pa_B, ~] = size(Profil_accel_moy_B);
%  
%  % On fait pareil avec les profils avec l'anticipation
% 
%  Donnees_cinematiques.antvelocity.R = Donnees_cinematiques.antvelocity.R(:, Idx_R);
%  Donnees_cinematiques.antvelocity.B = Donnees_cinematiques.antvelocity.B(:, Idx_B);
%  
%  Donnees_cinematiques.antaccel.B = derive(Donnees_cinematiques.antvelocity.B, 1)./(1/Frequence_acquisition);
%  Donnees_cinematiques.antaccel.R = derive(Donnees_cinematiques.antvelocity.R, 1)./(1/Frequence_acquisition);
%  
%  Profil_vitesse_ant_R = meantrials(Donnees_cinematiques.antvelocity.R, Nb_averaged_trials);
%  Profil_vitesse_ant_B = meantrials(Donnees_cinematiques.antvelocity.B, Nb_averaged_trials);
%  
%  Profil_accel_ant_R = meantrials(Donnees_cinematiques.antaccel.R, Nb_averaged_trials);
%  Profil_accel_ant_B = meantrials(Donnees_cinematiques.antaccel.B, Nb_averaged_trials);
%  
%  % On calcule les param�tres cin�matiques sur les profils tri�s et moyenn�s
%  
%  for k = 1:colR/Nb_averaged_trials
%      
%      Donnees_cinematiques.Profils_means.Results.R(k, 1) = max(Profil_accel_moy_R(:, k));
%      Donnees_cinematiques.Profils_means.Results.B(k, 1) = max(Profil_accel_moy_B(:, k));
%      
%      Donnees_cinematiques.Profils_means.Results.R(k, 7) = min(Profil_accel_moy_R(:, k));
%      Donnees_cinematiques.Profils_means.Results.B(k, 7) = min(Profil_accel_moy_B(:, k));
%      
%      Donnees_cinematiques.Profils_means.Results.R(k, 2) = max(Profil_vitesse_moy_R(:, k));
%      Donnees_cinematiques.Profils_means.Results.B(k, 2) = max(Profil_vitesse_moy_B(:, k));
%         
%      [~, ind_pa_R] = max(Profil_accel_moy_R(:, k));
%      [~, ind_pa_B] = max(Profil_accel_moy_B(:, k));
%      
%      [~, ind_pv_R] = max(Profil_vitesse_moy_R(:, k));
%      [~, ind_pv_B] = max(Profil_vitesse_moy_B(:, k));
%      
%      Donnees_cinematiques.Profils_means.Results.R(k, 3) = ind_pa_R/Frequence_acquisition;
%      Donnees_cinematiques.Profils_means.Results.B(k, 3) = ind_pa_B/Frequence_acquisition;
%      
%      Donnees_cinematiques.Profils_means.Results.R(k, 4) = ind_pv_R/Frequence_acquisition;
%      Donnees_cinematiques.Profils_means.Results.B(k, 4) = ind_pv_B/Frequence_acquisition;
%      
%      a = ind_pv_R;
%      
%      while Profil_vitesse_moy_R(a, k) > Profil_vitesse_moy_R(1, k) && a<ligR
%          a = a+1;
%      end
%      
%      b = ind_pv_B;
%      
%      while Profil_vitesse_moy_B(b, k) > Profil_vitesse_moy_B(1, k) && b<ligB
%          b = b+1;
%      end
%      
%      
%      Donnees_cinematiques.Profils_means.Results.R(k, 5) = a/Frequence_acquisition;
%      Donnees_cinematiques.Profils_means.Results.B(k, 5) = b/Frequence_acquisition;
%      
%      Mean_Baseline_Vitesse_R = mean(Donnees_cinematiques.antvelocity.R(10:20, k));
%      Mean_Baseline_Vitesse_B = mean(Donnees_cinematiques.antvelocity.B(10:20, k));
%      
%      Std_Baseline_Vitesse_R = std(Donnees_cinematiques.antvelocity.R(10:20, k));
%      Std_Baseline_Vitesse_B = std(Donnees_cinematiques.antvelocity.B(10:20, k));
%      
%      g = ind_pv_R+25;
%      
%      while Profil_vitesse_ant_R(g, k) > Mean_Baseline_Vitesse_R+ICvalueK*Std_Baseline_Vitesse_R && g>1
%          g = g-1;
%          
%      end
%      
%      d = ind_pv_B+25;
%      
%      while Profil_vitesse_ant_B(d, k) > Mean_Baseline_Vitesse_B+ICvalueK*Std_Baseline_Vitesse_B && d>1
%          d = d-1;
%          
%      end
%      
%      Donnees_cinematiques.Profils_means.Results.R(k, 6) = g*10;
%      Donnees_cinematiques.Profils_means.Results.B(k, 6) = d*10;
     
     
%  end 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Importation des donn�es MVT LENT %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if MVT_LENT == true
%On selectionne le repertoire
disp('Selectionnez le Dossier regroupant les essais lents');
[Dossier] = uigetdir ('Selectionnez le Dossier o� ex�cuter le Script');

if (Dossier ~= 0) % Si on clique sur un dossier
    
    Extension = '*.mat'; %Traite tous les .mat
    
    %On construit le chemin
    Chemin = fullfile(Dossier, Extension);
    
    %On construit la liste des fichiers
    ListeFichier = dir(Chemin);

    %% On cr�e les matrices de r�sultats
    
    Donnees_EMG_lent = {};
    Donnees_cinematiques_lent = {};
    Premiere_fois = true; % Pour n'effecteur certaines actions de lecture des labels qu'une seule fois
    disp('POST TRAITEMENT MOUVEMENTS LENTS -- BRAS')
    disp(append('Il y a ', string(numel(ListeFichier)),' fichiers � analyser.'));

    %% On proc�de au balayage fichier par fichier
     for i = 1: numel(ListeFichier)
       disp(append("i = "+i));
       Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
        
       load (Fichier_traite);
       
       if Bras_Droit == true             % POUR LE COTE DROIT
           marqueurShoulder = 'RSHO';  marqueurFinger = 'RFIN'; a_muscle = 1;
        MUSCLE_1 = 1; % POUR DELTO A DROIT
        MUSCLE_2 = 2; % POUR DELTO P DROIT

       else                               % POUR LE COTE GAUCHE 
           marqueurShoulder = 'LSHO';  marqueurFinger = 'LFIN'; a_muscle = 3;
        MUSCLE_1 = 3; % POUR DELTO A gauche
        MUSCLE_2 = 4; % POUR DELTO P gauche
       end


       if Premiere_fois %% Boucle pour trouver les coordonn�es du marqueur de l'�paule et du doigt
            j=0; marqueur = 'a';
            while ~strcmp(marqueur,marqueurShoulder)
                j=j+1;
                marqueur = C3D.Cinematique.Labels(j);  
            end
            disp(append('Le marqueur ', marqueurShoulder,' est le num�ro ',string(j)));
            j = j*4-1;

            j2=0; marqueur2 = 'a';
            while ~strcmp(marqueur2,marqueurFinger)
                j2=j2+1;
                marqueur2 = C3D.Cinematique.Labels(j2);  
            end
            disp(append('Le marqueur ', marqueurFinger,' est le num�ro ',string(j2)));
            j2 = j2*4-1;
        
            Premiere_fois = false;
       end

        %On cr�e une matrice de la position du doigt et de l'�paule
        posxyz = C3D.Cinematique.Donnees(:, j2-2:j2);
        pos_epaule = C3D.Cinematique.Donnees(:, j-2:j);   
        
        [posxyz_lig, ~] = size(posxyz);
        
        %On filtre le signal de position
        posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
        posfiltre_epaule = butter_emgs(pos_epaule, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
       
        %On coupe le signal de vitesse pour avoir 2 plages contenant chacune un mouvement

        plot(posfiltre(:, 3))
        [Cut] = ginput(3);

        Plage_mvmt_1_start = round(Cut(1,1));
        Plage_mvmt_1_end = round(Cut(2,1));
        
        Plage_mvmt_2_start = round(Cut(2,1));
        Plage_mvmt_2_end = round(Cut(3,1));
        
        [Pos_mvmt_1] = posfiltre(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
        [Pos_mvmt_2] = posfiltre(Plage_mvmt_2_start:Plage_mvmt_2_end, :);  
        
        [Pos_epaule_mvmt_1] = posfiltre_epaule(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
        [Pos_epaule_mvmt_2] = posfiltre_epaule(Plage_mvmt_2_start:Plage_mvmt_2_end, :);
        
      
        %On attribue une cible aux 2 mouvements
                              
        
        %% On calcule les param�tres cin�matiques des 2 mouvements
        
        % Premier Mouvement
        [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_1, vitesse1, profil_vitesse_1_norm, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, Vmoy_1, Param_C_1, Amp_1, Angle_mvmt_1, Nbmaxloc_1, debut_1, fin_1, Amp_reel_1, Angle_reel_1, profil_accel_1] = compute_kinematics_BrasDom_nondom(Pos_mvmt_1, Pos_epaule_mvmt_1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin);
        
        % Second Mouvement
        [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_2, vitesse2, profil_vitesse_2_norm, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, Vmoy_2, Param_C_2, Amp_2, Angle_mvmt_2, Nbmaxloc_2, debut_2, fin_2, Amp_reel_2, Angle_reel_2, profil_accel_2] = compute_kinematics_BrasDom_nondom(Pos_mvmt_2, Pos_epaule_mvmt_2, Frequence_acquisition, 1, Cut_off, Ech_norm_kin);

       
        
        %% On remplit les matrices de r�sulats des param�tres cin�matiques pour chaque cas
       
          k = 3*i;
          z = k-2;
            
            Donnees_cinematiques_lent.Position_cut_brut(1:lig_pos_1, z:k) = profil_position_1;
            Donnees_cinematiques_lent.Position_cut_brut(1:lig_pos_2, z+3*numel(ListeFichier):k+3*numel(ListeFichier)) = profil_position_2;
            
            Donnees_cinematiques_lent.Position_cut_norm(:, z:k) = profil_position_1_norm;
            Donnees_cinematiques_lent.Position_cut_norm(:, z+3*numel(ListeFichier):k+3*numel(ListeFichier)) = profil_position_2_norm;
            
            Donnees_cinematiques_lent.Vel_cut_brut(1:lig_pv1, i) = profil_vitesse_1;
            Donnees_cinematiques_lent.Vel_cut_brut(1:lig_pv2, i+numel(ListeFichier)) = profil_vitesse_2;          
            
            Donnees_cinematiques_lent.Vel_brut(1:length(vitesse1), i) = vitesse1;
            Donnees_cinematiques_lent.Vel_brut(1:length(vitesse2), i+numel(ListeFichier)) = vitesse2;     
        
            Donnees_cinematiques_lent.Vel_cut_norm(:, i) = profil_vitesse_1_norm;
            Donnees_cinematiques_lent.Vel_cut_norm(:, i+numel(ListeFichier)) = profil_vitesse_2_norm;
            
            Donnees_cinematiques_lent.AccelCut.R(1:lig_pv1, i) = profil_accel_1;
            Donnees_cinematiques_lent.AccelCut.B(1:lig_pv2, i) = profil_accel_2;
            
            Donnees_cinematiques_lent.Results_trial_by_trial(i, 2) = MD_1;
            Donnees_cinematiques_lent.Results_trial_by_trial(i+numel(ListeFichier), 2) = MD_2;
            
                         
         %% Calcul des param�tres electromyographiques
         
%On calcule la taille de la matrice contenant les EMG
size_emg_data = posxyz_lig*emg_div_kin_freq;

% On cr�e la matrice contenant les EMG

emg_data = C3D.EMG.Donnees;

%calcule le d�but et la fin du mouvement sur l'ensemble du signal
%cin�matique

onset_1 = (debut_1+Plage_mvmt_1_start);
offset_1 = (fin_1+Plage_mvmt_1_start);
onset_2 = (debut_2+Plage_mvmt_2_start);
offset_2 = (fin_2+Plage_mvmt_2_start);

% On sauvegarde un profil de position plus large pour trouver le
        % lag de la bouff�e EMG par la suite
        
ligantpos1 = offset_1-onset_1+add_for_ant+1;
ligantpos2 = offset_2-onset_2+add_for_ant+1;

antvelocity_B = sqrt(derive(posfiltre(onset_1-add_for_ant:offset_1, 1), 2).^2+derive(posfiltre(onset_1-add_for_ant:offset_1, 2), 2).^2+derive(posfiltre(onset_1-add_for_ant:offset_1, 3), 2).^2)./(1/Frequence_acquisition);
antvelocity_R = sqrt(derive(posfiltre(onset_2-add_for_ant:offset_2, 1), 2).^2+derive(posfiltre(onset_2-add_for_ant:offset_2, 2), 2).^2+derive(posfiltre(onset_2-add_for_ant:offset_2, 3), 2).^2)./(1/Frequence_acquisition);

Donnees_cinematiques_lent.antvelocity.B(1:ligantpos1, i) = antvelocity_B;
Donnees_cinematiques_lent.antvelocity.R(1:ligantpos2, i) = antvelocity_R;
                
%On calcule les param�tres emg du premier mouvement

[rms_cuts_1, rms_cuts_norm_1, ~, ...
    ~, ~, tonic_starts_1, tonic_ends_1, ...
    rms_cut_lig_1, ~, ~, ...
    ~, ~, tonic_lig_1] = compute_emg(emg_data, Nb_emgs, emg_frequency, ...
    emg_band_pass_Freq, emg_low_pass_Freq, type_RMS, rms_window_step, onset_1, offset_1, ...
    emg_div_kin_freq,  anticip,emg_ech_norm, anticip_tonic, duration_tonic, emgrms_div_kin_freq);

% On calcule les pram�tres EMG du second mouvement

[rms_cuts_2, rms_cuts_norm_2, emg_rms, ...
    emg_filt, emg_rect_filt, tonic_starts_2, tonic_ends_2, ...
    rms_cut_lig_2, emg_data_filtre_rms_lig, emg_data_filtre_lig, ...
    emg_data_filtre_rect_second_lig, anticip_rms, tonic_lig_2] = compute_emg(emg_data, Nb_emgs, emg_frequency, ...
    emg_band_pass_Freq, emg_low_pass_Freq, type_RMS, rms_window_step, onset_2, offset_2, ...
    emg_div_kin_freq,  anticip,emg_ech_norm, anticip_tonic, duration_tonic, emgrms_div_kin_freq);


        
        %% On construit les matrices de r�sultats des EMG
        
%         % Pour le signal EMG brut
Donnees_EMG_lent.Brutes.DA(1:size_emg_data, i) = emg_data(1:size_emg_data, MUSCLE_1);
Donnees_EMG_lent.Brutes.DP(1:size_emg_data, i) = emg_data(1:size_emg_data, MUSCLE_2);
%     
%     % Pour le signal EMG filtr�
Donnees_EMG_lent.Filtrees.DA(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, MUSCLE_1);
Donnees_EMG_lent.Filtrees.DP(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, MUSCLE_2);  
%     
%     % Pour le signal rectifi� et refiltr�
Donnees_EMG_lent.Rectifiees.DA(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, MUSCLE_1);
Donnees_EMG_lent.Rectifiees.DP(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, MUSCLE_2);
%     
    % Pour le signal RMS
    
    % Si on veut normaliser par le max de du bloc
Donnees_EMG_lent.RMS.DA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_1);
Donnees_EMG_lent.RMS.DP(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_2);

%     
EMGMax_DA = max(max(Donnees_EMG_lent.RMS.DA));
EMGMax_DP = max(max(Donnees_EMG_lent.RMS.DP));
    
Donnees_EMG_lent.RMS.DA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG_lent.RMS.DP(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_2);%./EMGMax_DP;
Donnees_EMG_lent.RMSpasnorm.DA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_1);
Donnees_EMG_lent.RMSpasnorm.DP(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, MUSCLE_2);


    % Pour le mouvement RMS brut et normalis� et le tonic, on trie les signaux par direction
Donnees_EMG_lent.RMSCut.DA(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG_lent.RMSCut.DP(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, MUSCLE_2);%./EMGMax_DP;
%        
Donnees_EMG_lent.RMSCut.DA(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG_lent.RMSCut.DP(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, MUSCLE_2);%./EMGMax_DP;
       
       % Mouvements Normalis�s
Donnees_EMG_lent.RMSCutNorm.DA(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG_lent.RMSCutNorm.DP(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, MUSCLE_2);%./EMGMax_DP;
%        
Donnees_EMG_lent.RMSCutNorm.DA(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG_lent.RMSCutNorm.DP(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, MUSCLE_2);%./EMGMax_DP;
       
       % Pour le tonic au d�but
Donnees_EMG_lent.TonicStart.DA(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG_lent.TonicStart.DP(1:tonic_lig_1, i) = tonic_starts_1(1:tonic_lig_1, MUSCLE_2);%./EMGMax_DP;
%        
Donnees_EMG_lent.TonicStart.DA(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG_lent.TonicStart.DP(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_starts_2(1:tonic_lig_2, MUSCLE_2);%./EMGMax_DP;
       
       % Pour le tonic � la fin
Donnees_EMG_lent.TonicEnd.DA(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG_lent.TonicEnd.DP(1:tonic_lig_1, i) = tonic_ends_1(1:tonic_lig_1, MUSCLE_2);%./EMGMax_DP;
%        
Donnees_EMG_lent.TonicEnd.DA(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, MUSCLE_1);%./EMGMax_DA;
Donnees_EMG_lent.TonicEnd.DP(1:tonic_lig_2, i+numel(ListeFichier)) = tonic_ends_2(1:tonic_lig_2, MUSCLE_2);%./EMGMax_DP;
       

    
     end
       
    
      % On rajoute un profil moyen avec erreur standard sur le rms_cut_norm
    
     for f = 1:1000  
%         
Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.R(f, 1) = mean(Donnees_EMG_lent.RMSCutNorm.DA(f, 1:numel(ListeFichier)), 2);
Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.R(f, 4) = mean(Donnees_EMG_lent.RMSCutNorm.DP(f, 1:numel(ListeFichier)), 2);
%         
Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.R(f, 2) = Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.R(f, 1)+std(Donnees_EMG_lent.RMSCutNorm.DA(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.R(f, 5) = Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.R(f, 4)+std(Donnees_EMG_lent.RMSCutNorm.DP(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         
Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.R(f, 3) = Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.R(f, 1)-std(Donnees_EMG_lent.RMSCutNorm.DA(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.R(f, 6) = Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.R(f, 4)-std(Donnees_EMG_lent.RMSCutNorm.DP(f, 1:numel(ListeFichier))./sqrt(numel(ListeFichier)));
% 
Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.B(f, 1) = mean(Donnees_EMG_lent.RMSCutNorm.DA(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.B(f, 4) = mean(Donnees_EMG_lent.RMSCutNorm.DP(f, numel(ListeFichier)+1:2*numel(ListeFichier)), 2);
%         
Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.B(f, 2) = Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.B(f, 1)+std(Donnees_EMG_lent.RMSCutNorm.DA(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.B(f, 5) = Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.B(f, 4)+std(Donnees_EMG_lent.RMSCutNorm.DP(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
%         
Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.B(f, 3) = Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.B(f, 1)-std(Donnees_EMG_lent.RMSCutNorm.DA(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));
Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.B(f, 6) = Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.B(f, 4)-std(Donnees_EMG_lent.RMSCutNorm.DP(f, numel(ListeFichier)+1:2*numel(ListeFichier))./sqrt(numel(ListeFichier)));

     end
     
end
end





     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %% On effectue le second process des Donn�es EMG pour chaque muscle %%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % On calcule le phasique � l'aide des MVTS LENTS pour chaque muscle
[len, colRMSRapide] = size(Donnees_EMG.RMSCutNorm.DA);
Donnees_EMG.Phasic.TonicLent.DA.R = Donnees_EMG.RMSCutNorm.DA(:,1:colRMSRapide/2) - Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.R(:,1);
Donnees_EMG.Phasic.TonicLent.DA.B = Donnees_EMG.RMSCutNorm.DA(:,1+colRMSRapide/2:colRMSRapide) - Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.B(:,1);

Donnees_EMG.Phasic.TonicLent.DP.R = Donnees_EMG.RMSCutNorm.DP(:,1:colRMSRapide/2) - Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.R(:,4);
Donnees_EMG.Phasic.TonicLent.DP.B = Donnees_EMG.RMSCutNorm.DP(:,1+colRMSRapide/2:colRMSRapide) - Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.B(:,4);

     
     %% On calcule le phasique     CLASSIQUE     ET     COMBIN�    pour chaque muscle
     

[EMG_traite.DA, Tonic.DA, Vmean_RMS_R, Vmean_RMS_B, Profil_tonic_R.DA, Profil_tonic_B.DA] = compute_emg2_TonicNew(Donnees_EMG.RMSCut.DA, Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,1), Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,1), ...
          emg_frequency, Donnees_EMG.TonicStart.DA, Donnees_EMG.TonicEnd.DA, Idx, limite_en_temps, Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.R(:, 1), Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.B(:, 1) );
      
[EMG_traite.DP, Tonic.DP, ~, ~, Profil_tonic_R.DP, Profil_tonic_B.DP] = compute_emg2_TonicNew(Donnees_EMG.RMSCut.DP,  Donnees_EMG.RMSCutNorm.ProfilMoyen.R(:,4), Donnees_EMG.RMSCutNorm.ProfilMoyen.B(:,4), ...
          emg_frequency, Donnees_EMG.TonicStart.DP, Donnees_EMG.TonicEnd.DP, Idx, limite_en_temps, Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.R(:, 4), Donnees_EMG_lent.RMSCutNorm.ProfilMoyen.B(:, 4));


        Donnees_EMG.Phasic.Combined.DA.Lever = EMG_traite.DA.combined.R;
        Donnees_EMG.Phasic.Combined.DA.Baisser = EMG_traite.DA.combined.B;

        Donnees_EMG.Phasic.Combined.DP.Lever = EMG_traite.DP.combined.R;
        Donnees_EMG.Phasic.Combined.DP.Baisser = EMG_traite.DP.combined.B;

        Donnees_EMG.Phasic.Classique.DA.Lever = EMG_traite.DA.classique.R;
        Donnees_EMG.Phasic.Classique.DA.Baisser = EMG_traite.DA.classique.B;

        Donnees_EMG.Phasic.Classique.DP.Lever = EMG_traite.DP.classique.R;
        Donnees_EMG.Phasic.Classique.DP.Baisser = EMG_traite.DP.classique.B;

[~, ColPhasicLent]= size(Donnees_EMG.Phasic.TonicLent.DA.R);
[~, ColPhasicClassique]= size(EMG_traite.DA.classique.R);
[~, ColPhasicCombined]= size(EMG_traite.DA.combined.R);

% Profil moyen + Erreur standard 
for f=1:1000
        Donnees_EMG.Phasic.TonicLent.DA.ProfilMoyen(f,1) = mean(Donnees_EMG.Phasic.TonicLent.DA.R(f,1:ColPhasicLent));
        Donnees_EMG.Phasic.TonicLent.DA.ProfilMoyen(f,2) = mean(Donnees_EMG.Phasic.TonicLent.DA.R(f,1:ColPhasicLent))+std(Donnees_EMG.Phasic.TonicLent.DA.R(f,1:ColPhasicLent))/sqrt(ColPhasicLent);
        Donnees_EMG.Phasic.TonicLent.DA.ProfilMoyen(f,3) = mean(Donnees_EMG.Phasic.TonicLent.DA.R(f,1:ColPhasicLent))-std(Donnees_EMG.Phasic.TonicLent.DA.R(f,1:ColPhasicLent))/sqrt(ColPhasicLent);
        Donnees_EMG.Phasic.TonicLent.DA.ProfilMoyen(f,4) = mean(Donnees_EMG.Phasic.TonicLent.DA.B(f,1:ColPhasicLent));
        Donnees_EMG.Phasic.TonicLent.DA.ProfilMoyen(f,5) = mean(Donnees_EMG.Phasic.TonicLent.DA.B(f,1:ColPhasicLent))+std(Donnees_EMG.Phasic.TonicLent.DA.B(f,1:ColPhasicLent))/sqrt(ColPhasicLent);
        Donnees_EMG.Phasic.TonicLent.DA.ProfilMoyen(f,6) = mean(Donnees_EMG.Phasic.TonicLent.DA.B(f,1:ColPhasicLent))-std(Donnees_EMG.Phasic.TonicLent.DA.B(f,1:ColPhasicLent))/sqrt(ColPhasicLent);
        
        Donnees_EMG.Phasic.TonicLent.DP.ProfilMoyen(f,1) = mean(Donnees_EMG.Phasic.TonicLent.DP.R(f,1:ColPhasicLent));
        Donnees_EMG.Phasic.TonicLent.DP.ProfilMoyen(f,2) = mean(Donnees_EMG.Phasic.TonicLent.DP.R(f,1:ColPhasicLent))+std(Donnees_EMG.Phasic.TonicLent.DP.R(f,1:ColPhasicLent))/sqrt(ColPhasicLent);
        Donnees_EMG.Phasic.TonicLent.DP.ProfilMoyen(f,3) = mean(Donnees_EMG.Phasic.TonicLent.DP.R(f,1:ColPhasicLent))-std(Donnees_EMG.Phasic.TonicLent.DP.R(f,1:ColPhasicLent))/sqrt(ColPhasicLent);
        Donnees_EMG.Phasic.TonicLent.DP.ProfilMoyen(f,4) = mean(Donnees_EMG.Phasic.TonicLent.DP.B(f,1:ColPhasicLent));
        Donnees_EMG.Phasic.TonicLent.DP.ProfilMoyen(f,5) = mean(Donnees_EMG.Phasic.TonicLent.DP.B(f,1:ColPhasicLent))+std(Donnees_EMG.Phasic.TonicLent.DP.B(f,1:ColPhasicLent))/sqrt(ColPhasicLent);
        Donnees_EMG.Phasic.TonicLent.DP.ProfilMoyen(f,6) = mean(Donnees_EMG.Phasic.TonicLent.DP.B(f,1:ColPhasicLent))-std(Donnees_EMG.Phasic.TonicLent.DP.B(f,1:ColPhasicLent))/sqrt(ColPhasicLent);


        Donnees_EMG.Phasic.Classique.DA.ProfilMoyen(f,1) = mean(EMG_traite.DA.classique.R(f,1:ColPhasicClassique));
        Donnees_EMG.Phasic.Classique.DA.ProfilMoyen(f,2) = mean(EMG_traite.DA.classique.R(f,1:ColPhasicClassique))+std(EMG_traite.DA.classique.R(f,1:ColPhasicClassique))/sqrt(ColPhasicClassique);
        Donnees_EMG.Phasic.Classique.DA.ProfilMoyen(f,3) = mean(EMG_traite.DA.classique.R(f,1:ColPhasicClassique))-std(EMG_traite.DA.classique.R(f,1:ColPhasicClassique))/sqrt(ColPhasicClassique);
        Donnees_EMG.Phasic.Classique.DA.ProfilMoyen(f,4) = mean(EMG_traite.DA.classique.B(f,1:ColPhasicClassique));
        Donnees_EMG.Phasic.Classique.DA.ProfilMoyen(f,5) = mean(EMG_traite.DA.classique.B(f,1:ColPhasicClassique))+std(EMG_traite.DA.classique.B(f,1:ColPhasicClassique))/sqrt(ColPhasicClassique);
        Donnees_EMG.Phasic.Classique.DA.ProfilMoyen(f,6) = mean(EMG_traite.DA.classique.B(f,1:ColPhasicClassique))-std(EMG_traite.DA.classique.B(f,1:ColPhasicClassique))/sqrt(ColPhasicClassique);

        Donnees_EMG.Phasic.Classique.DP.ProfilMoyen(f,1) = mean(EMG_traite.DP.classique.R(f,1:ColPhasicClassique));
        Donnees_EMG.Phasic.Classique.DP.ProfilMoyen(f,2) = mean(EMG_traite.DP.classique.R(f,1:ColPhasicClassique))+std(EMG_traite.DP.classique.R(f,1:ColPhasicClassique))/sqrt(ColPhasicClassique);
        Donnees_EMG.Phasic.Classique.DP.ProfilMoyen(f,3) = mean(EMG_traite.DP.classique.R(f,1:ColPhasicClassique))-std(EMG_traite.DP.classique.R(f,1:ColPhasicClassique))/sqrt(ColPhasicClassique);
        Donnees_EMG.Phasic.Classique.DP.ProfilMoyen(f,4) = mean(EMG_traite.DP.classique.B(f,1:ColPhasicClassique));
        Donnees_EMG.Phasic.Classique.DP.ProfilMoyen(f,5) = mean(EMG_traite.DP.classique.B(f,1:ColPhasicClassique))+std(EMG_traite.DP.classique.B(f,1:ColPhasicClassique))/sqrt(ColPhasicClassique);
        Donnees_EMG.Phasic.Classique.DP.ProfilMoyen(f,6) = mean(EMG_traite.DP.classique.B(f,1:ColPhasicClassique))-std(EMG_traite.DP.classique.B(f,1:ColPhasicClassique))/sqrt(ColPhasicClassique);
        

        Donnees_EMG.Phasic.Combined.DA.ProfilMoyen(f,1) = mean(EMG_traite.DA.combined.R(f,1:ColPhasicCombined));
        Donnees_EMG.Phasic.Combined.DA.ProfilMoyen(f,2) = mean(EMG_traite.DA.combined.R(f,1:ColPhasicCombined))+std(EMG_traite.DA.combined.R(f,1:ColPhasicClassique))/sqrt(ColPhasicCombined);
        Donnees_EMG.Phasic.Combined.DA.ProfilMoyen(f,3) = mean(EMG_traite.DA.combined.R(f,1:ColPhasicCombined))-std(EMG_traite.DA.combined.R(f,1:ColPhasicClassique))/sqrt(ColPhasicCombined);
        Donnees_EMG.Phasic.Combined.DA.ProfilMoyen(f,4) = mean(EMG_traite.DA.combined.B(f,1:ColPhasicCombined));
        Donnees_EMG.Phasic.Combined.DA.ProfilMoyen(f,5) = mean(EMG_traite.DA.combined.B(f,1:ColPhasicCombined))+std(EMG_traite.DA.combined.B(f,1:ColPhasicCombined))/sqrt(ColPhasicCombined);
        Donnees_EMG.Phasic.Combined.DA.ProfilMoyen(f,6) = mean(EMG_traite.DA.combined.B(f,1:ColPhasicCombined))-std(EMG_traite.DA.combined.B(f,1:ColPhasicCombined))/sqrt(ColPhasicCombined);
        
        Donnees_EMG.Phasic.Combined.DP.ProfilMoyen(f,1) = mean(EMG_traite.DP.combined.R(f,:));
        Donnees_EMG.Phasic.Combined.DP.ProfilMoyen(f,2) = mean(EMG_traite.DP.combined.R(f,1:ColPhasicCombined))+std(EMG_traite.DP.combined.R(f,1:ColPhasicClassique))/sqrt(ColPhasicCombined);
        Donnees_EMG.Phasic.Combined.DP.ProfilMoyen(f,3) = mean(EMG_traite.DP.combined.R(f,1:ColPhasicCombined))-std(EMG_traite.DP.combined.R(f,1:ColPhasicClassique))/sqrt(ColPhasicCombined);
        Donnees_EMG.Phasic.Combined.DP.ProfilMoyen(f,4) = mean(EMG_traite.DP.combined.B(f,:));
        Donnees_EMG.Phasic.Combined.DP.ProfilMoyen(f,5) = mean(EMG_traite.DP.combined.B(f,1:ColPhasicCombined))+std(EMG_traite.DP.combined.B(f,1:ColPhasicClassique))/sqrt(ColPhasicCombined);
        Donnees_EMG.Phasic.Combined.DP.ProfilMoyen(f,6) = mean(EMG_traite.DP.combined.B(f,1:ColPhasicCombined))-std(EMG_traite.DP.combined.B(f,1:ColPhasicClassique))/sqrt(ColPhasicCombined);
end


Donnees_EMG.PhasicQuantif.DA = EMG_traite.DA.QuantifDesac;
Donnees_EMG.PhasicQuantif.DP = EMG_traite.DP.QuantifDesac;

%% PARTIE EXPORT DES DONNEES

Donnees.EMG = Donnees_EMG;
Donnees.cinematiques = Donnees_cinematiques;
Donnees.Muscles = C3D.EMG.Labels;


name = append(C3D.NomSujet(1,:),'');
disp('Selectionnez le Dossier o� enregistre les donn�es.');
[Dossier] = uigetdir ('Selectionnez le Dossier o� enregistre les donn�es.');
save([Dossier '/' name ], 'Donnees');
delete(findall(0));
disp('Donn�es enregistr�es avec succ�s !');

