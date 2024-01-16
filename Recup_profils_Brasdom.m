%% Importation des données
Frequence_acquisition = 100;
Cutoff = 0.1;
Profils_moyens_V_haut = ones(100, 21*30);
Profils_moyens_V_bas = ones(100, 21*30);
    Profils_moyens_P_haut = ones(100, 21*30);
    Profils_moyens_P_bas = ones(100, 21*30);
    Coude = zeros(numel(ListeFichier)*100, 2)
    Poignet = zeros(numel(ListeFichier)*100, 2)
    
for k = 1:21
k
%On selectionne le repertoire
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');
   
    
    Extension = '*.mat'; %Traite tous les .mat
    
    %On construit le chemin
    Chemin = fullfile(Dossier, Extension);
    
    %On construit la liste des fichiers
    ListeFichier = dir(Chemin);
    
    % On construit la matrice de résultats
    
    
 %% On procède au balayage fichier par fichier
     for i = 1: numel(ListeFichier)
        i
       Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
        
       load (Fichier_traite);
       %On crée une matrice de la position du doigt et de l'épaule
        posxyz = C3D.Cinematique.Donnees(:, 17:19);
        pos_epaule = C3D.Cinematique.Donnees(:, 1:3);
        pos_coude = C3D.Cinematique.Donnees(:, 5:7);
        pos_poignet = C3D.Cinematique.Donnees(:, 13:15);
        [posxyz_lig, ~] = size(posxyz);
        
        %On filtre le signal de position
        posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
        posfiltre_epaule = butter_emgs(pos_epaule, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
        posfiltre_coude = butter_emgs(pos_coude, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
        posfiltre_poignet = butter_emgs(pos_poignet, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
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
        
         [Pos_coude_mvmt_1] = posfiltre_coude(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
         [Pos_coude_mvmt_2] = posfiltre_coude(Plage_mvmt_2_start:Plage_mvmt_2_end, :);
        
         [Pos_poignet_mvmt_1] = posfiltre_poignet(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
         [Pos_poignet_mvmt_2] = posfiltre_poignet(Plage_mvmt_2_start:Plage_mvmt_2_end, :);
         
         % On applique la fonction qui permet de récupérer les paramètres
         
     [profil_pos_1, profil_vit_1, rot_coude_1, rot_poignet_1] = recup_profils_rots(Pos_mvmt_1, Pos_epaule_mvmt_1, ...
     Pos_coude_mvmt_1, Pos_poignet_mvmt_1, Frequence_acquisition, Cutoff);

     [profil_pos_2, profil_vit_2, rot_coude_2, rot_poignet_2] = recup_profils_rots(Pos_mvmt_2, Pos_epaule_mvmt_2, ...
     Pos_coude_mvmt_2, Pos_poignet_mvmt_2, Frequence_acquisition, Cutoff);
 
 % On range les résultats dans les matrices
 
        if data_sequence(i) == 1
 
 Profils_moyens_P_bas(:, (k-1)*30+i) = profil_pos_1;
 Profils_moyens_P_haut(:, (k-1)*30+i) = profil_pos_2;
 
 Profils_moyens_V_bas(:, (k-1)*30+i) = profil_vit_1;
 Profils_moyens_V_haut(:, (k-1)*30+i) = profil_vit_2;
 
 Coude(i, 1) = rot_coude_1;
 Coude(i, 2) = rot_coude_2;
 
  Poignet(i, 1) = rot_poignet_1;
 Poignet(i, 2) = rot_poignet_2;
 
 else
     
 Profils_moyens_P_bas(:, (k-1)*30+i) = profil_pos_2;
 Profils_moyens_P_haut(:, (k-1)*30+i) = profil_pos_1;
 
 Profils_moyens_V_bas(:, (k-1)*30+i) = profil_vit_2;
 Profils_moyens_V_haut(:, (k-1)*30+i) = profil_vit_1;
 
 Poignet(i, 1) = rot_poignet_1;
 Poignet(i, 2) = rot_poignet_2;
 
        end
 
     end
     
end
         