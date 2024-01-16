
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   COPIE AVANT CHANGEMENT DU CALCUL DU TONIC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
































close all
clear all

%% Informations sur le traitement des données
% Données pour le traitement cinématique
Low_pass_Freq = 5; % Fréquence passe-bas la position pour la cinématique
Cut_off = 0.1; % Pourcentage du pic de vitesse pour déterminer début et fin du mouvement POUR MVTS RAPIDES
Ech_norm_kin = 1000; % Fréquence d'échantillonage du profil de vitesse normalisé en durée 
Frequence_acquisition = 200; % Fréquence d'acquisition du signal cinématique
emg_band_pass_Freq = [30 300]; % Passe_bande du filtre EMG
emg_low_pass_Freq = 20; % Fréquence passe_bas lors du second filtre du signal emg. 100 est la fréquence habituelle chez les humains (cf script Jérémie)
emg_ech_norm = 1000; % Fréquence d'échantillonage du signal EMG
param_moyenne = 200; % Nb images pour moyenner la position pendant phases stables
param_moyenne2 = 200/5; % Nb images pour moyenner la position pendant phases stables
nb_images_to_add=param_moyenne/2;

% Données pour le traitement EMG
anticip = 0.25; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée
emg_frequency = 1000; % Fréquence d'acquisition du signal EMG
%Nb_averaged_trials = 2; % Indicate the number of EMG traces to be averaged 
Nb_emgs = 14; % Spécification du nombre de channels EMG
rms_window = 200; % Time in ms of the window used to compute sliding root mean square of EMG
rms_window_step = (rms_window/1000)*emg_frequency;
emg_div_kin_freq = emg_frequency/Frequence_acquisition; %used to synchronized emg cutting (for sliding rms) with regard to kinematics
NB_SD = 15; % Nombre d'écart-types utilisé pour détecter le début/fin du mouvement lent
limite_en_temps = 0.04; % en ms, correspond au temps minimal pour considérer une désactivation

%% Importation des données

%On selectionne le repertoire
disp('Selectionnez le Dossier regroupant les essais lents');
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');

if (Dossier ~= 0) %Si on clique sur un dossier
    
    Extension = '*.mat'; %Traite tous les .mat
    Chemin = fullfile(Dossier, Extension); % On construit le chemin
    ListeFichier = dir(Chemin); % On construit la liste des fichiers

%% On crée les matrices de résultats

    Donnees = {};
    Donnees_EMG_TL = {};
    Donnees_cinematiques_TL = {};
    Premiere_fois = true; % Pour n'effecteur certaines actions de lecture des labels qu'une seule fois
    
%% On procède au balayage fichier par fichier
    disp('POST TRAITEMENT MOUVEMENTS RAPIDES')
    disp(append('Il y a ', string(numel(ListeFichier)),' fichiers à analyser.'));
    for i = 1: numel(ListeFichier)
 
       Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
       disp(append('i = ',string(i)));
       load (Fichier_traite);
       
        if Premiere_fois %% Boucle pour trouver les coordonnées du marqueur de l'épaule gauche
            j=0; marqueur = 'a';
            while ~strcmp(marqueur,'LSHO')
                j=j+1;
                marqueur = C3D.Cinematique.Labels(j);  
            end
            disp(append('Le marqueur LSHO est le numéro ',string(j)));
            j = j*4-1;
        
            Nb_emgs = length(C3D.EMG.Labels); %% On compte le nombre d'EMG présents dans le fichier
            Premiere_fois = false;
            disp(append('Il y a ',string(Nb_emgs),' signaux EMG'));
        end
       
        %On crée une matrice de la position de l'épaule
        posxyz = C3D.Cinematique.Donnees(:, j-2:j);
        [posxyz_lig, ~] = size(posxyz);
        
        %On filtre le signal de position
        posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
        vec_position = sqrt(posfiltre(:, 1).^2+posfiltre(:, 2).^2+posfiltre(:, 3).^2);
        
        %On coupe le signal de vitesse pour avoir 2 plages contenant chacune un mouvement
        Titredec = append('Découpage mvt lent numéro ', string(i));
        figure('Name',Titredec,'NumberTitle','off');
        plot(vec_position(:, 1))
        [Cut] = ginput(1);
        
        % On prédécoupe selon la définition manuelle
        Plage_mvmt_1_end = round(Cut(1,1));
        Plage_mvmt_2_start = round(Cut(1,1));
        % On ajoute 100 images pour le calcul des phases stables
        [Pos_mvmt_1] = posfiltre(1:Plage_mvmt_1_end+nb_images_to_add, :);  
        [Pos_mvmt_2] = posfiltre(Plage_mvmt_2_start-nb_images_to_add:length(posfiltre), :);
        
%% On calcule les paramètres cinématiques des 2 mouvements
        
        % Premier Mouvement
        [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_pas_cut_1, moy_deb_1, moy_fin_1, std_deb_1, std_fin_1, profil_vitesse_1, profil_vitesse_1_norm, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, Vmoy_1, Param_C_1, Nbmaxloc_1, debut_1, fin_1, profil_accel_1] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin, param_moyenne, NB_SD);
        % Second Mouvement
        [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_pas_cut_2, moy_deb_2, moy_fin_2, std_deb_2, std_fin_2, profil_vitesse_2, profil_vitesse_2_norm, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, Vmoy_2, Param_C_2, Nbmaxloc_2, debut_2, fin_2, profil_accel_2] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_2, Frequence_acquisition, 2, Cut_off, Ech_norm_kin, param_moyenne, NB_SD);
        
%% On remplit les matrices de résulats des paramètres cinématiques des mvts très lents
       
        k = 3*i;
        z = k-2;
        
%%%%% DATA SEQ

        Donnees_cinematiques_TL.Position_cut_brut(1:lig_pos_1, z:k) = profil_position_1;
        Donnees_cinematiques_TL.Position_cut_brut(1:lig_pos_2, z+3*numel(ListeFichier):k+3*numel(ListeFichier)) = profil_position_2;
        Donnees_cinematiques_TL.Position_cut_norm(:, z:k) = profil_position_1_norm;
        Donnees_cinematiques_TL.Position_cut_norm(:, z+3*numel(ListeFichier):k+3*numel(ListeFichier)) = profil_position_2_norm;
        Donnees_cinematiques_TL.Vel_brut(1:length(profil_vitesse_pas_cut_1), i) = profil_vitesse_pas_cut_1;
        Donnees_cinematiques_TL.Vel_brut(1:length(profil_vitesse_pas_cut_2), i+numel(ListeFichier)) = profil_vitesse_pas_cut_2;
        Donnees_cinematiques_TL.Vel_cut_brut(1:lig_pv1, i) = profil_vitesse_1;
        Donnees_cinematiques_TL.Vel_cut_brut(1:lig_pv2, i+numel(ListeFichier)) = profil_vitesse_2;           
        Donnees_cinematiques_TL.Vel_cut_norm(:, i) = profil_vitesse_1_norm;
        Donnees_cinematiques_TL.Vel_cut_norm(:, i+numel(ListeFichier)) = profil_vitesse_2_norm;
        Donnees_cinematiques_TL.Acc(1:lig_pv1, i) = profil_accel_1;
        Donnees_cinematiques_TL.Acc(1:lig_pv2, i+numel(ListeFichier)) = profil_accel_2;            
            
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 2) = MD_1;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+numel(ListeFichier), 2) = MD_2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 3) = rD_PA_1;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+numel(ListeFichier), 3) = rD_PA_2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 4) = rD_PV_1;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+numel(ListeFichier), 4) = rD_PV_2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 5) = rD_PD_1;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+numel(ListeFichier), 5) = rD_PD_2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 6) = PA_max_1;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+numel(ListeFichier), 6) = PA_max_2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 7) = PD_max_1;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+numel(ListeFichier), 7) = PD_max_2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 8) = pv1_max;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+numel(ListeFichier), 8) = pv2_max;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 8) = Vmoy_1;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+numel(ListeFichier), 8) = Vmoy_2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 8) = Param_C_1;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+numel(ListeFichier), 8) = Param_C_2;
        
            
        Titre = append('Vérification découpage mvts lents de ',string(C3D.NomSujet(1,:)));
        figure('Name',Titre,'NumberTitle','off');
        plot(vec_position(:,1),'DisplayName','vec_position(:,1)');hold on;
        y = ylim; % current y-axis limits
        x = xlim; % current y-axis limits
        
        plot([debut_1 debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
        plot([fin_1 fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
        plot([x(1) x(1)+param_moyenne],[moy_deb_1(:,1) moy_deb_1(:,1)],'r');hold on; %moyenne debut

        plot([Plage_mvmt_1_end-param_moyenne/2 Plage_mvmt_1_end+param_moyenne/2],[moy_fin_1(:,1) moy_fin_1(:,1)],'b');hold on; % moyenne milieu
        plot([Plage_mvmt_1_end Plage_mvmt_1_end],[y(1) y(2)],'b');hold on; % ginput au milieu

        plot([Plage_mvmt_2_start+debut_2-param_moyenne/2 Plage_mvmt_2_start+debut_2-param_moyenne/2],[y(1) y(2)],'g');hold on; %debut mvt 2
        plot([Plage_mvmt_2_start+fin_2-param_moyenne/2 Plage_mvmt_2_start+fin_2-param_moyenne/2],[y(1) y(2)],'g'); % fin  mvt 2
        plot([length(vec_position(:,1))-param_moyenne length(vec_position(:,1))],[moy_fin_2(:,1) moy_fin_2(:,1)],'g');hold on; %moyenne fin
        title('Position en Z marqueur épaule ')
        %disp(Plage_mvmt_2_start);
        w = waitforbuttonpress;
        axes;

        % %% Pour comparer avec la détection de mvt avec 10%
        % ZZ = 4;
        % plot(Donnees_cinematiques_TL.Vel_brut(:,ZZ)); hold on;
        % y2 = ylim; % current y-axis limits
        % x2 = xlim; % current y-axis limits
        % plot([x2(1) x2(2)],[0.1*max(Donnees_cinematiques_TL.Vel_brut(:,ZZ)) 0.1*max(Donnees_cinematiques_TL.Vel_brut(:,ZZ))],'r'); hold on; % debut mvt 1

        [nb_ligne,nb_col] = size(Donnees_cinematiques_TL.Vel_cut_norm);
        a=1;a2=1+nb_col/2; % a correspond au début des mvts lents se lever,      a2 correspond au début des mvts lents se rassoir
        b=nb_col/2;b2=nb_col; % b correspond à la fin des mvts lents se lever,      b2 correspond à la fin des mvts lents se rassoir


%% Calcul des paramètres electromyographiques

        %On calcule la taille de la matrice contenant les EMG
        size_emg_data = posxyz_lig*emg_div_kin_freq;

        % On crée la matrice contenant les EMG

        emg_data = C3D.EMG.Donnees;
        emg_data(:, 1) = C3D.EMG.Donnees(:, 1);
        emg_data(:, 2) = C3D.EMG.Donnees(:, 2);

        %calcule le début et la fin du mouvement sur l'ensemble du signal
        %cinématique

        onset_1 = (debut_1);
        offset_1 = (fin_1);
        onset_2 = (debut_2+Plage_mvmt_2_start);
        offset_2 = (fin_2+Plage_mvmt_2_start);

    %On calcule les paramètres emg du premier mouvement
        [rms_cuts_1, rms_cuts_norm_1, ~, ...
            ~, ~, ...
            rms_cut_lig_1, ~, ~, ...
            ~] = compute_emg_WB(emg_data, Nb_emgs, emg_frequency, ...
            emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step, onset_1, offset_1, ...
            emg_div_kin_freq, anticip,emg_ech_norm);

        % On calcule les pramètres EMG du second mouvement

        [rms_cuts_2, rms_cuts_norm_2, emg_rms, ...
            emg_filt, emg_rect_filt, ...
            rms_cut_lig_2, emg_data_filtre_rms_lig, emg_data_filtre_lig, ...
            emg_data_filtre_rect_second_lig] = compute_emg_WB(emg_data, Nb_emgs, emg_frequency, ...
            emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step, onset_2, offset_2, ...
            emg_div_kin_freq,  anticip,emg_ech_norm);


%% On construit les matrices de résultats des EMG
        
            o=0;
            for m = 1:Nb_emgs
                Donnees_EMG_TL.Brutes(1:size_emg_data, o+i) = emg_data(1:size_emg_data, m);   
                Donnees_EMG_TL.Filtrees(1:emg_data_filtre_lig, o+i) = emg_filt(1:emg_data_filtre_lig, m);
                Donnees_EMG_TL.Rectifiees(1:emg_data_filtre_rect_second_lig, o+i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, m);
                Donnees_EMG_TL.RMS(1:emg_data_filtre_rms_lig, o+i) = emg_rms(1:emg_data_filtre_rms_lig, m);  

                Donnees_EMG_TL.RMSCut(1:rms_cut_lig_1, o+i) = rms_cuts_1(1:rms_cut_lig_1, m);
                Donnees_EMG_TL.RMSCut(1:rms_cut_lig_2, o+i+Nb_emgs*numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, m);
                Donnees_EMG_TL.RMSCutNorm(1:emg_ech_norm, o+i) = rms_cuts_norm_1(1:emg_ech_norm, m); 
                Donnees_EMG_TL.RMSCutNorm(1:emg_ech_norm, o+i+Nb_emgs*numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, m);
                o = o+numel(ListeFichier);
            end

     end

%% Données moyennes se lever
    for f = 1:Ech_norm_kin
        o=0;
        p=0;
        for m = 1:Nb_emgs
            Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL.RMSCutNorm(f,a+o:b+o),2);
            Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL.RMSCutNorm(f,a+o:b+o),2)+std(Donnees_EMG_TL.RMSCutNorm(f,a+o:b+o));
            Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL.RMSCutNorm(f,a+o:b+o),2)-std(Donnees_EMG_TL.RMSCutNorm(f,a+o:b+o));

            Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o),2);
            Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o),2)+std(Donnees_EMG_TL.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o));
            Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o),2)-std(Donnees_EMG_TL.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o));
            o = o+numel(ListeFichier);
            p= p+3;
        end

    end

    delete(findall(0));
    %clear C3D;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PARTIE SUR LES MVTS RAPIDES %% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Savec_J = j;
j = Savec_J;
disp('Selectionnez le Dossier regroupant les essais à vitesse rapide');
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script MVT Rapide');

if (Dossier ~= 0) %Si on clique sur un dossier
    
    Extension = '*.mat'; %Traite tous les .mat
    
    %On construit le chemin
    Chemin = fullfile(Dossier, Extension);
    
    %On construit la liste des fichiers
    ListeFichier = dir(Chemin);

    %% On crée les matrices de résultats
    
    Donnees_EMG = {};
    Donnees_cinematiques = {};

    %% On procède au balayage fichier par fichier
    disp('POST TRAITEMENT MOUVEMENTS RAPIDES')
    disp(append('Il y a ', string(numel(ListeFichier)),' fichiers à analyser.'));
     for i = 1: numel(ListeFichier)
         
       disp(append('i = ',string(i)));
       Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
        
       load (Fichier_traite);

        %On crée une matrice de la position de l'épaule
        posxyz = C3D.Cinematique.Donnees(:, j-2:j);
        [posxyz_lig, ~] = size(posxyz);
        
        %On filtre le signal de position
        posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
        %On coupe le signal de vitesse pour avoir 2 plages contenant chacune un mouvement
        Titre = append('Position en Z du marqueur ', string(marqueur));
        figure('Name',Titre,'NumberTitle','off');
        plot(posfiltre(:, 3))
        [Cut] = ginput(3);

        Plage_mvmt_1_start = round(Cut(1,1));
        Plage_mvmt_1_end = round(Cut(2,1));
        
        Plage_mvmt_2_start = round(Cut(2,1));
        Plage_mvmt_2_end = round(Cut(3,1));
        
        [Pos_mvmt_1] = posfiltre(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
        [Pos_mvmt_2] = posfiltre(Plage_mvmt_2_start:Plage_mvmt_2_end, :);  
        
        
        %% On calcule les paramètres cinématiques des 2 mouvements
        
%         [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_pas_cut_1, profil_vitesse_1, profil_vitesse_1_norm, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, Vmoy_1, Param_C_1, Nbmaxloc_1, debut_1, fin_1, profil_accel_1] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin);
%         [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_pas_cut_2, profil_vitesse_2, profil_vitesse_2_norm, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, Vmoy_2, Param_C_2, Nbmaxloc_2, debut_2, fin_2, profil_accel_2] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_2, Frequence_acquisition, 2, Cut_off, Ech_norm_kin);

        [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_pas_cut_1, moy_deb_1, moy_fin_1, std_deb_1, std_fin_1, profil_vitesse_1, profil_vitesse_1_norm, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, Vmoy_1, Param_C_1, Nbmaxloc_1, debut_1, fin_1, profil_accel_1] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin, param_moyenne2, NB_SD);
        % Second Mouvement
        [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_pas_cut_2, moy_deb_2, moy_fin_2, std_deb_2, std_fin_2, profil_vitesse_2, profil_vitesse_2_norm, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, Vmoy_2, Param_C_2, Nbmaxloc_2, debut_2, fin_2, profil_accel_2] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_2, Frequence_acquisition, 2, Cut_off, Ech_norm_kin, param_moyenne2, NB_SD);
       
        %% On remplit les matrices de résulats des paramètres cinématiques des mvts très lents
       
          k = 3*i;
          z = k-2;
        
%%%%% DATA SEQ
            
            Donnees_cinematiques.Position_cut_brut(1:lig_pos_1, z:k) = profil_position_1;
            Donnees_cinematiques.Position_cut_brut(1:lig_pos_2, z+3*numel(ListeFichier):k+3*numel(ListeFichier)) = profil_position_2;
            Donnees_cinematiques.Position_cut_norm(:, z:k) = profil_position_1_norm;
            Donnees_cinematiques.Position_cut_norm(:, z+3*numel(ListeFichier):k+3*numel(ListeFichier)) = profil_position_2_norm;
            Donnees_cinematiques.Vel_cut_brut(1:lig_pv1, i) = profil_vitesse_1;
            Donnees_cinematiques.Vel_cut_brut(1:lig_pv2, i+numel(ListeFichier)) = profil_vitesse_2;           
            Donnees_cinematiques.Vel_cut_norm(:, i) = profil_vitesse_1_norm;
            Donnees_cinematiques.Vel_cut_norm(:, i+numel(ListeFichier)) = profil_vitesse_2_norm;
            Donnees_cinematiques.Acc(1:lig_pv1, i) = profil_accel_1;
            Donnees_cinematiques.Acc(1:lig_pv2, i+numel(ListeFichier)) = profil_accel_2;
            Donnees_cinematiques.Results_trial_by_trial(i, 2) = MD_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 2) = MD_2;
            Donnees_cinematiques.Results_trial_by_trial(i, 3) = rD_PA_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 3) = rD_PA_2;
            Donnees_cinematiques.Results_trial_by_trial(i, 4) = rD_PV_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 4) = rD_PV_2;
            Donnees_cinematiques.Results_trial_by_trial(i, 5) = rD_PD_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 5) = rD_PD_2;
            Donnees_cinematiques.Results_trial_by_trial(i, 6) = PA_max_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 6) = PA_max_2;
            Donnees_cinematiques.Results_trial_by_trial(i, 7) = PD_max_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 7) = PD_max_2;
            Donnees_cinematiques.Results_trial_by_trial(i, 8) = pv1_max;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 8) = pv2_max;
            Donnees_cinematiques.Results_trial_by_trial(i, 8) = Vmoy_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 8) = Vmoy_2;
            Donnees_cinematiques.Results_trial_by_trial(i, 8) = Param_C_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 8) = Param_C_2;

            transpo = C3D.Cinematique.CenterOfMass(:,:).';   
            Donnees_cinematiques.COM(1:length(transpo),(i-1)*3+1:(i-1)*3+3) = transpo;  

            transpo_trunkL = C3D.Cinematique.Angles.LTrunk(1,:).';
            transpo_trunkR = C3D.Cinematique.Angles.RTrunk(1,:).';

            transpo_kneeL = C3D.Cinematique.Angles.LKnee(1,:).';
            transpo_kneeR = C3D.Cinematique.Angles.RKnee(1,:).';

            Donnees_cinematiques.ANGLES.troncL(1:length(transpo_trunkL),i) = transpo_trunkL;
            Donnees_cinematiques.ANGLES.troncR(1:length(transpo_trunkR),i) = transpo_trunkR;
            Donnees_cinematiques.ANGLES.kneeL(1:length(transpo_kneeL),i) = transpo_kneeL;
            Donnees_cinematiques.ANGLES.kneeR(1:length(transpo_kneeR),i) = transpo_kneeR;
            
            
            [nb_ligne,nb_col] = size(Donnees_cinematiques.Vel_cut_norm);
            c=1;c2=1+nb_col/2; % c correspond au début des mvts rapides se lever,      c2 correspond au début des mvts rapides se rassoir
            d=nb_col/2;d2=nb_col; % d correspond à la fin des mvts rapides se lever,      d2 correspond à la fin des mvts rapides se rassoir

        
         
        
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

        %On calcule les paramètres emg du premier mouvement
        [rms_cuts_1, rms_cuts_norm_1, ~, ...
            ~, ~, ...
            rms_cut_lig_1, ~, ~, ...
            ~] = compute_emg_WB(emg_data, Nb_emgs, emg_frequency, ...
            emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step, onset_1, offset_1, ...
            emg_div_kin_freq, anticip,emg_ech_norm);

        % On calcule les pramètres EMG du second mouvement

        [rms_cuts_2, rms_cuts_norm_2, emg_rms, ...
            emg_filt, emg_rect_filt, ...
            rms_cut_lig_2, emg_data_filtre_rms_lig, emg_data_filtre_lig, ...
            emg_data_filtre_rect_second_lig] = compute_emg_WB(emg_data, Nb_emgs, emg_frequency, ...
            emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step, onset_2, offset_2, ...
            emg_div_kin_freq,  anticip,emg_ech_norm);
        
        %% On construit les matrices de résultats des EMG
        o=0;
        for m = 1:Nb_emgs
            Donnees_EMG.Brutes(1:size_emg_data, o+i) = emg_data(1:size_emg_data, m);   
            Donnees_EMG.Filtrees(1:emg_data_filtre_lig, o+i) = emg_filt(1:emg_data_filtre_lig, m);
            Donnees_EMG.Rectifiees(1:emg_data_filtre_rect_second_lig, o+i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, m);
            Donnees_EMG.RMS(1:emg_data_filtre_rms_lig, o+i) = emg_rms(1:emg_data_filtre_rms_lig, m);  

            Donnees_EMG.RMSCut(1:rms_cut_lig_1, o+i) = rms_cuts_1(1:rms_cut_lig_1, m);
            Donnees_EMG.RMSCut(1:rms_cut_lig_2, o+i+Nb_emgs*numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, m);
            Donnees_EMG.RMSCutNorm(1:emg_ech_norm, o+i) = rms_cuts_norm_1(1:emg_ech_norm, m); 
            Donnees_EMG.RMSCutNorm(1:emg_ech_norm, o+i+Nb_emgs*numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, m);
            o = o+numel(ListeFichier);
        end

    end

%% Données moyennes se lever
for f = 1:Ech_norm_kin
    o=0;
    p=0;
    for m = 1:Nb_emgs
        Donnees_EMG.RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG.RMSCutNorm(f,a+o:b+o),2);
        Donnees_EMG.RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG.RMSCutNorm(f,a+o:b+o),2)+std(Donnees_EMG.RMSCutNorm(f,a+o:b+o));
        Donnees_EMG.RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG.RMSCutNorm(f,a+o:b+o),2)-std(Donnees_EMG.RMSCutNorm(f,a+o:b+o));
        
        Donnees_EMG.RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o),2);
        Donnees_EMG.RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o),2)+std(Donnees_EMG.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o));
        Donnees_EMG.RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o),2)-std(Donnees_EMG.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o));
        o = o+numel(ListeFichier);
        p= p+3;
    end
end

%% Calcul tonic

[l, nb_col_rms] = size(Donnees_EMG.RMSCutNorm);
Temps_mvts_rapide_se_lever = mean(Donnees_cinematiques.Results_trial_by_trial(1:length(Donnees_cinematiques.Results_trial_by_trial)/2,2));
Temps_mvts_rapide_se_rassoir = mean(Donnees_cinematiques.Results_trial_by_trial(1+length(Donnees_cinematiques.Results_trial_by_trial)/2:length(Donnees_cinematiques.Results_trial_by_trial),2));
i = 1;
j = 1;
compteur_essais = 0;

while j <= nb_col_rms/2 % On ne balaye que la moitié des colonnes car on sépare entre les deux types de mvts
    
    % Calcul du tonic en soustrayant à chaque RMS des essais rapides la moyenne RMS des essais lents
    Donnees_EMG.Phasic.Se_lever(1:emg_ech_norm, j) = Donnees_EMG.RMSCutNorm(:, j)-Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_lever(:, i);
	Donnees_EMG.Phasic.Se_rassoir(1:emg_ech_norm, j) = Donnees_EMG.RMSCutNorm(:, j+nb_col_rms/2)-Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_rassoir(:, i);
    
%% Calculs quantif desac pour le mvt se lever

    % Calcul temps phase desac
    indic = 0; % Variable pour vérifier la longueur des phases de désactivation
    Limite_atteinte = false; % variable bouléene pour enregistrer le fait que les phases de désactivation sont assez longues (ou pas)
    compteur = 0; % Si la désactivation est assez longue, elle est comptée dans cette variable
    Limite_basse_detection = round(Ech_norm_kin * limite_en_temps / Temps_mvts_rapide_se_lever); %Limite d'image à atteindre pour considérer la phase négative 40ms, arrondi à l'image près 
    
    for f = 1 : Ech_norm_kin % Une boucle pour tester toutes les valeurs du phasic
        
        if Donnees_EMG.Phasic.Se_lever(f, j) < 0 % Si la valeur est inf à zero indic est incrementé
           indic = indic + 1 ;
        else   % Sinon
            if Limite_atteinte % Soit la limite avait déjà été atteinte (la phase doit donc être comptée)
                compteur = compteur + indic; % On la compte 
                indic = 0;    % on remet la variable indic à 0 pour vérifier les suivantes
                Limite_atteinte = false; % On remet la variable bouléene à Faux 
            else
                indic = 0; % Si la limite n'avait pas été atteinte on remet simplement l'indicateur à 0
            end
        end
        
        if indic >Limite_basse_detection % Si la variable indicateur augmente et dépasse la limite de détection (40 ms), la limite est atteinte
            Limite_atteinte = true;
        end
        
    end
    
    % Calcul de l'amplitude max de négativité
    [Pmin, indice] = min(Donnees_EMG.Phasic.Se_lever(:, j));
    if Pmin > 0
        Pmin =0;
    end
    amplitude = Pmin * 100 / Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_lever(indice,i);
    
    if compteur>0
       frequence =1;
    else
        frequence = 0;
    end
    
    %% Calculs quantif desac pour le mvt se rassoir
        % Calcul temps phase desac
    indic = 0; % Variable pour vérifier la longueur des phases de désactivation
    Limite_atteinte = false; % variable bouléene pour enregistrer le fait que les phases de désactivation sont assez longues (ou pas)
    compteur2 = 0; % Si la désactivation est assez longue, elle est comptée dans cette variable
    Limite_basse_detection = round(Ech_norm_kin * limite_en_temps / Temps_mvts_rapide_se_rassoir); %Limite d'image à atteindre pour considérer la phase négative 40ms, arrondi à l'image près 
    for f = 1 : Ech_norm_kin % Une boucle pour tester toutes les valeurs du phasic
        
        if Donnees_EMG.Phasic.Se_rassoir(f, j) < 0 % Si la valeur est inf à zero indic est incrementé
           indic = indic + 1 ;
        else   % Sinon
            if Limite_atteinte % Soit la limite avait déjà été atteinte (la phase doit donc être comptée)
                compteur2 = compteur2 + indic; % On la compte 
                indic = 0;    % on remet la variable indic à 0 pour vérifier les suivantes
                Limite_atteinte = false; % On remet la variable bouléene à Faux 
            else
                indic = 0; % Si la limite n'avait pas été atteinte on remet simplement l'indicateur à 0
            end
        end
        
        if indic >Limite_basse_detection % Si la variable indicateur augmente et dépasse la limite de détection (40 ms), la limite est atteinte
            Limite_atteinte = true;
        end
        
    end
    
    % Calcul de l'amplitude max de négativité
    [Pmin, indice] = min(Donnees_EMG.Phasic.Se_rassoir(:, j));
    if Pmin > 0
        Pmin =0;
    end
    amplitude2 = Pmin * 100 / Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_rassoir(indice,i);
    
    if compteur2>0
       frequence2 =1;
    else
        frequence2 = 0;
    end
    
%% Enregistrement des données

    Donnees_EMG.Phasic.QuantifDesac(j, 1) = compteur*Temps_mvts_rapide_se_lever/Ech_norm_kin;  % Pour l'avoir en temps
    Donnees_EMG.Phasic.QuantifDesac(j, 2) = compteur2*Temps_mvts_rapide_se_rassoir/Ech_norm_kin; % Pour l'avoir en temps  
    Donnees_EMG.Phasic.QuantifDesac(j, 5) = amplitude; % Amplitudes des mvts se lever
    Donnees_EMG.Phasic.QuantifDesac(j, 6) = amplitude2; % Amplitudes des mvts se rassoir
    Donnees_EMG.Phasic.QuantifDesac(j, 9) = frequence;  % Fréquence des désac mvt se lever
    Donnees_EMG.Phasic.QuantifDesac(j, 10) = frequence2; % Fréquence des désac mvt se rassoir
    
    compteur_essais = compteur_essais+1;      % Pour soustraire le même tonic moyenné à chaque essai rapide
    if compteur_essais == numel(ListeFichier) % On passe au prochain tonic ( il y en a autant que d'EMG)
        i = i+4;                              % +4 car on utilise les profils moyens (col moyenne   col +SD   col -SD   col vide)
        compteur_essais = 0;
    end
    j = j+1;
end
    i=1; j=1;L=length(Donnees_EMG.Phasic.QuantifDesac(:,1));L2=L/Nb_emgs;
    while i <= L
        Donnees_EMG.Phasic.QuantifDesac(j, 3)= mean(Donnees_EMG.Phasic.QuantifDesac(i:i+L2-1,1));   % Moyenne des temps cumulés/muscle
        Donnees_EMG.Phasic.QuantifDesac(j, 4)= mean(Donnees_EMG.Phasic.QuantifDesac(i:i+L2-1,2));   % Moyenne des temps cumulés/muscle
        Donnees_EMG.Phasic.QuantifDesac(j, 7)= mean(Donnees_EMG.Phasic.QuantifDesac(i:i+L2-1,5));   % Moyenne des amplitudes/muscle
        Donnees_EMG.Phasic.QuantifDesac(j, 8)= mean(Donnees_EMG.Phasic.QuantifDesac(i:i+L2-1,6));   % Moyenne des amplitudes/muscle
        Donnees_EMG.Phasic.QuantifDesac(j, 11)= mean(Donnees_EMG.Phasic.QuantifDesac(i:i+L2-1,9));  % Moyenne des fréquence/muscle
        Donnees_EMG.Phasic.QuantifDesac(j, 12)= mean(Donnees_EMG.Phasic.QuantifDesac(i:i+L2-1,10)); % Moyenne des fréquence/muscle
        i=i+L2; j=j+1;
    end
% Enregistrement du profil moyen EMG phasic
w=1;

for v=1 : Nb_emgs
    for f=1 : Ech_norm_kin
        Donnees_EMG.Phasic.ProfilMoyen.Se_lever(f, v) = mean(Donnees_EMG.Phasic.Se_lever(f,w:w+numel(ListeFichier)-1));
        Donnees_EMG.Phasic.ProfilMoyen.Se_rassoir(f, v) = mean(Donnees_EMG.Phasic.Se_rassoir(f,w:w+numel(ListeFichier)-1));
    end
    w = w + numel(ListeFichier);
end


Donnees.EMG_TL = Donnees_EMG_TL;
Donnees.EMG = Donnees_EMG;
Donnees.cinematiques_TL = Donnees_cinematiques_TL;
Donnees.cinematiques = Donnees_cinematiques;
Donnees.Muscles = C3D.EMG.Labels;

name = append(C3D.NomSujet(1,:),'');
disp('Selectionnez le Dossier où enregistre les données.');
[Dossier] = uigetdir ('Selectionnez le Dossier où enregistre les données.');
save([Dossier '/' name ], 'Donnees');
delete(findall(0));
disp('Données enregistrées avec succès !');

end




% plot(Donnees_EMG.Phasic.QuantifDesac(1:14,11:end),'DisplayName','Donnees_EMG.Phasic.QuantifDesac(1:14,11:end)');hold on;
% y = ylim; % current y-axis limits
% x = xlim; % current y-axis limits
% plot([x(1) x(2)],[mean(Donnees_EMG.Phasic.QuantifDesac(1:14,11)) mean(Donnees_EMG.Phasic.QuantifDesac(1:14,11))],'b');hold on;
% plot([x(1) x(2)],[mean(Donnees_EMG.Phasic.QuantifDesac(1:14,12)) mean(Donnees_EMG.Phasic.QuantifDesac(1:14,12))],'r');

% newcolors = [0 0.4470 0.7410
%     0.8500 0.3250 0.0980
%     0.9290 0.6940 0.1250
%     0.4940 0.1840 0.5560
% 0.4660 0.6740 0.1880
% 0.3010 0.7450 0.9330
% 0.6350 0.0780 0.1840
% 0 1 0
% 1 0 0
% 0 0 0];
%          
% colororder(newcolors)

% for vvv=1:11
%     for i=1:length(Donnees_cinematiques.COM(:,vvv*3-1))
%         if Donnees_cinematiques.COM(i,vvv*3-1)==0
%             Donnees_cinematiques.COM(i,vvv*3-1)=NaN;
%             Donnees_cinematiques.COM(i,vvv*3)=NaN;
%         end
%     end
% 
%     plot(Donnees_cinematiques.COM(:,vvv*3-1),Donnees_cinematiques.COM(:,vvv*3));hold on;
%     %plot(Donnees_cinematiques.COM(:,vvv*3));hold on;
%     xlabel('Axe Y (mm)') 
%     ylabel('Axe Z (mm)') 
%     title('Trajectoire du centre de gravité dans le plan YZ (// au plan sagittal)')
end
% 
% for w=1:12
%     for i=1:length(Donnees_cinematiques.ANGLES.troncL(:,w))
%         if Donnees_cinematiques.ANGLES.troncL(i,w)==0
%             Donnees_cinematiques.ANGLES.troncL(i,w)=NaN;
%         end
%     end
% end
% 
% for w=1:12
%     for i=1:length(Donnees_cinematiques.ANGLES.kneeL(:,w))
%         if Donnees_cinematiques.ANGLES.kneeL(i,w)==0
%             Donnees_cinematiques.ANGLES.kneeL(i,w)=NaN;
%         end
%     end
% end
% 
% 
% fig = figure('Name',Titre,'NumberTitle','off');
% for w=1:12
%     
%     plot(Donnees_cinematiques.ANGLES.troncL(:,w));hold on;
%     xlabel('Frames') 
%     ylabel('(°)') 
%     title('Evolution angle du tronc'); 
% end
% hold off;
% fig = figure('Name',Titre,'NumberTitle','off');
% for w=1:12
%     plot(Donnees_cinematiques.ANGLES.kneeL(:,w));hold on;
%     xlabel('Frames') 
%     ylabel('(°)') 
%     title('Evolution angle du genou'); 
% end
% hold off;