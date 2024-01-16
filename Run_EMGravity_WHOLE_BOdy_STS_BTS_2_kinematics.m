
%% Script -----Kinematics----- pour manip mvts whole body
% A executer pour post-traiter les données deja traité par le script 1



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%
% HYPOTHESE
% CASTERAN
% + RDPV mvts full body
%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%











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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   


%% Importation des données pour COM 

%On selectionne le repertoire

disp('Selectionnez le Dossier regroupant les essais rapides');
[Dossier] = uigetdir ('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\MATLAB\data_gabriel\DONNES KINEMATICS');

Extension = '*.mat'; %Traite tous les .mat
Chemin = fullfile(Dossier, Extension); % On construit le chemin
ListeFichier = dir(Chemin); % On construit la liste des fichiers
    
%% On procède au balayage fichier par fichier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% On récupère le COM pour chaque sujet et pour chaque mouvement
%% On calcule les vitesse AP et V
for YY = 1: numel(ListeFichier)
    Fichier_traite = [Dossier '\' ListeFichier(YY).name]; %On charge le fichier .mat
    disp(append('i = ',string(YY)));
    load (Fichier_traite);
    disp(Fichier_traite)
    for Nb_Acq = 1 : 12
        debut = Donnees.cinematiques.debut_fin(Nb_Acq,1)-200;
        fin = Donnees.cinematiques.debut_fin(Nb_Acq,2);
        debut2 = Donnees.cinematiques.debut_fin(Nb_Acq,3)-200;
        fin2 = Donnees.cinematiques.debut_fin(Nb_Acq,4);
    
        try
            % On stock la longueur des mouvements
            l_1 = length(Donnees.EMG(Nb_Acq).C3D.Cinematique.CenterOfMass(:,debut:fin)');
            l_2 = length(Donnees.EMG(Nb_Acq).C3D.Cinematique.CenterOfMass(:,debut2:fin2)');

            % On récupère le COM sur le mouvement
            DATA(YY).D1(Nb_Acq).COM_MVT1(1:l_1,1:3) = Donnees.EMG(Nb_Acq).C3D.Cinematique.CenterOfMass(:,debut:fin)';
            DATA(YY).D1(Nb_Acq).COM_MVT2(1:l_2,1:3) = Donnees.EMG(Nb_Acq).C3D.Cinematique.CenterOfMass(:,debut2:fin2)';
            com_mvt1 = Donnees.EMG(Nb_Acq).C3D.Cinematique.CenterOfMass(:,debut:fin)'; % pour plus facilement calculer la vitesse
            com_mvt2 = Donnees.EMG(Nb_Acq).C3D.Cinematique.CenterOfMass(:,debut2:fin2)';

            com_mvt1(com_mvt1 == 0) = NaN;
            com_mvt2(com_mvt2 == 0) = NaN;
    
            
            DATA(YY).D1(Nb_Acq).COM_MVT1_Filtered(:,1:3) = fillgaps(com_mvt1,25);
            DATA(YY).D1(Nb_Acq).COM_MVT2_Filtered(:,1:3) = fillgaps(com_mvt2,25);
            
            com_mvt1_Filtered = DATA(YY).D1(Nb_Acq).COM_MVT1_Filtered(:,1:3); 
            com_mvt2_Filtered = DATA(YY).D1(Nb_Acq).COM_MVT2_Filtered(:,1:3);
            
            % On calcule sa vitesse AP et V pour le mouvement 1
            DATA(YY).D1(Nb_Acq).Vit_MVT1_AP = sqrt(derive(com_mvt1_Filtered(:,2),1).^2); % Selon l'axe Y pour la vitesse ANTERO POSTERIEUR
            DATA(YY).D1(Nb_Acq).Vit_MVT1_V = sqrt(derive(com_mvt1_Filtered(:,3),1).^2); % Selon l'axe Z pour la vitesse VERTICALE
            
            % On calcule sa vitesse AP et V pour le mouvement 2
            DATA(YY).D1(Nb_Acq).Vit_MVT2_AP = sqrt(derive(com_mvt2_Filtered(:,2),1).^2); % Selon l'axe Y pour la vitesse ANTERO POSTERIEUR
            DATA(YY).D1(Nb_Acq).Vit_MVT2_V = sqrt(derive(com_mvt2_Filtered(:,3),1).^2); % Selon l'axe Z pour la vitesse VERTICALE
            
%             % On Normalise le signal pour pouvoir le moyenner ensuite
%             DATA(YY).D1(1).Vit_MVT1_V_NORM(:,Nb_Acq) = normalize2(DATA(YY).D1(Nb_Acq).Vit_MVT1_V, 'PCHIP', 1000);
%             DATA(YY).D1(1).Vit_MVT1_AP_NORM(:,Nb_Acq) = normalize2(DATA(YY).D1(Nb_Acq).Vit_MVT1_AP, 'PCHIP', 1000);
        catch
            disp('PAS DE COM')  
        end   

            
    end

end




% PLOT PROFILS BRUTS UNIQUES
for SUJET=1:numel(ListeFichier)
figure;
    for a =1:12
        try
            figure;
            vit_V=DATA(SUJET).D1(a).Vit_MVT2_V;
            vit_AP=DATA(SUJET).D1(a).Vit_MVT2_AP;
            plot(vit_V);hold on; plot(vit_AP);
            [Cut] = ginput(1)
            round(Cut(1,1))

            pos = round(Cut(1,1));
            while vit_V(pos)>vit_AP(pos)
                pos = pos-1;
            end
            DATA(SUJET).Intercept(:,a) = 100*(pos-200)/(length(vit_V)-200);
            
        catch
            disp(append('SUJET = ',string(SUJET),' Acq = ',string(a),' PAS DE COM'))
        end
    end
    close all;
end

for SUJET=1:numel(ListeFichier)
    intercept(SUJET,1:length(DATA(SUJET).Intercept)) = DATA(SUJET).Intercept(:,:);
end

