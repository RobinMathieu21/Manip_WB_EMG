
%% Script -----kinematics----- pour manip mvts whole body
% A executer pour post-traiter les donn�es obtenues lors des manips whole
% body. Ce script est � utiliser pour les donn�es STS/BTS et WB reaching.

close all
clear all

%% Informations sur le traitement des donn�es
% Donn�es pour le traitement cin�matique
Low_pass_Freq = 5; % Fr�quence passe-bas la position pour la cin�matique
Cut_off = 0.1; % Pourcentage du pic de vitesse pour d�terminer d�but et fin du mouvement POUR MVTS RAPIDES
Ech_norm_kin = 1000; % Fr�quence d'�chantillonage du profil de vitesse normalis� en dur�e 
Frequence_acquisition = 200; % Fr�quence d'acquisition du signal cin�matique
param_moyenne = 100; % Nb images pour moyenner la position pendant phases stables
param_moyenne2 = 200/5; % Nb images pour moyenner la position pendant phases stables
nb_images_to_add=param_moyenne/2;
pourcen_amp = 0.05;

%% Importation des donn�es
[Dossier] = uigetdir ('Selectionnez le Dossier o� ex�cuter le Script');
    
Extension = '*.mat'; %Traite tous les .mat
Chemin = fullfile(Dossier, Extension); % On construit le chemin
ListeFichier = dir(Chemin); % On construit la liste des fichiers

for SUJETS = 1: numel(ListeFichier)
        Fichier_traite = [Dossier '\' ListeFichier(SUJETS).name]; %On charge le fichier .mat
        load (Fichier_traite);
        DonneesSAVED = Donnees;
    %% On cr�e les matrices de r�sultats
        SUJETS
        Donnees_cinematiques_TL = {};
        Premiere_fois = true; % Pour n'effecteur certaines actions de lecture des labels qu'une seule fois
        disp('POST TRAITEMENT MOUVEMENTS LENTS')
        [Col, lig_nb_acq] = size(DonneesSAVED.EMG_lent);
        for i = 1: lig_nb_acq
     
           disp(append('i = ',string(i)));
           
           Donnees.EMG_lent(i).data = DonneesSAVED.EMG_lent(i).C3DLENT.EMG.Donnees;
           Donnees.EMG_lent(i).Muscles = DonneesSAVED.EMG_lent(i).C3DLENT.EMG.Labels;
           Donnees.EMG_lent(i).C3DLENT = DonneesSAVED.EMG_lent(i).C3DLENT;
       
        if Premiere_fois %% Boucle pour trouver les coordonn�es du marqueur de l'�paule gauche
            j=0; marqueur = 'a';
            while ~strcmp(marqueur,'RFIN')
                j=j+1;
                marqueur = DonneesSAVED.EMG_lent(i).C3DLENT.Cinematique.Labels(j);  
            end
            disp(append('Le marqueur RFIN est le num�ro ',string(j)));
            j = j*4-1;
        
        end
       
        %On cr�e une matrice de la position du doigt
        posxyz = DonneesSAVED.EMG_lent(i).C3DLENT.Cinematique.Donnees(:, j-2:j);
        [posxyz_lig, ~] = size(posxyz);
        
        %On filtre le signal de position
        posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');

        vec_position = sqrt(posfiltre(:, 3).^2);

        Cut = DonneesSAVED.cinematiques_TL.clics;
        
        Plage_mvmt_1_start = round(Cut(i,1)); %%%% AVEC SAVE
        Plage_mvmt_1_end = round(Cut(i,2));


        Plage_mvmt_2_start = round(Cut(i,2)); %%%% AVEC SAVE
        Plage_mvmt_2_end = round(Cut(i,3));

        mid1 = round(Cut(i,4));% - Plage_mvmt_1_start; %%%% AVEC SAVE
        mid2 = round(Cut(i,5));% - Plage_mvmt_2_start;

        [Pos_mvmt_1] = posfiltre(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
        [Pos_mvmt_2] = posfiltre(Plage_mvmt_2_start:Plage_mvmt_2_end, :);  
        
%% On calcule les param�tres cin�matiques des 2 mouvements
        
        % Premier Mouvement
        [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_pas_cut_1, moy_deb_1, moy_fin_1, std_deb_1, std_fin_1, profil_vitesse_1, profil_vitesse_1_norm, profil_vitesse_1_normV2, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, MD_1_V2, rD_PA_1_V2, rD_PV_1_V2, rD_PD_1_V2, debut_1, fin_1, debut_V2_1, fin_V2_1, nb_pics1] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_1,mid1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin, param_moyenne,pourcen_amp);
        % Second Mouvement
        [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_pas_cut_2, moy_deb_2, moy_fin_2, std_deb_2, std_fin_2, profil_vitesse_2, profil_vitesse_2_norm, profil_vitesse_2_normV2, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, MD_2_V2, rD_PA_2_V2, rD_PV_2_V2, rD_PD_2_V2, debut_2, fin_2, debut_V2_2, fin_V2_2, nb_pics2] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_2,mid2,  Frequence_acquisition, 2, Cut_off, Ech_norm_kin, param_moyenne,pourcen_amp);
        
%% On remplit les matrices de r�sulats des param�tres cin�matiques des mvts tr�s lents
       
        k = 3*i;
        z = k-2;
        
%%%%% DATA SEQ
        Donnees_cinematiques_TL.Clics_acq(:,i)=Cut(:,1);
        Donnees_cinematiques_TL.Position_cut_brut(1:lig_pos_1, z:k) = profil_position_1;
        Donnees_cinematiques_TL.Position_cut_brut(1:lig_pos_2, z+3*lig_nb_acq:k+3*lig_nb_acq) = profil_position_2;
        Donnees_cinematiques_TL.Position_cut_norm(:, z:k) = profil_position_1_norm;
        Donnees_cinematiques_TL.Position_cut_norm(:, z+3*lig_nb_acq:k+3*lig_nb_acq) = profil_position_2_norm;
        Donnees_cinematiques_TL.Vel_brut(1:length(profil_vitesse_pas_cut_1), i) = profil_vitesse_pas_cut_1;
        Donnees_cinematiques_TL.Vel_brut(1:length(profil_vitesse_pas_cut_2), i+lig_nb_acq) = profil_vitesse_pas_cut_2;
        Donnees_cinematiques_TL.Vel_cut_brut(1:lig_pv1, i) = profil_vitesse_1;
        Donnees_cinematiques_TL.Vel_cut_brut(1:lig_pv2, i+lig_nb_acq) = profil_vitesse_2;           
        Donnees_cinematiques_TL.Vel_cut_norm(:, i) = profil_vitesse_1_norm;
        Donnees_cinematiques_TL.Vel_cut_norm(:, i+lig_nb_acq) = profil_vitesse_2_norm;         
            
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 2) = MD_1;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+lig_nb_acq, 2) = MD_2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 3) = rD_PA_1;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+lig_nb_acq, 3) = rD_PA_2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 4) = rD_PV_1;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+lig_nb_acq, 4) = rD_PV_2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 5) = rD_PD_1;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+lig_nb_acq, 5) = rD_PD_2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 6) = PA_max_1;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+lig_nb_acq, 6) = PA_max_2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 7) = PD_max_1;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+lig_nb_acq, 7) = PD_max_2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 8) = pv1_max;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+lig_nb_acq, 8) = pv2_max;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 9) = MD_1_V2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+lig_nb_acq, 9) = MD_1_V2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 10) = rD_PA_1_V2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+lig_nb_acq, 10) = rD_PA_2_V2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i, 11) = rD_PV_1_V2;
        Donnees_cinematiques_TL.Results_trial_by_trial(i+lig_nb_acq, 11) = rD_PV_2_V2;

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

            
%         gap = Plage_mvmt_1_start;
%         Titre = append('V�rification d�coupage mvts lents de ',string(DonneesSAVED.NOM(1,:)));
%         figure('Name',Titre,'NumberTitle','off');
% 
%         %         f = figure('units','normalized','outerposition',[0 0 1 1]);
%         t = tiledlayout(2,1,'TileSpacing','Compact');
%     
% %         nexttile 
%         plot(vec_position);hold on;
%         y = ylim; % current y-axis limits
%         x = xlim; % current y-axis limits
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
%         title('Position en Z marqueur �paule ')
        %disp(Plage_mvmt_2_start);

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
%         w = waitforbuttonpress;
%         axes;



     end

%% Donn�es moyennes se lever
   

%     delete(findall(0));
   



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% PARTIE SUR LES MVTS RAPIDES %% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Savec_J = j;
    j = Savec_J;
    
    
        %% On cr�e les matrices de r�sultats

    
        %% On proc�de au balayage fichier par fichier
        disp('POST TRAITEMENT MOUVEMENTS RAPIDES')
        [~, lig_nb_acq] = size(DonneesSAVED.EMG);
         for i = 1: lig_nb_acq
             
            disp(append('i rap = ',string(i)));
    
            %% on recup�re les donn�es EMG brutes pour le prochain code
           
           % on recup�re les donn�es EMG brutes pour le prochain code
           
           Donnees.EMG(i).data = DonneesSAVED.EMG(i).C3D.EMG.Donnees;
           Donnees.EMG(i).Muscles = DonneesSAVED.EMG(i).C3D.EMG.Labels;
           Donnees.EMG(i).C3D = DonneesSAVED.EMG(i).C3D;
       
        %% On cr�e une matrice de la position de l'�paule
        posxyz =DonneesSAVED.EMG(i).C3D.Cinematique.Donnees(:, j-2:j);
            [posxyz_lig, ~] = size(posxyz);
        
        %On filtre le signal de position

        posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
        vec_position = sqrt(posfiltre(:, 3).^2);%+posfiltre(:, 2).^2+posfiltre(:, 3).^2);


        Cut = DonneesSAVED.cinematiques.clics;
        
        Plage_mvmt_1_start = round(Cut(i,1)); %%%% AVEC SAVE
        Plage_mvmt_1_end = round(Cut(i,2));
        
        Plage_mvmt_2_start = round(Cut(i,2)); %%%% AVEC SAVE
        Plage_mvmt_2_end = round(Cut(i,3));

        mid1 = round(Cut(i,4));% - Plage_mvmt_1_start; %%%% AVEC SAVE
        mid2 = round(Cut(i,5));% - Plage_mvmt_2_start;

        
        [Pos_mvmt_1] = posfiltre(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
        [Pos_mvmt_2] = posfiltre(Plage_mvmt_2_start:Plage_mvmt_2_end, :);  

        
        %% On calcule les param�tres cin�matiques des 2 mouvements
        
        % Premier Mouvement
        [lig_pos_1, profil_position_1, profil_position_1_norm, lig_pv1, profil_vitesse_pas_cut_1, moy_deb_1, moy_fin_1, std_deb_1, std_fin_1, profil_vitesse_1, profil_vitesse_1_norm,profil_vitesse_1_normV2, MD_1, rD_PA_1, rD_PV_1, rD_PD_1, PA_max_1, pv1_max, PD_max_1, MD_1_V2, rD_PA_1_V2, rD_PV_1_V2, rD_PD_1_V2, debut_1, fin_1, debut_V2_1, fin_V2_1, nb_pics1] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_1,mid1, Frequence_acquisition, 1, Cut_off, Ech_norm_kin, param_moyenne,pourcen_amp);
        % Second Mouvement
        [lig_pos_2, profil_position_2, profil_position_2_norm, lig_pv2, profil_vitesse_pas_cut_2, moy_deb_2, moy_fin_2, std_deb_2, std_fin_2, profil_vitesse_2, profil_vitesse_2_norm,profil_vitesse_2_normV2, MD_2, rD_PA_2, rD_PV_2, rD_PD_2, PA_max_2, pv2_max, PD_max_2, MD_2_V2, rD_PA_2_V2, rD_PV_2_V2, rD_PD_2_V2, debut_2, fin_2, debut_V2_2, fin_V2_2, nb_pics2] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(Pos_mvmt_2,mid2,  Frequence_acquisition, 2, Cut_off, Ech_norm_kin, param_moyenne,pourcen_amp);
        
        %% On remplit les matrices de r�sulats des param�tres cin�matiques des mvts
       
          nb_pics1
          nb_pics2
        
%%%%% DATA SEQ   
    if nb_pics1<2
        k = 3*i;
        z = k-2;

        Donnees_cinematiques.Clics_acq(:,i)=Cut(:,1);
        Donnees_cinematiques.Position_cut_brut(1:lig_pos_1, z:k) = profil_position_1;
        Donnees_cinematiques.Position_cut_norm(:, z:k) = profil_position_1_norm;
        Donnees_cinematiques.Vel_cut_brut(1:lig_pv1, i) = profil_vitesse_1;
        Donnees_cinematiques.Vel_cut_norm(:, i) = profil_vitesse_1_norm;
        Donnees_cinematiques.Vel_cut_normV2(:, i) = profil_vitesse_1_normV2;
        
        Donnees_cinematiques.Results_trial_by_trial(i, 2) = MD_1;
        Donnees_cinematiques.Results_trial_by_trial(i, 3) = rD_PA_1;
        Donnees_cinematiques.Results_trial_by_trial(i, 4) = rD_PV_1;
        Donnees_cinematiques.Results_trial_by_trial(i, 5) = rD_PD_1;
        Donnees_cinematiques.Results_trial_by_trial(i, 6) = PA_max_1;
        Donnees_cinematiques.Results_trial_by_trial(i, 7) = PD_max_1;
        Donnees_cinematiques.Results_trial_by_trial(i, 8) = pv1_max;
        Donnees_cinematiques.Results_trial_by_trial(i, 9) = MD_1_V2;
        Donnees_cinematiques.Results_trial_by_trial(i, 10) = rD_PA_1_V2;
        Donnees_cinematiques.Results_trial_by_trial(i, 11) = rD_PV_1_V2;
    else
        Donnees_cinematiques.Clics_acq(:,i)=Cut(:,1);
        Donnees_cinematiques.Position_cut_brut(1:lig_pos_1, z:k) = 0;
        Donnees_cinematiques.Position_cut_norm(:, z:k) = 0;
        Donnees_cinematiques.Vel_cut_brut(1:lig_pv1, i) = 0;
        Donnees_cinematiques.Vel_cut_norm(:, i) = 0;
        Donnees_cinematiques.Vel_cut_normV2(:, i) = 0;
        
        Donnees_cinematiques.Results_trial_by_trial(i, 2) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i, 3) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i, 4) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i, 5) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i, 6) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i, 7) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i, 8) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i, 9) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i, 10) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i, 11) = 0;
    end

    if nb_pics2<2
        Donnees_cinematiques.Position_cut_brut(1:lig_pos_2, z+3*lig_nb_acq:k+3*lig_nb_acq) = profil_position_2;
        Donnees_cinematiques.Position_cut_norm(:, z+3*lig_nb_acq:k+3*lig_nb_acq) = profil_position_2_norm;
        Donnees_cinematiques.Vel_cut_brut(1:lig_pv2, i+lig_nb_acq) = profil_vitesse_2;  
        Donnees_cinematiques.Vel_cut_norm(:, i+lig_nb_acq) = profil_vitesse_2_norm;
        Donnees_cinematiques.Vel_cut_normV2(:, i+lig_nb_acq) = profil_vitesse_2_normV2;    

        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 2) = MD_2;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 3) = rD_PA_2;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 4) = rD_PV_2;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 5) = rD_PD_2;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 6) = PA_max_2;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 7) = PD_max_2;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 8) = pv2_max;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 9) = MD_1_V2;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 10) = rD_PA_2_V2;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 11) = rD_PV_2_V2;
    else
        Donnees_cinematiques.Position_cut_brut(1:lig_pos_2, z+3*lig_nb_acq:k+3*lig_nb_acq) = 0;
        Donnees_cinematiques.Position_cut_norm(:, z+3*lig_nb_acq:k+3*lig_nb_acq) = 0;
        Donnees_cinematiques.Vel_cut_brut(1:lig_pv2, i+lig_nb_acq) = 0;  
        Donnees_cinematiques.Vel_cut_norm(:, i+lig_nb_acq) = 0;
        Donnees_cinematiques.Vel_cut_normV2(:, i+lig_nb_acq) = 0;  

        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 2) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 3) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 4) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 5) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 6) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 7) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 8) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 9) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 10) = 0;
        Donnees_cinematiques.Results_trial_by_trial(i+lig_nb_acq, 11) = 0;
    end      
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
            
            
%         gap = Plage_mvmt_1_start;
%         Titre = append('V�rification d�coupage mvts lents de ',string(DonneesSAVED.NOM(1,:)));
%         figure('Name',Titre,'NumberTitle','off');
% % 
% %         f = figure('units','normalized','outerposition',[0 0 1 1]);
%             t = tiledlayout(2,1,'TileSpacing','Compact');
%     
% %         nexttile 
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
%         title('Position en Z marqueur �paule ')
%         %disp(Plage_mvmt_2_start);
% 
% %         nexttile
% %         plot(vec_positionCOM);hold on;
% %         y = ylim; % current y-axis limits
% %         x = xlim; % current y-axis limits
% % 
% %         plot([gap+debut_V2_1 gap+debut_V2_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
% %         plot([gap+fin_V2_1 gap+fin_V2_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
% % 
% %         plot([Plage_mvmt_2_start+debut_V2_2 Plage_mvmt_2_start+debut_V2_2],[y(1) y(2)],'g');hold on; %debut mvt 2
% %         plot([Plage_mvmt_2_start+fin_V2_2 Plage_mvmt_2_start+fin_V2_2],[y(1) y(2)],'g'); % fin  mvt 2
% 
% %         w = waitforbuttonpress;
%         axes;


        
     end     
        
% delete(findall(0));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Export des donn�es
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Donnees.cinematiques_TL = Donnees_cinematiques_TL;
Donnees.cinematiques = Donnees_cinematiques;
Donnees.NOM = DonneesSAVED.NOM(1,:);

name = append('KINE_',DonneesSAVED.NOM(1,:),'');
disp('Enregistrement .......');
[Dossier2] = 'C:\Users\RobinM\Desktop\Manip 1 DATA post-treated\Age vs young\V2\brasD\young_new'; %uigetdir ('Selectionnez le Dossier o� enregistre les donn�es.');
save([Dossier2 '/' name ], 'Donnees');
disp('Donn�es enregistr�es avec succ�s !');

end


