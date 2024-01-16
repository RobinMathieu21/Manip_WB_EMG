
%% Script permettant la comparaison des méthodes d'obtention du tonic

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
nb_images_to_add=param_moyenne/2;

% Données pour le traitement EMG
anticip = 0.25; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée
emg_frequency = 1000; % Fréquence d'acquisition du signal EMG
%Nb_averaged_trials = 2; % Indicate the number of EMG traces to be averaged 
Nb_emgs = 14; % Spécification du nombre de channels EMG
rms_window = 200; % Time in ms of the window used to compute sliding root mean square of EMG
rms_window_step = (rms_window/1000)*emg_frequency;
emg_div_kin_freq = emg_frequency/Frequence_acquisition; %used to synchronized emg cutting (for sliding rms) with regard to kinematics
NB_SD = 3; % Nombre d'écart-types utilisé pour détecter le début/fin du mouvement lent
limite_en_temps = 0.04; % en ms, correspond au temps minimal pour considérer une désactivation

%% Importation des données

%On selectionne le repertoire
disp('Selectionnez le Dossier regroupant les essais très lents');
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
    disp('POST TRAITEMENT MOUVEMENTS TRES LENTS')
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Importation des données des essais lents

%On selectionne le repertoire
disp('Selectionnez le Dossier regroupant les essais lents');
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');

if (Dossier ~= 0) %Si on clique sur un dossier
    
    Extension = '*.mat'; %Traite tous les .mat
    Chemin = fullfile(Dossier, Extension); % On construit le chemin
    ListeFichier = dir(Chemin); % On construit la liste des fichiers

%% On crée les matrices de résultats

    Donnees_EMG_L = {};
    Donnees_cinematiques_L = {};
    Premiere_fois = true; % Pour n'effecteur certaines actions de lecture des labels qu'une seule fois
    
%% On procède au balayage fichier par fichier
    disp('POST TRAITEMENT MOUVEMENTS LENTS')
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

        Donnees_cinematiques_L.Position_cut_brut(1:lig_pos_1, z:k) = profil_position_1;
        Donnees_cinematiques_L.Position_cut_brut(1:lig_pos_2, z+3*numel(ListeFichier):k+3*numel(ListeFichier)) = profil_position_2;
        Donnees_cinematiques_L.Position_cut_norm(:, z:k) = profil_position_1_norm;
        Donnees_cinematiques_L.Position_cut_norm(:, z+3*numel(ListeFichier):k+3*numel(ListeFichier)) = profil_position_2_norm;
        Donnees_cinematiques_L.Vel_brut(1:length(profil_vitesse_pas_cut_1), i) = profil_vitesse_pas_cut_1;
        Donnees_cinematiques_L.Vel_brut(1:length(profil_vitesse_pas_cut_2), i+numel(ListeFichier)) = profil_vitesse_pas_cut_2;
        Donnees_cinematiques_L.Vel_cut_brut(1:lig_pv1, i) = profil_vitesse_1;
        Donnees_cinematiques_L.Vel_cut_brut(1:lig_pv2, i+numel(ListeFichier)) = profil_vitesse_2;           
        Donnees_cinematiques_L.Vel_cut_norm(:, i) = profil_vitesse_1_norm;
        Donnees_cinematiques_L.Vel_cut_norm(:, i+numel(ListeFichier)) = profil_vitesse_2_norm;
        Donnees_cinematiques_L.Acc(1:lig_pv1, i) = profil_accel_1;
        Donnees_cinematiques_L.Acc(1:lig_pv2, i+numel(ListeFichier)) = profil_accel_2;            
            
        Donnees_cinematiques_L.Results_trial_by_trial(i, 2) = MD_1;
        Donnees_cinematiques_L.Results_trial_by_trial(i+numel(ListeFichier), 2) = MD_2;
        Donnees_cinematiques_L.Results_trial_by_trial(i, 3) = rD_PA_1;
        Donnees_cinematiques_L.Results_trial_by_trial(i+numel(ListeFichier), 3) = rD_PA_2;
        Donnees_cinematiques_L.Results_trial_by_trial(i, 4) = rD_PV_1;
        Donnees_cinematiques_L.Results_trial_by_trial(i+numel(ListeFichier), 4) = rD_PV_2;
        Donnees_cinematiques_L.Results_trial_by_trial(i, 5) = rD_PD_1;
        Donnees_cinematiques_L.Results_trial_by_trial(i+numel(ListeFichier), 5) = rD_PD_2;
        Donnees_cinematiques_L.Results_trial_by_trial(i, 6) = PA_max_1;
        Donnees_cinematiques_L.Results_trial_by_trial(i+numel(ListeFichier), 6) = PA_max_2;
        Donnees_cinematiques_L.Results_trial_by_trial(i, 7) = PD_max_1;
        Donnees_cinematiques_L.Results_trial_by_trial(i+numel(ListeFichier), 7) = PD_max_2;
        Donnees_cinematiques_L.Results_trial_by_trial(i, 8) = pv1_max;
        Donnees_cinematiques_L.Results_trial_by_trial(i+numel(ListeFichier), 8) = pv2_max;
        Donnees_cinematiques_L.Results_trial_by_trial(i, 8) = Vmoy_1;
        Donnees_cinematiques_L.Results_trial_by_trial(i+numel(ListeFichier), 8) = Vmoy_2;
        Donnees_cinematiques_L.Results_trial_by_trial(i, 8) = Param_C_1;
        Donnees_cinematiques_L.Results_trial_by_trial(i+numel(ListeFichier), 8) = Param_C_2;
        
            
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
        
        [nb_ligne,nb_col] = size(Donnees_cinematiques_L.Vel_cut_norm);
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
                Donnees_EMG_L.Brutes(1:size_emg_data, o+i) = emg_data(1:size_emg_data, m);   
                Donnees_EMG_L.Filtrees(1:emg_data_filtre_lig, o+i) = emg_filt(1:emg_data_filtre_lig, m);
                Donnees_EMG_L.Rectifiees(1:emg_data_filtre_rect_second_lig, o+i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, m);
                Donnees_EMG_L.RMS(1:emg_data_filtre_rms_lig, o+i) = emg_rms(1:emg_data_filtre_rms_lig, m);  

                Donnees_EMG_L.RMSCut(1:rms_cut_lig_1, o+i) = rms_cuts_1(1:rms_cut_lig_1, m);
                Donnees_EMG_L.RMSCut(1:rms_cut_lig_2, o+i+Nb_emgs*numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, m);
                Donnees_EMG_L.RMSCutNorm(1:emg_ech_norm, o+i) = rms_cuts_norm_1(1:emg_ech_norm, m); 
                Donnees_EMG_L.RMSCutNorm(1:emg_ech_norm, o+i+Nb_emgs*numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, m);
                o = o+numel(ListeFichier);
            end

     end

%% Données moyennes se lever
    for f = 1:Ech_norm_kin
        o=0;
        p=0;
        for m = 1:Nb_emgs
            Donnees_EMG_L.RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_L.RMSCutNorm(f,a+o:b+o),2);
            Donnees_EMG_L.RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_L.RMSCutNorm(f,a+o:b+o),2)+std(Donnees_EMG_L.RMSCutNorm(f,a+o:b+o));
            Donnees_EMG_L.RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_L.RMSCutNorm(f,a+o:b+o),2)-std(Donnees_EMG_L.RMSCutNorm(f,a+o:b+o));

            Donnees_EMG_L.RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_L.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o),2);
            Donnees_EMG_L.RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_L.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o),2)+std(Donnees_EMG_L.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o));
            Donnees_EMG_L.RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_L.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o),2)-std(Donnees_EMG_L.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o));
            o = o+numel(ListeFichier);
            p= p+3;
        end

    end

    delete(findall(0));
    %clear C3D;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Importation des données pour calcul tonic pos alea

%On selectionne le repertoire
disp('Selectionnez le Dossier regroupant les essais de pos aléatoires');
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');

if (Dossier ~= 0) %Si on clique sur un dossier
    
    Extension = '*.mat'; %Traite tous les .mat
    Chemin = fullfile(Dossier, Extension); % On construit le chemin
    ListeFichier = dir(Chemin); % On construit la liste des fichiers

%% On crée les matrices de résultats

    Donnees_EMG_PA = {};
    Donnees_cinematiques_PA = {};
    Premiere_fois = true; % Pour n'effecteur certaines actions de lecture des labels qu'une seule fois
    
%% On procède au balayage fichier par fichier
    disp('POST TRAITEMENT POS ALEA')
    disp(append('Il y a ', string(numel(ListeFichier)),' fichiers à analyser.'));
    Nb_pos_alea = numel(ListeFichier);
    for i = 1: numel(ListeFichier)
        
       Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
       disp(append('i = ',string(i)));
       load (Fichier_traite);   

%% Calcul des paramètres electromyographiques

        % On crée la matrice contenant les EMG

        emg_data = C3D.EMG.Donnees;
        emg_data(:, 1) = C3D.EMG.Donnees(:, 1);
        emg_data(:, 2) = C3D.EMG.Donnees(:, 2);

        %calcule le début et la fin du mouvement sur l'ensemble du signal
        %cinématique
        size_emg_data = length(emg_data);
        onset_1 = 1;
        offset_1 = length(emg_data);

    %On calcule les paramètres emg du premier mouvement
        [ emg_rms, ...
    emg_filt, emg_rect_filt, ...
    emg_data_filtre_rms_lig, emg_data_filtre_lig, ...
    emg_data_filtre_rect_second_lig] = compute_emg_WB_pos_alea(emg_data, Nb_emgs, emg_frequency, ...
            emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step);

%% On construit les matrices de résultats des EMG
            Donnees_cinematiques_PA.angleflexiongenou(:,i)=mean(C3D.Cinematique.Angles.RKnee(1,:));
            Donnees_cinematiques_PA.copieangle(i,1:length(C3D.Cinematique.Angles.RKnee(1,:)))=C3D.Cinematique.Angles.RKnee(1,:);
            figure;plot(C3D.Cinematique.Angles.RKnee(1,:)); hold on;
            y = ylim; % current y-axis limits
            x = xlim; % current y-axis limits
            plot([x(1) x(2)],[mean(C3D.Cinematique.Angles.RKnee(1,:)) mean(C3D.Cinematique.Angles.RKnee(1,:))],'r');  % debut mvt 1
            
            o=0;
            for m = 1:Nb_emgs
                Donnees_EMG_PA.Brutes(1:size_emg_data, o+i) = emg_data(:, m);   
                Donnees_EMG_PA.Filtrees(1:size_emg_data, o+i) = emg_filt(:, m);
                Donnees_EMG_PA.Rectifiees(1:size_emg_data, o+i) = emg_rect_filt(:, m);
                Donnees_EMG_PA.RMS(1:length(emg_rms), o+i) = emg_rms(1:length(emg_rms), m);
                Donnees_EMG_PA.RMSmoyen(:,o+i)= mean(emg_rms(:,m));
                Donnees_EMG_PA.RMS_SD(:,o+i)= std(emg_rms(:,m));
                o = o+numel(ListeFichier);
            end

     end

end
s2 = length(Donnees_EMG_PA.RMSmoyen);
muscle = 1;
for s=1 : s2
    
    Donnees_EMG_PA.RMSmoyen(2,s)=Donnees_EMG_PA.RMSmoyen(1,s)/max(Donnees_EMG_PA.RMSmoyen(1,(muscle-1)*Nb_pos_alea+1:muscle*Nb_pos_alea));
    if mod(s,Nb_pos_alea)==0
        muscle=muscle+1;
    end
end


Donnees_cinematiques_PA.angleflexiongenou(2,:) = 1000 * normalize(Donnees_cinematiques_PA.angleflexiongenou(1,:), 'range');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT GRAPHS pour comparer les tonics 
x=0;
for muscle=1 : length(C3D.EMG.Labels)
    
    Titre = append(C3D.NomSujet,' _ SE LEVER muscle : ',string(C3D.EMG.Labels(muscle)));
    figure('Name',Titre,'NumberTitle','off');
    set(gcf,'position',[75,200,1400,400])
    disp(3*x+muscle);
    
    % Plot des signaux se lever (si mvt assis/debout) ou se pencher (si mvt WB reaching)
    subplot(1,2,1)
    plot(Donnees_EMG_L.RMSCutNormProfilMoyen.Se_lever(:,muscle+(3*x))); hold on; % Plot EMG lents
    plot(Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_lever(:,muscle+(3*x))); hold on; % Plot EMG très lents
    % Plot les signaux EMG des positions iso en fonction de l'angle de
    % flexion du genou
    scatter(Donnees_cinematiques_PA.angleflexiongenou(2,:),Donnees_EMG_PA.RMSmoyen(1,muscle*Nb_pos_alea-Nb_pos_alea+1:muscle*Nb_pos_alea)); 
    title('SE LEVER / Se pencher');legend('Lent','Très lent','Pos alea');
    
        
    % Plot des signaux se rassoir (si mvt assis/debout) ou se redresser (si mvt WB reaching)
    subplot(1,2,2)
    plot(Donnees_EMG_L.RMSCutNormProfilMoyen.Se_rassoir(:,muscle+(3*x)));hold on;
    plot(Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_rassoir(:,muscle+(3*x))); hold on;
    scatter(-Donnees_cinematiques_PA.angleflexiongenou(2,:)+max(Donnees_cinematiques_PA.angleflexiongenou(2,:)),Donnees_EMG_PA.RMSmoyen(1,muscle*Nb_pos_alea-Nb_pos_alea+1:muscle*Nb_pos_alea)); 
    title('SE RASSOIR / Se redresser');legend('Lent','Très lent','Pos alea');
    x=x+1;
end 

Donnees.EMG_PA= Donnees_EMG_PA; 
Donnees.EMG_TL = Donnees_EMG_TL;
Donnees.EMG_L = Donnees_EMG_L;
Donnees.cinematiques_PA = Donnees_cinematiques_PA;
Donnees.cinematiques_TL = Donnees_cinematiques_TL;
Donnees.cinematiques_L = Donnees_cinematiques_L;
Donnees.Muscles = C3D.EMG.Labels;
Donnees.Mvt = Fichier_traite;

name = append(C3D.NomSujet(1,:),'');
disp('Selectionnez le Dossier où enregistre les données.');
[Dossier] = uigetdir ('Selectionnez le Dossier où enregistre les données.');
save([Dossier '/' name ], 'Donnees');
disp('Données enregistrées avec succès !');



for g=1 : length(Donnees_EMG_PA.RMS)
    disp(g);
    figure;plot(Donnees_EMG_PA.RMS(:,g))
end
