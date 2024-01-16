
%% Script pour Manip EMGravity
% A executer dans un dossier de 30 essais contenant aussi le dossier de
% data sequence. Le script sort une matrice contenant les données
% cinématiques, essai par essai et triés en fonction de la cible. 

close all
clear all

%% Informations sur le traitement des données
% Données pour la cinématique
Low_pass_Freq = 5; %fréquence passe-bas la position pour la cinématique
Cut_off = 0.1; %pourcentage du pic de vitesse pour déterminer début et fin du mouvement
Ech_norm_kin = 1000; %Fréquence d'échantillonage du profil de vitesse normalisé en durée 
Frequence_acquisition = 200;%Fréquence d'acquisition du signal cinématique
emg_band_pass_Freq = [30 300]; % Passe_bande du filtre EMG
emg_low_pass_Freq = 20; %fréquence passe_bas lors du second filtre du signal emg. 100 est la fréquence habituelle chez les humains (cf script Jérémie)
emg_ech_norm = 1000; %Fréquence d'échantillonage du signal EMG
param_moyenne = 200; %nb images pour moyenner la position pendant phases stables
nb_images_to_add=param_moyenne/2;

anticip = 0.25; %Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée
emg_frequency = 1000; %Fréquence d'acquisition du signal EMG
Nb_averaged_trials = 2; % Indicate the number of EMG traces to be averaged 
Nb_emgs = 14; % Spécification du nombre de channels EMG
rms_window = 200; % Time in ms of the window used to compute sliding root mean square of EMG
rms_window_step = (rms_window/1000)*emg_frequency;
emg_div_kin_freq = emg_frequency/Frequence_acquisition; %used to synchronized emg cutting (for sliding rms) with regard to kinematics

%% Importation des données

%On selectionne le repertoire
disp('Selectionnez le Dossier regroupant les essais lents');
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');

if (Dossier ~= 0) %Si on clique sur un dossier
    
    Extension = '*.mat'; %Traite tous les .mat
    
    %On construit le chemin
    Chemin = fullfile(Dossier, Extension);
    
    %On construit la liste des fichiers
    ListeFichier = dir(Chemin);

    %% On crée les matrices de résultats
    Donnees = {};
    Donnees_EMG_TL = {};
    Donnees_cinematiques_TL = {};

    %% On procède au balayage fichier par fichier
    disp('POST TRAITEMENT MOUVEMENTS RAPIDES')
    disp(append('Il y a ', string(numel(ListeFichier)),' fichiers à analyser.'));
     for i = 1: numel(ListeFichier)
 
       Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
       disp(append('i = ',string(i)));
       load (Fichier_traite);
       
        j=0; marqueur = 'a';
        while ~strcmp(marqueur,'LSHO')
            j=j+1;
            marqueur = C3D.Cinematique.Labels(j);
            %afficher = ['marqueur numéro ',j,marqueur];
%            disp(afficher);
            
        end
        j = j*4-1;
        %On crée une matrice de la position de l'épaule
        posxyz = C3D.Cinematique.Donnees(:, j-2:j);
        %On crée une matrice de la position de l'épine illiaque gauche
        %postérieure
        %posxyz = C3D.Cinematique.Donnees(:, 101:103);
        [posxyz_lig, ~] = size(posxyz);
        
        %On filtre le signal de position
        posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
        posfiltretest = sqrt(posfiltre(:, 2).^2+posfiltre(:, 3).^2);
        %On coupe le signal de vitesse pour avoir 2 plages contenant chacune un mouvement
        Titredec = append('Découpage mvt lent numéro ', string(i));
        figure('Name',Titredec,'NumberTitle','off');
        plot(posfiltre(:, 3))
        [Cut] = ginput(1);
%          plot(posfiltretest);hold on; plot(posfiltre(:, 3));hold on; plot(posfiltre(:, 2));
%          legend('Norme du vecteur position Y et Z','Position en Z','Position en Y')
        Plage_mvmt_1_end = round(Cut(1,1));
        Plage_mvmt_2_start = round(Cut(1,1));
        
        [Pos_mvmt_1] = posfiltre(1:Plage_mvmt_1_end+nb_images_to_add, :);  
        [Pos_mvmt_2] = posfiltre(Plage_mvmt_2_start-nb_images_to_add:length(posfiltre), :);
        
        %% On calcule les paramètres cinématiques des 2 mouvements
        
        % Premier Mouvement
        [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_pas_cut_1, moy_deb_1, moy_fin_1, std_deb_1, std_fin_1, profil_vitesse_1, profil_vitesse_1_norm, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, Vmoy_1, Param_C_1, Nbmaxloc_1, debut_1, fin_1, profil_accel_1] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin, param_moyenne);
        % Second Mouvement
        [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_pas_cut_2, moy_deb_2, moy_fin_2, std_deb_2, std_fin_2, profil_vitesse_2, profil_vitesse_2_norm, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, Vmoy_2, Param_C_2, Nbmaxloc_2, debut_2, fin_2, profil_accel_2] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_2, Frequence_acquisition, 2, Cut_off, Ech_norm_kin, param_moyenne);
        
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
            
            
            Donnees_cinematiques_TL.Results_trial_by_trial(i, 2) = MD_1;
            Donnees_cinematiques_TL.Results_trial_by_trial(i+numel(ListeFichier), 2) = MD_2;
            
Titre = append('Vérification découpage mvts lents de ',string(C3D.NomSujet(1,:)));
figure('Name',Titre,'NumberTitle','off');
plot(posfiltre(:,3),'DisplayName','posfiltre(:,3)');hold on;
y = ylim; % current y-axis limits
x = xlim; % current y-axis limits
plot([debut_1 debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
plot([fin_1 fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
plot([x(1) x(1)+param_moyenne],[moy_deb_1(:,3) moy_deb_1(:,3)],'r');hold on; %moyenne debut

plot([Plage_mvmt_1_end-param_moyenne/2 Plage_mvmt_1_end+param_moyenne/2],[moy_fin_1(:,3) moy_fin_1(:,3)],'b');hold on; % moyenne milieu
plot([Plage_mvmt_1_end Plage_mvmt_1_end],[y(1) y(2)],'b');hold on; % ginput au milieu

plot([Plage_mvmt_2_start+debut_2-param_moyenne/2 Plage_mvmt_2_start+debut_2-param_moyenne/2],[y(1) y(2)],'g');hold on; %debut mvt 2
plot([Plage_mvmt_2_start+fin_2-param_moyenne/2 Plage_mvmt_2_start+fin_2-param_moyenne/2],[y(1) y(2)],'g'); % fin  mvt 2
plot([length(posfiltre(:,3))-param_moyenne length(posfiltre(:,3))],[moy_fin_2(:,3) moy_fin_2(:,3)],'g');hold on; %moyenne fin
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
% 



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

% if debut_1 < anticip
%     onset_1 = anticip;
% else
    onset_1 = (debut_1);
% end

offset_1 = (fin_1);
onset_2 = (debut_2+Plage_mvmt_2_start);

% if length(posfiltre)-fin_2-Plage_mvmt_2_start<anticip
%     offset_2=length(posfiltre)-Plage_mvmt_2_start-anticip;
% else
    offset_2 = (fin_2+Plage_mvmt_2_start);
% end
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
        
%         % Pour le signal EMG brut
Donnees_EMG_TL.Brutes.RAS(1:size_emg_data, i) = emg_data(1:size_emg_data, 1);
Donnees_EMG_TL.Brutes.ESL1(1:size_emg_data, i) = emg_data(1:size_emg_data, 2);
Donnees_EMG_TL.Brutes.DA(1:size_emg_data, i) = emg_data(1:size_emg_data, 3);
Donnees_EMG_TL.Brutes.DP(1:size_emg_data, i) = emg_data(1:size_emg_data, 4);
Donnees_EMG_TL.Brutes.DAG(1:size_emg_data, i) = emg_data(1:size_emg_data, 5);
Donnees_EMG_TL.Brutes.DPG(1:size_emg_data, i) = emg_data(1:size_emg_data, 6);
Donnees_EMG_TL.Brutes.ST(1:size_emg_data, i) = emg_data(1:size_emg_data, 7);
Donnees_EMG_TL.Brutes.BF(1:size_emg_data, i) = emg_data(1:size_emg_data, 8);
Donnees_EMG_TL.Brutes.RF(1:size_emg_data, i) = emg_data(1:size_emg_data, 9);
Donnees_EMG_TL.Brutes.VL(1:size_emg_data, i) = emg_data(1:size_emg_data, 10);
Donnees_EMG_TL.Brutes.TA(1:size_emg_data, i) = emg_data(1:size_emg_data, 11);
Donnees_EMG_TL.Brutes.SOL(1:size_emg_data, i) = emg_data(1:size_emg_data, 12);
Donnees_EMG_TL.Brutes.GM(1:size_emg_data, i) = emg_data(1:size_emg_data, 13);
Donnees_EMG_TL.Brutes.ESD7(1:size_emg_data, i) = emg_data(1:size_emg_data, 14);
     
%     % Pour le signal EMG filtré
Donnees_EMG_TL.Filtrees.RAS(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 1);
Donnees_EMG_TL.Filtrees.ESL1(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 2);
Donnees_EMG_TL.Filtrees.DA(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 3);
Donnees_EMG_TL.Filtrees.DP(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 4);
Donnees_EMG_TL.Filtrees.DAG(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 5);
Donnees_EMG_TL.Filtrees.DPG(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 6);
Donnees_EMG_TL.Filtrees.ST(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 7);
Donnees_EMG_TL.Filtrees.BF(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 8);
Donnees_EMG_TL.Filtrees.RF(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 9);
Donnees_EMG_TL.Filtrees.VL(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 10);
Donnees_EMG_TL.Filtrees.TA(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 11);
Donnees_EMG_TL.Filtrees.SOL(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 12);
Donnees_EMG_TL.Filtrees.GM(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 13);
Donnees_EMG_TL.Filtrees.ESD7(1:emg_data_filtre_lig, i) = emg_filt(1:emg_data_filtre_lig, 14);   
     
%     % Pour le signal rectifié et refiltré
Donnees_EMG_TL.Rectifiees.RAS(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 1);
Donnees_EMG_TL.Rectifiees.ESL1(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 2);
Donnees_EMG_TL.Rectifiees.DA(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 3);
Donnees_EMG_TL.Rectifiees.DP(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 4);
Donnees_EMG_TL.Rectifiees.DAG(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 5);
Donnees_EMG_TL.Rectifiees.DPG(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 6);
Donnees_EMG_TL.Rectifiees.ST(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 7);
Donnees_EMG_TL.Rectifiees.BF(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 8);
Donnees_EMG_TL.Rectifiees.RF(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 9);
Donnees_EMG_TL.Rectifiees.VL(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 10);
Donnees_EMG_TL.Rectifiees.TA(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 11);
Donnees_EMG_TL.Rectifiees.SOL(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 12);
Donnees_EMG_TL.Rectifiees.GM(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 13);
Donnees_EMG_TL.Rectifiees.ESD7(1:emg_data_filtre_rect_second_lig, i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, 14);
    
    % Pour le signal RMS
Donnees_EMG_TL.RMS.RAS(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 1);
Donnees_EMG_TL.RMS.ESL1(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 2);
Donnees_EMG_TL.RMS.DA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 3);
Donnees_EMG_TL.RMS.DP(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 4);
Donnees_EMG_TL.RMS.DAG(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 5);
Donnees_EMG_TL.RMS.DPG(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 6);
Donnees_EMG_TL.RMS.ST(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 7);
Donnees_EMG_TL.RMS.BF(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 8);
Donnees_EMG_TL.RMS.RF(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 9);
Donnees_EMG_TL.RMS.VL(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 10);
Donnees_EMG_TL.RMS.TA(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 11);
Donnees_EMG_TL.RMS.SOL(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 12);
Donnees_EMG_TL.RMS.GM(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 13);
Donnees_EMG_TL.RMS.ESD7(1:emg_data_filtre_rms_lig, i) = emg_rms(1:emg_data_filtre_rms_lig, 14);
%     
Donnees_EMG_TL.RMSCut.RAS(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 1);
Donnees_EMG_TL.RMSCut.ESL1(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 2);
Donnees_EMG_TL.RMSCut.DA(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 3);
Donnees_EMG_TL.RMSCut.DP(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 4);
Donnees_EMG_TL.RMSCut.DAG(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 5);
Donnees_EMG_TL.RMSCut.DPG(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 6);
Donnees_EMG_TL.RMSCut.ST(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 7);
Donnees_EMG_TL.RMSCut.BF(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 8);
Donnees_EMG_TL.RMSCut.RF(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 9);
Donnees_EMG_TL.RMSCut.VL(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 10);
Donnees_EMG_TL.RMSCut.TA(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 11);
Donnees_EMG_TL.RMSCut.SOL(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 12);
Donnees_EMG_TL.RMSCut.GM(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 13);
Donnees_EMG_TL.RMSCut.ESD7(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 14); 

Donnees_EMG_TL.RMSCut.RAS(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 1);
Donnees_EMG_TL.RMSCut.ESL1(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 2);
Donnees_EMG_TL.RMSCut.DA(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 3);
Donnees_EMG_TL.RMSCut.DP(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 4);
Donnees_EMG_TL.RMSCut.DAG(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 5);
Donnees_EMG_TL.RMSCut.DPG(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 6);
Donnees_EMG_TL.RMSCut.ST(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 7);
Donnees_EMG_TL.RMSCut.BF(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 8);
Donnees_EMG_TL.RMSCut.RF(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 9);
Donnees_EMG_TL.RMSCut.VL(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 10);
Donnees_EMG_TL.RMSCut.TA(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 11);
Donnees_EMG_TL.RMSCut.SOL(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 12);
Donnees_EMG_TL.RMSCut.GM(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 13);
Donnees_EMG_TL.RMSCut.ESD7(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 14);
       
       % Mouvements Normalisés
Donnees_EMG_TL.RMSCutNorm.RAS(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 1);     
Donnees_EMG_TL.RMSCutNorm.ESL1(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 2);
Donnees_EMG_TL.RMSCutNorm.DA(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 3);
Donnees_EMG_TL.RMSCutNorm.DP(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 4);
Donnees_EMG_TL.RMSCutNorm.DAG(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 5);
Donnees_EMG_TL.RMSCutNorm.DPG(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 6);
Donnees_EMG_TL.RMSCutNorm.ST(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 7);
Donnees_EMG_TL.RMSCutNorm.BF(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 8);
Donnees_EMG_TL.RMSCutNorm.RF(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 9);
Donnees_EMG_TL.RMSCutNorm.VL(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 10);
Donnees_EMG_TL.RMSCutNorm.TA(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 11);
Donnees_EMG_TL.RMSCutNorm.SOL(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 12);
Donnees_EMG_TL.RMSCutNorm.GM(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 13);
Donnees_EMG_TL.RMSCutNorm.ESD7(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 14);
   
Donnees_EMG_TL.RMSCutNorm.RAS(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 1);
Donnees_EMG_TL.RMSCutNorm.ESL1(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 2);
Donnees_EMG_TL.RMSCutNorm.DA(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 3);
Donnees_EMG_TL.RMSCutNorm.DP(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 4);
Donnees_EMG_TL.RMSCutNorm.DAG(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 5);
Donnees_EMG_TL.RMSCutNorm.DPG(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 6);
Donnees_EMG_TL.RMSCutNorm.ST(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 7);
Donnees_EMG_TL.RMSCutNorm.BF(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 8);
Donnees_EMG_TL.RMSCutNorm.RF(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 9);
Donnees_EMG_TL.RMSCutNorm.VL(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 10);
Donnees_EMG_TL.RMSCutNorm.TA(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 11);
Donnees_EMG_TL.RMSCutNorm.SOL(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 12);
Donnees_EMG_TL.RMSCutNorm.GM(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 13);
Donnees_EMG_TL.RMSCutNorm.ESD7(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 14);
     end

end

%% Données moyennes se lever
for f = 1:1000
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 1) =  mean(Donnees_EMG_TL.RMSCutNorm.RAS(f,a:b),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 2) = mean(Donnees_EMG_TL.RMSCutNorm.RAS(f,a:b),2)+std(Donnees_EMG_TL.RMSCutNorm.RAS(f,a:b));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 3) = mean(Donnees_EMG_TL.RMSCutNorm.RAS(f,a:b),2)-std(Donnees_EMG_TL.RMSCutNorm.RAS(f,a:b));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 4) =  mean(Donnees_EMG_TL.RMSCutNorm.ESL1(f,a:b),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 5) = mean(Donnees_EMG_TL.RMSCutNorm.ESL1(f,a:b),2)+std(Donnees_EMG_TL.RMSCutNorm.ESL1(f,a:b));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 6) = mean(Donnees_EMG_TL.RMSCutNorm.ESL1(f,a:b),2)-std(Donnees_EMG_TL.RMSCutNorm.ESL1(f,a:b));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 7) =  mean(Donnees_EMG_TL.RMSCutNorm.DA(f,a:b),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 8) = mean(Donnees_EMG_TL.RMSCutNorm.DA(f,a:b),2)+std(Donnees_EMG_TL.RMSCutNorm.DA(f,a:b));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 9) = mean(Donnees_EMG_TL.RMSCutNorm.DA(f,a:b),2)-std(Donnees_EMG_TL.RMSCutNorm.DA(f,a:b));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 10) =  mean(Donnees_EMG_TL.RMSCutNorm.DP(f,a:b),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 11) = mean(Donnees_EMG_TL.RMSCutNorm.DP(f,a:b),2)+std(Donnees_EMG_TL.RMSCutNorm.DP(f,a:b));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 12) = mean(Donnees_EMG_TL.RMSCutNorm.DP(f,a:b),2)-std(Donnees_EMG_TL.RMSCutNorm.DP(f,a:b));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 13) =  mean(Donnees_EMG_TL.RMSCutNorm.DAG(f,a:b),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 14) = mean(Donnees_EMG_TL.RMSCutNorm.DAG(f,a:b),2)+std(Donnees_EMG_TL.RMSCutNorm.DAG(f,a:b));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 15) = mean(Donnees_EMG_TL.RMSCutNorm.DAG(f,a:b),2)-std(Donnees_EMG_TL.RMSCutNorm.DAG(f,a:b));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 16) =  mean(Donnees_EMG_TL.RMSCutNorm.DPG(f,a:b),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 17) = mean(Donnees_EMG_TL.RMSCutNorm.DPG(f,a:b),2)+std(Donnees_EMG_TL.RMSCutNorm.DPG(f,a:b));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 18) = mean(Donnees_EMG_TL.RMSCutNorm.DPG(f,a:b),2)-std(Donnees_EMG_TL.RMSCutNorm.DPG(f,a:b));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 19) =  mean(Donnees_EMG_TL.RMSCutNorm.ST(f,a:b),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 20) = mean(Donnees_EMG_TL.RMSCutNorm.ST(f,a:b),2)+std(Donnees_EMG_TL.RMSCutNorm.ST(f,a:b));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 21) = mean(Donnees_EMG_TL.RMSCutNorm.ST(f,a:b),2)-std(Donnees_EMG_TL.RMSCutNorm.ST(f,a:b));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 22) =  mean(Donnees_EMG_TL.RMSCutNorm.BF(f,a:b),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 23) = mean(Donnees_EMG_TL.RMSCutNorm.BF(f,a:b),2)+std(Donnees_EMG_TL.RMSCutNorm.BF(f,a:b));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 24) = mean(Donnees_EMG_TL.RMSCutNorm.BF(f,a:b),2)-std(Donnees_EMG_TL.RMSCutNorm.BF(f,a:b));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 25) =  mean(Donnees_EMG_TL.RMSCutNorm.RF(f,a:b),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 26) = mean(Donnees_EMG_TL.RMSCutNorm.RF(f,a:b),2)+std(Donnees_EMG_TL.RMSCutNorm.RF(f,a:b));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 27) = mean(Donnees_EMG_TL.RMSCutNorm.RF(f,a:b),2)-std(Donnees_EMG_TL.RMSCutNorm.RF(f,a:b));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 28) =  mean(Donnees_EMG_TL.RMSCutNorm.VL(f,a:b),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 29) = mean(Donnees_EMG_TL.RMSCutNorm.VL(f,a:b),2)+std(Donnees_EMG_TL.RMSCutNorm.VL(f,a:b));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 30) = mean(Donnees_EMG_TL.RMSCutNorm.VL(f,a:b),2)-std(Donnees_EMG_TL.RMSCutNorm.VL(f,a:b));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 31) =  mean(Donnees_EMG_TL.RMSCutNorm.TA(f,a:b),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 32) = mean(Donnees_EMG_TL.RMSCutNorm.TA(f,a:b),2)+std(Donnees_EMG_TL.RMSCutNorm.TA(f,a:b));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 33) = mean(Donnees_EMG_TL.RMSCutNorm.TA(f,a:b),2)-std(Donnees_EMG_TL.RMSCutNorm.TA(f,a:b));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 34) =  mean(Donnees_EMG_TL.RMSCutNorm.SOL(f,a:b),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 35) = mean(Donnees_EMG_TL.RMSCutNorm.SOL(f,a:b),2)+std(Donnees_EMG_TL.RMSCutNorm.SOL(f,a:b));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 36) = mean(Donnees_EMG_TL.RMSCutNorm.SOL(f,a:b),2)-std(Donnees_EMG_TL.RMSCutNorm.SOL(f,a:b));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 37) =  mean(Donnees_EMG_TL.RMSCutNorm.GM(f,a:b),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 38) = mean(Donnees_EMG_TL.RMSCutNorm.GM(f,a:b),2)+std(Donnees_EMG_TL.RMSCutNorm.GM(f,a:b));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 39) = mean(Donnees_EMG_TL.RMSCutNorm.GM(f,a:b),2)-std(Donnees_EMG_TL.RMSCutNorm.GM(f,a:b));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 40) =  mean(Donnees_EMG_TL.RMSCutNorm.ESD7(f,a:b),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 41) = mean(Donnees_EMG_TL.RMSCutNorm.ESD7(f,a:b),2)+std(Donnees_EMG_TL.RMSCutNorm.ESD7(f,a:b));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(f, 42) = mean(Donnees_EMG_TL.RMSCutNorm.ESD7(f,a:b),2)-std(Donnees_EMG_TL.RMSCutNorm.ESD7(f,a:b));

    %% Se rassoir
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 1) =  mean(Donnees_EMG_TL.RMSCutNorm.RAS(f,a2:b2),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 2) = mean(Donnees_EMG_TL.RMSCutNorm.RAS(f,a2:b2),2)+std(Donnees_EMG_TL.RMSCutNorm.RAS(f,a2:b2));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 3) = mean(Donnees_EMG_TL.RMSCutNorm.RAS(f,a2:b2),2)-std(Donnees_EMG_TL.RMSCutNorm.RAS(f,a2:b2));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 4) =  mean(Donnees_EMG_TL.RMSCutNorm.ESL1(f,a2:b2),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 5) = mean(Donnees_EMG_TL.RMSCutNorm.ESL1(f,a2:b2),2)+std(Donnees_EMG_TL.RMSCutNorm.ESL1(f,a2:b2));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 6) = mean(Donnees_EMG_TL.RMSCutNorm.ESL1(f,a2:b2),2)-std(Donnees_EMG_TL.RMSCutNorm.ESL1(f,a2:b2));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 7) =  mean(Donnees_EMG_TL.RMSCutNorm.DA(f,a2:b2),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 8) = mean(Donnees_EMG_TL.RMSCutNorm.DA(f,a2:b2),2)+std(Donnees_EMG_TL.RMSCutNorm.DA(f,a2:b2));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 9) = mean(Donnees_EMG_TL.RMSCutNorm.DA(f,a2:b2),2)-std(Donnees_EMG_TL.RMSCutNorm.DA(f,a2:b2));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 10) =  mean(Donnees_EMG_TL.RMSCutNorm.DP(f,a2:b2),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 11) = mean(Donnees_EMG_TL.RMSCutNorm.DP(f,a2:b2),2)+std(Donnees_EMG_TL.RMSCutNorm.DP(f,a2:b2));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 12) = mean(Donnees_EMG_TL.RMSCutNorm.DP(f,a2:b2),2)-std(Donnees_EMG_TL.RMSCutNorm.DP(f,a2:b2));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 13) =  mean(Donnees_EMG_TL.RMSCutNorm.DAG(f,a2:b2),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 14) = mean(Donnees_EMG_TL.RMSCutNorm.DAG(f,a2:b2),2)+std(Donnees_EMG_TL.RMSCutNorm.DAG(f,a2:b2));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 15) = mean(Donnees_EMG_TL.RMSCutNorm.DAG(f,a2:b2),2)-std(Donnees_EMG_TL.RMSCutNorm.DAG(f,a2:b2));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 16) =  mean(Donnees_EMG_TL.RMSCutNorm.DPG(f,a2:b2),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 17) = mean(Donnees_EMG_TL.RMSCutNorm.DPG(f,a2:b2),2)+std(Donnees_EMG_TL.RMSCutNorm.DPG(f,a2:b2));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 18) = mean(Donnees_EMG_TL.RMSCutNorm.DPG(f,a2:b2),2)-std(Donnees_EMG_TL.RMSCutNorm.DPG(f,a2:b2));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 19) =  mean(Donnees_EMG_TL.RMSCutNorm.ST(f,a2:b2),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 20) = mean(Donnees_EMG_TL.RMSCutNorm.ST(f,a2:b2),2)+std(Donnees_EMG_TL.RMSCutNorm.ST(f,a2:b2));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 21) = mean(Donnees_EMG_TL.RMSCutNorm.ST(f,a2:b2),2)-std(Donnees_EMG_TL.RMSCutNorm.ST(f,a2:b2));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 22) =  mean(Donnees_EMG_TL.RMSCutNorm.BF(f,a2:b2),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 23) = mean(Donnees_EMG_TL.RMSCutNorm.BF(f,a2:b2),2)+std(Donnees_EMG_TL.RMSCutNorm.BF(f,a2:b2));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 24) = mean(Donnees_EMG_TL.RMSCutNorm.BF(f,a2:b2),2)-std(Donnees_EMG_TL.RMSCutNorm.BF(f,a2:b2));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 25) =  mean(Donnees_EMG_TL.RMSCutNorm.RF(f,a2:b2),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 26) = mean(Donnees_EMG_TL.RMSCutNorm.RF(f,a2:b2),2)+std(Donnees_EMG_TL.RMSCutNorm.RF(f,a2:b2));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 27) = mean(Donnees_EMG_TL.RMSCutNorm.RF(f,a2:b2),2)-std(Donnees_EMG_TL.RMSCutNorm.RF(f,a2:b2));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 28) =  mean(Donnees_EMG_TL.RMSCutNorm.VL(f,a2:b2),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 29) = mean(Donnees_EMG_TL.RMSCutNorm.VL(f,a2:b2),2)+std(Donnees_EMG_TL.RMSCutNorm.VL(f,a2:b2));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 30) = mean(Donnees_EMG_TL.RMSCutNorm.VL(f,a2:b2),2)-std(Donnees_EMG_TL.RMSCutNorm.VL(f,a2:b2));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 31) =  mean(Donnees_EMG_TL.RMSCutNorm.TA(f,a2:b2),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 32) = mean(Donnees_EMG_TL.RMSCutNorm.TA(f,a2:b2),2)+std(Donnees_EMG_TL.RMSCutNorm.TA(f,a2:b2));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 33) = mean(Donnees_EMG_TL.RMSCutNorm.TA(f,a2:b2),2)-std(Donnees_EMG_TL.RMSCutNorm.TA(f,a2:b2));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 34) =  mean(Donnees_EMG_TL.RMSCutNorm.SOL(f,a2:b2),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 35) = mean(Donnees_EMG_TL.RMSCutNorm.SOL(f,a2:b2),2)+std(Donnees_EMG_TL.RMSCutNorm.SOL(f,a2:b2));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 36) = mean(Donnees_EMG_TL.RMSCutNorm.SOL(f,a2:b2),2)-std(Donnees_EMG_TL.RMSCutNorm.SOL(f,a2:b2));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 37) =  mean(Donnees_EMG_TL.RMSCutNorm.GM(f,a2:b2),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 38) = mean(Donnees_EMG_TL.RMSCutNorm.GM(f,a2:b2),2)+std(Donnees_EMG_TL.RMSCutNorm.GM(f,a2:b2));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 39) = mean(Donnees_EMG_TL.RMSCutNorm.GM(f,a2:b2),2)-std(Donnees_EMG_TL.RMSCutNorm.GM(f,a2:b2));

    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 40) =  mean(Donnees_EMG_TL.RMSCutNorm.ESD7(f,a2:b2),2);
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 41) = mean(Donnees_EMG_TL.RMSCutNorm.ESD7(f,a2:b2),2)+std(Donnees_EMG_TL.RMSCutNorm.ESD7(f,a2:b2));
    Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 42) = mean(Donnees_EMG_TL.RMSCutNorm.ESD7(f,a2:b2),2)-std(Donnees_EMG_TL.RMSCutNorm.ESD7(f,a2:b2));
end

delete(findall(0));
%clear C3D;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PARTIE SUR LES MVTS RAPIDES 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
       j=0; marqueur = 'a';
        while ~strcmp(marqueur,'LSHO')
            j=j+1;
            marqueur = C3D.Cinematique.Labels(j);
            afficher = ['marqueur numéro ',j,marqueur]; %disp(afficher);
        end
        j = j*4-1;
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
        
        % Premier Mouvement
        [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_pas_cut_1, profil_vitesse_1, profil_vitesse_1_norm, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, Vmoy_1, Param_C_1, Nbmaxloc_1, debut_1, fin_1, profil_accel_1] = compute_kinematics_WHOLE_BODY_STS_BTS(Pos_mvmt_1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin);

        % Second Mouvement
        [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_pas_cut_2, profil_vitesse_2, profil_vitesse_2_norm, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, Vmoy_2, Param_C_2, Nbmaxloc_2, debut_2, fin_2, profil_accel_2] = compute_kinematics_WHOLE_BODY_STS_BTS(Pos_mvmt_2, Frequence_acquisition, 1, Cut_off, Ech_norm_kin);

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
            Donnees_cinematiques.Results_trial_by_trial(i, 2) = MD_1;
            Donnees_cinematiques.Results_trial_by_trial(i+numel(ListeFichier), 2) = MD_2;
            
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
    
    % Pour le signal RMS
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
Donnees_EMG.RMSCut.RAS(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 1);
Donnees_EMG.RMSCut.ESL1(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 2);
Donnees_EMG.RMSCut.DA(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 3);
Donnees_EMG.RMSCut.DP(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 4);
Donnees_EMG.RMSCut.DAG(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 5);
Donnees_EMG.RMSCut.DPG(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 6);
Donnees_EMG.RMSCut.ST(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 7);
Donnees_EMG.RMSCut.BF(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 8);
Donnees_EMG.RMSCut.RF(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 9);
Donnees_EMG.RMSCut.VL(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 10);
Donnees_EMG.RMSCut.TA(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 11);
Donnees_EMG.RMSCut.SOL(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 12);
Donnees_EMG.RMSCut.GM(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 13);
Donnees_EMG.RMSCut.ESD7(1:rms_cut_lig_1, i) = rms_cuts_1(1:rms_cut_lig_1, 14); 

Donnees_EMG.RMSCut.RAS(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 1);
Donnees_EMG.RMSCut.ESL1(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 2);
Donnees_EMG.RMSCut.DA(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 3);
Donnees_EMG.RMSCut.DP(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 4);
Donnees_EMG.RMSCut.DAG(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 5);
Donnees_EMG.RMSCut.DPG(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 6);
Donnees_EMG.RMSCut.ST(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 7);
Donnees_EMG.RMSCut.BF(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 8);
Donnees_EMG.RMSCut.RF(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 9);
Donnees_EMG.RMSCut.VL(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 10);
Donnees_EMG.RMSCut.TA(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 11);
Donnees_EMG.RMSCut.SOL(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 12);
Donnees_EMG.RMSCut.GM(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 13);
Donnees_EMG.RMSCut.ESD7(1:rms_cut_lig_2, i+numel(ListeFichier)) = rms_cuts_2(1:rms_cut_lig_2, 14);
       
       % Mouvements Normalisés
Donnees_EMG.RMSCutNorm.RAS(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 1);     
Donnees_EMG.RMSCutNorm.ESL1(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 2);
Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 3);
Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 4);
Donnees_EMG.RMSCutNorm.DAG(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 5);
Donnees_EMG.RMSCutNorm.DPG(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 6);
Donnees_EMG.RMSCutNorm.ST(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 7);
Donnees_EMG.RMSCutNorm.BF(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 8);
Donnees_EMG.RMSCutNorm.RF(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 9);
Donnees_EMG.RMSCutNorm.VL(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 10);
Donnees_EMG.RMSCutNorm.TA(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 11);
Donnees_EMG.RMSCutNorm.SOL(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 12);
Donnees_EMG.RMSCutNorm.GM(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 13);
Donnees_EMG.RMSCutNorm.ESD7(1:emg_ech_norm, i) = rms_cuts_norm_1(1:emg_ech_norm, 14);
   
Donnees_EMG.RMSCutNorm.RAS(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 1);
Donnees_EMG.RMSCutNorm.ESL1(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 2);
Donnees_EMG.RMSCutNorm.DA(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 3);
Donnees_EMG.RMSCutNorm.DP(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 4);
Donnees_EMG.RMSCutNorm.DAG(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 5);
Donnees_EMG.RMSCutNorm.DPG(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 6);
Donnees_EMG.RMSCutNorm.ST(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 7);
Donnees_EMG.RMSCutNorm.BF(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 8);
Donnees_EMG.RMSCutNorm.RF(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 9);
Donnees_EMG.RMSCutNorm.VL(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 10);
Donnees_EMG.RMSCutNorm.TA(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 11);
Donnees_EMG.RMSCutNorm.SOL(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 12);
Donnees_EMG.RMSCutNorm.GM(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 13);
Donnees_EMG.RMSCutNorm.ESD7(1:emg_ech_norm, i+numel(ListeFichier)) = rms_cuts_norm_2(1:emg_ech_norm, 14);

     end

     
     
     
%% Données moyennes se lever
for f = 1:1000
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 1) = mean(Donnees_EMG.RMSCutNorm.RAS(f,c:d),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 2) = mean(Donnees_EMG.RMSCutNorm.RAS(f,c:d),2)+std(Donnees_EMG.RMSCutNorm.RAS(f,c:d));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 3) = mean(Donnees_EMG.RMSCutNorm.RAS(f,c:d),2)-std(Donnees_EMG.RMSCutNorm.RAS(f,c:d));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 4) =  mean(Donnees_EMG.RMSCutNorm.ESL1(f,c:d),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 5) = mean(Donnees_EMG.RMSCutNorm.ESL1(f,c:d),2)+std(Donnees_EMG.RMSCutNorm.ESL1(f,c:d));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 6) = mean(Donnees_EMG.RMSCutNorm.ESL1(f,c:d),2)-std(Donnees_EMG.RMSCutNorm.ESL1(f,c:d));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 7) =  mean(Donnees_EMG.RMSCutNorm.DA(f,c:d),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 8) = mean(Donnees_EMG.RMSCutNorm.DA(f,c:d),2)+std(Donnees_EMG.RMSCutNorm.DA(f,c:d));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 9) = mean(Donnees_EMG.RMSCutNorm.DA(f,c:d),2)-std(Donnees_EMG.RMSCutNorm.DA(f,c:d));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 10) =  mean(Donnees_EMG.RMSCutNorm.DP(f,c:d),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 11) = mean(Donnees_EMG.RMSCutNorm.DP(f,c:d),2)+std(Donnees_EMG.RMSCutNorm.DP(f,c:d));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 12) = mean(Donnees_EMG.RMSCutNorm.DP(f,c:d),2)-std(Donnees_EMG.RMSCutNorm.DP(f,c:d));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 13) =  mean(Donnees_EMG.RMSCutNorm.DAG(f,c:d),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 14) = mean(Donnees_EMG.RMSCutNorm.DAG(f,c:d),2)+std(Donnees_EMG.RMSCutNorm.DAG(f,c:d));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 15) = mean(Donnees_EMG.RMSCutNorm.DAG(f,c:d),2)-std(Donnees_EMG.RMSCutNorm.DAG(f,c:d));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 16) =  mean(Donnees_EMG.RMSCutNorm.DPG(f,c:d),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 17) = mean(Donnees_EMG.RMSCutNorm.DPG(f,c:d),2)+std(Donnees_EMG.RMSCutNorm.DPG(f,c:d));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 18) = mean(Donnees_EMG.RMSCutNorm.DPG(f,c:d),2)-std(Donnees_EMG.RMSCutNorm.DPG(f,c:d));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 19) =  mean(Donnees_EMG.RMSCutNorm.ST(f,c:d),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 20) = mean(Donnees_EMG.RMSCutNorm.ST(f,c:d),2)+std(Donnees_EMG.RMSCutNorm.ST(f,c:d));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 21) = mean(Donnees_EMG.RMSCutNorm.ST(f,c:d),2)-std(Donnees_EMG.RMSCutNorm.ST(f,c:d));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 22) =  mean(Donnees_EMG.RMSCutNorm.BF(f,c:d),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 23) = mean(Donnees_EMG.RMSCutNorm.BF(f,c:d),2)+std(Donnees_EMG.RMSCutNorm.BF(f,c:d));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 24) = mean(Donnees_EMG.RMSCutNorm.BF(f,c:d),2)-std(Donnees_EMG.RMSCutNorm.BF(f,c:d));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 25) =  mean(Donnees_EMG.RMSCutNorm.RF(f,c:d),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 26) = mean(Donnees_EMG.RMSCutNorm.RF(f,c:d),2)+std(Donnees_EMG.RMSCutNorm.RF(f,c:d));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 27) = mean(Donnees_EMG.RMSCutNorm.RF(f,c:d),2)-std(Donnees_EMG.RMSCutNorm.RF(f,c:d));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 28) =  mean(Donnees_EMG.RMSCutNorm.VL(f,c:d),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 29) = mean(Donnees_EMG.RMSCutNorm.VL(f,c:d),2)+std(Donnees_EMG.RMSCutNorm.VL(f,c:d));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 30) = mean(Donnees_EMG.RMSCutNorm.VL(f,c:d),2)-std(Donnees_EMG.RMSCutNorm.VL(f,c:d));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 31) =  mean(Donnees_EMG.RMSCutNorm.TA(f,c:d),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 32) = mean(Donnees_EMG.RMSCutNorm.TA(f,c:d),2)+std(Donnees_EMG.RMSCutNorm.TA(f,c:d));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 33) = mean(Donnees_EMG.RMSCutNorm.TA(f,c:d),2)-std(Donnees_EMG.RMSCutNorm.TA(f,c:d));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 34) =  mean(Donnees_EMG.RMSCutNorm.SOL(f,c:d),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 35) = mean(Donnees_EMG.RMSCutNorm.SOL(f,c:d),2)+std(Donnees_EMG.RMSCutNorm.SOL(f,c:d));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 36) = mean(Donnees_EMG.RMSCutNorm.SOL(f,c:d),2)-std(Donnees_EMG.RMSCutNorm.SOL(f,c:d));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 37) =  mean(Donnees_EMG.RMSCutNorm.GM(f,c:d),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 38) = mean(Donnees_EMG.RMSCutNorm.GM(f,c:d),2)+std(Donnees_EMG.RMSCutNorm.GM(f,c:d));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 39) = mean(Donnees_EMG.RMSCutNorm.GM(f,c:d),2)-std(Donnees_EMG.RMSCutNorm.GM(f,c:d));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 40) =  mean(Donnees_EMG.RMSCutNorm.ESD7(f,c:d),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 41) = mean(Donnees_EMG.RMSCutNorm.ESD7(f,c:d),2)+std(Donnees_EMG.RMSCutNorm.ESD7(f,c:d));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(f, 42) = mean(Donnees_EMG.RMSCutNorm.ESD7(f,c:d),2)-std(Donnees_EMG.RMSCutNorm.ESD7(f,c:d));

    %% Se rassoir
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 1) =  mean(Donnees_EMG.RMSCutNorm.RAS(f,c2:d2),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 2) = mean(Donnees_EMG.RMSCutNorm.RAS(f,c2:d2),2)+std(Donnees_EMG.RMSCutNorm.RAS(f,c2:d2));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 3) = mean(Donnees_EMG.RMSCutNorm.RAS(f,c2:d2),2)-std(Donnees_EMG.RMSCutNorm.RAS(f,c2:d2));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 4) =  mean(Donnees_EMG.RMSCutNorm.ESL1(f,c2:d2),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 5) = mean(Donnees_EMG.RMSCutNorm.ESL1(f,c2:d2),2)+std(Donnees_EMG.RMSCutNorm.ESL1(f,c2:d2));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 6) = mean(Donnees_EMG.RMSCutNorm.ESL1(f,c2:d2),2)-std(Donnees_EMG.RMSCutNorm.ESL1(f,c2:d2));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 7) =  mean(Donnees_EMG.RMSCutNorm.DA(f,c2:d2),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 8) = mean(Donnees_EMG.RMSCutNorm.DA(f,c2:d2),2)+std(Donnees_EMG.RMSCutNorm.DA(f,c2:d2));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 9) = mean(Donnees_EMG.RMSCutNorm.DA(f,c2:d2),2)-std(Donnees_EMG.RMSCutNorm.DA(f,c2:d2));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 10) =  mean(Donnees_EMG.RMSCutNorm.DP(f,c2:d2),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 11) = mean(Donnees_EMG.RMSCutNorm.DP(f,c2:d2),2)+std(Donnees_EMG.RMSCutNorm.DP(f,c2:d2));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 12) = mean(Donnees_EMG.RMSCutNorm.DP(f,c2:d2),2)-std(Donnees_EMG.RMSCutNorm.DP(f,c2:d2));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 13) =  mean(Donnees_EMG.RMSCutNorm.DAG(f,c2:d2),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 14) = mean(Donnees_EMG.RMSCutNorm.DAG(f,c2:d2),2)+std(Donnees_EMG.RMSCutNorm.DAG(f,c2:d2));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 15) = mean(Donnees_EMG.RMSCutNorm.DAG(f,c2:d2),2)-std(Donnees_EMG.RMSCutNorm.DAG(f,c2:d2));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 16) =  mean(Donnees_EMG.RMSCutNorm.DPG(f,c2:d2),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 17) = mean(Donnees_EMG.RMSCutNorm.DPG(f,c2:d2),2)+std(Donnees_EMG.RMSCutNorm.DPG(f,c2:d2));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 18) = mean(Donnees_EMG.RMSCutNorm.DPG(f,c2:d2),2)-std(Donnees_EMG.RMSCutNorm.DPG(f,c2:d2));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 19) =  mean(Donnees_EMG.RMSCutNorm.ST(f,c2:d2),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 20) = mean(Donnees_EMG.RMSCutNorm.ST(f,c2:d2),2)+std(Donnees_EMG.RMSCutNorm.ST(f,c2:d2));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 21) = mean(Donnees_EMG.RMSCutNorm.ST(f,c2:d2),2)-std(Donnees_EMG.RMSCutNorm.ST(f,c2:d2));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 22) =  mean(Donnees_EMG.RMSCutNorm.BF(f,c2:d2),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 23) = mean(Donnees_EMG.RMSCutNorm.BF(f,c2:d2),2)+std(Donnees_EMG.RMSCutNorm.BF(f,c2:d2));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 24) = mean(Donnees_EMG.RMSCutNorm.BF(f,c2:d2),2)-std(Donnees_EMG.RMSCutNorm.BF(f,c2:d2));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 25) =  mean(Donnees_EMG.RMSCutNorm.RF(f,c2:d2),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 26) = mean(Donnees_EMG.RMSCutNorm.RF(f,c2:d2),2)+std(Donnees_EMG.RMSCutNorm.RF(f,c2:d2));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 27) = mean(Donnees_EMG.RMSCutNorm.RF(f,c2:d2),2)-std(Donnees_EMG.RMSCutNorm.RF(f,c2:d2));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 28) =  mean(Donnees_EMG.RMSCutNorm.VL(f,c2:d2),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 29) = mean(Donnees_EMG.RMSCutNorm.VL(f,c2:d2),2)+std(Donnees_EMG.RMSCutNorm.VL(f,c2:d2));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 30) = mean(Donnees_EMG.RMSCutNorm.VL(f,c2:d2),2)-std(Donnees_EMG.RMSCutNorm.VL(f,c2:d2));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 31) =  mean(Donnees_EMG.RMSCutNorm.TA(f,c2:d2),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 32) = mean(Donnees_EMG.RMSCutNorm.TA(f,c2:d2),2)+std(Donnees_EMG.RMSCutNorm.TA(f,c2:d2));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 33) = mean(Donnees_EMG.RMSCutNorm.TA(f,c2:d2),2)-std(Donnees_EMG.RMSCutNorm.TA(f,c2:d2));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 34) =  mean(Donnees_EMG.RMSCutNorm.SOL(f,c2:d2),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 35) = mean(Donnees_EMG.RMSCutNorm.SOL(f,c2:d2),2)+std(Donnees_EMG.RMSCutNorm.SOL(f,c2:d2));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 36) = mean(Donnees_EMG.RMSCutNorm.SOL(f,c2:d2),2)-std(Donnees_EMG.RMSCutNorm.SOL(f,c2:d2));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 37) =  mean(Donnees_EMG.RMSCutNorm.GM(f,c2:d2),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 38) = mean(Donnees_EMG.RMSCutNorm.GM(f,c2:d2),2)+std(Donnees_EMG.RMSCutNorm.GM(f,c2:d2));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 39) = mean(Donnees_EMG.RMSCutNorm.GM(f,c2:d2),2)-std(Donnees_EMG.RMSCutNorm.GM(f,c2:d2));

    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 40) =  mean(Donnees_EMG.RMSCutNorm.ESD7(f,c2:d2),2);
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 41) = mean(Donnees_EMG.RMSCutNorm.ESD7(f,c2:d2),2)+std(Donnees_EMG.RMSCutNorm.ESD7(f,c2:d2));
    Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(f, 42) = mean(Donnees_EMG.RMSCutNorm.ESD7(f,c2:d2),2)-std(Donnees_EMG.RMSCutNorm.ESD7(f,c2:d2));
end


%% Calcul tonic
i = 1;
j=1;
while j <= 14
    Donnees_EMG.Phasic.Se_lever(1:emg_ech_norm, j) = Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(:, i)-Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(:, i);
    Donnees_EMG.Phasic.Se_rassoir(1:emg_ech_norm, j) = Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(:, i)-Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(:, i);
    i = i+3;
    j = j+1;
end

Donnees.EMG_TL = Donnees_EMG_TL;
Donnees.EMG = Donnees_EMG;
Donnees.cinematiques_TL = Donnees_cinematiques_TL;
Donnees.cinematiques = Donnees_cinematiques;

name = append(C3D.NomSujet(1,:),'');
disp('Selectionnez le Dossier où enregistre les données.');
[Dossier] = uigetdir ('Selectionnez le Dossier où enregistre les données.');
save([Dossier '/' name ], 'Donnees');
delete(findall(0));
disp('Données enregistrées avec succès !');


% PLOT GRAPHS 
% for muscle=1 : 14
% muscle2 = 3*muscle-2;
% Titre = append('SE baisser muscle : ',string(C3D.EMG.Labels(muscle)));
% figure('Name',Titre,'NumberTitle','off');
% set(gcf,'position',[50,45,400,735])
% 
% subplot(5,1,1)
% plot(Donnees_cinematiques_TL.Vel_cut_norm(:,a:b),'DisplayName','Donnees_cinematiques_TL.Vel_cut_norm(:,a:b)')
% title('Vitesse du marqueur epaule MVT LENT')
% subplot(5,1,2)
% plot(Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(:,muscle2:muscle2+2),'DisplayName','Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(:,muscle2:muscle2+2)')
% title('EMG LENT (Tonic) moyenne de 4 essais')
% subplot(5,1,3)
% plot(Donnees_cinematiques.Vel_cut_norm(:,c:d),'DisplayName','Donnees_cinematiques.Vel_cut_norm(:,c:d)')
% title('Vitesse du marqueur epaule MVT rapide')
% subplot(5,1,4)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(:,muscle2:muscle2+2),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_lever(:,muscle2:muscle2+2)')
% title('EMG RAPIDE (Tonic + rapide) moyenne de 10 essais')
% subplot(5,1,5)
% r=[0.1:0.1:1000];
% y = zeros(length(r),1);
% plot(Donnees_EMG.Phasic.Se_lever(:,muscle));hold on;
% plot(r,y,'r');
% title('Phasic (EMG rapide - EMG très lent)')
% 
% Titre = append('SE relever muscle : ',string(C3D.EMG.Labels(muscle)));
% figure('Name',Titre,'NumberTitle','off');
% set(gcf,'position',[450,45,400,735])
% 
% subplot(5,1,1)
% plot(Donnees_cinematiques_TL.Vel_cut_norm(:,a2:b2),'DisplayName','Donnees_cinematiques_TL.Vel_cut_norm(:,a2:b2)');
% title('Vitesse du marqueur epaule MVT LENT')
% subplot(5,1,2)
% plot(Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(:,muscle2:muscle2+2),'DisplayName','Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(:,muscle2:muscle2+2)')
% title('EMG LENT (Tonic) moyenne de 4 essais')
% subplot(5,1,3)
% plot(Donnees_cinematiques.Vel_cut_norm(:,c2:d2),'DisplayName','Donnees_cinematiques.Vel_cut_norm(:,c2:d2)')
% title('Vitesse du marqueur epaule RAPIDE')
% subplot(5,1,4)
% plot(Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(:,muscle2:muscle2+2),'DisplayName','Donnees_EMG.RMSCutNorm.ProfilMoyen.Se_rassoir(:,muscle2:muscle2+2)')
% title('EMG RAPIDE (Tonic + rapide) moyenne de 10 essais')
% subplot(5,1,5)
% r=[0.1:0.1:1000];
% y = zeros(length(r),1);
% plot(Donnees_EMG.Phasic.Se_rassoir(:,muscle));hold on;
% plot(r,y,'r');
% title('Phasic (EMG rapide - EMG très lent)')
% 
% end

end





% 
% for muscle=1 : 14
% muscle2 = 3*muscle-2;
% Titre = append('SE LEVER muscle : ',string(C3D.EMG.Labels(muscle)));
% figure('Name',Titre,'NumberTitle','off');
% set(gcf,'position',[50,45,400,250])
% subplot(1,1,1)
% plot(Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(:,muscle2:muscle2+2),'DisplayName','Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_lever(:,muscle2:muscle2+2)')
% title('EMG LENT (Tonic) moyenne de 2 essais')
% 
% Titre = append('SE RASSOIR muscle : ',string(C3D.EMG.Labels(muscle)));
% figure('Name',Titre,'NumberTitle','off');
% set(gcf,'position',[450,45,400,250])
% subplot(1,1,1)
% plot(Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(:,muscle2:muscle2+2),'DisplayName','Donnees_EMG_TL.RMSCutNorm.ProfilMoyen.Se_rassoir(:,muscle2:muscle2+2)')
% title('EMG LENT (Tonic) moyenne de 2 essais')
% end