
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

[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');
    
Extension = '*.mat'; %Traite tous les .mat
Chemin = fullfile(Dossier, Extension); % On construit le chemin
ListeFichier = dir(Chemin); % On construit la liste des fichiers

for SUJETS = 1: numel(ListeFichier)
        Fichier_traite = [Dossier '\' ListeFichier(SUJETS).name]; %On charge le fichier .mat
        load (Fichier_traite);
        DonneesSAVED = Donnees;
    %% On crée les matrices de résultats
        SUJETS
        Donnees_cinematiques_TL = {};
        Premiere_fois = true; % Pour n'effecteur certaines actions de lecture des labels qu'une seule fois
        
    %% On procède au balayage fichier par fichier
        disp('POST TRAITEMENT MOUVEMENTS LENTS')
        [Col, lig_nb_acq] = size(DonneesSAVED.EMG_lent);
        for i = 1: lig_nb_acq
     
           disp(append('i = ',string(i)));
           
           Donnees(SUJETS).EMG_lent(i).data = DonneesSAVED.EMG_lent(i).C3DLENT.EMG.Donnees;
           Donnees(SUJETS).EMG_lent(i).Muscles = DonneesSAVED.EMG_lent(i).C3DLENT.EMG.Labels;
           Donnees(SUJETS).EMG_lent(i).C3DLENT = DonneesSAVED.EMG_lent(i).C3DLENT;
           
            if Premiere_fois %% Boucle pour trouver les coordonnées du marqueur de l'épaule gauche
                j=0; marqueur = 'a';
                while ~strcmp(marqueur,'RSHO')
                    j=j+1;
                    marqueur = DonneesSAVED.EMG_lent(i).C3DLENT.Cinematique.Labels(j);  
                end
                disp(append('Le marqueur RSHO est le numéro ',string(j)));
                j = j*4-1;
            
            end
           
            %On crée une matrice de la position de l'épaule
            posxyz = DonneesSAVED.EMG_lent(i).C3DLENT.Cinematique.Donnees(:, j-2:j);
            [posxyz_lig, ~] = size(posxyz);
            
            %On filtre le signal de position
            posxyzCOM = DonneesSAVED.EMG_lent(i).C3DLENT.Cinematique.Donnees(:, j-2:j);% C3D.Cinematique.CenterOfMass(:,:)';
            posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
    
            posfiltreCOM = butter_emgs(posxyzCOM, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
            vec_position = sqrt(posfiltre(:, 3).^2);
            vec_positionCOM = sqrt(posfiltreCOM(:, 1).^2+posfiltre(:, 2).^2+posfiltre(:, 3).^2);
            
    
            %On coupe le signal de vitesse pour avoir 2 plages contenant chacune un mouvement
    %         Titredec = append('Découpage mvt lent numéro ', string(i));
    %         figure('Name',Titredec,'NumberTitle','off');
    %         plot(vec_position)%posfiltre(:, 3)
    %         [Cut] = ginput(5);
            Cut = DonneesSAVED.cinematiques_TL.Clics_acq(:,i);
    %         
            Plage_mvmt_1_start = round(Cut(1)); %%%% AVEC SAVE
            Plage_mvmt_1_end = round(Cut(2));
    
    %         Plage_mvmt_1_start = round(Cut(1,1));
    %         Plage_mvmt_1_end = round(Cut(2,1));
            
            Plage_mvmt_2_start = round(Cut(2)); %%%% AVEC SAVE
            Plage_mvmt_2_end = round(Cut(3));
    
    %         Plage_mvmt_2_start = round(Cut(2,1));
    %         Plage_mvmt_2_end = round(Cut(3,1));
    
            mid1 = round(Cut(4)) - Plage_mvmt_1_start; %%%% AVEC SAVE
            mid2 = round(Cut(5)) - Plage_mvmt_2_start;
            
    %         mid1 = round(Cut(4,1)) - Plage_mvmt_1_start;
    %         mid2 = round(Cut(5,1)) - Plage_mvmt_2_start;
    
            [Pos_mvmt_1] = posfiltre(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
            [Pos_mvmt_2] = posfiltre(Plage_mvmt_2_start:Plage_mvmt_2_end, :);  
    
            [Pos_mvmt_1COM] = posfiltreCOM(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
            [Pos_mvmt_2COM] = posfiltreCOM(Plage_mvmt_2_start:Plage_mvmt_2_end, :);  
            
    %% On calcule les paramètres cinématiques des 2 mouvements
            
            % Premier Mouvement
            [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_pas_cut_1, moy_deb_1, moy_fin_1, std_deb_1, std_fin_1, profil_vitesse_1, profil_vitesse_1_norm, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, Vmoy_1, Param_C_1, debut_1, fin_1, debut_V2_1, fin_V2_1] = compute_kinematics_WHOLE_BODY_STS_BTS_TL_RDPV(Pos_mvmt_1, Pos_mvmt_1COM,mid1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin, param_moyenne,pourcen_amp);
            % Second Mouvement
            [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_pas_cut_2, moy_deb_2, moy_fin_2, std_deb_2, std_fin_2, profil_vitesse_2, profil_vitesse_2_norm, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, Vmoy_2, Param_C_2, debut_2, fin_2, debut_V2_2, fin_V2_2] = compute_kinematics_WHOLE_BODY_STS_BTS_TL_RDPV(Pos_mvmt_2,Pos_mvmt_2COM,mid2,  Frequence_acquisition, 2, Cut_off, Ech_norm_kin, param_moyenne,pourcen_amp);
            
    %% On remplit les matrices de résulats des paramètres cinématiques des mvts très lents
           
            k = 3*i;
            z = k-2;
            
    %%%%% DATA SEQ
            Donnees_cinematiques_TL(SUJETS).Clics_acq(:,i)=Cut(:,1);
            Donnees_cinematiques_TL(SUJETS).Position_cut_brut(1:lig_pos_1, z:k) = profil_position_1;
            Donnees_cinematiques_TL(SUJETS).Position_cut_brut(1:lig_pos_2, z+3*lig_nb_acq:k+3*lig_nb_acq) = profil_position_2;
            Donnees_cinematiques_TL(SUJETS).Position_cut_norm(:, z:k) = profil_position_1_norm;
            Donnees_cinematiques_TL(SUJETS).Position_cut_norm(:, z+3*lig_nb_acq:k+3*lig_nb_acq) = profil_position_2_norm;
            Donnees_cinematiques_TL(SUJETS).Vel_brut(1:length(profil_vitesse_pas_cut_1), i) = profil_vitesse_pas_cut_1;
            Donnees_cinematiques_TL(SUJETS).Vel_brut(1:length(profil_vitesse_pas_cut_2), i+lig_nb_acq) = profil_vitesse_pas_cut_2;
            Donnees_cinematiques_TL(SUJETS).Vel_cut_brut(1:lig_pv1, i) = profil_vitesse_1;
            Donnees_cinematiques_TL(SUJETS).Vel_cut_brut(1:lig_pv2, i+lig_nb_acq) = profil_vitesse_2;           
            Donnees_cinematiques_TL(SUJETS).Vel_cut_norm(:, i) = profil_vitesse_1_norm;
            Donnees_cinematiques_TL(SUJETS).Vel_cut_norm(:, i+lig_nb_acq) = profil_vitesse_2_norm;
    %         Donnees_cinematiques_TL.Acc(1:lig_pv1, i) = profil_accel_1;
    %         Donnees_cinematiques_TL.Acc(1:lig_pv2, i+lig_nb_acq) = profil_accel_2;            
                
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i, 2) = MD_1;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 2) = MD_2;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i, 3) = rD_PA_1;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 3) = rD_PA_2;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i, 4) = rD_PV_1;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 4) = rD_PV_2;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i, 5) = rD_PD_1;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 5) = rD_PD_2;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i, 6) = PA_max_1;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 6) = PA_max_2;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i, 7) = PD_max_1;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 7) = PD_max_2;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i, 8) = pv1_max;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 8) = pv2_max;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i, 8) = Vmoy_1;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 8) = Vmoy_2;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i, 8) = Param_C_1;
            Donnees_cinematiques_TL(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 8) = Param_C_2;
    
            Donnees_cinematiques_TL(SUJETS).debut_fin(i, 1) = Plage_mvmt_1_start+debut_1;
            Donnees_cinematiques_TL(SUJETS).debut_fin(i, 2) = Plage_mvmt_1_start+fin_1;
            Donnees_cinematiques_TL(SUJETS).debut_fin(i, 3) = Plage_mvmt_2_start+debut_2;
            Donnees_cinematiques_TL(SUJETS).debut_fin(i, 4) = Plage_mvmt_2_start+fin_2;
    
            Donnees_cinematiques_TL(SUJETS).debut_fin2(i, 1) = Plage_mvmt_1_start+debut_V2_1;
            Donnees_cinematiques_TL(SUJETS).debut_fin2(i, 2) = Plage_mvmt_1_start+fin_V2_1;
            Donnees_cinematiques_TL(SUJETS).debut_fin2(i, 3) = Plage_mvmt_2_start+debut_V2_2;
            Donnees_cinematiques_TL(SUJETS).debut_fin2(i, 4) = Plage_mvmt_2_start+fin_V2_2;
    
            Donnees_cinematiques_TL(SUJETS).clics(i, 1) = Plage_mvmt_1_start;
            Donnees_cinematiques_TL(SUJETS).clics(i, 2) = Plage_mvmt_1_end;
            Donnees_cinematiques_TL(SUJETS).clics(i, 3) = Plage_mvmt_2_end;
            Donnees_cinematiques_TL(SUJETS).clics(i, 4) = mid1;
            Donnees_cinematiques_TL(SUJETS).clics(i, 5) = mid2;
                
            gap = Plage_mvmt_1_start;
            Titre = append('Vérification découpage mvts lents de ',string(DonneesSAVED.NOM(1,:)));
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
       
    
    %     delete(findall(0));
       
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% PARTIE SUR LES MVTS RAPIDES %% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Savec_J = j;
    j = Savec_J;
    
    
        %% On crée les matrices de résultats

    
        %% On procède au balayage fichier par fichier
        disp('POST TRAITEMENT MOUVEMENTS RAPIDES')
        [~, lig_nb_acq] = size(DonneesSAVED.EMG);
         for i = 1: lig_nb_acq
             
            disp(append('i rap = ',string(i)));
    
            %% on recupère les données EMG brutes pour le prochain code
           
           % on recupère les données EMG brutes pour le prochain code
           
           Donnees(SUJETS).EMG(i).data = DonneesSAVED.EMG(i).C3D.EMG.Donnees;
           Donnees(SUJETS).EMG(i).Muscles = DonneesSAVED.EMG(i).C3D.EMG.Labels;
           Donnees(SUJETS).EMG(i).C3D = DonneesSAVED.EMG(i).C3D;
           
           
            %% On crée une matrice de la position de l'épaule
            posxyz =DonneesSAVED.EMG(i).C3D.Cinematique.Donnees(:, j-2:j);
            [posxyz_lig, ~] = size(posxyz);
            
            %On filtre le signal de position
    %         posxyz = C3D.Cinematique.Angles.LKnee(:,:)';
            posxyzCOM = DonneesSAVED.EMG(i).C3D.Cinematique.Donnees(:, j-2:j);% C3D.Cinematique.CenterOfMass(:,:)';
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
            Cut = DonneesSAVED.cinematiques.Clics_acq(:,i);
    %         
            Plage_mvmt_1_start = round(Cut(1)); %%%% AVEC SAVE
            Plage_mvmt_1_end = round(Cut(2));
    
    %         Plage_mvmt_1_start = round(Cut(1,1));
    %         Plage_mvmt_1_end = round(Cut(2,1));
            
            Plage_mvmt_2_start = round(Cut(2)); %%%% AVEC SAVE
            Plage_mvmt_2_end = round(Cut(3));
    
    %         Plage_mvmt_2_start = round(Cut(2,1));
    %         Plage_mvmt_2_end = round(Cut(3,1));
    
            mid1 = round(Cut(4)) - Plage_mvmt_1_start; %%%% AVEC SAVE
            mid2 = round(Cut(5))- Plage_mvmt_2_start;
            
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
                Donnees_cinematiques(SUJETS).Clics_acq(:,i)=Cut(:,1);
                Donnees_cinematiques(SUJETS).Position_cut_brut(1:lig_pos_1, z:k) = profil_position_1;
                Donnees_cinematiques(SUJETS).Position_cut_brut(1:lig_pos_2, z+3*lig_nb_acq:k+3*lig_nb_acq) = profil_position_2;
                Donnees_cinematiques(SUJETS).Position_cut_norm(:, z:k) = profil_position_1_norm;
                Donnees_cinematiques(SUJETS).Position_cut_norm(:, z+3*lig_nb_acq:k+3*lig_nb_acq) = profil_position_2_norm;
                Donnees_cinematiques(SUJETS).Vel_cut_brut(1:lig_pv1, i) = profil_vitesse_1;
                Donnees_cinematiques(SUJETS).Vel_cut_brut(1:lig_pv2, i+lig_nb_acq) = profil_vitesse_2;           
                Donnees_cinematiques(SUJETS).Vel_cut_norm(:, i) = profil_vitesse_1_norm;
                Donnees_cinematiques(SUJETS).Vel_cut_norm(:, i+lig_nb_acq) = profil_vitesse_2_norm;
    %             Donnees_cinematiques(SUJETS).Acc(1:lig_pv1, i) = profil_accel_1;
    %             Donnees_cinematiques(SUJETS).Acc(1:lig_pv2, i+lig_nb_acq) = profil_accel_2;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i, 2) = MD_1;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 2) = MD_2;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i, 3) = rD_PA_1;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 3) = rD_PA_2;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i, 4) = rD_PV_1;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 4) = rD_PV_2;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i, 5) = rD_PD_1;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 5) = rD_PD_2;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i, 6) = PA_max_1;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 6) = PA_max_2;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i, 7) = PD_max_1;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 7) = PD_max_2;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i, 8) = pv1_max;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 8) = pv2_max;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i, 9) = Vmoy_1;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 9) = Vmoy_2;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i, 10) = Param_C_1;
                Donnees_cinematiques(SUJETS).Results_trial_by_trial(i+lig_nb_acq, 10) = Param_C_2;
                
                Donnees_cinematiques(SUJETS).debut_fin(i, 1) = Plage_mvmt_1_start+debut_1;
                Donnees_cinematiques(SUJETS).debut_fin(i, 2) = Plage_mvmt_1_start+fin_1;
                Donnees_cinematiques(SUJETS).debut_fin(i, 3) = Plage_mvmt_2_start+debut_2;
                Donnees_cinematiques(SUJETS).debut_fin(i, 4) = Plage_mvmt_2_start+fin_2;
    
                Donnees_cinematiques(SUJETS).debut_fin2(i, 1) = Plage_mvmt_1_start+debut_V2_1;
                Donnees_cinematiques(SUJETS).debut_fin2(i, 2) = Plage_mvmt_1_start+fin_V2_1;
                Donnees_cinematiques(SUJETS).debut_fin2(i, 3) = Plage_mvmt_2_start+debut_V2_2;
                Donnees_cinematiques(SUJETS).debut_fin2(i, 4) = Plage_mvmt_2_start+fin_V2_2;
    
                Donnees_cinematiques(SUJETS).clics(i, 1) = Plage_mvmt_1_start;
                Donnees_cinematiques(SUJETS).clics(i, 2) = Plage_mvmt_1_end;
                Donnees_cinematiques(SUJETS).clics(i, 3) = Plage_mvmt_2_end;
                Donnees_cinematiques(SUJETS).clics(i, 4) = mid1;
                Donnees_cinematiques(SUJETS).clics(i, 5) = mid2;
                
    %             
    %         gap = Plage_mvmt_1_start;
    %         Titre = append('Vérification découpage mvts lents de ',string(C3D.NomSujet(1,:)));
    %         figure('Name',Titre,'NumberTitle','off');
    % % 
    % %         f = figure('units','normalized','outerposition',[0 0 1 1]);
    %             t = tiledlayout(2,1,'TileSpacing','Compact');
    %     
    %         nexttile 
    %         plot(vec_position);hold on;
    %         y = ylim; % current y-axis limits
    %         x = xlim; % current y-axis limits
    % %         debut_1 = debut_V2_1;
    % %         fin_1 = fin_V2_1;
    % %         debut_2 = debut_V2_2;
    % %         fin_2 = fin_V2_2;
    % 
    %         plot([gap+debut_1 gap+debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
    %         plot([gap+fin_1 gap+fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
    %         plot([gap+x(1) gap+x(1)+param_moyenne],[moy_deb_1(:,1) moy_deb_1(:,1)],'r');hold on; %moyenne debut
    % 
    %         plot([Plage_mvmt_1_end-param_moyenne/2 Plage_mvmt_1_end+param_moyenne/2],[moy_fin_1(:,1) moy_fin_1(:,1)],'b');hold on; % moyenne milieu
    %         plot([Plage_mvmt_1_end Plage_mvmt_1_end],[y(1) y(2)],'b');hold on; % ginput au milieu
    % 
    %         plot([Plage_mvmt_2_start+debut_2 Plage_mvmt_2_start+debut_2],[y(1) y(2)],'g');hold on; %debut mvt 2
    %         plot([Plage_mvmt_2_start+fin_2 Plage_mvmt_2_start+fin_2],[y(1) y(2)],'g'); % fin  mvt 2
    %         plot([Plage_mvmt_2_end-param_moyenne/2 Plage_mvmt_2_end+param_moyenne/2],[moy_fin_2(:,1) moy_fin_2(:,1)],'g');hold on; %moyenne fin
    %         title('Position en Z marqueur épaule ')
    %         %disp(Plage_mvmt_2_start);
    % 
    %         nexttile
    %         plot(vec_positionCOM);hold on;
    %         y = ylim; % current y-axis limits
    %         x = xlim; % current y-axis limits
    % 
    %         plot([gap+debut_V2_1 gap+debut_V2_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
    %         plot([gap+fin_V2_1 gap+fin_V2_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
    % 
    %         plot([Plage_mvmt_2_start+debut_V2_2 Plage_mvmt_2_start+debut_V2_2],[y(1) y(2)],'g');hold on; %debut mvt 2
    %         plot([Plage_mvmt_2_start+fin_V2_2 Plage_mvmt_2_start+fin_V2_2],[y(1) y(2)],'g'); % fin  mvt 2
    % 
    %         w = waitforbuttonpress;
    %         axes;
    
    
            
         end     
            
    % delete(findall(0));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Export des données
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     Donnees.cinematiques_TL = Donnees_cinematiques_TL(SUJETS);
%     Donnees.cinematiques = Donnees_cinematiques(SUJETS);
%     Donnees.NOM = DonneesSAVED.NOM(1,:);
%     
%     name = append('KINE_',DonneesSAVED.NOM(1,:),'');
%     disp('Selectionnez le Dossier où enregistre les données.');
%     [Dossier2] = 'C:\Users\RobinM\Desktop\Manip 1 DATA post-treated\Age vs young\V2\R2\9_ New Y'; %uigetdir ('Selectionnez le Dossier où enregistre les données.');
%     save([Dossier2 '/' name ], 'Donnees');
%     disp('Données enregistrées avec succès !');

end



