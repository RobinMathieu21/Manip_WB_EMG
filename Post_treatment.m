
%% Script pour Manip EMGravity
close all
clear all

%% Importation des données
newcolors = [0 0.4470 0.7410
0.8500 0.3250 0.0980
0.9290 0.6940 0.1250
0.4940 0.1840 0.5560
0.4660 0.6740 0.1880
0.3010 0.7450 0.9330
0.6350 0.0780 0.1840
0 1 0
1 0 0
0 0 0];
         
colororder(newcolors)
afficher_graphs_cinematique_emg =false; % Pour afficher les graphs avec cinématique et EMG d'un sujet, le sujet_a_garder
afficher_phasic_tout_le_monde = ~afficher_graphs_cinematique_emg; %Si on afficher les graphs avec cinématique et EMG d'un sujet on affiche pas les phasics de tout le monde
Nb_emgs = 16;
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');

    
    Extension = '*.mat'; %Traite tous les .mat
    
    %On construit le chemin
    Chemin = fullfile(Dossier, Extension);
    
    %On construit la liste des fichiers
    ListeFichier = dir(Chemin);

    %% On crée les matrices de résultats
    
    Donnees_EMG_PHASIC_TRAITEE = {};

    %% On procède au balayage fichier par fichier
    disp('')
    j=0;
    legende = '';
    Nb_Fichiers = numel(ListeFichier);
    %% On récupère les données de chaque sujet, en particulier le phasic qu'on enregistre dans une structure
     for i = 1: Nb_Fichiers
         disp(ListeFichier(i).name)
           Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
           i
           load (Fichier_traite);

           [lig, col] = size (Donnees.EMG.Phasic.Combined.ProfilMoyenSeLever);
           [lig2, col2] = size (Donnees.EMG.RMSCutNorm);
           

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% PARAMETRES EMG
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           for j = 1: Nb_emgs
               % Normalisation
                Donnees_TRAITEE.EMG.se_lever(1:1000, i+(j-1)*Nb_Fichiers) = Donnees.EMG.Phasic.TonicLent.ProfilMoyenSeLever(:,(j-1)*3+1)./max(max(abs(Donnees.EMG.RMSCutNorm(:,(j-1)*col2/2/Nb_emgs+1:j*col2/2/Nb_emgs))));
                Donnees_TRAITEE.EMG.se_rassoir(1:1000, i+(j-1)*Nb_Fichiers) = Donnees.EMG.Phasic.TonicLent.ProfilMoyenSeRassoir(:,(j-1)*3+1)./max(max(abs(Donnees.EMG.RMSCutNorm(:,(j-1)*col2/2/Nb_emgs+1+col2/2:j*col2/2/Nb_emgs+col2/2))));
           

               Donnees_TRAITEE.EMG.Quantif_desac.Tps_cum_inac_SeLever(j,i) = Donnees.EMG.Phasic.QuantifDesac(1,(j-1)*12+3); % on enregistre la moyenne des tps cumulés d'inactivation par muscle Se lever 
               Donnees_TRAITEE.EMG.Quantif_desac.Tps_cum_inac_SeRassoir(j,i) = Donnees.EMG.Phasic.QuantifDesac(1,(j-1)*12+4); % on enregistre la moyenne des tps cumulés d'inactivation par muscle Se Rassoir
               Donnees_TRAITEE.EMG.Quantif_desac.Amp_SeLever(j,i) = Donnees.EMG.Phasic.QuantifDesac(1,(j-1)*12+7); % on enregistre la moyenne des tps cumulés d'inactivation par muscle
               Donnees_TRAITEE.EMG.Quantif_desac.Amp_SeRassoir(j,i) = Donnees.EMG.Phasic.QuantifDesac(1,(j-1)*12+8); % on enregistre la moyenne des tps cumulés d'inactivation par muscle
               Donnees_TRAITEE.EMG.Quantif_desac.Freq_SeLever(j,i) = Donnees.EMG.Phasic.QuantifDesac(1,(j-1)*12+11); % on enregistre la moyenne des tps cumulés d'inactivation par muscle
               Donnees_TRAITEE.EMG.Quantif_desac.Freq_SeRassoir(j,i) = Donnees.EMG.Phasic.QuantifDesac(1,(j-1)*12+12); % on enregistre la moyenne des tps cumulés d'inactivation par muscle
           end
            

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% PARAMETRES CINEMATIQUES
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           [lengthprofvit, colprofVit] = size(Donnees.cinematiques.Vel_cut_norm);
           for v = 1: 1000
                Donnees_TRAITEE.Cinematique.ProfVitLeverPencher(v,i) = mean(Donnees.cinematiques.Vel_cut_norm(v,1:colprofVit/2));
                Donnees_TRAITEE.Cinematique.ProfVitRassoirRedresser(v,i) = mean(Donnees.cinematiques.Vel_cut_norm(v,1+colprofVit/2:colprofVit));
           end

           lengthTL = length(Donnees.cinematiques_TL.Results_trial_by_trial(:,2));
           lengthRap = length(Donnees.cinematiques.Results_trial_by_trial(:,2));
           Donnees_TRAITEE.Cinematique.MD_TL(1:lengthTL,i) = Donnees.cinematiques_TL.Results_trial_by_trial(:,2);
           Donnees_TRAITEE.Cinematique.MD(1:lengthRap,i) = Donnees.cinematiques.Results_trial_by_trial(:,2);

     end



   % Moyennage des signaux EMG
   column = 1;
   for MuscleNB=1:16
       for f=1:1000
            Donnees_TRAITEE.EMG.se_leverPM(f,column) = mean(Donnees_TRAITEE.EMG.se_lever(f,(MuscleNB-1)*Nb_Fichiers+1:MuscleNB*Nb_Fichiers)); 
            Donnees_TRAITEE.EMG.se_leverPM(f,column+1) = Donnees_TRAITEE.EMG.se_leverPM(f,column) + std(Donnees_TRAITEE.EMG.se_lever(f,(MuscleNB-1)*Nb_Fichiers+1:MuscleNB*Nb_Fichiers))/sqrt(10); 
            Donnees_TRAITEE.EMG.se_leverPM(f,column+2) = Donnees_TRAITEE.EMG.se_leverPM(f,column) - std(Donnees_TRAITEE.EMG.se_lever(f,(MuscleNB-1)*Nb_Fichiers+1:MuscleNB*Nb_Fichiers))/sqrt(10); 
            Donnees_TRAITEE.EMG.se_rassoirPM(f,column) = mean(Donnees_TRAITEE.EMG.se_rassoir(f,(MuscleNB-1)*Nb_Fichiers+1:MuscleNB*Nb_Fichiers)); 
            Donnees_TRAITEE.EMG.se_rassoirPM(f,column+1) = Donnees_TRAITEE.EMG.se_rassoirPM(f,column) + std(Donnees_TRAITEE.EMG.se_rassoir(f,(MuscleNB-1)*Nb_Fichiers+1:MuscleNB*Nb_Fichiers))/sqrt(10); 
            Donnees_TRAITEE.EMG.se_rassoirPM(f,column+2) = Donnees_TRAITEE.EMG.se_rassoirPM(f,column) - std(Donnees_TRAITEE.EMG.se_rassoir(f,(MuscleNB-1)*Nb_Fichiers+1:MuscleNB*Nb_Fichiers))/sqrt(10); 
       end
       column= column+3;
   end

%% On affiche les phasic de tous les sujets sur les mêmes graphs pour comparaison après avoir calculer la moyenne et l'erreur standard
    if afficher_phasic_tout_le_monde
        disp('COMPARAISON PHASIC');
        
        for k=1 : length(Donnees.Muscles)

                Titre = append('MOUVEMENT ASSIS/DEBOUT -  Muscle : ',string(Donnees.Muscles(k)));
                fig = figure('Name',Titre,'NumberTitle','off');
                set(gcf,'position',[200,200,1000,350])
                colororder(newcolors)

                subplot(1,2,1)
%                 plot(Donnees_TRAITEE.EMG.Profil_moyen_se_lever(:,k)); hold on;
%                 plot(Donnees_TRAITEE.EMG.Profil_moyen_se_lever_plus(:,k)); hold on; % pour la moyenne + erreur
%                 plot(Donnees_TRAITEE.EMG.Profil_moyen_se_lever_moins(:,k));
                plot(Donnees_TRAITEE.EMG.se_lever(:,1+(k-1)*Nb_Fichiers:(k-1)*Nb_Fichiers+Nb_Fichiers)); hold on; % pour tous les sujets
                titre = append('SE lever - ');%PHASIC (tps=',string(mean(Donnees_TRAITEE.EMG.Quantif_desac.Tps_cum_inac_SeLever(k,:))), ' / amp=', string(mean(Donnees_TRAITEE.EMG.Quantif_desac.Amp_SeLever(k,:))), '% / freq=',string(mean(Donnees_TRAITEE.EMG.Quantif_desac.Freq_SeLever(k,:))), ')');
                r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'r');title(titre);
                %set(gca, 'ColorOrder', colors, 'NextPlot', 'replacechildren');
                hold off; 
                %legend('Signal moyen', '+ erreur standard','- erreur standard');
                legend(ListeFichier.name,'Position',[0 0.5 0.1 0.3])
                legend('Orientation','vertical')
                legend('boxoff')


            subplot(1,2,2)
%                 plot(Donnees_TRAITEE.EMG.Profil_moyen_se_rassoir(:,k)); hold on;
%                 plot(Donnees_TRAITEE.EMG.Profil_moyen_se_rassoir_plus(:,k)); hold on; % pour la moyenne + erreur
%                 plot(Donnees_TRAITEE.EMG.Profil_moyen_se_rassoir_moins(:,k));
                plot(Donnees_TRAITEE.EMG.se_rassoir(:,1+(k-1)*Nb_Fichiers:(k-1)*Nb_Fichiers+Nb_Fichiers)); hold on;  % pour tous les sujets
                titre = append('SE rassoir - ');%PHASIC (',string(mean(Donnees_TRAITEE.EMG.Quantif_desac.Tps_cum_inac_SeRassoir(k,:))), ' / ', string(mean(Donnees_TRAITEE.EMG.Quantif_desac.Amp_SeRassoir(k,:))), ' / ',string(mean(Donnees_TRAITEE.EMG.Quantif_desac.Freq_SeRassoir(k,:))), ')');
                r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'r');title(titre);
                %set(gca, 'ColorOrder', jet(10), 'NextPlot', 'replacechildren');
                hold off;                 
                path = append(Dossier,'\',Donnees.Muscles(k));
                saveas(gcf,path{1},'png');

        end


        % GRAPHS POUR AFFICHER la durée des mouvements
        Titre = append('MD _ MOUVEMENT ASSIS/DEBOUT');
        fig = figure('Name',Titre,'NumberTitle','off');
        set(gcf,'position',[200,200,1000,350])
        colororder(newcolors)
        subplot(1,2,1)
        plot(Donnees_TRAITEE.Cinematique.MD_TL(:,:)); title('MD Lents (en s)');
        legend(ListeFichier.name,'Position',[0 0.5 0.1 0.3])
        legend('Orientation','vertical')
        legend('boxoff')
        subplot(1,2,2)
        plot(Donnees_TRAITEE.Cinematique.MD(:,:)); title('MD (en s)');

        path = append(Dossier,'\','MD');
        saveas(gcf,path,'png');


        % GRAPHS POUR AFFICHER Les profils de vitesse
        Titre = append('Profil vitesse _ ASSIS/DEBOUT');
        fig = figure('Name',Titre,'NumberTitle','off');
        set(gcf,'position',[200,200,1000,350])
        colororder(newcolors)
        subplot(1,2,1)
        plot(Donnees_TRAITEE.Cinematique.ProfVitLeverPencher(:,:)); title('Se lever (normalisé)');
        legend(ListeFichier.name,'Position',[0 0.5 0.1 0.3])
        legend('Orientation','vertical')
        legend('boxoff')
        subplot(1,2,2)
        plot(Donnees_TRAITEE.Cinematique.ProfVitRassoirRedresser(:,:)); title('Se rassoir (normalisé)');

        path = append(Dossier,'\','PV');
        saveas(gcf,path,'png');
        
    end  
    




Donnees_to_export = Donnees_TRAITEE.EMG.Quantif_desac;

disp('Selectionnez le Dossier où enregistre les données.');
[Dossier] = uigetdir ('Selectionnez le Dossier où enregistre les données.');
save([Dossier '/R2_rapide'  ], 'Donnees_to_export');

disp('Données enregistrées avec succès !');