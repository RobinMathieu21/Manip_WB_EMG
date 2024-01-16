
%% Script pour Manip EMGravity pour comparer les méthodes de calcul du tonic d'un mvt WB
close all
clear all

%% Importation des données

afficher_graphs_cinematique_emg =false; % Pour afficher les graphs avec cinématique et EMG d'un sujet, le sujet_a_garder
sujet_a_garder = 'Adrien.mat'; %(ou Antoine.mat)
afficher_phasic_tout_le_monde = ~afficher_graphs_cinematique_emg; %Si on afficher les graphs avec cinématique et EMG d'un sujet on affiche pas les phasics de tout le monde

[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');
if (Dossier ~= 0) %Si on clique sur un dossier
    
    Extension = '*.mat'; %Traite tous les .mat
    
    %On construit le chemin
    Chemin = fullfile(Dossier, Extension);
    
    %On construit la liste des fichiers
    ListeFichier = dir(Chemin);

    %% On crée les matrices de résultats
    
    Donnees_EMG_PHASIC_TRAITEE = {};

    %% On procède au balayage fichier par fichier

    Nb_Fichiers = numel(ListeFichier);
    %% On récupère les données de chaque sujet, en particulier le phasic qu'on enregistre dans une structure
     for i = 1: Nb_Fichiers
         disp(ListeFichier(i).name)
           Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
           i
           load (Fichier_traite);
           if strcmp(ListeFichier(i).name,sujet_a_garder) % on enregistre les données du sujet qu'on veut observer
                Donnees_saved= Donnees;
           end
     end
     
     
    Nb_pos_alea = length(Donnees_saved.cinematiques_PA.angleflexiongenou);
     
     x=0;
    for muscle=1 : length(Donnees_saved.Muscles)

        Titre = append('Signaux EMG RMS du ',sujet_a_garder,' _ muscle : ',string(Donnees_saved.Muscles(muscle)));
        figure('Name',Titre,'NumberTitle','off');
        set(gcf,'position',[75,200,1400,400])
        disp(3*x+muscle);
        
        % Plot se lever (Si assis/debout) ou se pencher (si WB reaching)
        subplot(1,2,1)
        plot(Donnees_saved.EMG_L.RMSCutNormProfilMoyen.Se_lever(:,muscle+(3*x)));hold on;
        plot(Donnees_saved.EMG_TL.RMSCutNormProfilMoyen.Se_lever(:,muscle+(3*x))); hold on;
        scatter(Donnees_saved.cinematiques_PA.angleflexiongenou(2,:),Donnees_saved.EMG_PA.RMSmoyen(1,muscle*Nb_pos_alea-Nb_pos_alea+1:muscle*Nb_pos_alea)); 
        title('SE LEVER / Se pencher');legend('Lent','Très lent','Pos alea');
        
        %Plot Se rassoir ou se redresser
        subplot(1,2,2)
        plot(Donnees_saved.EMG_L.RMSCutNormProfilMoyen.Se_rassoir(:,muscle+(3*x)));hold on;
        plot(Donnees_saved.EMG_TL.RMSCutNormProfilMoyen.Se_rassoir(:,muscle+(3*x))); hold on;
        scatter(-Donnees_saved.cinematiques_PA.angleflexiongenou(2,:)+max(Donnees_saved.cinematiques_PA.angleflexiongenou(2,:)),Donnees_saved.EMG_PA.RMSmoyen(1,muscle*Nb_pos_alea-Nb_pos_alea+1:muscle*Nb_pos_alea)); 
        title('SE RASSOIR / se redresser');legend('Lent','Très lent','Pos alea');
        x=x+1;
    end 

end


g=1;
for h=1 : 6*2*16
    disp(g);
    figure;plot(Donnees_saved.EMG_L.RMSCutNorm(:,g:g+5),'DisplayName','Donnees_saved.EMG_L.RMSCutNorm(:,g:g+5)')
    g=g+6;
end



