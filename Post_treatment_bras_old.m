
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
           i
           load (Fichier_traite);

           % ENREGISTREMENT DE DONNEES EMG
            [lig, col] = size (Donnees.EMG.Phasic.DA.nonsmooth.brut.R);
            [lig, col2] = size (Donnees.EMG.RMSCutNorm.DA);
            maxDAlever = max(max(Donnees.EMG.RMSCutNorm.DA(:,1:col2/12)));
            maxDPlever = max(max(Donnees.EMG.RMSCutNorm.DP(:,1:col2/12)));
            maxDAbaisser = max(max(Donnees.EMG.RMSCutNorm.DA(:,1+col2/12:col2)));
            maxDPbaisser = max(max(Donnees.EMG.RMSCutNorm.DP(:,1+col2/12:col2)));

            for f = 1:1000

                Donnees_TRAITEE.EMG.Profil_moyen_lever.DA(f,i) = mean(Donnees.EMG.Phasic.DA.nonsmooth.brut.R(f,1:col))/maxDAlever;
                Donnees_TRAITEE.EMG.Profil_moyen_lever_plus.DA(f,i) = mean(Donnees.EMG.Phasic.DA.nonsmooth.brut.R(f,1:col))+std(Donnees.EMG.Phasic.DA.nonsmooth.brut.R(f,1:col));
                Donnees_TRAITEE.EMG.Profil_moyen_lever_moins.DA(f,i) = mean(Donnees.EMG.Phasic.DA.nonsmooth.brut.R(f,1:col))-std(Donnees.EMG.Phasic.DA.nonsmooth.brut.R(f,1:col));
                Donnees_TRAITEE.EMG.Profil_moyen_lever.DP(f,i) = mean(Donnees.EMG.Phasic.DP.nonsmooth.brut.R(f,1:col))/maxDPlever;
                Donnees_TRAITEE.EMG.Profil_moyen_lever_plus.DP(f,i) = mean(Donnees.EMG.Phasic.DP.nonsmooth.brut.R(f,1:col))+std(Donnees.EMG.Phasic.DP.nonsmooth.brut.R(f,1:col));
                Donnees_TRAITEE.EMG.Profil_moyen_lever_moins.DP(f,i) = mean(Donnees.EMG.Phasic.DP.nonsmooth.brut.R(f,1:col))-std(Donnees.EMG.Phasic.DP.nonsmooth.brut.R(f,1:col));
                
                Donnees_TRAITEE.EMG.Profil_moyen_descendre.DA(f,i) = mean(Donnees.EMG.Phasic.DA.nonsmooth.brut.B(f,1:col))/maxDAbaisser;
                Donnees_TRAITEE.EMG.Profil_moyen_descendre_plus.DA(f,i) = mean(Donnees.EMG.Phasic.DA.nonsmooth.brut.B(f,1:col))+std(Donnees.EMG.Phasic.DA.nonsmooth.brut.B(f,1:col));
                Donnees_TRAITEE.EMG.Profil_moyen_descendre_moins.DA(f,i) = mean(Donnees.EMG.Phasic.DA.nonsmooth.brut.B(f,1:col))-std(Donnees.EMG.Phasic.DA.nonsmooth.brut.B(f,1:col));
                Donnees_TRAITEE.EMG.Profil_moyen_descendre.DP(f,i) = mean(Donnees.EMG.Phasic.DP.nonsmooth.brut.B(f,1:col))/maxDPbaisser;
                Donnees_TRAITEE.EMG.Profil_moyen_descendre_plus.DP(f,i) = mean(Donnees.EMG.Phasic.DP.nonsmooth.brut.B(f,1:col))+std(Donnees.EMG.Phasic.DP.nonsmooth.brut.B(f,1:col));
                Donnees_TRAITEE.EMG.Profil_moyen_descendre_moins.DP(f,i) = mean(Donnees.EMG.Phasic.DP.nonsmooth.brut.B(f,1:col))-std(Donnees.EMG.Phasic.DP.nonsmooth.brut.B(f,1:col));

            end

            %% POUR COMPARER TONIC MVT LENTS/DEBUTFIN
            [lig, col] = size (Donnees.EMG.Phasic_MVT_lent.DA.R);

            for f = 1:1000

                Donnees_TRAITEE.EMG.Profil_moyen_leverMVTLENT.DA(f,i) = mean(Donnees.EMG.Phasic_MVT_lent.DA.R(f,1:col))/maxDAlever;
%                 Donnees_TRAITEE.EMG.Profil_moyen_lever_plus.DA(f,i) = mean(Donnees.EMG.PhasicNorm.DA.nonsmooth.R(f,1:col-1))+std(Donnees.EMG.PhasicNorm.DA.nonsmooth.R(f,1:col-1));
%                 Donnees_TRAITEE.EMG.Profil_moyen_lever_moins.DA(f,i) = mean(Donnees.EMG.PhasicNorm.DA.nonsmooth.R(f,1:col-1))-std(Donnees.EMG.PhasicNorm.DA.nonsmooth.R(f,1:col-1));
                Donnees_TRAITEE.EMG.Profil_moyen_leverMVTLENT.DP(f,i) = mean(Donnees.EMG.Phasic_MVT_lent.DP.R(f,1:col))/maxDPlever;
%                 Donnees_TRAITEE.EMG.Profil_moyen_lever_plus.DP(f,i) = mean(Donnees.EMG.PhasicNorm.DP.nonsmooth.R(f,1:col-1))+std(Donnees.EMG.PhasicNorm.DP.nonsmooth.R(f,1:col-1));
%                 Donnees_TRAITEE.EMG.Profil_moyen_lever_moins.DP(f,i) = mean(Donnees.EMG.PhasicNorm.DP.nonsmooth.R(f,1:col-1))-std(Donnees.EMG.PhasicNorm.DP.nonsmooth.R(f,1:col-1));
%                 
                Donnees_TRAITEE.EMG.Profil_moyen_descendreMVTLENT.DA(f,i) = mean(Donnees.EMG.Phasic_MVT_lent.DA.B(f,1:col))/maxDAbaisser;
%                 Donnees_TRAITEE.EMG.Profil_moyen_descendre_plus.DA(f,i) = mean(Donnees.EMG.PhasicNorm.DA.nonsmooth.B(f,1:col-1))+std(Donnees.EMG.PhasicNorm.DA.nonsmooth.B(f,1:col-1));
%                 Donnees_TRAITEE.EMG.Profil_moyen_descendre_moins.DA(f,i) = mean(Donnees.EMG.PhasicNorm.DA.nonsmooth.B(f,1:col-1))-std(Donnees.EMG.PhasicNorm.DA.nonsmooth.B(f,1:col-1));
                Donnees_TRAITEE.EMG.Profil_moyen_descendreMVTLENT.DP(f,i) = mean(Donnees.EMG.Phasic_MVT_lent.DP.B(f,1:col))/maxDPbaisser;
%                 Donnees_TRAITEE.EMG.Profil_moyen_descendre_plus.DP(f,i) = mean(Donnees.EMG.PhasicNorm.DP.nonsmooth.B(f,1:col-1))+std(Donnees.EMG.PhasicNorm.DP.nonsmooth.B(f,1:col-1));
%                 Donnees_TRAITEE.EMG.Profil_moyen_descendre_moins.DP(f,i) = mean(Donnees.EMG.PhasicNorm.DP.nonsmooth.B(f,1:col-1))-std(Donnees.EMG.PhasicNorm.DP.nonsmooth.B(f,1:col-1));

            end
           
    %% On enregistre les paramètres de quantification
           Donnees_TRAITEE.EMG.Quantif_desac.Tps_cum_inac_Lever(1,i) = Donnees.EMG.Phasic.DA.QuantifDesac(1,3); % on enregistre la moyenne des tps cumulés d'inactivation par muscle Se lever 
           Donnees_TRAITEE.EMG.Quantif_desac.Tps_cum_inac_Baisser(1,i) = Donnees.EMG.Phasic.DA.QuantifDesac(1,4);
           Donnees_TRAITEE.EMG.Quantif_desac.Tps_cum_inac_Lever(2,i) = Donnees.EMG.Phasic.DP.QuantifDesac(1,3); % on enregistre la moyenne des tps cumulés d'inactivation par muscle Se lever 
           Donnees_TRAITEE.EMG.Quantif_desac.Tps_cum_inac_Baisser(2,i) = Donnees.EMG.Phasic.DP.QuantifDesac(1,4);

           Donnees_TRAITEE.EMG.Quantif_desac.AmpLever(1,i) = Donnees.EMG.Phasic.DA.QuantifDesac(1,7); % on enregistre la moyenne des tps cumulés d'inactivation par muscle Se lever 
           Donnees_TRAITEE.EMG.Quantif_desac.AmpBaisser(1,i) = Donnees.EMG.Phasic.DA.QuantifDesac(1,8);
           Donnees_TRAITEE.EMG.Quantif_desac.AmpLever(2,i) = Donnees.EMG.Phasic.DP.QuantifDesac(1,7); % on enregistre la moyenne des tps cumulés d'inactivation par muscle Se lever 
           Donnees_TRAITEE.EMG.Quantif_desac.AmpBaisser(2,i) = Donnees.EMG.Phasic.DP.QuantifDesac(1,8);

           Donnees_TRAITEE.EMG.Quantif_desac.FreqLever(1,i) = Donnees.EMG.Phasic.DA.QuantifDesac(1,11); % on enregistre la moyenne des tps cumulés d'inactivation par muscle Se lever 
           Donnees_TRAITEE.EMG.Quantif_desac.FreqBaisser(1,i) = Donnees.EMG.Phasic.DA.QuantifDesac(1,12);
           Donnees_TRAITEE.EMG.Quantif_desac.FreqLever(2,i) = Donnees.EMG.Phasic.DP.QuantifDesac(1,11); % on enregistre la moyenne des tps cumulés d'inactivation par muscle Se lever 
           Donnees_TRAITEE.EMG.Quantif_desac.FreqBaisser(2,i) = Donnees.EMG.Phasic.DP.QuantifDesac(1,12);

            
    %% ENREGISTREMENT DE DONNEES CINEMATIQUE
            lengthRap = length(Donnees.cinematiques.Results_trial_by_trial(:,2));
            Donnees_TRAITEE.Cinematique.MD(1:lengthRap,i) = Donnees.cinematiques.Results_trial_by_trial(:,2);
            [lengthprofvit, colprofVit] = size(Donnees.cinematiques.Vel_cut_norm);
            
            [Max_lever,posmaxlever] = max(Donnees.cinematiques.Vel_cut_norm(:,1:colprofVit/2));
            [Max_baisser,posmaxbaisser] = max(Donnees.cinematiques.Vel_cut_norm(:,1+colprofVit/2:colprofVit));
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
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_lever.DA(f,1) = mean(Donnees_TRAITEE.EMG.Profil_moyen_lever.DA(f,:));
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_lever.DA(f,2) = mean(Donnees_TRAITEE.EMG.Profil_moyen_lever.DA(f,:))+std(Donnees_TRAITEE.EMG.Profil_moyen_lever.DA(f,:))/sqrt(12);
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_lever.DA(f,3) = mean(Donnees_TRAITEE.EMG.Profil_moyen_lever.DA(f,:))-std(Donnees_TRAITEE.EMG.Profil_moyen_lever.DA(f,:))/sqrt(12);
            
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendre.DA(f,1) = mean(Donnees_TRAITEE.EMG.Profil_moyen_descendre.DA(f,:));
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendre.DA(f,2) = mean(Donnees_TRAITEE.EMG.Profil_moyen_descendre.DA(f,:))+std(Donnees_TRAITEE.EMG.Profil_moyen_descendre.DA(f,:))/sqrt(12);
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendre.DA(f,3) = mean(Donnees_TRAITEE.EMG.Profil_moyen_descendre.DA(f,:))-std(Donnees_TRAITEE.EMG.Profil_moyen_descendre.DA(f,:))/sqrt(12);
    
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_lever.DP(f,1) = mean(Donnees_TRAITEE.EMG.Profil_moyen_lever.DP(f,:));
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_lever.DP(f,2) = mean(Donnees_TRAITEE.EMG.Profil_moyen_lever.DP(f,:))+std(Donnees_TRAITEE.EMG.Profil_moyen_lever.DP(f,:))/sqrt(12);
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_lever.DP(f,3) = mean(Donnees_TRAITEE.EMG.Profil_moyen_lever.DP(f,:))-std(Donnees_TRAITEE.EMG.Profil_moyen_lever.DP(f,:))/sqrt(12);
            
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendre.DP(f,1) = mean(Donnees_TRAITEE.EMG.Profil_moyen_descendre.DP(f,:));
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendre.DP(f,2) = mean(Donnees_TRAITEE.EMG.Profil_moyen_descendre.DP(f,:))+std(Donnees_TRAITEE.EMG.Profil_moyen_descendre.DP(f,:))/sqrt(12);
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendre.DP(f,3) = mean(Donnees_TRAITEE.EMG.Profil_moyen_descendre.DP(f,:))-std(Donnees_TRAITEE.EMG.Profil_moyen_descendre.DP(f,:))/sqrt(12);
 

            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_leverMVTLENT.DA(f,1) = mean(Donnees_TRAITEE.EMG.Profil_moyen_leverMVTLENT.DA(f,:));
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_leverMVTLENT.DA(f,2) = mean(Donnees_TRAITEE.EMG.Profil_moyen_leverMVTLENT.DA(f,:))+std(Donnees_TRAITEE.EMG.Profil_moyen_leverMVTLENT.DA(f,:))/sqrt(12);
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_leverMVTLENT.DA(f,3) = mean(Donnees_TRAITEE.EMG.Profil_moyen_leverMVTLENT.DA(f,:))-std(Donnees_TRAITEE.EMG.Profil_moyen_leverMVTLENT.DA(f,:))/sqrt(12);
            
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendreMVTLENT.DA(f,1) = mean(Donnees_TRAITEE.EMG.Profil_moyen_descendreMVTLENT.DA(f,:));
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendreMVTLENT.DA(f,2) = mean(Donnees_TRAITEE.EMG.Profil_moyen_descendreMVTLENT.DA(f,:))+std(Donnees_TRAITEE.EMG.Profil_moyen_descendreMVTLENT.DA(f,:))/sqrt(12);
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendreMVTLENT.DA(f,3) = mean(Donnees_TRAITEE.EMG.Profil_moyen_descendreMVTLENT.DA(f,:))-std(Donnees_TRAITEE.EMG.Profil_moyen_descendreMVTLENT.DA(f,:))/sqrt(12);
    
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_leverMVTLENT.DP(f,1) = mean(Donnees_TRAITEE.EMG.Profil_moyen_leverMVTLENT.DP(f,:));
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_leverMVTLENT.DP(f,2) = mean(Donnees_TRAITEE.EMG.Profil_moyen_leverMVTLENT.DP(f,:))+std(Donnees_TRAITEE.EMG.Profil_moyen_leverMVTLENT.DP(f,:))/sqrt(12);
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_leverMVTLENT.DP(f,3) = mean(Donnees_TRAITEE.EMG.Profil_moyen_leverMVTLENT.DP(f,:))-std(Donnees_TRAITEE.EMG.Profil_moyen_leverMVTLENT.DP(f,:))/sqrt(12);
            
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendreMVTLENT.DP(f,1) = mean(Donnees_TRAITEE.EMG.Profil_moyen_descendreMVTLENT.DP(f,:));
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendreMVTLENT.DP(f,2) = mean(Donnees_TRAITEE.EMG.Profil_moyen_descendreMVTLENT.DP(f,:))+std(Donnees_TRAITEE.EMG.Profil_moyen_descendreMVTLENT.DP(f,:))/sqrt(12);
            Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendreMVTLENT.DP(f,3) = mean(Donnees_TRAITEE.EMG.Profil_moyen_descendreMVTLENT.DP(f,:))-std(Donnees_TRAITEE.EMG.Profil_moyen_descendreMVTLENT.DP(f,:))/sqrt(12);

        end






% CALCUL RATIO ASSYMETRIES
for f = 1:1000
    Donnees_TRAITEE.Cinematique.ProfVitLeverMoyenMOYEN(f,1) = mean(Donnees_TRAITEE.Cinematique.ProfVitLeverMoyen(f,1:10));
    Donnees_TRAITEE.Cinematique.ProfVitBaisserMoyenMOYEN(f,1) = mean(Donnees_TRAITEE.Cinematique.ProfVitBaisserMoyen(f,1:10));
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
    Donnees_TRAITEE.Cinematique.MD_moyen(f,1) = mean(Donnees_TRAITEE.Cinematique.MD(f,1:10));
    Donnees_TRAITEE.Cinematique.MD_moyen(f,2) = mean(Donnees_TRAITEE.Cinematique.MD(f+12,1:10));
end

XXX = mean(Donnees_TRAITEE.Cinematique.MD_moyen(:,1));
disp('MD MOYEN LEVER = '+string(XXX))
YYY = mean(Donnees_TRAITEE.Cinematique.MD_moyen(:,2));
disp('MD MOYEN BAISSER = '+string(YYY))







% Pour afficher les differents tonics
a=1; 

        Titre = append('MOUVEMENT BRAS  -  Muscle : ','DA');
        fig = figure('Name',Titre,'NumberTitle','off');
        set(gcf,'position',[200,200,1000,350])
        colororder(newcolors)

        subplot(1,2,1)
        plot(Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_lever.DA(:,1));hold on;
        plot(Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_leverMVTLENT.DA(:,1));
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'r');title('Lever le bras');

        legend('Phasic (Tonic calculé sur mvt rapide)','Phasic (Tonic calculé avec mvt lent)')
        legend('Orientation','vertical')
        legend('boxoff')
                
        subplot(1,2,2)
        plot(Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendre.DA(:,1));hold on;
        plot(Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendreMVTLENT.DA(:,1));
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'r');title('Baisser le bras');


        Titre = append('MOUVEMENT BRAS  -  Muscle : ','DP'); fig = figure('Name',Titre,'NumberTitle','off');
        set(gcf,'position',[200,200,1000,350])
        colororder(newcolors)

        subplot(1,2,1)
        plot(Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_lever.DP(:,1));hold on;
        plot(Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_leverMVTLENT.DP(:,1));
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'r');title('Lever le bras');

        legend('Phasic (Tonic calculé sur mvt rapide)','Phasic (Tonic calculé avec mvt lent)')
        legend('Orientation','vertical')
        legend('boxoff')
                
        subplot(1,2,2)
        plot(Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendre.DP(:,1));hold on;
        plot(Donnees_TRAITEE.EMG.Moyenne.Profil_moyen_descendreMVTLENT.DP(:,1));
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'r');title('Baisser le bras');



Donnees_to_export = Donnees_TRAITEE.EMG.Quantif_desac;

disp('Selectionnez le Dossier où enregistre les données.');
[Dossier] = uigetdir ('Selectionnez le Dossier où enregistre les données.');
save([Dossier '/BrasDroit'  ], 'Donnees_to_export');

disp('Données enregistrées avec succès !');