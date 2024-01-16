
%% Script pour Manip EMGravity
close all
clear all

%% Importation des données


[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script BRAS DROIT RAPIDE');
if (Dossier ~= 0) %Si on clique sur un dossier
    
    Extension = '*.mat'; %Traite tous les .mat
    
    %On construit le chemin
    Chemin = fullfile(Dossier, Extension);
    
    %On construit la liste des fichiers
    ListeFichier = dir(Chemin);

    %% On procède au balayage fichier par fichier
    Nb_Fichiers = numel(ListeFichier);

    %% On récupère les données de chaque sujet, en particulier le phasic qu'on enregistre dans une structure
     for i = 1: Nb_Fichiers
         disp(ListeFichier(i).name)
           Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
           i
           load (Fichier_traite);
           lengthRap = length(Donnees.cinematiques.Results_trial_by_trial(:,2));
           Donnees_TRAITEE.Cinematique.MD(1+(i-1)*lengthRap:i*lengthRap,1) = Donnees.cinematiques.Results_trial_by_trial(:,2);
     end

end
i_saved = i ;
[Dossier2] = uigetdir ('Selectionnez le Dossier où exécuter le Script BRAS DROIT NATURELLE');
if (Dossier2 ~= 0) %Si on clique sur un dossier

    %On construit le chemin
    Chemin2 = fullfile(Dossier2, Extension);
    
    %On construit la liste des fichiers
    ListeFichier2 = dir(Chemin2);

    %% On procède au balayage fichier par fichier

    Nb_Fichiers2 = numel(ListeFichier2);

    %% On récupère les données de chaque sujet, en particulier le phasic qu'on enregistre dans une structure
     for i = 1: Nb_Fichiers
         disp(ListeFichier2(i).name)
           Fichier_traite2 = [Dossier2 '\' ListeFichier2(i).name]; %On charge le fichier .mat
           i
           load (Fichier_traite2);
           lengthRap = length(Donnees.cinematiques.Results_trial_by_trial(:,2));
           Donnees_TRAITEE.Cinematique.MD(1+(i+i_saved-1)*lengthRap:(i+i_saved)*lengthRap,1) = Donnees.cinematiques.Results_trial_by_trial(:,2);
     end

end
i_saved2 = i +  i_saved;
[Dossier2] = uigetdir ('Selectionnez le Dossier où exécuter le Script BRAS GAUCHE RAPIDE');
if (Dossier2 ~= 0) %Si on clique sur un dossier

    %On construit le chemin
    Chemin2 = fullfile(Dossier2, Extension);
    
    %On construit la liste des fichiers
    ListeFichier2 = dir(Chemin2);

    %% On procède au balayage fichier par fichier

    Nb_Fichiers2 = numel(ListeFichier2);

    %% On récupère les données de chaque sujet, en particulier le phasic qu'on enregistre dans une structure
     for i = 1: Nb_Fichiers
         disp(ListeFichier2(i).name)
           Fichier_traite2 = [Dossier2 '\' ListeFichier2(i).name]; %On charge le fichier .mat
           i
           load (Fichier_traite2);
           lengthRap = length(Donnees.cinematiques.Results_trial_by_trial(:,2));
           Donnees_TRAITEE.Cinematique.MD(1+(i+i_saved2-1)*lengthRap:(i+i_saved2)*lengthRap,1) = Donnees.cinematiques.Results_trial_by_trial(:,2);
     end

end
i_saved3 = i +i_saved2;
[Dossier2] = uigetdir ('Selectionnez le Dossier où exécuter le Script BRAS GAUCHE NATURELLE');
if (Dossier2 ~= 0) %Si on clique sur un dossier

    %On construit le chemin
    Chemin2 = fullfile(Dossier2, Extension);
    
    %On construit la liste des fichiers
    ListeFichier2 = dir(Chemin2);

    %% On procède au balayage fichier par fichier

    Nb_Fichiers2 = numel(ListeFichier2);

    %% On récupère les données de chaque sujet, en particulier le phasic qu'on enregistre dans une structure
     for i = 1: Nb_Fichiers
         disp(ListeFichier2(i).name)
           Fichier_traite2 = [Dossier2 '\' ListeFichier2(i).name]; %On charge le fichier .mat
           i
           load (Fichier_traite2);
           lengthRap = length(Donnees.cinematiques.Results_trial_by_trial(:,2));
           Donnees_TRAITEE.Cinematique.MD(1+(i+i_saved3-1)*lengthRap:(i+i_saved3)*lengthRap,1) = Donnees.cinematiques.Results_trial_by_trial(:,2);
     end

end
count01=0;count27=0;count32=0;count37=0;count42=0;count47=0;
count52=0;count57=0;count62=0;count67=0;count72=0;count77=0;
count82=0;count87=0;count92=0;count97=0;count100=0;
[lengthMD, colMD] = size(Donnees_TRAITEE.Cinematique.MD);

for i=1 : lengthMD
    
    switch true
        
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),0:250)
            count01=count01+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),251:300)
            count27=count27+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),301:350)
            count32=count32+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),351:400)
            count37=count37+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),401:450)
            count42=count42+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),451:500)
            count47=count47+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),501:550)
            count52=count52+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),551:600)
            count57=count57+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),601:650)
            count62=count62+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),651:700)
            count67=count67+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),701:750)
            count72=count72+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),751:800)
            count77=count77+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),801:850)
            count82=count82+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),851:900)
            count87=count87+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),901:950)
            count92=count92+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),951:1000)
            count97=count97+1;
        case ismember(1000*Donnees_TRAITEE.Cinematique.MD(i,1),1001:5000)
            count100=count100+1;
        otherwise
            disp('ERROR _ '+string(Donnees_TRAITEE.Cinematique.MD(i,1)))
    end

end

Donnees_TRAITEE.Cinematique.MDCase(1,1)= 0.1; Donnees_TRAITEE.Cinematique.MDCase(1,2)=count01;
Donnees_TRAITEE.Cinematique.MDCase(2,1)= 0.275; Donnees_TRAITEE.Cinematique.MDCase(2,2)=count27;
Donnees_TRAITEE.Cinematique.MDCase(3,1)= 0.325; Donnees_TRAITEE.Cinematique.MDCase(3,2)=count32;
Donnees_TRAITEE.Cinematique.MDCase(4,1)= 0.375; Donnees_TRAITEE.Cinematique.MDCase(4,2)=count37;
Donnees_TRAITEE.Cinematique.MDCase(5,1)= 0.425; Donnees_TRAITEE.Cinematique.MDCase(5,2)=count42;
Donnees_TRAITEE.Cinematique.MDCase(6,1)= 0.475; Donnees_TRAITEE.Cinematique.MDCase(6,2)=count47;
Donnees_TRAITEE.Cinematique.MDCase(7,1)= 0.525; Donnees_TRAITEE.Cinematique.MDCase(7,2)=count52;
Donnees_TRAITEE.Cinematique.MDCase(8,1)= 0.575; Donnees_TRAITEE.Cinematique.MDCase(8,2)=count57;
Donnees_TRAITEE.Cinematique.MDCase(9,1)= 0.625; Donnees_TRAITEE.Cinematique.MDCase(9,2)=count62;
Donnees_TRAITEE.Cinematique.MDCase(10,1)= 0.675; Donnees_TRAITEE.Cinematique.MDCase(10,2)=count67;
Donnees_TRAITEE.Cinematique.MDCase(11,1)= 0.725; Donnees_TRAITEE.Cinematique.MDCase(11,2)=count72;
Donnees_TRAITEE.Cinematique.MDCase(12,1)= 0.775; Donnees_TRAITEE.Cinematique.MDCase(12,2)=count77;
Donnees_TRAITEE.Cinematique.MDCase(13,1)= 0.825; Donnees_TRAITEE.Cinematique.MDCase(13,2)=count82;
Donnees_TRAITEE.Cinematique.MDCase(14,1)= 0.875; Donnees_TRAITEE.Cinematique.MDCase(14,2)=count87;
Donnees_TRAITEE.Cinematique.MDCase(15,1)= 0.925; Donnees_TRAITEE.Cinematique.MDCase(15,2)=count92;
Donnees_TRAITEE.Cinematique.MDCase(16,1)= 0.975; Donnees_TRAITEE.Cinematique.MDCase(16,2)=count97;
Donnees_TRAITEE.Cinematique.MDCase(17,1)= 1; Donnees_TRAITEE.Cinematique.MDCase(17,2)=count100;



Titre = append('MD _ MOUVEMENT BRAS');
fig = figure('Name',Titre,'NumberTitle','off');
set(gcf,'position',[200,200,1000,350])
scatter(Donnees_TRAITEE.Cinematique.MDCase(:,1),Donnees_TRAITEE.Cinematique.MDCase(:,2)); hold on;

% scatter(DonneesB.BrasDJeune(:,1),DonneesB.BrasDJeune(:,2)); hold on;
% scatter(DonneesB.BrasGJeune(:,1),DonneesB.BrasGJeune(:,2)); hold on;
% scatter(DonneesB.BrasDOld(:,1),DonneesB.BrasDOld(:,2)); hold on;
% scatter(DonneesB.BrasGOld(:,1),DonneesB.BrasGOld(:,2)); hold on;
title('Movement Duration Lever (en s)');
xlabel('Durée (s) par regroupement de 0.25s')
ylabel('nb essais')





% BrasGOld = Donnees_TRAITEE.Cinematique.MDCase
% clearvars -except BrasDJeune BrasGJeune BrasDOld BrasGOld
% DonneesB.BrasDJeune = BrasDJeune;
% DonneesB.BrasGJeune = BrasGJeune;
% DonneesB.BrasDOld = BrasDOld;
% DonneesB.BrasGOld = BrasGOld;
% name = 'Temps_Bras';
% disp('Selectionnez le Dossier où enregistre les données.');
% [Dossier] = uigetdir ('Selectionnez le Dossier où enregistre les données.');
% save([Dossier '/' name ], 'DonneesB');
% disp('Données enregistrées avec succès !');