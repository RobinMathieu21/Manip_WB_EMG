
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   COPIE AVANT CHANGEMENT avec différents codes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



























%% Script principal pour manip mvts whole body
% A executer pour post-traiter les données obtenues lors des manips whole
% body. Ce script est à utiliser pour les données STS/BTS et WB reaching.

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
param_moyenne = 100; % Nb images pour moyenner la position pendant phases stables
param_moyenne2 = 200/5; % Nb images pour moyenner la position pendant phases stables
nb_images_to_add=param_moyenne/2;
delay2 = 40;%250;
delay = 100;
pourcen_amp = 0.05;

% Données pour le traitement EMG
anticip = 0.25; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée
emg_frequency = 1000; % Fréquence d'acquisition du signal EMG
%Nb_averaged_trials = 2; % Indicate the number of EMG traces to be averaged 
Nb_emgs = 16; % Spécification du nombre de channels EMG
rms_window = 200; % Time in ms of the window used to compute sliding root mean square of EMG
rms_window_step = (rms_window/1000)*emg_frequency;
emg_div_kin_freq = emg_frequency/Frequence_acquisition; %used to synchronized emg cutting (for sliding rms) with regard to kinematics
NB_SD = 15; % Nombre d'écart-types utilisé pour détecter le début/fin du mouvement lent
limite_en_temps = 0.01; % en ms, correspond au temps minimal pour considérer une désactivation
duration_tonic = 100; % Durée (en ms) de moyennage du tonic
anticip_tonic = 0; % Durée (en ms) pour avoir le dernier point du tonic avant le mouvement et le premier point du tonic après le mouvement
EMD = 0.076; % délai electromécanique moyen de tous les muscles
Nb_averaged_trials = 2;

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
        [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_pas_cut_1, moy_deb_1, moy_fin_1, std_deb_1, std_fin_1, profil_vitesse_1, profil_vitesse_1_norm, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, Vmoy_1, Param_C_1, Nbmaxloc_1, debut_1, fin_1, profil_accel_1] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin, param_moyenne, NB_SD,pourcen_amp);
        % Second Mouvement
        [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_pas_cut_2, moy_deb_2, moy_fin_2, std_deb_2, std_fin_2, profil_vitesse_2, profil_vitesse_2_norm, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, Vmoy_2, Param_C_2, Nbmaxloc_2, debut_2, fin_2, profil_accel_2] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_2, Frequence_acquisition, 2, Cut_off, Ech_norm_kin, param_moyenne, NB_SD,pourcen_amp);
        
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

        onset_1 = (debut_1-delay);
        offset_1 = (fin_1+delay);
        onset_2 = (debut_2+Plage_mvmt_2_start-delay);
        offset_2 = (fin_2+Plage_mvmt_2_start+delay);

    %On calcule les paramètres emg du premier mouvement
        [rms_cuts_1, rms_cuts_norm_1, ~, ...
            ~, ~, ...
            rms_cut_lig_1, ~, ~, ...
            ~, tonic_start_1, tonic_end_1] = compute_emg_WB(emg_data, Nb_emgs, emg_frequency, ...
            emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step, onset_1, offset_1, ...
            emg_div_kin_freq, anticip,emg_ech_norm, duration_tonic, anticip_tonic);

        % On calcule les pramètres EMG du second mouvement

        [rms_cuts_2, rms_cuts_norm_2, emg_rms, ...
            emg_filt, emg_rect_filt, ...
            rms_cut_lig_2, emg_data_filtre_rms_lig, emg_data_filtre_lig, ...
            emg_data_filtre_rect_second_lig, tonic_start_2, tonic_end_2] = compute_emg_WB(emg_data, Nb_emgs, emg_frequency, ...
            emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step, onset_2, offset_2, ...
            emg_div_kin_freq,  anticip, emg_ech_norm, duration_tonic, anticip_tonic);


%% On construit les matrices de résultats des EMG
        
            o=0;
            for m = 1:Nb_emgs
                Donnees_EMG_TL.Brutes(1:size_emg_data, o+i) = emg_data(1:size_emg_data, m);   
                Donnees_EMG_TL.Filtrees(1:emg_data_filtre_lig, o+i) = emg_filt(1:emg_data_filtre_lig, m);
                Donnees_EMG_TL.Rectifiees(1:emg_data_filtre_rect_second_lig, o+i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, m);
                Donnees_EMG_TL.RMS(1:emg_data_filtre_rms_lig, o+i) = emg_rms(1:emg_data_filtre_rms_lig, m);  
                Donnees_EMG_TL.Tonic_start1(1:length(tonic_start_1), o+i) = tonic_start_1(1:length(tonic_start_1), m);
                Donnees_EMG_TL.Tonic_end1(1:length(tonic_end_1), o+i) = tonic_end_1(1:length(tonic_end_1), m);  

                Donnees_EMG_TL.RMSCut(1:rms_cut_lig_1, o+i) = rms_cuts_1(1:rms_cut_lig_1, m);
                Donnees_EMG_TL.RMSCut(1:rms_cut_lig_2, o+i+Nb_emgs*numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, m);
                Donnees_EMG_TL.RMSCutNorm(1:emg_ech_norm, o+i) = rms_cuts_norm_1(1:emg_ech_norm, m); 
                Donnees_EMG_TL.RMSCutNorm(1:emg_ech_norm, o+i+Nb_emgs*numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, m);
                Donnees_EMG_TL.Tonic_start2(1:length(tonic_start_2), o+i) = tonic_start_2(1:length(tonic_start_2), m);
                Donnees_EMG_TL.Tonic_end2(1:length(tonic_end_2), o+i) = tonic_end_2(1:length(tonic_end_2), m);  
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
            Donnees_cinematiques.Results_trial_by_trial(i, 9) = Vmoy_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 9) = Vmoy_2;
            Donnees_cinematiques.Results_trial_by_trial(i, 10) = Param_C_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 10) = Param_C_2;
            

%             transpo = C3D.Cinematique.CenterOfMass(:,:).';   
%             Donnees_cinematiques.COM(1:length(transpo),(i-1)*3+1:(i-1)*3+3) = transpo;  

%             transpo_trunkL = C3D.Cinematique.Angles.LTrunk(1,:).';
%             transpo_trunkR = C3D.Cinematique.Angles.RTrunk(1,:).';
% 
%             transpo_kneeL = C3D.Cinematique.Angles.LKnee(1,:).';
%             transpo_kneeR = C3D.Cinematique.Angles.RKnee(1,:).';
% 
%             Donnees_cinematiques.ANGLES.troncL(1:length(transpo_trunkL),i) = transpo_trunkL;
%             Donnees_cinematiques.ANGLES.troncR(1:length(transpo_trunkR),i) = transpo_trunkR;
%             Donnees_cinematiques.ANGLES.kneeL(1:length(transpo_kneeL),i) = transpo_kneeL;
%             Donnees_cinematiques.ANGLES.kneeR(1:length(transpo_kneeR),i) = transpo_kneeR;
            
            
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

        onset_1 = (debut_1+Plage_mvmt_1_start-delay2);
        offset_1 = (fin_1+Plage_mvmt_1_start+delay2);
        onset_2 = (debut_2+Plage_mvmt_2_start-delay2);
        offset_2 = (fin_2+Plage_mvmt_2_start+delay2);

        %On calcule les paramètres emg du premier mouvement
        [rms_cuts_1, rms_cuts_norm_1, ~, ...
            ~, ~, ...
            rms_cut_lig_1, ~, ~, ...
            ~, tonic_start_1, tonic_end_1] = compute_emg_WB(emg_data, Nb_emgs, emg_frequency, ...
            emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step, onset_1, offset_1, ...
            emg_div_kin_freq, anticip,emg_ech_norm, duration_tonic, anticip_tonic);

        % On calcule les pramètres EMG du second mouvement

        [rms_cuts_2, rms_cuts_norm_2, emg_rms, ...
            emg_filt, emg_rect_filt, ...
            rms_cut_lig_2, emg_data_filtre_rms_lig, emg_data_filtre_lig, ...
            emg_data_filtre_rect_second_lig, tonic_start_2, tonic_end_2] = compute_emg_WB(emg_data, Nb_emgs, emg_frequency, ...
            emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step, onset_2, offset_2, ...
            emg_div_kin_freq,  anticip,emg_ech_norm, duration_tonic, anticip_tonic);
        
        %% On construit les matrices de résultats des EMG
        o=0;
        for m = 1:Nb_emgs
            Donnees_EMG.Brutes(1:size_emg_data, o+i) = emg_data(1:size_emg_data, m);   
            Donnees_EMG.Filtrees(1:emg_data_filtre_lig, o+i) = emg_filt(1:emg_data_filtre_lig, m);
            Donnees_EMG.Rectifiees(1:emg_data_filtre_rect_second_lig, o+i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, m);
            Donnees_EMG.RMS(1:emg_data_filtre_rms_lig, o+i) = emg_rms(1:emg_data_filtre_rms_lig, m);  
            Donnees_EMG.Tonic_start(1:length(tonic_start_1), o+i) = tonic_start_1(1:length(tonic_start_1), m);
            Donnees_EMG.Tonic_end(1:length(tonic_end_1), o+i) = tonic_end_1(1:length(tonic_end_1), m);  
            Donnees_EMG.Tonic_start(1:length(tonic_start_2), o+i+Nb_emgs*numel(ListeFichier)) = tonic_start_2(1:length(tonic_start_2), m);
            Donnees_EMG.Tonic_end(1:length(tonic_end_2), o+i+Nb_emgs*numel(ListeFichier)) = tonic_end_2(1:length(tonic_end_2), m);  

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calcul PHAISC Avec tonic lent
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[l, nb_col_rms] = size(Donnees_EMG.RMSCutNorm);
Temps_mvts_rapide_se_lever = mean(Donnees_cinematiques.Results_trial_by_trial(1:length(Donnees_cinematiques.Results_trial_by_trial)/2,2));
Temps_mvts_rapide_se_rassoir = mean(Donnees_cinematiques.Results_trial_by_trial(1+length(Donnees_cinematiques.Results_trial_by_trial)/2:length(Donnees_cinematiques.Results_trial_by_trial),2));
i = 1;
j = 1;
compteur_essais = 0;

while j <= nb_col_rms/2 % On ne balaye que la moitié des colonnes car on sépare entre les deux types de mvts
    
    % Calcul du tonic en soustrayant à chaque RMS des essais rapides la moyenne RMS des essais lents
    Donnees_EMG.Phasic.TonicLent.Se_lever(1:emg_ech_norm, j) = Donnees_EMG.RMSCutNorm(:, j)-Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_lever(:, i);
	Donnees_EMG.Phasic.TonicLent.Se_rassoir(1:emg_ech_norm, j) = Donnees_EMG.RMSCutNorm(:, j+nb_col_rms/2)-Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_rassoir(:, i);

    j= j+1;
    compteur_essais = compteur_essais+1;      % Pour soustraire le même tonic moyenné à chaque essai rapide
    if compteur_essais == numel(ListeFichier) % On passe au prochain tonic ( il y en a autant que d'EMG)
        i = i+4;                              % +4 car on utilise les profils moyens (col moyenne   col +SD   col -SD   col vide)
        compteur_essais = 0;
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Partie qui permet de trier les essais par vitesse, de les moyenner par trois pour phasic classique et combined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
 Idx.nb = numel(ListeFichier);
Donnees_EMG.Idx = Idx;



% Deuxième traitement EMG pour obtenir phasic classique et combined 

[EMG_traite, Tonic, Vmean_RMS_R, Vmean_RMS_B, Profil_tonic_R.muscle, Profil_tonic_B.muscle] = compute_emg2_TonicNew_WB(Donnees_EMG.RMSCut, Donnees_EMG.RMSCutNormProfilMoyen.Se_lever, Donnees_EMG.RMSCutNormProfilMoyen.Se_rassoir, ...
          emg_frequency, Donnees_EMG.Tonic_start, Donnees_EMG.Tonic_end, Idx, limite_en_temps, Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_lever, Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_rassoir, Nb_emgs, Donnees_EMG.Phasic.TonicLent  );
   


% Enregistrement des différents résultats de manière brute (6 par 6 dans une
% grande matrice

        Donnees_EMG.Phasic.Combined.Se_lever = EMG_traite.combined.R;
        Donnees_EMG.Phasic.Combined.Se_rassoir = EMG_traite.combined.B;
        Donnees_EMG.Phasic.Classique.Se_lever = EMG_traite.classique.R;
        Donnees_EMG.Phasic.Classique.Se_rassoir = EMG_traite.classique.B;
        Donnees_EMG.Phasic.QuantifDesac = EMG_traite.QuantifDesac;
        Donnees_EMG.Phasic.RMS_combined = EMG_traite.RMS;



% Profil moyen + Erreur standard pour les trois types de phasics
w=1;
www=1;
for v=1 : Nb_emgs
    for f=1:Ech_norm_kin
            Donnees_EMG.Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG.Phasic.TonicLent.Se_lever(f,w:w+numel(ListeFichier)-1));
            Donnees_EMG.Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG.Phasic.TonicLent.Se_lever(f,w:w+numel(ListeFichier)-1))+std(Donnees_EMG.Phasic.TonicLent.Se_lever(f,w:w+numel(ListeFichier)-1))/sqrt(numel(ListeFichier));
            Donnees_EMG.Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG.Phasic.TonicLent.Se_lever(f,w:w+numel(ListeFichier)-1))-std(Donnees_EMG.Phasic.TonicLent.Se_lever(f,w:w+numel(ListeFichier)-1))/sqrt(numel(ListeFichier));
            Donnees_EMG.Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG.Phasic.TonicLent.Se_rassoir(f,w:w+numel(ListeFichier)-1));
            Donnees_EMG.Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG.Phasic.TonicLent.Se_rassoir(f,w:w+numel(ListeFichier)-1))+std(Donnees_EMG.Phasic.TonicLent.Se_rassoir(f,w:w+numel(ListeFichier)-1))/sqrt(numel(ListeFichier));
            Donnees_EMG.Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG.Phasic.TonicLent.Se_rassoir(f,w:w+numel(ListeFichier)-1))-std(Donnees_EMG.Phasic.TonicLent.Se_rassoir(f,w:w+numel(ListeFichier)-1))/sqrt(numel(ListeFichier));
    
            Donnees_EMG.Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,www:www+numel(ListeFichier)/2-1));
            Donnees_EMG.Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,www:www+numel(ListeFichier)/2-1))+std(EMG_traite.classique.R(f,www:www+numel(ListeFichier)/2-1))/sqrt(numel(ListeFichier)/2);
            Donnees_EMG.Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,www:www+numel(ListeFichier)/2-1))-std(EMG_traite.classique.R(f,www:www+numel(ListeFichier)/2-1))/sqrt(numel(ListeFichier)/2);
            Donnees_EMG.Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,www:www+numel(ListeFichier)/2-1));
            Donnees_EMG.Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,www:www+numel(ListeFichier)/2-1))+std(EMG_traite.classique.B(f,www:www+numel(ListeFichier)/2-1))/sqrt(numel(ListeFichier)/2);
            Donnees_EMG.Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,www:www+numel(ListeFichier)/2-1))-std(EMG_traite.classique.B(f,www:www+numel(ListeFichier)/2-1))/sqrt(numel(ListeFichier)/2);

            Donnees_EMG.Phasic.Combined.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.combined.R(f,www:www+numel(ListeFichier)/2-1));
            Donnees_EMG.Phasic.Combined.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.combined.R(f,www:www+numel(ListeFichier)/2-1))+std(EMG_traite.combined.R(f,www:www+numel(ListeFichier)/2-1))/sqrt(numel(ListeFichier)/2);
            Donnees_EMG.Phasic.Combined.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.combined.R(f,www:www+numel(ListeFichier)/2-1))-std(EMG_traite.combined.R(f,www:www+numel(ListeFichier)/2-1))/sqrt(numel(ListeFichier)/2);
            Donnees_EMG.Phasic.Combined.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.combined.B(f,www:www+numel(ListeFichier)/2-1));
            Donnees_EMG.Phasic.Combined.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.combined.B(f,www:www+numel(ListeFichier)/2-1))+std(EMG_traite.combined.B(f,www:www+numel(ListeFichier)/2-1))/sqrt(numel(ListeFichier)/2);
            Donnees_EMG.Phasic.Combined.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.combined.B(f,www:www+numel(ListeFichier)/2-1))-std(EMG_traite.combined.B(f,www:www+numel(ListeFichier)/2-1))/sqrt(numel(ListeFichier)/2);
            
    end
    w = w + numel(ListeFichier);
    www = www + numel(ListeFichier)/2;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Export des données
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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


