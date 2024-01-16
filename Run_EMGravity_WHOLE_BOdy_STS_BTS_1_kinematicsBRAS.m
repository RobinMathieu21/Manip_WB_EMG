
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
            while ~strcmp(marqueur,'RFIN')
                j=j+1;
                marqueur = C3D.Cinematique.Labels(j);  
            end
            disp(append('Le marqueur RFIN est le numéro ',string(j)));
            j = j*4-1;
        
        end
       
        %On crée une matrice de la position du doigt
        posxyz = C3D.Cinematique.Donnees(:, j-2:j);
        [posxyz_lig, ~] = size(posxyz);
        
        %On filtre le signal de position
        posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');

        vec_position = sqrt(posfiltre(:, 3).^2);

        %On coupe le signal de vitesse pour avoir 2 plages contenant chacune un mouvement
        Titredec = append('Découpage mvt lent numéro ', string(i));
        figure('Name',Titredec,'NumberTitle','off');
        plot(vec_position)
        [Cut] = ginput(5);


        Plage_mvmt_1_start = round(Cut(1,1));
        Plage_mvmt_1_end = round(Cut(2,1));

        Plage_mvmt_2_start = round(Cut(2,1));
        Plage_mvmt_2_end = round(Cut(3,1));

        
        mid1 = round(Cut(4,1)) - Plage_mvmt_1_start;
        mid2 = round(Cut(5,1)) - Plage_mvmt_2_start;

        Donnees_cinematiques_TL.clics(i, 1) = Plage_mvmt_1_start;
        Donnees_cinematiques_TL.clics(i, 2) = Plage_mvmt_1_end;
        Donnees_cinematiques_TL.clics(i, 3) = Plage_mvmt_2_end;
        Donnees_cinematiques_TL.clics(i, 4) = mid1;
        Donnees_cinematiques_TL.clics(i, 5) = mid2;
       
     end

%% Données moyennes se lever
   
 
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

        posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
        vec_position = sqrt(posfiltre(:, 3).^2);%+posfiltre(:, 2).^2+posfiltre(:, 3).^2);

        %On coupe le signal de vitesse pour avoir 2 plages contenant chacune un mouvement
        Titre = append('Position en Z du marqueur ', string(marqueur));
        figure('Name',Titre,'NumberTitle','off');
        plot(vec_position); hold on;%posfiltre(:, 3) 
        [Cut] = ginput(5);

        Plage_mvmt_1_start = round(Cut(1,1));
        Plage_mvmt_1_end = round(Cut(2,1));

        Plage_mvmt_2_start = round(Cut(2,1));
        Plage_mvmt_2_end = round(Cut(3,1));
        
        mid1 = round(Cut(4,1)) - Plage_mvmt_1_start;
        mid2 = round(Cut(5,1)) - Plage_mvmt_2_start;
        

            Donnees_cinematiques.clics(i, 1) = Plage_mvmt_1_start;
            Donnees_cinematiques.clics(i, 2) = Plage_mvmt_1_end;
            Donnees_cinematiques.clics(i, 3) = Plage_mvmt_2_end;
            Donnees_cinematiques.clics(i, 4) = mid1;
            Donnees_cinematiques.clics(i, 5) = mid2;
            
        


        
     end     
        


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


