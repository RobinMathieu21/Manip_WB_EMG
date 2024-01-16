
%% Script 
% A executer pour post-traiter les données obtenues lors des manips whole
% body. Ce script est à utiliser pour les données STS/BTS et WB reaching.

close all
clear all


%% Importation des données
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');
    
Extension = '*.mat'; %Traite tous les .mat
Chemin = fullfile(Dossier, Extension); % On construit le chemin
ListeFichier = dir(Chemin); % On construit la liste des fichiers

for SUJETS = 1: numel(ListeFichier)
    Fichier_traite = [Dossier '\' ListeFichier(SUJETS).name]; %On charge le fichier .mat
    load (Fichier_traite);
    DonneesSAVED = Donnees;
    nb_acqui_ok =length(Donnees.cinematiques.Results_trial_by_trial);
%% On crée les matrices de résultats
    SUJETS
    data2.PA_PV(SUJETS,2) = mean(nonzeros(Donnees.cinematiques.Results_trial_by_trial(13:24,3)))-mean(nonzeros(Donnees.cinematiques.Results_trial_by_trial(1:12,3)));
    data2.PA_PV(SUJETS,1) = mean(nonzeros(Donnees.cinematiques.Results_trial_by_trial(13:24,4)))-mean(nonzeros(Donnees.cinematiques.Results_trial_by_trial(1:12,4)));

    data2.PA_PV(SUJETS,4) = mean(nonzeros(Donnees.cinematiques.Results_trial_by_trial(13:24,10)))-mean(nonzeros(Donnees.cinematiques.Results_trial_by_trial(1:12,10)));
    data2.PA_PV(SUJETS,3) = mean(nonzeros(Donnees.cinematiques.Results_trial_by_trial(13:24,11)))-mean(nonzeros(Donnees.cinematiques.Results_trial_by_trial(1:12,11)));

end


for SUJETS = 1: numel(ListeFichier)
    Fichier_traite = [Dossier '\' ListeFichier(SUJETS).name]; %On charge le fichier .mat
    load (Fichier_traite);
    DonneesSAVED = Donnees;
%% On crée les matrices de résultats
    SUJETS
    for f=1:1000
        moyennnnne(f,1) = mean(DonneesSAVED.cinematiques.Vel_cut_norm(f,1:12));
        moyennnnne(f,2) = mean(DonneesSAVED.cinematiques.Vel_cut_norm(f,13:24));
    end
    moyennnnne(:,1)=moyennnnne(:,1)./max(moyennnnne(:,1));
    moyennnnne(:,2)=moyennnnne(:,2)./max(moyennnnne(:,2));

    for f=1:1000
        moyennnnneV2(f,1) = mean(DonneesSAVED.cinematiques.Vel_cut_normV2(f,1:12));
        moyennnnneV2(f,2) = mean(DonneesSAVED.cinematiques.Vel_cut_normV2(f,13:24));
    end
    moyennnnneV2(:,1)=moyennnnneV2(:,1)./max(moyennnnneV2(:,1));
    moyennnnneV2(:,2)=moyennnnneV2(:,2)./max(moyennnnneV2(:,2));
    figure;
    nexttile
    plot(DonneesSAVED.cinematiques.Vel_cut_norm(:,1:12))
    nexttile
    plot(DonneesSAVED.cinematiques.Vel_cut_norm(:,13:24))
    nexttile
    plot(moyennnnne(:,1))
    nexttile
    plot(DonneesSAVED.cinematiques.Vel_cut_normV2(:,1:12))
    nexttile
    plot(DonneesSAVED.cinematiques.Vel_cut_normV2(:,13:24))
    nexttile
    plot(moyennnnneV2(:,1:2))
end


for SUJETS = 1: numel(ListeFichier)
    Fichier_traite = [Dossier '\' ListeFichier(SUJETS).name]; %On charge le fichier .mat
    load (Fichier_traite);
    DonneesSAVED = Donnees;
%% On crée les matrices de résultats
    SUJETS

    Donnees.cinematiques.debut_fin(:,5) = (Donnees.cinematiques.debut_fin(:,2)-Donnees.cinematiques.debut_fin(:,1))/200;
    Donnees.cinematiques.debut_fin(:,6) = (Donnees.cinematiques.debut_fin(:,4)-Donnees.cinematiques.debut_fin(:,3))/200;

    Donnees.cinematiques.debut_fin2(:,5) = (Donnees.cinematiques.debut_fin2(:,2)-Donnees.cinematiques.debut_fin2(:,1))/200;
    Donnees.cinematiques.debut_fin2(:,6) = (Donnees.cinematiques.debut_fin2(:,4)-Donnees.cinematiques.debut_fin2(:,3))/200;
    
    DUREE(SUJETS,:) = mean(Donnees.cinematiques.debut_fin2(:,5));

end


