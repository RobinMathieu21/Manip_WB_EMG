
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

graph_emg= true;
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');

    Extension = '*.mat'; %Traite tous les .mat
    
    %On construit le chemin
    Chemin = fullfile(Dossier, Extension);
    
    %On construit la liste des fichiers
    ListeFichier = dir(Chemin);

    %% On procède au balayage fichier par fichier
    disp('')
    j=0;
    legende = '';
    Nb_Fichiers = numel(ListeFichier);


    %% On récupère les données de chaque sujet, en particulier le phasic qu'on enregistre dans une structure
     for i = 1: Nb_Fichiers
         disp(ListeFichier(i).name)
           Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
           disp(append("i = "+i));
           load (Fichier_traite);

           % ENREGISTREMENT DE DONNEES EMG DE CHAQUE SUJET - - - EMG COMBINED
           % On calcule le max
            maxDAlever = max(max(abs(Donnees.EMG.Phasic.Combined.DA.Lever)));
            maxDPlever = max(max(abs(Donnees.EMG.Phasic.Combined.DP.Lever)));
            maxDAbaisser = max(max(abs(Donnees.EMG.Phasic.Combined.DA.Baisser)));
            maxDPbaisser = max(max(abs(Donnees.EMG.Phasic.Combined.DP.Baisser)));

           % On normalise par le max du max
            for j=1:3
                Donnees.EMG.Phasic.Combined.DA.ProfilMoyen(:,j) = Donnees.EMG.Phasic.Combined.DA.ProfilMoyen(:,j)/maxDAlever;
                Donnees.EMG.Phasic.Combined.DA.ProfilMoyen(:,j+3) = Donnees.EMG.Phasic.Combined.DA.ProfilMoyen(:,j+3)/maxDAbaisser;
                Donnees.EMG.Phasic.Combined.DP.ProfilMoyen(:,j) = Donnees.EMG.Phasic.Combined.DP.ProfilMoyen(:,j)/maxDPlever;
                Donnees.EMG.Phasic.Combined.DP.ProfilMoyen(:,j+3) = Donnees.EMG.Phasic.Combined.DP.ProfilMoyen(:,j+3)/maxDPbaisser;
            end
            
           Donnees_TRAITEE.EMGCombined.Profil_moyen_lever.DA(:,i) = Donnees.EMG.Phasic.Combined.DA.ProfilMoyen(:,1);
           Donnees_TRAITEE.EMGCombined.Profil_moyen_baisser.DA(:,i) = Donnees.EMG.Phasic.Combined.DA.ProfilMoyen(:,4);
           Donnees_TRAITEE.EMGCombined.Profil_moyen_lever.DP(:,i) = Donnees.EMG.Phasic.Combined.DP.ProfilMoyen(:,1);
           Donnees_TRAITEE.EMGCombined.Profil_moyen_baisser.DP(:,i) = Donnees.EMG.Phasic.Combined.DP.ProfilMoyen(:,4);

%-----------------------------
           % ENREGISTREMENT DE DONNEES EMG DE CHAQUE SUJET - - - EMG CLASSIQUE
           % On calcule le max
            maxDAlever = max(max(abs(Donnees.EMG.Phasic.Classique.DA.Lever)));
            maxDPlever = max(max(abs(Donnees.EMG.Phasic.Classique.DP.Lever)));
            maxDAbaisser = max(max(abs(Donnees.EMG.Phasic.Classique.DA.Baisser)));
            maxDPbaisser = max(max(abs(Donnees.EMG.Phasic.Classique.DP.Baisser)));

           % On normalise par le max du max
            for j=1:3
                Donnees.EMG.Phasic.Classique.DA.ProfilMoyen(:,j) = Donnees.EMG.Phasic.Classique.DA.ProfilMoyen(:,j)/maxDAlever;
                Donnees.EMG.Phasic.Classique.DA.ProfilMoyen(:,j+3) = Donnees.EMG.Phasic.Classique.DA.ProfilMoyen(:,j+3)/maxDAbaisser;
                Donnees.EMG.Phasic.Classique.DP.ProfilMoyen(:,j) = Donnees.EMG.Phasic.Classique.DP.ProfilMoyen(:,j)/maxDPlever;
                Donnees.EMG.Phasic.Classique.DP.ProfilMoyen(:,j+3) = Donnees.EMG.Phasic.Classique.DP.ProfilMoyen(:,j+3)/maxDPbaisser;
            end
            
           Donnees_TRAITEE.EMGClassique.Profil_moyen_lever.DA(:,i) = Donnees.EMG.Phasic.Classique.DA.ProfilMoyen(:,1);
           Donnees_TRAITEE.EMGClassique.Profil_moyen_baisser.DA(:,i) = Donnees.EMG.Phasic.Classique.DA.ProfilMoyen(:,4);
           Donnees_TRAITEE.EMGClassique.Profil_moyen_lever.DP(:,i) = Donnees.EMG.Phasic.Classique.DP.ProfilMoyen(:,1);
           Donnees_TRAITEE.EMGClassique.Profil_moyen_baisser.DP(:,i) = Donnees.EMG.Phasic.Classique.DP.ProfilMoyen(:,4);

%-----------------------------
                      % ENREGISTREMENT DE DONNEES EMG DE CHAQUE SUJET - - - EMG TONIC LENT
           % On calcule le max
            maxDAlever = max(max(abs(Donnees.EMG.Phasic.TonicLent.DA.R)));
            maxDPlever = max(max(abs(Donnees.EMG.Phasic.TonicLent.DP.R)));
            maxDAbaisser = max(max(abs(Donnees.EMG.Phasic.TonicLent.DA.B)));
            maxDPbaisser = max(max(abs(Donnees.EMG.Phasic.TonicLent.DP.B)));

           % On normalise par le max du max
            for j=1:3
                Donnees.EMG.Phasic.TonicLent.DA.ProfilMoyen(:,j) = Donnees.EMG.Phasic.TonicLent.DA.ProfilMoyen(:,j)/maxDAlever;
                Donnees.EMG.Phasic.TonicLent.DA.ProfilMoyen(:,j+3) = Donnees.EMG.Phasic.TonicLent.DA.ProfilMoyen(:,j+3)/maxDAbaisser;
                Donnees.EMG.Phasic.TonicLent.DP.ProfilMoyen(:,j) = Donnees.EMG.Phasic.TonicLent.DP.ProfilMoyen(:,j)/maxDPlever;
                Donnees.EMG.Phasic.TonicLent.DP.ProfilMoyen(:,j+3) = Donnees.EMG.Phasic.TonicLent.DP.ProfilMoyen(:,j+3)/maxDPbaisser;
            end
            
           Donnees_TRAITEE.EMGTonicLent.Profil_moyen_lever.DA(:,i) = Donnees.EMG.Phasic.TonicLent.DA.ProfilMoyen(:,1);
           Donnees_TRAITEE.EMGTonicLent.Profil_moyen_baisser.DA(:,i) = Donnees.EMG.Phasic.TonicLent.DA.ProfilMoyen(:,4);
           Donnees_TRAITEE.EMGTonicLent.Profil_moyen_lever.DP(:,i) = Donnees.EMG.Phasic.TonicLent.DP.ProfilMoyen(:,1);
           Donnees_TRAITEE.EMGTonicLent.Profil_moyen_baisser.DP(:,i) = Donnees.EMG.Phasic.TonicLent.DP.ProfilMoyen(:,4);



    %% On enregistre les paramètres de quantification
           Donnees_TRAITEE.EMG.Quantif_desac.Tps_cum_inac_Lever(1,i) = Donnees.EMG.PhasicQuantif.DA(1,3); % on enregistre la moyenne des tps cumulés d'inactivation par muscle Se lever 
           Donnees_TRAITEE.EMG.Quantif_desac.Tps_cum_inac_Baisser(1,i) = Donnees.EMG.PhasicQuantif.DA(1,4);
           Donnees_TRAITEE.EMG.Quantif_desac.Tps_cum_inac_Lever(2,i) = Donnees.EMG.PhasicQuantif.DP(1,3); % on enregistre la moyenne des tps cumulés d'inactivation par muscle Se lever 
           Donnees_TRAITEE.EMG.Quantif_desac.Tps_cum_inac_Baisser(2,i) = Donnees.EMG.PhasicQuantif.DP(1,4);

           Donnees_TRAITEE.EMG.Quantif_desac.AmpLever(1,i) = Donnees.EMG.PhasicQuantif.DA(1,7); % on enregistre la moyenne des tps cumulés d'inactivation par muscle Se lever 
           Donnees_TRAITEE.EMG.Quantif_desac.AmpBaisser(1,i) = Donnees.EMG.PhasicQuantif.DA(1,8);
           Donnees_TRAITEE.EMG.Quantif_desac.AmpLever(2,i) = Donnees.EMG.PhasicQuantif.DP(1,7); % on enregistre la moyenne des tps cumulés d'inactivation par muscle Se lever 
           Donnees_TRAITEE.EMG.Quantif_desac.AmpBaisser(2,i) = Donnees.EMG.PhasicQuantif.DP(1,8);

           Donnees_TRAITEE.EMG.Quantif_desac.FreqLever(1,i) = Donnees.EMG.PhasicQuantif.DA(1,11); % on enregistre la moyenne des tps cumulés d'inactivation par muscle Se lever 
           Donnees_TRAITEE.EMG.Quantif_desac.FreqBaisser(1,i) = Donnees.EMG.PhasicQuantif.DA(1,12);
           Donnees_TRAITEE.EMG.Quantif_desac.FreqLever(2,i) = Donnees.EMG.PhasicQuantif.DP(1,11); % on enregistre la moyenne des tps cumulés d'inactivation par muscle Se lever 
           Donnees_TRAITEE.EMG.Quantif_desac.FreqBaisser(2,i) = Donnees.EMG.PhasicQuantif.DP(1,12);

            


    %% ENREGISTREMENT DE DONNEES CINEMATIQUE
            lengthRap = length(Donnees.cinematiques.Results_trial_by_trial(:,2));
            Donnees_TRAITEE.Cinematique.MD(1:lengthRap,i) = Donnees.cinematiques.Results_trial_by_trial(:,2);
            [lengthprofvit, colprofVit] = size(Donnees.cinematiques.Vel_cut_norm);
            
            [~,posmaxlever] = max(Donnees.cinematiques.Vel_cut_norm(:,1:colprofVit/2));
            [~,posmaxbaisser] = max(Donnees.cinematiques.Vel_cut_norm(:,1+colprofVit/2:colprofVit));
            disp('Ra lever ='+string(mean(posmaxlever)));
            disp('Ra baisser ='+string(mean(posmaxbaisser)));
            Donnees_TRAITEE.Cinematique.ProfVitLever(:,i) = posmaxlever.';
            Donnees_TRAITEE.Cinematique.ProfVitBaisser(:,i) = posmaxbaisser.';

            % On enregistre un profil moyen des profils de vitesse
            for f = 1:1000
                Donnees_TRAITEE.Cinematique.ProfVitLeverMoyen(f,i) = mean(Donnees.cinematiques.Vel_cut_norm(f,1:colprofVit/2));
                Donnees_TRAITEE.Cinematique.ProfVitBaisserMoyen(f,i) = mean(Donnees.cinematiques.Vel_cut_norm(f,1+colprofVit/2:colprofVit));
            end
   
     end


%% On affiche soit les phasics de tous les sujets soit le phasic moyen +/- std error
        disp('COMPARAISON PHASIC BRAS');

        for f = 1:1000
% Pour afficher la moyenne + erreur des sujets                           
            Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_lever.DA(f,1) = mean(Donnees_TRAITEE.EMGClassique.Profil_moyen_lever.DA(f,:));
            Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_lever.DA(f,2) = mean(Donnees_TRAITEE.EMGClassique.Profil_moyen_lever.DA(f,:))+std(Donnees_TRAITEE.EMGClassique.Profil_moyen_lever.DA(f,:))/sqrt(6);
            Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_lever.DA(f,3) = mean(Donnees_TRAITEE.EMGClassique.Profil_moyen_lever.DA(f,:))-std(Donnees_TRAITEE.EMGClassique.Profil_moyen_lever.DA(f,:))/sqrt(6);
            
            Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_descendre.DA(f,1) = mean(Donnees_TRAITEE.EMGClassique.Profil_moyen_baisser.DA(f,:));
            Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_descendre.DA(f,2) = mean(Donnees_TRAITEE.EMGClassique.Profil_moyen_baisser.DA(f,:))+std(Donnees_TRAITEE.EMGClassique.Profil_moyen_baisser.DA(f,:))/sqrt(6);
            Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_descendre.DA(f,3) = mean(Donnees_TRAITEE.EMGClassique.Profil_moyen_baisser.DA(f,:))-std(Donnees_TRAITEE.EMGClassique.Profil_moyen_baisser.DA(f,:))/sqrt(6);
    
            Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_lever.DP(f,1) = mean(Donnees_TRAITEE.EMGClassique.Profil_moyen_lever.DP(f,:));
            Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_lever.DP(f,2) = mean(Donnees_TRAITEE.EMGClassique.Profil_moyen_lever.DP(f,:))+std(Donnees_TRAITEE.EMGClassique.Profil_moyen_lever.DP(f,:))/sqrt(6);
            Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_lever.DP(f,3) = mean(Donnees_TRAITEE.EMGClassique.Profil_moyen_lever.DP(f,:))-std(Donnees_TRAITEE.EMGClassique.Profil_moyen_lever.DP(f,:))/sqrt(6);
            
            Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_descendre.DP(f,1) = mean(Donnees_TRAITEE.EMGClassique.Profil_moyen_baisser.DP(f,:));
            Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_descendre.DP(f,2) = mean(Donnees_TRAITEE.EMGClassique.Profil_moyen_baisser.DP(f,:))+std(Donnees_TRAITEE.EMGClassique.Profil_moyen_baisser.DP(f,:))/sqrt(6);
            Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_descendre.DP(f,3) = mean(Donnees_TRAITEE.EMGClassique.Profil_moyen_baisser.DP(f,:))-std(Donnees_TRAITEE.EMGClassique.Profil_moyen_baisser.DP(f,:))/sqrt(6);
 
        end

        for f = 1:1000
% Pour afficher la moyenne + erreur des sujets                           
            Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_lever.DA(f,1) = mean(Donnees_TRAITEE.EMGCombined.Profil_moyen_lever.DA(f,:));
            Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_lever.DA(f,2) = mean(Donnees_TRAITEE.EMGCombined.Profil_moyen_lever.DA(f,:))+std(Donnees_TRAITEE.EMGCombined.Profil_moyen_lever.DA(f,:))/sqrt(6);
            Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_lever.DA(f,3) = mean(Donnees_TRAITEE.EMGCombined.Profil_moyen_lever.DA(f,:))-std(Donnees_TRAITEE.EMGCombined.Profil_moyen_lever.DA(f,:))/sqrt(6);
            
            Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_descendre.DA(f,1) = mean(Donnees_TRAITEE.EMGCombined.Profil_moyen_baisser.DA(f,:));
            Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_descendre.DA(f,2) = mean(Donnees_TRAITEE.EMGCombined.Profil_moyen_baisser.DA(f,:))+std(Donnees_TRAITEE.EMGCombined.Profil_moyen_baisser.DA(f,:))/sqrt(6);
            Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_descendre.DA(f,3) = mean(Donnees_TRAITEE.EMGCombined.Profil_moyen_baisser.DA(f,:))-std(Donnees_TRAITEE.EMGCombined.Profil_moyen_baisser.DA(f,:))/sqrt(6);
    
            Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_lever.DP(f,1) = mean(Donnees_TRAITEE.EMGCombined.Profil_moyen_lever.DP(f,:));
            Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_lever.DP(f,2) = mean(Donnees_TRAITEE.EMGCombined.Profil_moyen_lever.DP(f,:))+std(Donnees_TRAITEE.EMGCombined.Profil_moyen_lever.DP(f,:))/sqrt(6);
            Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_lever.DP(f,3) = mean(Donnees_TRAITEE.EMGCombined.Profil_moyen_lever.DP(f,:))-std(Donnees_TRAITEE.EMGCombined.Profil_moyen_lever.DP(f,:))/sqrt(6);
            
            Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_descendre.DP(f,1) = mean(Donnees_TRAITEE.EMGCombined.Profil_moyen_baisser.DP(f,:));
            Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_descendre.DP(f,2) = mean(Donnees_TRAITEE.EMGCombined.Profil_moyen_baisser.DP(f,:))+std(Donnees_TRAITEE.EMGCombined.Profil_moyen_baisser.DP(f,:))/sqrt(6);
            Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_descendre.DP(f,3) = mean(Donnees_TRAITEE.EMGCombined.Profil_moyen_baisser.DP(f,:))-std(Donnees_TRAITEE.EMGCombined.Profil_moyen_baisser.DP(f,:))/sqrt(6);
 
        end

        for f = 1:1000
% Pour afficher la moyenne + erreur des sujets                           
            Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_lever.DA(f,1) = mean(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_lever.DA(f,:));
            Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_lever.DA(f,2) = mean(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_lever.DA(f,:))+std(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_lever.DA(f,:))/sqrt(6);
            Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_lever.DA(f,3) = mean(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_lever.DA(f,:))-std(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_lever.DA(f,:))/sqrt(6);
            
            Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_descendre.DA(f,1) = mean(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_baisser.DA(f,:));
            Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_descendre.DA(f,2) = mean(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_baisser.DA(f,:))+std(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_baisser.DA(f,:))/sqrt(6);
            Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_descendre.DA(f,3) = mean(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_baisser.DA(f,:))-std(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_baisser.DA(f,:))/sqrt(6);
    
            Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_lever.DP(f,1) = mean(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_lever.DP(f,:));
            Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_lever.DP(f,2) = mean(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_lever.DP(f,:))+std(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_lever.DP(f,:))/sqrt(6);
            Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_lever.DP(f,3) = mean(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_lever.DP(f,:))-std(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_lever.DP(f,:))/sqrt(6);
            
            Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_descendre.DP(f,1) = mean(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_baisser.DP(f,:));
            Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_descendre.DP(f,2) = mean(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_baisser.DP(f,:))+std(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_baisser.DP(f,:))/sqrt(6);
            Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_descendre.DP(f,3) = mean(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_baisser.DP(f,:))-std(Donnees_TRAITEE.EMGTonicLent.Profil_moyen_baisser.DP(f,:))/sqrt(6);
 
        end






% CALCUL RATIO ASSYMETRIES
for f = 1:1000
    Donnees_TRAITEE.Cinematique.ProfVitLeverMoyenMOYEN(f,1) = mean(Donnees_TRAITEE.Cinematique.ProfVitLeverMoyen(f,1:2));
    Donnees_TRAITEE.Cinematique.ProfVitBaisserMoyenMOYEN(f,1) = mean(Donnees_TRAITEE.Cinematique.ProfVitBaisserMoyen(f,1:2));
end

[Max_lever,posmaxlever] = max(Donnees_TRAITEE.Cinematique.ProfVitLeverMoyenMOYEN);
[Max_baisser,posmaxbaisser] = max(Donnees_TRAITEE.Cinematique.ProfVitBaisserMoyenMOYEN);
plot(Donnees_TRAITEE.Cinematique.ProfVitLeverMoyenMOYEN,'r');hold on
plot(Donnees_TRAITEE.Cinematique.ProfVitBaisserMoyenMOYEN,'b');hold on ; title('BRAS GAUCHE _ Ratio assymetrie');
y = ylim; % current y-axis limits
x = xlim; % current y-axis limits
plot([posmaxlever posmaxlever],[y(1) y(2)],'r'); hold on
plot([posmaxbaisser posmaxbaisser],[y(1) y(2)],'b');
lever = append('Lever ',string(posmaxlever/1000));
baisser = append('baisser ',string(posmaxbaisser/1000));
legend(lever,baisser)
xlabel('Temps normalisé') 
ylabel('Vitesse du marqueur index') 

for f = 1:12
    Donnees_TRAITEE.Cinematique.MD_moyen(f,1) = mean(Donnees_TRAITEE.Cinematique.MD(f,1:2));
    Donnees_TRAITEE.Cinematique.MD_moyen(f,2) = mean(Donnees_TRAITEE.Cinematique.MD(f+12,1:2));
end

XXX = mean(Donnees_TRAITEE.Cinematique.MD_moyen(:,1));
disp('MD MOYEN LEVER = '+string(XXX))
YYY = mean(Donnees_TRAITEE.Cinematique.MD_moyen(:,2));
disp('MD MOYEN BAISSER = '+string(YYY))







% Pour afficher les differents tonics
a=1; 

        Titre = append('MOUVEMENT BRAS  -  Muscle : ','DA');
        fig2 = figure('Name',Titre,'NumberTitle','off');
        set(gcf,'position',[200,200,1000,350])
        colororder(newcolors)

        subplot(1,2,1)
        plot(Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_lever.DA(:,1));hold on;
        plot(Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_lever.DA(:,1));hold on;
        plot(Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_lever.DA(:,1));
        r=(0.1:0.1:1000); y = zeros(length(r),1);plot(r,y,'r');title('Lever le bras');

        legend('Combined','Classique','TonicLent')
        %legend('Phasic (Tonic calculé sur mvt rapide)')
        legend('Orientation','vertical')
        legend('boxoff')
                
        subplot(1,2,2)
        plot(Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_descendre.DA(:,1));hold on;
        plot(Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_descendre.DA(:,1));hold on;
        plot(Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_descendre.DA(:,1));
        r=(0.1:0.1:1000); y = zeros(length(r),1);plot(r,y,'r');title('Baisser le bras');


        Titre = append('MOUVEMENT BRAS  -  Muscle : ','DP'); 
        fig = figure('Name',Titre,'NumberTitle','off');
        set(gcf,'position',[200,200,1000,350])
        colororder(newcolors)

        subplot(1,2,1)
        plot(Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_lever.DP(:,1));hold on;
        plot(Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_lever.DP(:,1));hold on;
        plot(Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_lever.DP(:,1));
        r=(0.1:0.1:1000); y = zeros(length(r),1);plot(r,y,'r');title('Lever le bras');

        legend('Combined','Classique','TonicLent')
        %legend('Phasic (Tonic calculé sur mvt rapide)')
        legend('Orientation','vertical')
        legend('boxoff')
                
        subplot(1,2,2)
        plot(Donnees_TRAITEE.EMGCombined.Moyenne.Profil_moyen_descendre.DP(:,1));hold on;
        plot(Donnees_TRAITEE.EMGClassique.Moyenne.Profil_moyen_descendre.DP(:,1));hold on;
        plot(Donnees_TRAITEE.EMGTonicLent.Moyenne.Profil_moyen_descendre.DP(:,1));hold on;
        r=(0.1:0.1:1000); y = zeros(length(r),1);plot(r,y,'r');title('Baisser le bras');



Donnees_to_export = Donnees_TRAITEE.EMG.Quantif_desac;

disp('Selectionnez le Dossier où enregistre les données.');
[Dossier] = uigetdir ('Selectionnez le Dossier où enregistre les données.');
save([Dossier '/BrasDroit'  ], 'Donnees_to_export');

disp('Données enregistrées avec succès !');