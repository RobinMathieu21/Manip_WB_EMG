
%% Script -----kinematics----- pour manip mvts whole body
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
param_moyenne = 100; % Nb images pour moyenner la position pendant phases stables
param_moyenne2 = 200/5; % Nb images pour moyenner la position pendant phases stables
nb_images_to_add=param_moyenne/2;
pourcen_amp = 0.05;

%% Importation des données

%On selectionne le repertoire
disp('Selectionnez le Dossier regroupant les essais lents');
%[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');
% Dossier = 'C:\Users\robin\Desktop\Drive google\6A - THESE\MANIP 1\MATLAB\CODES\2_Assis_debout\MVT lents'; % Pour PC portable
Dossier = 'G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\MATLAB\CODES\2_Assis_debout\MVT lents';
if (Dossier ~= 0) %Si on clique sur un dossier
    
    Extension = '*.mat'; %Traite tous les .mat
    Chemin = fullfile(Dossier, Extension); % On construit le chemin
    ListeFichier = dir(Chemin); % On construit la liste des fichiers

%% On crée les matrices de résultats

    Donnees = {};
    Donnees_cinematiques_TL = {};
    Premiere_fois = true; % Pour n'effecteur certaines actions de lecture des labels qu'une seule fois
    
%% On procède au balayage fichier par fichier
    disp('POST TRAITEMENT MOUVEMENTS RAPIDES')
    disp(append('Il y a ', string(numel(ListeFichier)),' fichiers à analyser.'));
    for i = 1: numel(ListeFichier)
 
       Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
       disp(append('i = ',string(i)));
       load (Fichier_traite);
       

       Donnees.EMG_lent(i).data = C3D.EMG.Donnees;
       Donnees.EMG_lent(i).Muscles = C3D.EMG.Labels;
       Donnees.EMG_lent(i).C3DLENT = C3D;
       
        if Premiere_fois %% Boucle pour trouver les coordonnées du marqueur de l'épaule gauche
            j=0; marqueur = 'a';
            while ~strcmp(marqueur,'RSHO')
                j=j+1;
                marqueur = C3D.Cinematique.Labels(j);  
            end
            disp(append('Le marqueur RSHO est le numéro ',string(j)));
            j = j*4-1;
        
        end
       
        %On crée une matrice de la position de l'épaule
        posxyz = C3D.Cinematique.Donnees(:, j-2:j);
        [posxyz_lig, ~] = size(posxyz);
        
        %On filtre le signal de position
        posxyzCOM = C3D.Cinematique.Donnees(:, j-2:j);% C3D.Cinematique.CenterOfMass(:,:)';
        posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');

        posfiltreCOM = butter_emgs(posxyzCOM, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
        vec_position = sqrt(posfiltre(:, 3).^2);
        vec_positionCOM = sqrt(posfiltreCOM(:, 1).^2+posfiltre(:, 2).^2+posfiltre(:, 3).^2);
        

        %On coupe le signal de vitesse pour avoir 2 plages contenant chacune un mouvement
%         Titredec = append('Découpage mvt lent numéro ', string(i));
%         figure('Name',Titredec,'NumberTitle','off');
%         plot(vec_position)%posfiltre(:, 3)
%         [Cut] = ginput(5);
        Cut = DonneesSAVED.cinematiques_TL.clics;
%         
        Plage_mvmt_1_start = round(Cut(i,1)); %%%% AVEC SAVE
        Plage_mvmt_1_end = round(Cut(i,2));

%         Plage_mvmt_1_start = round(Cut(1,1));
%         Plage_mvmt_1_end = round(Cut(2,1));
        
        Plage_mvmt_2_start = round(Cut(i,2)); %%%% AVEC SAVE
        Plage_mvmt_2_end = round(Cut(i,3));

%         Plage_mvmt_2_start = round(Cut(2,1));
%         Plage_mvmt_2_end = round(Cut(3,1));

        mid1 = round(Cut(i,4));% - Plage_mvmt_1_start; %%%% AVEC SAVE
        mid2 = round(Cut(i,5));% - Plage_mvmt_2_start;
        
%         mid1 = round(Cut(4,1)) - Plage_mvmt_1_start;
%         mid2 = round(Cut(5,1)) - Plage_mvmt_2_start;

        [Pos_mvmt_1] = posfiltre(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
        [Pos_mvmt_2] = posfiltre(Plage_mvmt_2_start:Plage_mvmt_2_end, :);  

        [Pos_mvmt_1COM] = posfiltreCOM(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
        [Pos_mvmt_2COM] = posfiltreCOM(Plage_mvmt_2_start:Plage_mvmt_2_end, :);  
        
%% On calcule les paramètres cinématiques des 2 mouvements
        
        % Premier Mouvement
        [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_pas_cut_1, moy_deb_1, moy_fin_1, std_deb_1, std_fin_1, profil_vitesse_1, profil_vitesse_1_norm, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, Vmoy_1, Param_C_1, debut_1, fin_1, debut_V2_1, fin_V2_1] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_1, Pos_mvmt_1COM,mid1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin, param_moyenne,pourcen_amp);
        % Second Mouvement
        [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_pas_cut_2, moy_deb_2, moy_fin_2, std_deb_2, std_fin_2, profil_vitesse_2, profil_vitesse_2_norm, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, Vmoy_2, Param_C_2, debut_2, fin_2, debut_V2_2, fin_V2_2] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_2,Pos_mvmt_2COM,mid2,  Frequence_acquisition, 2, Cut_off, Ech_norm_kin, param_moyenne,pourcen_amp);
        
%% On remplit les matrices de résulats des paramètres cinématiques des mvts très lents
       
        k = 3*i;
        z = k-2;
        
%%%%% DATA SEQ
        Donnees_cinematiques_TL.Clics_acq(:,i)=Cut(:,1);
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
%         Donnees_cinematiques_TL.Acc(1:lig_pv1, i) = profil_accel_1;
%         Donnees_cinematiques_TL.Acc(1:lig_pv2, i+numel(ListeFichier)) = profil_accel_2;            
            
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

        Donnees_cinematiques_TL.debut_fin(i, 1) = Plage_mvmt_1_start+debut_1;
        Donnees_cinematiques_TL.debut_fin(i, 2) = Plage_mvmt_1_start+fin_1;
        Donnees_cinematiques_TL.debut_fin(i, 3) = Plage_mvmt_2_start+debut_2;
        Donnees_cinematiques_TL.debut_fin(i, 4) = Plage_mvmt_2_start+fin_2;

        Donnees_cinematiques_TL.debut_fin2(i, 1) = Plage_mvmt_1_start+debut_V2_1;
        Donnees_cinematiques_TL.debut_fin2(i, 2) = Plage_mvmt_1_start+fin_V2_1;
        Donnees_cinematiques_TL.debut_fin2(i, 3) = Plage_mvmt_2_start+debut_V2_2;
        Donnees_cinematiques_TL.debut_fin2(i, 4) = Plage_mvmt_2_start+fin_V2_2;

        Donnees_cinematiques_TL.clics(i, 1) = Plage_mvmt_1_start;
        Donnees_cinematiques_TL.clics(i, 2) = Plage_mvmt_1_end;
        Donnees_cinematiques_TL.clics(i, 3) = Plage_mvmt_2_end;
        Donnees_cinematiques_TL.clics(i, 4) = mid1;
        Donnees_cinematiques_TL.clics(i, 5) = mid2;
            
        gap = Plage_mvmt_1_start;
        Titre = append('Vérification découpage mvts lents de ',string(C3D.NomSujet(1,:)));
        figure('Name',Titre,'NumberTitle','off');

        %         f = figure('units','normalized','outerposition',[0 0 1 1]);
        t = tiledlayout(2,1,'TileSpacing','Compact');
    
        nexttile 
        plot(vec_position);hold on;
        y = ylim; % current y-axis limits
        x = xlim; % current y-axis limits
        
        plot([gap+debut_1 gap+debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
        plot([gap+fin_1 gap+fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
        plot([gap+x(1) gap+x(1)+param_moyenne],[moy_deb_1(:,1) moy_deb_1(:,1)],'r');hold on; %moyenne debut

        plot([Plage_mvmt_1_end-param_moyenne/2 Plage_mvmt_1_end+param_moyenne/2],[moy_fin_1(:,1) moy_fin_1(:,1)],'b');hold on; % moyenne milieu
        plot([Plage_mvmt_1_end Plage_mvmt_1_end],[y(1) y(2)],'b');hold on; % ginput au milieu

        plot([Plage_mvmt_2_start+debut_2 Plage_mvmt_2_start+debut_2],[y(1) y(2)],'g');hold on; %debut mvt 2
        plot([Plage_mvmt_2_start+fin_2 Plage_mvmt_2_start+fin_2],[y(1) y(2)],'g'); % fin  mvt 2
        plot([Plage_mvmt_2_end-param_moyenne/2 Plage_mvmt_2_end+param_moyenne/2],[moy_fin_2(:,1) moy_fin_2(:,1)],'g');hold on; %moyenne fin
        title('Position en Z marqueur épaule ')
        %disp(Plage_mvmt_2_start);

        nexttile
        plot(vec_positionCOM);hold on;
        y = ylim; % current y-axis limits
        x = xlim; % current y-axis limits

        plot([gap+debut_V2_1 gap+debut_V2_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
        plot([gap+fin_V2_1 gap+fin_V2_1],[y(1) y(2)],'r'); hold on; % fin mvt 1

        plot([Plage_mvmt_2_start+debut_V2_2 Plage_mvmt_2_start+debut_V2_2],[y(1) y(2)],'g');hold on; %debut mvt 2
        plot([Plage_mvmt_2_start+fin_V2_2 Plage_mvmt_2_start+fin_V2_2],[y(1) y(2)],'g'); % fin  mvt 2
        w = waitforbuttonpress;
        axes;



     end

%% Données moyennes se lever
   

    delete(findall(0));
   

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PARTIE SUR LES MVTS RAPIDES %% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Savec_J = j;
j = Savec_J;
disp('Selectionnez le Dossier regroupant les essais à vitesse rapide');
%[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script MVT Rapide');
% Dossier = 'C:\Users\robin\Desktop\Drive google\6A - THESE\MANIP 1\MATLAB\CODES\2_Assis_debout\MVT rapides';% Pour portable
Dossier = 'G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\MATLAB\CODES\2_Assis_debout\MVT rapides';

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

        %% on recupère les données EMG brutes pour le prochain code
       
       % on recupère les données EMG brutes pour le prochain code
       
       Donnees.EMG(i).data = C3D.EMG.Donnees;
       Donnees.EMG(i).Muscles = C3D.EMG.Labels;
       Donnees.EMG(i).C3D = C3D;
       
       
        %% On crée une matrice de la position de l'épaule
        posxyz = C3D.Cinematique.Donnees(:, j-2:j);
        [posxyz_lig, ~] = size(posxyz);
        
        %On filtre le signal de position
%         posxyz = C3D.Cinematique.Angles.LKnee(:,:)';
        posxyzCOM = C3D.Cinematique.Donnees(:, j-2:j);% C3D.Cinematique.CenterOfMass(:,:)';
        posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
        posfiltreCOM = butter_emgs(posxyzCOM, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
        vec_position = sqrt(posfiltre(:, 3).^2);%+posfiltre(:, 2).^2+posfiltre(:, 3).^2);
        vec_positionCOM = sqrt(posfiltreCOM(:, 1).^2+posfiltre(:, 2).^2+posfiltre(:, 3).^2);
%         vitesse_test = sqrt(derive(posfiltre(:, 3), 1).^2);
%         vitesseZ = vitesse_test./(1/Frequence_acquisition);
%         vitesseZ = butter_emgs(vitesseZ,250, 2, Low_pass_Freq, 'low-pass', 'false', 'centered');

        %On coupe le signal de vitesse pour avoir 2 plages contenant chacune un mouvement
%         Titre = append('Position en Z du marqueur ', string(marqueur));
%         figure('Name',Titre,'NumberTitle','off');
%         plot(vec_position); hold on;%posfiltre(:, 3) 
%         [Cut] = ginput(5);
        Cut = DonneesSAVED.cinematiques.clics;
        
        Plage_mvmt_1_start = round(Cut(i,1)); %%%% AVEC SAVE
        Plage_mvmt_1_end = round(Cut(i,2));

%         Plage_mvmt_1_start = round(Cut(1,1));
%         Plage_mvmt_1_end = round(Cut(2,1));
%         
        Plage_mvmt_2_start = round(Cut(i,2)); %%%% AVEC SAVE
        Plage_mvmt_2_end = round(Cut(i,3));

%         Plage_mvmt_2_start = round(Cut(2,1));
%         Plage_mvmt_2_end = round(Cut(3,1));

        mid1 = round(Cut(i,4));% - Plage_mvmt_1_start; %%%% AVEC SAVE
        mid2 = round(Cut(i,5));% - Plage_mvmt_2_start;
        
%         mid1 = round(Cut(4,1)) - Plage_mvmt_1_start;
%         mid2 = round(Cut(5,1)) - Plage_mvmt_2_start;
        
        [Pos_mvmt_1] = posfiltre(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
        [Pos_mvmt_2] = posfiltre(Plage_mvmt_2_start:Plage_mvmt_2_end, :);  
        [Pos_mvmt_1COM] = posfiltreCOM(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
        [Pos_mvmt_2COM] = posfiltreCOM(Plage_mvmt_2_start:Plage_mvmt_2_end, :);  

        
        %% On calcule les paramètres cinématiques des 2 mouvements
        
%         [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_pas_cut_1, profil_vitesse_1, profil_vitesse_1_norm, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, Vmoy_1, Param_C_1, Nbmaxloc_1, debut_1, fin_1, profil_accel_1] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin);
%         [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_pas_cut_2, profil_vitesse_2, profil_vitesse_2_norm, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, Vmoy_2, Param_C_2, Nbmaxloc_2, debut_2, fin_2, profil_accel_2] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_2, Frequence_acquisition, 2, Cut_off, Ech_norm_kin);

        [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_pas_cut_1, moy_deb_1, moy_fin_1, std_deb_1, std_fin_1, profil_vitesse_1, profil_vitesse_1_norm, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, Vmoy_1, Param_C_1, debut_1, fin_1, debut_V2_1, fin_V2_1] = compute_kinematics_WHOLE_BODY_STS_BTS_TL_RDPV(Pos_mvmt_1, Pos_mvmt_1COM,mid1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin, param_moyenne2, pourcen_amp);
        % Second Mouvement
        [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_pas_cut_2, moy_deb_2, moy_fin_2, std_deb_2, std_fin_2, profil_vitesse_2, profil_vitesse_2_norm, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, Vmoy_2, Param_C_2, debut_2, fin_2, debut_V2_2, fin_V2_2] = compute_kinematics_WHOLE_BODY_STS_BTS_TL_RDPV(Pos_mvmt_2, Pos_mvmt_2COM,mid2, Frequence_acquisition, 2, Cut_off, Ech_norm_kin, param_moyenne2, pourcen_amp);
       
        %% On remplit les matrices de résulats des paramètres cinématiques des mvts
       
          k = 3*i;
          z = k-2;
        
%%%%% DATA SEQ
            Donnees_cinematiques.Clics_acq(:,i)=Cut(:,1);
            Donnees_cinematiques.Position_cut_brut(1:lig_pos_1, z:k) = profil_position_1;
            Donnees_cinematiques.Position_cut_brut(1:lig_pos_2, z+3*numel(ListeFichier):k+3*numel(ListeFichier)) = profil_position_2;
            Donnees_cinematiques.Position_cut_norm(:, z:k) = profil_position_1_norm;
            Donnees_cinematiques.Position_cut_norm(:, z+3*numel(ListeFichier):k+3*numel(ListeFichier)) = profil_position_2_norm;
            Donnees_cinematiques.Vel_cut_brut(1:lig_pv1, i) = profil_vitesse_1;
            Donnees_cinematiques.Vel_cut_brut(1:lig_pv2, i+numel(ListeFichier)) = profil_vitesse_2;           
            Donnees_cinematiques.Vel_cut_norm(:, i) = profil_vitesse_1_norm;
            Donnees_cinematiques.Vel_cut_norm(:, i+numel(ListeFichier)) = profil_vitesse_2_norm;
%             Donnees_cinematiques.Acc(1:lig_pv1, i) = profil_accel_1;
%             Donnees_cinematiques.Acc(1:lig_pv2, i+numel(ListeFichier)) = profil_accel_2;
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
            
            Donnees_cinematiques.debut_fin(i, 1) = Plage_mvmt_1_start+debut_1;
            Donnees_cinematiques.debut_fin(i, 2) = Plage_mvmt_1_start+fin_1;
            Donnees_cinematiques.debut_fin(i, 3) = Plage_mvmt_2_start+debut_2;
            Donnees_cinematiques.debut_fin(i, 4) = Plage_mvmt_2_start+fin_2;

            Donnees_cinematiques.debut_fin2(i, 1) = Plage_mvmt_1_start+debut_V2_1;
            Donnees_cinematiques.debut_fin2(i, 2) = Plage_mvmt_1_start+fin_V2_1;
            Donnees_cinematiques.debut_fin2(i, 3) = Plage_mvmt_2_start+debut_V2_2;
            Donnees_cinematiques.debut_fin2(i, 4) = Plage_mvmt_2_start+fin_V2_2;

            Donnees_cinematiques.clics(i, 1) = Plage_mvmt_1_start;
            Donnees_cinematiques.clics(i, 2) = Plage_mvmt_1_end;
            Donnees_cinematiques.clics(i, 3) = Plage_mvmt_2_end;
            Donnees_cinematiques.clics(i, 4) = mid1;
            Donnees_cinematiques.clics(i, 5) = mid2;
            
            
        gap = Plage_mvmt_1_start;
        Titre = append('Vérification découpage mvts lents de ',string(C3D.NomSujet(1,:)));
        figure('Name',Titre,'NumberTitle','off');
% 
%         f = figure('units','normalized','outerposition',[0 0 1 1]);
            t = tiledlayout(2,1,'TileSpacing','Compact');
    
        nexttile 
        plot(vec_position);hold on;
        y = ylim; % current y-axis limits
        x = xlim; % current y-axis limits
%         debut_1 = debut_V2_1;
%         fin_1 = fin_V2_1;
%         debut_2 = debut_V2_2;
%         fin_2 = fin_V2_2;

        plot([gap+debut_1 gap+debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
        plot([gap+fin_1 gap+fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
        plot([gap+x(1) gap+x(1)+param_moyenne],[moy_deb_1(:,1) moy_deb_1(:,1)],'r');hold on; %moyenne debut

        plot([Plage_mvmt_1_end-param_moyenne/2 Plage_mvmt_1_end+param_moyenne/2],[moy_fin_1(:,1) moy_fin_1(:,1)],'b');hold on; % moyenne milieu
        plot([Plage_mvmt_1_end Plage_mvmt_1_end],[y(1) y(2)],'b');hold on; % ginput au milieu

        plot([Plage_mvmt_2_start+debut_2 Plage_mvmt_2_start+debut_2],[y(1) y(2)],'g');hold on; %debut mvt 2
        plot([Plage_mvmt_2_start+fin_2 Plage_mvmt_2_start+fin_2],[y(1) y(2)],'g'); % fin  mvt 2
        plot([Plage_mvmt_2_end-param_moyenne/2 Plage_mvmt_2_end+param_moyenne/2],[moy_fin_2(:,1) moy_fin_2(:,1)],'g');hold on; %moyenne fin
        title('Position en Z marqueur épaule ')
        %disp(Plage_mvmt_2_start);

        nexttile
        plot(vec_positionCOM);hold on;
        y = ylim; % current y-axis limits
        x = xlim; % current y-axis limits

        plot([gap+debut_V2_1 gap+debut_V2_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
        plot([gap+fin_V2_1 gap+fin_V2_1],[y(1) y(2)],'r'); hold on; % fin mvt 1

        plot([Plage_mvmt_2_start+debut_V2_2 Plage_mvmt_2_start+debut_V2_2],[y(1) y(2)],'g');hold on; %debut mvt 2
        plot([Plage_mvmt_2_start+fin_V2_2 Plage_mvmt_2_start+fin_V2_2],[y(1) y(2)],'g'); % fin  mvt 2

        w = waitforbuttonpress;
        axes;


        
     end     
        
delete(findall(0));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Export des données
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Donnees.cinematiques_TL = Donnees_cinematiques_TL;
Donnees.cinematiques = Donnees_cinematiques;
Donnees.NOM = C3D.NomSujet(1,:);

name = append('KINE_',C3D.NomSujet(1,:),'');
disp('Selectionnez le Dossier où enregistre les données.');
[Dossier] = uigetdir ('Selectionnez le Dossier où enregistre les données.');
save([Dossier '/' name ], 'Donnees');
disp('Données enregistrées avec succès !');

end


