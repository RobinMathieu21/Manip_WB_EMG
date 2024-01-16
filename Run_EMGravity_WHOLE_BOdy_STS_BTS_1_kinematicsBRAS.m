
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

%On selectionne le repertoire
disp('Selectionnez le Dossier regroupant les essais lents');
%[Dossier] = uigetdir ('Selectionnez le Dossier o� ex�cuter le Script');
% Dossier = 'C:\Users\robin\Desktop\Drive google\6A - THESE\MANIP 1\MATLAB\CODES\2_Assis_debout\MVT lents'; % Pour PC portable
Dossier = 'G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\MATLAB\CODES\2_Assis_debout\MVT lents';
if (Dossier ~= 0) %Si on clique sur un dossier
    
    Extension = '*.mat'; %Traite tous les .mat
    Chemin = fullfile(Dossier, Extension); % On construit le chemin
    ListeFichier = dir(Chemin); % On construit la liste des fichiers

%% On cr�e les matrices de r�sultats

    Donnees = {};
    Donnees_cinematiques_TL = {};
    Premiere_fois = true; % Pour n'effecteur certaines actions de lecture des labels qu'une seule fois
    
%% On proc�de au balayage fichier par fichier
    disp('POST TRAITEMENT MOUVEMENTS RAPIDES')
    disp(append('Il y a ', string(numel(ListeFichier)),' fichiers � analyser.'));
    for i = 1: numel(ListeFichier)
 
       Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
       disp(append('i = ',string(i)));
       load (Fichier_traite);
       

       Donnees.EMG_lent(i).data = C3D.EMG.Donnees;
       Donnees.EMG_lent(i).Muscles = C3D.EMG.Labels;
       Donnees.EMG_lent(i).C3DLENT = C3D;
       
        if Premiere_fois %% Boucle pour trouver les coordonn�es du marqueur de l'�paule gauche
            j=0; marqueur = 'a';
            while ~strcmp(marqueur,'RFIN')
                j=j+1;
                marqueur = C3D.Cinematique.Labels(j);  
            end
            disp(append('Le marqueur RFIN est le num�ro ',string(j)));
            j = j*4-1;
        
        end
       
        %On cr�e une matrice de la position du doigt
        posxyz = C3D.Cinematique.Donnees(:, j-2:j);
        [posxyz_lig, ~] = size(posxyz);
        
        %On filtre le signal de position
        posfiltre = butter_emgs(posxyz, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');

        vec_position = sqrt(posfiltre(:, 3).^2);

        %On coupe le signal de vitesse pour avoir 2 plages contenant chacune un mouvement
        Titredec = append('D�coupage mvt lent num�ro ', string(i));
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

%% Donn�es moyennes se lever
   
 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PARTIE SUR LES MVTS RAPIDES %% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Savec_J = j;
j = Savec_J;
disp('Selectionnez le Dossier regroupant les essais � vitesse rapide');
%[Dossier] = uigetdir ('Selectionnez le Dossier o� ex�cuter le Script MVT Rapide');
% Dossier = 'C:\Users\robin\Desktop\Drive google\6A - THESE\MANIP 1\MATLAB\CODES\2_Assis_debout\MVT rapides';% Pour portable
Dossier = 'G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\MATLAB\CODES\2_Assis_debout\MVT rapides';

if (Dossier ~= 0) %Si on clique sur un dossier
    
    Extension = '*.mat'; %Traite tous les .mat
    
    %On construit le chemin
    Chemin = fullfile(Dossier, Extension);
    
    %On construit la liste des fichiers
    ListeFichier = dir(Chemin);

    %% On cr�e les matrices de r�sultats
    
    Donnees_EMG = {};
    Donnees_cinematiques = {};

    %% On proc�de au balayage fichier par fichier
    disp('POST TRAITEMENT MOUVEMENTS RAPIDES')
    disp(append('Il y a ', string(numel(ListeFichier)),' fichiers � analyser.'));
     for i = 1: numel(ListeFichier)
         
       disp(append('i = ',string(i)));
       Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
        
       load (Fichier_traite);

        %% on recup�re les donn�es EMG brutes pour le prochain code
       
       % on recup�re les donn�es EMG brutes pour le prochain code
       
       Donnees.EMG(i).data = C3D.EMG.Donnees;
       Donnees.EMG(i).Muscles = C3D.EMG.Labels;
       Donnees.EMG(i).C3D = C3D;
       
       
        %% On cr�e une matrice de la position de l'�paule
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
    %% Export des donn�es
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Donnees.cinematiques_TL = Donnees_cinematiques_TL;
Donnees.cinematiques = Donnees_cinematiques;
Donnees.NOM = C3D.NomSujet(1,:);

name = append('KINE_',C3D.NomSujet(1,:),'');
disp('Selectionnez le Dossier o� enregistre les donn�es.');
[Dossier] = uigetdir ('Selectionnez le Dossier o� enregistre les donn�es.');
save([Dossier '/' name ], 'Donnees');
disp('Donn�es enregistr�es avec succ�s !');

end


