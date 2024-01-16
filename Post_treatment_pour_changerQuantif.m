
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
if (Dossier ~= 0) %Si on clique sur un dossier
    
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

limite_en_temps = 0.01; % en ms, correspond au temps minimal pour considérer une désactivation
%% AJOUT DES QUANTIFICATIONS

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
    %% Partie pour quantifier les desacs musculaires sur le phasic lent
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [~, nb_col_rms] = size(Donnees.EMG.Phasic.Se_lever);
    i = 1;
    j = 1;
    
    while j <= nb_col_rms % On balaye
    %% Calculs quantif desac pour le mvt lever
    
        % Calcul temps phase desac LEVER
        indic = 0; % Variable pour vérifier la longueur des phases de désactivation
        Limite_atteinte = false; % variable bouléene pour enregistrer le fait que les phases de désactivation sont assez longues (ou pas)
        compteur = 0; % Si la désactivation est assez longue, elle est comptée dans cette variable
        Limite_basse_detection = round(emg_frequency * limite_en_temps / MD_MEAN_R(j,1)); %Limite d'image à atteindre pour considérer la phase négative 40ms, arrondi à l'image près
        for f = 1 : emg_frequency % Une boucle pour tester toutes les valeurs du phasic
            
            if emg_phasique_combined_R(f, j) < -2*tonics_R_meanstd(3, j) % Si la valeur est inf à zero indic est incrementé
               indic = indic + 1 ;
            else   % Sinon
                if Limite_atteinte % Soit la limite avait déjà été atteinte (la phase doit donc être comptée)
                    compteur = compteur + indic; % On la compte 
                    indic = 0;    % on remet la variable indic à 0 pour vérifier les suivantes
                    Limite_atteinte = false; % On remet la variable bouléene à Faux 
                else
                    indic = 0; % Si la limite n'avait pas été atteinte on remet simplement l'indicateur à 0
                end
            end
            
            if indic >Limite_basse_detection % Si la variable indicateur augmente et dépasse la limite de détection (40 ms), la limite est atteinte
                Limite_atteinte = true;
            end
            
        end
        
        % Calcul de l'amplitude max de négativité
        [Pmin, indice] = min(emg_phasique_combined_R(:, j));
        if Pmin > 0
            Pmin =0;
        end
        amplitude = Pmin * 100 / RMS_R_moy_normProfilmoyen(indice,i);
        
        if compteur>0
            frequence =1;
        else 
            frequence = 0;
        end
       
            % Calcul temps phase desac BAISSER
        indic = 0; % Variable pour vérifier la longueur des phases de désactivation
        Limite_atteinte = false; % variable bouléene pour enregistrer le fait que les phases de désactivation sont assez longues (ou pas)
        compteur2 = 0; % Si la désactivation est assez longue, elle est comptée dans cette variable
        Limite_basse_detection = round(emg_frequency * limite_en_temps / MD_MEAN_B(j,1)); %Limite d'image à atteindre pour considérer la phase négative 40ms, arrondi à l'image près
        for f = 1 : emg_frequency % Une boucle pour tester toutes les valeurs du phasic
            
            if emg_phasique_combined_B(f, j) < -2*tonics_B_meanstd(3, j) % Si la valeur est inf à zero indic est incrementé
               indic = indic + 1 ;
            else   % Sinon
                if Limite_atteinte % Soit la limite avait déjà été atteinte (la phase doit donc être comptée)
                    compteur2 = compteur2 + indic; % On la compte 
                    indic = 0;    % on remet la variable indic à 0 pour vérifier les suivantes
                    Limite_atteinte = false; % On remet la variable bouléene à Faux 
                else
                    indic = 0; % Si la limite n'avait pas été atteinte on remet simplement l'indicateur à 0
                end
            end
            
            if indic >Limite_basse_detection % Si la variable indicateur augmente et dépasse la limite de détection (40 ms), la limite est atteinte
                Limite_atteinte = true;
            end
        end
        
        % Calcul de l'amplitude max de négativité
        [Pmin, indice] = min(emg_phasique_combined_B(:, j));
        if Pmin > 0
            Pmin =0;
        end
        amplitude2 = Pmin * 100 / RMS_B_moy_normProfilmoyen(indice,i);
        
        if compteur2>0
            frequence2 =1;
        else 
            frequence2 = 0;
        end
       
    %% Enregistrement des données
    
        EMG_phasique.QuantifDesac(j, (WW-1)*12+1) = compteur*MD_MEAN_R(j,1)/emg_frequency;  % Pour l'avoir en temps
        EMG_phasique.QuantifDesac(j, (WW-1)*12+2) = compteur2*MD_MEAN_B(j,1)/emg_frequency; % Pour l'avoir en temps  
        EMG_phasique.QuantifDesac(j, (WW-1)*12+5) = amplitude; % Amplitudes des mvts se lever
        EMG_phasique.QuantifDesac(j, (WW-1)*12+6) = amplitude2; % Amplitudes des mvts se rassoir
        EMG_phasique.QuantifDesac(j, (WW-1)*12+9) = frequence;  % Fréquence des désac mvt se lever
        EMG_phasique.QuantifDesac(j, (WW-1)*12+10) = frequence2; % Fréquence des désac mvt se rassoir
        
        j = j+1;
    end
    
    
    % Moyennage des parametres
    L=length(EMG_phasique.QuantifDesac(:,1));
    
    EMG_phasique.QuantifDesac(1, (WW-1)*12 + 3) = mean(EMG_phasique.QuantifDesac(1:L,(WW-1)*12 + 1));    % Moyenne des temps cumulés/muscle
    EMG_phasique.QuantifDesac(1, (WW-1)*12 + 4) = mean(EMG_phasique.QuantifDesac(1:L,(WW-1)*12 + 2));    % Moyenne des temps cumulés/muscle
    EMG_phasique.QuantifDesac(1, (WW-1)*12 + 7) = mean(EMG_phasique.QuantifDesac(1:L,(WW-1)*12 + 5));    % Moyenne des amplitudes/muscle
    EMG_phasique.QuantifDesac(1, (WW-1)*12 + 8) = mean(EMG_phasique.QuantifDesac(1:L,(WW-1)*12 + 6));    % Moyenne des amplitudes/muscle
    EMG_phasique.QuantifDesac(1, (WW-1)*12 + 11) = mean(EMG_phasique.QuantifDesac(1:L,(WW-1)*12 + 9));   % Moyenne des fréquence/muscle
    EMG_phasique.QuantifDesac(1, (WW-1)*12 + 12) = mean(EMG_phasique.QuantifDesac(1:L,(WW-1)*12 + 10));  % Moyenne des fréquence/muscle
    
    
    



























           [lig, col] = size (Donnees.EMG.Phasic.ProfilMoyen.Se_lever);
           [lig2, col2] = size (Donnees.EMG.RMSCutNorm);
           
           for j = 1: col
                Donnees_TRAITEE.EMG.se_lever(1:1000, i+(j-1)*Nb_Fichiers) = Donnees.EMG.Phasic.ProfilMoyen.Se_lever(:,j)./max(max(abs(Donnees.EMG.RMSCutNorm(:,(j-1)*col2/2/Nb_emgs+1:j*col2/2/Nb_emgs))));
                Donnees_TRAITEE.EMG.se_rassoir(:, i+(j-1)*Nb_Fichiers) = Donnees.EMG.Phasic.ProfilMoyen.Se_rassoir(:,j)./max(max(abs(Donnees.EMG.RMSCutNorm(:,(j-1)*col2/2/Nb_emgs+1+col2/2:j*col2/2/Nb_emgs+col2/2))));
           end
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

%% On affiche les phasic de tous les sujets sur les mêmes graphs pour comparaison après avoir calculer la moyenne et l'erreur standard
    if afficher_phasic_tout_le_monde
        disp('COMPARAISON PHASIC');
        
        for k=1 : length(Donnees.Muscles)
                Titre = append('MOUVEMENT ASSIS/DEBOUT -  Muscle : ',string(Donnees.Muscles(k)));
                fig = figure('Name',Titre,'NumberTitle','off');
                set(gcf,'position',[200,200,1000,350])
                colororder(newcolors)
                subplot(1,2,1)
                        for f = 1:1000
 % Pour afficher la moyenne + erreur des sujets                           
                                Donnees_TRAITEE.EMG.Profil_moyen_se_lever(f,k) = mean(Donnees_TRAITEE.EMG.se_lever(f,1+(k-1)*Nb_Fichiers:(k-1)*Nb_Fichiers+Nb_Fichiers));
                                Donnees_TRAITEE.EMG.Profil_moyen_se_lever_plus(f,k) = mean(Donnees_TRAITEE.EMG.se_lever(f,1+(k-1)*Nb_Fichiers:(k-1)*Nb_Fichiers+Nb_Fichiers))+std(Donnees_TRAITEE.EMG.se_lever(f,1+(k-1)*Nb_Fichiers:(k-1)*Nb_Fichiers+Nb_Fichiers))/sqrt(12);
                                Donnees_TRAITEE.EMG.Profil_moyen_se_lever_moins(f,k) = mean(Donnees_TRAITEE.EMG.se_lever(f,1+(k-1)*Nb_Fichiers:(k-1)*Nb_Fichiers+Nb_Fichiers))-std(Donnees_TRAITEE.EMG.se_lever(f,1+(k-1)*Nb_Fichiers:(k-1)*Nb_Fichiers+Nb_Fichiers))/sqrt(12);
                                
                                Donnees_TRAITEE.EMG.Profil_moyen_se_rassoir(f,k) = mean(Donnees_TRAITEE.EMG.se_rassoir(f,1+(k-1)*Nb_Fichiers:(k-1)*Nb_Fichiers+Nb_Fichiers));
                                Donnees_TRAITEE.EMG.Profil_moyen_se_rassoir_plus(f,k) = mean(Donnees_TRAITEE.EMG.se_rassoir(f,1+(k-1)*Nb_Fichiers:(k-1)*Nb_Fichiers+Nb_Fichiers))+std(Donnees_TRAITEE.EMG.se_rassoir(f,1+(k-1)*Nb_Fichiers:(k-1)*Nb_Fichiers+Nb_Fichiers))/sqrt(12);
                                Donnees_TRAITEE.EMG.Profil_moyen_se_rassoir_moins(f,k) = mean(Donnees_TRAITEE.EMG.se_rassoir(f,1+(k-1)*Nb_Fichiers:(k-1)*Nb_Fichiers+Nb_Fichiers))-std(Donnees_TRAITEE.EMG.se_rassoir(f,1+(k-1)*Nb_Fichiers:(k-1)*Nb_Fichiers+Nb_Fichiers))/sqrt(12);
% Pour afficher tous les sujets
%                                 Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o),2);
%                                 Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o),2)+std(Donnees_EMG_TL.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o));
%                                 Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o),2)-std(Donnees_EMG_TL.RMSCutNorm(f,Nb_emgs*numel(ListeFichier)+a+o:Nb_emgs*numel(ListeFichier)+b+o));
                    
                        end

%                 plot(Donnees_TRAITEE.EMG.Profil_moyen_se_lever(:,k)); hold on;
%                 plot(Donnees_TRAITEE.EMG.Profil_moyen_se_lever_plus(:,k)); hold on; % pour la moyenne + erreur
%                 plot(Donnees_TRAITEE.EMG.Profil_moyen_se_lever_moins(:,k));

                h = plot(Donnees_TRAITEE.EMG.se_lever(:,1+(k-1)*Nb_Fichiers:(k-1)*Nb_Fichiers+Nb_Fichiers)); hold on; % pour tous les sujets
                
                titre = append('SE lever - PHASIC (tps=',string(mean(Donnees_TRAITEE.EMG.Quantif_desac.Tps_cum_inac_SeLever(k,:))), ' / amp=', string(mean(Donnees_TRAITEE.EMG.Quantif_desac.Amp_SeLever(k,:))), '% / freq=',string(mean(Donnees_TRAITEE.EMG.Quantif_desac.Freq_SeLever(k,:))), ')');
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

                titre = append('SE rassoir - PHASIC (',string(mean(Donnees_TRAITEE.EMG.Quantif_desac.Tps_cum_inac_SeRassoir(k,:))), ' / ', string(mean(Donnees_TRAITEE.EMG.Quantif_desac.Amp_SeRassoir(k,:))), ' / ',string(mean(Donnees_TRAITEE.EMG.Quantif_desac.Freq_SeRassoir(k,:))), ')');
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


end





Donnees_to_export = Donnees_TRAITEE.EMG.Quantif_desac;

disp('Selectionnez le Dossier où enregistre les données.');
[Dossier] = uigetdir ('Selectionnez le Dossier où enregistre les données.');
save([Dossier '/R2_rapide'  ], 'Donnees_to_export');

disp('Données enregistrées avec succès !');