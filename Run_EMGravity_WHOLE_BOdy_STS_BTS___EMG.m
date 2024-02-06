   



%% Script -----EMG----- 
% Script to be used to compute EMG parameters. The script uses files that
% are already processed regarding the kinematics.
%%




close all
clear all

%% Informations on data processing
% Data for kinematic
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
delay2 = 0;%40; % Nb d'images (Cinématiques) à ajouter pour compenser l'EMD et les 5% mvts rapides
delay = 0;
pourcen_amp = 0.05;

% EMG constants
anticip_rap_aller1 = 0.239; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Aller Pre
anticip_rap_aller2 = 0.089; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Aller Post
anticip_rap_retour1 = 0.239; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Retour Pre
anticip_rap_retour2 = 0.089;  % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Reour Post
anticip2 = 0.075; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT lent 
emg_frequency = 1000; % Fréquence d'acquisition du signal EMG
Nb_emgs = 16; % Spécification du nombre de channels EMG
rms_window = 100; % Time in ms of the window used to compute sliding root mean square of EMG
rms_window_step = (rms_window/1000)*emg_frequency;
emg_div_kin_freq = emg_frequency/Frequence_acquisition; %used to synchronized emg cutting (for sliding rms) with regard to kinematics
NB_SD = 15; % Nombre d'écart-types utilisé pour détecter le début/fin du mouvement lent
limite_en_temps = 0.04; % en ms, correspond au temps minimal pour considérer une désactivation
duration_tonic = 250; % Durée (en ms) de moyennage du tonic
anticip_tonic = 250; % Durée (en ms) pour avoir le dernier point du tonic avant le mouvement et le premier point du tonic après le mouvement
EMD = 0.100;%0.076; % délai electromécanique moyen de tous les muscles
Nb_averaged_trials = 2;
ordre_filtre_phasic = 3;
passebas_filtre_phasic = 10;

%% Importation des données

%On selectionne le repertoire
disp('Selectionnez le Dossier regroupant donnees');
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');

if (Dossier ~= 0) %Si on clique sur un dossier
    
    Extension = '*.mat'; %Traite tous les .mat
    Chemin = fullfile(Dossier, Extension); % On construit le chemin
    ListeFichier = dir(Chemin); % On construit la liste des fichiers

% %% On crée les matrices de résultats

    Premiere_fois = true; % Pour n'effecteur certaines actions de lecture des labels qu'une seule fois
    
%% On procède au balayage fichier par fichier
    disp('POST TRAITEMENT MOUVEMENTS LENTS')
    disp(append('Il y a ', string(numel(ListeFichier)),' fichiers à analyser.'));
    
for YY = 1: numel(ListeFichier)
    Fichier_traite = [Dossier '\' ListeFichier(YY).name]; %On charge le fichier .mat
    disp(append('i = ',string(YY)));
    load (Fichier_traite);

    if Premiere_fois 
        Nb_emgs = length(Donnees.EMG_lent(1).C3DLENT.EMG.Labels); %% On compte le nombre d'EMG présents dans le fichier
        Premiere_fois = false;
        disp(append('Il y a ',string(Nb_emgs),' signaux EMG'));
    end

        
    for i = 1: length(Donnees.EMG_lent)
        disp(i)
        %On recharge les données cinématiques des mvts lents
        Donnees_cinematiques_TL(YY) = Donnees.cinematiques_TL;
      
        %On crée une matrice de la position de l'épaule
     
%% Calcul des paramètres electromyographiques

        %On calcule la taille de la matrice contenant les EMG
        size_emg_data = Donnees.EMG_lent(i).C3DLENT.Cinematique.FrameFin *emg_div_kin_freq;

        % On crée la matrice contenant les EMG

        emg_data = Donnees.EMG_lent(i).data;

        %calcule le début et la fin du mouvement sur l'ensemble du signal
        %cinématique

        onset_1 = (Donnees.cinematiques_TL.debut_fin(i,1)-delay);
        offset_1 = (Donnees.cinematiques_TL.debut_fin(i,2)+delay);
        onset_2 = (Donnees.cinematiques_TL.debut_fin(i,3)-delay);
        offset_2 = (Donnees.cinematiques_TL.debut_fin(i,4)+delay);

    %On calcule les paramètres emg du premier mouvement

%         if  YY==555%5 && i ==1 % For young STS%%%%%%%%%%%%     YY==5 && i ==1 % For young STS
%             [rms_cuts_1, rms_cuts_norm_1, ~, ...
%             ~, ~, ...
%             rms_cut_lig_1, ~, ~, ...
%             ~] = compute_emg_WB_TL(emg_data, Nb_emgs, emg_frequency, ...
%             emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step, onset_1, offset_1, ...
%             emg_div_kin_freq, 0.7,emg_ech_norm, duration_tonic, anticip_tonic);
%         else
            [rms_cuts_1, rms_cuts_norm_1, ~, ...
            ~, ~, ...
            rms_cut_lig_1, ~, ~, ...
            ~] = compute_emg_WB_TL(emg_data, Nb_emgs, emg_frequency, ...
            emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step, onset_1, offset_1, ...
            emg_div_kin_freq, anticip2,emg_ech_norm, duration_tonic, anticip_tonic);
%         end
        % On calcule les pramètres EMG du second mouvement

        
%         if  YY==55 %YY == 14 && i == 6 %FOR OLD STS       YY==3 && i ==6 || YY==5 && i ==1 || YY==14 && i ==1 || YY==14 && i ==6% FOR YOUNG STS BTS    
%             [rms_cuts_2, rms_cuts_norm_2, emg_rms, ...
%             emg_filt, emg_rect_filt, ...
%             rms_cut_lig_2, emg_data_filtre_rms_lig, emg_data_filtre_lig, ...
%             emg_data_filtre_rect_second_lig] = compute_emg_WB_TL(emg_data, Nb_emgs, emg_frequency, ...
%             emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step, onset_2, offset_2, ...
%             emg_div_kin_freq,  0.75, emg_ech_norm, duration_tonic, anticip_tonic);
%         else
            [rms_cuts_2, rms_cuts_norm_2, emg_rms, ...
            emg_filt, emg_rect_filt, ...
            rms_cut_lig_2, emg_data_filtre_rms_lig, emg_data_filtre_lig, ...
            emg_data_filtre_rect_second_lig] = compute_emg_WB_TL(emg_data, Nb_emgs, emg_frequency, ...
            emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step, onset_2, offset_2, ...
            emg_div_kin_freq,  anticip2, emg_ech_norm, duration_tonic, anticip_tonic);
%         end

%% On construit les matrices de résultats des EMG
        Donnees_EMG_TL(YY).name = Donnees.NOM;
            o=0;
            for m = 1:Nb_emgs
                Donnees_EMG_TL(YY).Brutes(1:size_emg_data, o+i) = emg_data(1:size_emg_data, m);   
                Donnees_EMG_TL(YY).Filtrees(1:emg_data_filtre_lig, o+i) = emg_filt(1:emg_data_filtre_lig, m);
                Donnees_EMG_TL(YY).Rectifiees(1:emg_data_filtre_rect_second_lig, o+i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, m);
                Donnees_EMG_TL(YY).RMS(1:emg_data_filtre_rms_lig, o+i) = emg_rms(1:emg_data_filtre_rms_lig, m);  
%                 Donnees_EMG_TL(YY).Tonic_start1(1:length(tonic_start_1), o+i) = tonic_start_1(1:length(tonic_start_1), m);
%                 Donnees_EMG_TL(YY).Tonic_end1(1:length(tonic_end_1), o+i) = tonic_end_1(1:length(tonic_end_1), m);  

                Donnees_EMG_TL(YY).RMSCut(1:rms_cut_lig_1, o+i) = rms_cuts_1(1:rms_cut_lig_1, m);
                Donnees_EMG_TL(YY).RMSCut(1:rms_cut_lig_2, o+i+Nb_emgs*length(Donnees.EMG_lent)) = rms_cuts_2(1:rms_cut_lig_2, m);
                Donnees_EMG_TL(YY).RMSCutNorm(1:emg_ech_norm, o+i) = rms_cuts_norm_1(1:emg_ech_norm, m); 
                Donnees_EMG_TL(YY).RMSCutNorm(1:emg_ech_norm, o+i+Nb_emgs*length(Donnees.EMG_lent)) = rms_cuts_norm_2(1:emg_ech_norm, m);
%                 Donnees_EMG_TL(YY).Tonic_start2(1:length(tonic_start_2), o+i) = tonic_start_2(1:length(tonic_start_2), m);
%                 Donnees_EMG_TL(YY).Tonic_end2(1:length(tonic_end_2), o+i) = tonic_end_2(1:length(tonic_end_2), m);  
                o = o+length(Donnees.EMG_lent);
            end

     end




%% Données moyennes se lever
    [~,nb_col] = size(Donnees.cinematiques_TL.Vel_cut_norm);
    a=1;
    b=nb_col/2;
    for f = 1:Ech_norm_kin
        o=0;
        p=0;
        for m = 1:Nb_emgs


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSERER CODE POUR MOUVEMENT ET GROUP CORRESPONDANT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2);
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));

            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSERER CODE POUR MOUVEMENT ET GROUP CORRESPONDANT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            o = o+length(Donnees.EMG_lent);
            p= p+3;

        end

    end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PARTIE SUR LES MVTS RAPIDES %% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    %% On procède au balayage fichier par fichier
    disp('POST TRAITEMENT MOUVEMENTS RAPIDES')

     for i = 1: length(Donnees.EMG) 
         disp(i)

         %On recharge les données cinématiques des mvts rapides
        Donnees_cinematiques(YY) = Donnees.cinematiques;     
        
         %% Calcul des paramètres electromyographiques

        %On calcule la taille de la matrice contenant les EMG
        size_emg_data = Donnees.EMG(i).C3D.Cinematique.FrameFin*emg_div_kin_freq;

        % On crée la matrice contenant les EMG

        emg_data = Donnees.EMG(i).data;
        %calcule le début et la fin du mouvement sur l'ensemble du signal
        %cinématique

        onset_1 = (Donnees.cinematiques.debut_fin(i,1)-delay2);
        offset_1 = (Donnees.cinematiques.debut_fin(i,2)+delay2);
        onset_2 = (Donnees.cinematiques.debut_fin(i,3)-delay2);
        offset_2 = (Donnees.cinematiques.debut_fin(i,4)+delay2);

        %On calcule les paramètres emg du premier mouvement
        [rms_cuts_1, rms_cuts_norm_1, ~, ...
            ~, ~, ...
            rms_cut_lig_1, ~, ~, ...
            ~, tonic_start_1, tonic_end_1] = compute_emg_WB(emg_data, Nb_emgs, emg_frequency, ...
            emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step, onset_1, offset_1, ...
            emg_div_kin_freq, anticip_rap_aller1, anticip_rap_aller2,emg_ech_norm, duration_tonic, anticip_tonic);

        % On calcule les pramètres EMG du second mouvement

        [rms_cuts_2, rms_cuts_norm_2, emg_rms, ...
            emg_filt, emg_rect_filt, ...
            rms_cut_lig_2, emg_data_filtre_rms_lig, emg_data_filtre_lig, ...
            emg_data_filtre_rect_second_lig, tonic_start_2, tonic_end_2] = compute_emg_WB(emg_data, Nb_emgs, emg_frequency, ...
            emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step, onset_2, offset_2, ...
            emg_div_kin_freq, anticip_rap_retour1, anticip_rap_retour2,emg_ech_norm, duration_tonic, anticip_tonic);
        
        %% On construit les matrices de résultats des EMG
        o=0;
        for m = 1:Nb_emgs
            Donnees_EMG(YY).Brutes(1:size_emg_data, o+i) = emg_data(1:size_emg_data, m);   
            Donnees_EMG(YY).Filtrees(1:emg_data_filtre_lig, o+i) = emg_filt(1:emg_data_filtre_lig, m);
            Donnees_EMG(YY).Rectifiees(1:emg_data_filtre_rect_second_lig, o+i) = emg_rect_filt(1:emg_data_filtre_rect_second_lig, m);
            Donnees_EMG(YY).RMS(1:emg_data_filtre_rms_lig, o+i) = emg_rms(1:emg_data_filtre_rms_lig, m);  
            Donnees_EMG(YY).Tonic_start(1:length(tonic_start_1), o+i) = tonic_start_1(1:length(tonic_start_1), m);
            Donnees_EMG(YY).Tonic_end(1:length(tonic_end_1), o+i) = tonic_end_1(1:length(tonic_end_1), m);  
            Donnees_EMG(YY).Tonic_start(1:length(tonic_start_2), o+i+Nb_emgs*length(Donnees.EMG)) = tonic_start_2(1:length(tonic_start_2), m);
            Donnees_EMG(YY).Tonic_end(1:length(tonic_end_2), o+i+Nb_emgs*length(Donnees.EMG)) = tonic_end_2(1:length(tonic_end_2), m);  

            Donnees_EMG(YY).RMSCut(1:rms_cut_lig_1, o+i) = rms_cuts_1(1:rms_cut_lig_1, m);
            Donnees_EMG(YY).RMSCut(1:rms_cut_lig_2, o+i+Nb_emgs*length(Donnees.EMG)) = rms_cuts_2(1:rms_cut_lig_2, m);
            Donnees_EMG(YY).RMSCutNorm(1:emg_ech_norm, o+i) = rms_cuts_norm_1(1:emg_ech_norm, m); 
            Donnees_EMG(YY).RMSCutNorm(1:emg_ech_norm, o+i+Nb_emgs*length(Donnees.EMG)) = rms_cuts_norm_2(1:emg_ech_norm, m);
            
            o = o+length(Donnees.EMG);
        end

    end

%% Données moyennes se lever/ se rassoir
[nb_ligne,nb_col] = size(Donnees.cinematiques_TL.Vel_cut_norm);
a=1;
b=nb_col/2;
for f = 1:Ech_norm_kin
    o=0;
    p=0;
    for m = 1:Nb_emgs
        Donnees_EMG(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG(YY).RMSCutNorm(f,a+o:b+o),2);
        Donnees_EMG(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG(YY).RMSCutNorm(f,a+o:b+o),2)+std(Donnees_EMG(YY).RMSCutNorm(f,a+o:b+o));
        Donnees_EMG(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG(YY).RMSCutNorm(f,a+o:b+o),2)-std(Donnees_EMG(YY).RMSCutNorm(f,a+o:b+o));
        
        Donnees_EMG(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG)+a+o:Nb_emgs*length(Donnees.EMG)+b+o),2);
        Donnees_EMG(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG)+a+o:Nb_emgs*length(Donnees.EMG)+b+o),2)+std(Donnees_EMG(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG)+a+o:Nb_emgs*length(Donnees.EMG)+b+o));
        Donnees_EMG(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG)+a+o:Nb_emgs*length(Donnees.EMG)+b+o),2)-std(Donnees_EMG(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG)+a+o:Nb_emgs*length(Donnees.EMG)+b+o));
        o = o+length(Donnees.EMG);
        p= p+3;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calcul PHAISC Avec tonic lent
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[l, nb_col_rms] = size(Donnees_EMG(YY).RMSCutNorm);
i = 1;
j = 1;
compteur_essais = 0;

while j <= nb_col_rms/2 % On ne balaye que la moitié des colonnes car on sépare entre les deux types de mvts
    
    % Calcul du tonic en soustrayant à chaque RMS des essais rapides la moyenne RMS des essais lents
    Donnees_EMG(YY).Phasic.TonicLent.Se_lever(1:emg_ech_norm, j) = Donnees_EMG(YY).RMSCutNorm(:, j)-Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(:, i);
	Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(1:emg_ech_norm, j) = Donnees_EMG(YY).RMSCutNorm(:, j+nb_col_rms/2)-Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(:, i);

    j= j+1;
    compteur_essais = compteur_essais+1;      % Pour soustraire le même tonic moyenné à chaque essai rapide
    if compteur_essais == length(Donnees.EMG) % On passe au prochain tonic ( il y en a autant que d'EMG)
        i = i+4;                              % +4 car on utilise les profils moyens (col moyenne   col +SD   col -SD   col vide)
        compteur_essais = 0;
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Partie qui permet de trier les essais par vitesse, de les moyenner par trois pour phasic classique et combined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 SortVmean_R = Donnees_cinematiques(YY).Results_trial_by_trial(1:length(Donnees.EMG), 9);
 SortVmean_B = Donnees_cinematiques(YY).Results_trial_by_trial((length(Donnees.EMG)+1):(2*length(Donnees.EMG)), 9);
 [~, Idx_R] = sort(SortVmean_R);
 [~, Idx_B] = sort(SortVmean_B);
 
 % On sauve l'index pour trier aussi les phasiques
 Idx = {};
 Idx.R = Idx_R;
 Idx.B = Idx_B;
 Idx.Vmean_R = SortVmean_R(Idx_R);
 Idx.Vmean_B = SortVmean_B(Idx_B);
 Idx.EMD = EMD*emg_frequency;
 Idx.anticip = anticip2*emg_frequency;
 Idx.Nb_averaged_trials = Nb_averaged_trials;
 MD_R_to_be_sorted = Donnees_cinematiques(YY).Results_trial_by_trial(1:length(Donnees.EMG),2);
 MD_B_to_be_sorted = Donnees_cinematiques(YY).Results_trial_by_trial(length(Donnees.EMG)+1:end,2);
 Idx.MD_R = MD_R_to_be_sorted(Idx_R);
 Idx.MD_B = MD_B_to_be_sorted(Idx_B);
 Idx.nb = length(Donnees.EMG);
 Donnees_EMG(YY).Idx = Idx;

 %% Pour détection négativité il faut la variabilité du Zéro, on récupère les phases stables rapides et lentes

% On récupère 10ms autour des clics phases stables mouvements lents

    for comp = 1:Nb_emgs
        for acqui=1:6
            if (YY==5 && acqui ==6) || (YY==9 && acqui ==1) || (YY==23 && acqui ==4) || (YY==24 && acqui ==4) || (YY==7 && acqui ==6)
                clic = Donnees_cinematiques_TL(YY).clics(acqui,1);
                Donnees_EMG_TL(YY).Phases_Stables(1:100,(comp-1)*6+acqui) = Donnees_EMG_TL(YY).RMS(clic-31:clic+68,(comp-1)*6+acqui);
            else
                clic = Donnees_cinematiques_TL(YY).clics(acqui,1);
                Donnees_EMG_TL(YY).Phases_Stables(1:100,(comp-1)*6+acqui) = Donnees_EMG_TL(YY).RMS(clic-49:clic+50,(comp-1)*6+acqui);
            end
        end
    end

            
           



% On récupère 10ms autour des clics phases stables mouvements rapides
for comp = 1:Nb_emgs
    for acqui=1:12
        clic = Donnees_cinematiques(YY).clics(acqui,1);
        Donnees_EMG(YY).Phases_Stables(1:100,(comp-1)*12+acqui) = Donnees_EMG(YY).RMS(clic:clic+99,(comp-1)*12+acqui);
        
    end
end

%% MVT LENTS Mean des phases stables
a=1;
for comp =1:6:96
    for f = 1 : 100
        Donnees_EMG_TL(YY).Phases_Stables_mean(f,a) = mean(Donnees_EMG_TL(YY).Phases_Stables(f,comp:comp+5));
    end
    a=a+1;
%     comp
end



%%  Calculs SD
for comp =1:16
    for a = 1:12
        Donnees_EMG(YY).Phases_Stables_SD_all(:,a+12*(comp-1)) = std(Donnees_EMG(YY).Phases_Stables(:,a+12*(comp-1))-Donnees_EMG_TL(YY).Phases_Stables_mean(:,comp));
%         plot(Donnees_EMG(1).Phases_Stables(:,a+12*(comp-1))-Donnees_EMG_TL(1).Phases_Stables_mean(:,comp));hold on;
    end
end


%% Mean du SD
a=1;
for comp =1:12:192
    Donnees_EMG(YY).Phases_Stables_SD(:,a) = mean(Donnees_EMG(YY).Phases_Stables_SD_all(:,comp:comp+11));
    a=a+1;
end
%Deuxième traitement EMG pour obtenir phasic classique et combined 

[EMG_traite, Tonic, Vmean_RMS_R, Vmean_RMS_B, Profil_tonic_R.muscle, Profil_tonic_B.muscle,profil_sizes_R_mean,profil_sizes_B_mean] = compute_emg2_TonicNew_WB(Donnees_EMG(YY).RMSCut, Donnees_EMG(YY).Phases_Stables_SD, Donnees_EMG_TL(YY).RMS, ...
          emg_frequency, Donnees_EMG(YY).Tonic_start, Donnees_EMG(YY).Tonic_end, Idx, limite_en_temps, Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever, Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir, Nb_emgs, Donnees_EMG(YY).Phasic.TonicLent, ordre_filtre_phasic, passebas_filtre_phasic);
   



% Enregistrement des différents résultats de manière brute (6 par 6 dans une
% grande matrice

%         Donnees_EMG(YY).Phasic.Combined.Se_lever = EMG_traite.combined.R;
%         Donnees_EMG(YY).Phasic.Combined.Se_rassoir = EMG_traite.combined.B;
        Donnees_EMG(YY).Phasic.Classique.Se_lever = EMG_traite.classique.R;
        Donnees_EMG(YY).Phasic.Classique.Se_rassoir = EMG_traite.classique.B;
%         Donnees_EMG(YY).Phasic.Classique_OLD.Se_lever = EMG_traite.classiqueOLD.R;
%         Donnees_EMG(YY).Phasic.Classique_OLD.Se_rassoir = EMG_traite.classiqueOLD.B;
        Donnees_EMG(YY).Phasic.ClassiqueFILT.Se_lever = EMG_traite.classiqueFILT.R;
        Donnees_EMG(YY).Phasic.ClassiqueFILT.Se_rassoir = EMG_traite.classiqueFILT.B;
        Donnees_EMG(YY).Phasic.RMS_combined = EMG_traite.RMS;
        Donnees_EMG(YY).TonicSoustrait.R =  EMG_traite.TonicSoustrait.R;
        Donnees_EMG(YY).TonicSoustrait.B =  EMG_traite.TonicSoustrait.B;
        Donnees_EMG(YY).Temps.Se_lever = profil_sizes_R_mean;
        Donnees_EMG(YY).Temps.Se_rassoir = profil_sizes_B_mean;




    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
    %% Partie pour quantifier les desacs musculaires sur le phasic CLASSIQUE %%        
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    phasicSL = Donnees_EMG(YY).Phasic.Classique.Se_lever(:,:);
    SD=Donnees_EMG(YY).Phases_Stables_SD(1,:);
    timeSL = profil_sizes_R_mean;
    tonicSL = Donnees_EMG(YY).TonicSoustrait.R;

    phasicSR = Donnees_EMG(YY).Phasic.Classique.Se_rassoir;
    timeSR = profil_sizes_B_mean;
    tonicSR = Donnees_EMG(YY).TonicSoustrait.B;

    for comp =1:16
        for acqui=1:6 % On balaye
        %% Calculs quantif desac pour le mvt lever
            j = (comp-1)*6+acqui;

            % Calcul temps phase desac LEVER
            indic = 0; % Variable pour vérifier la longueur des phases de désactivation
            Limite_atteinte = false; % variable bouléene pour enregistrer le fait que les phases de désactivation sont assez longues (ou pas)
            compteur = 0; % Si la désactivation est assez longue, elle est comptée dans cette variable
            Limite_basse_detection = round(emg_frequency * limite_en_temps); %Limite d'image à atteindre pour considérer la phase négative 40ms, arrondi à l'image près
            for f = 250 : 1000 % Une boucle pour tester toutes les valeurs du phasic
                
                if phasicSL(f, j) < 0-3*abs(SD(1, comp)) % Si la valeur est inf à zero indic est incrementé
                   indic = indic + 1 ;

%                    indic
                else   % Sinon
                    if Limite_atteinte % Soit la limite avait déjà été atteinte (la phase doit donc être comptée)
                        compteur = compteur + indic; % On la compte 
                        indic = 0;    % on remet la variable indic à 0 pour vérifier les suivantes
                        Limite_atteinte = false; % On remet la variable bouléene à Faux 
                    else
                        indic = 0; % Si la limite n'avait pas été atteinte on remet simplement l'indicateur à 0
                    end
                end
                
                if indic >Limite_basse_detection*emg_frequency/timeSL(1,acqui) % Si la variable indicateur augmente et dépasse la limite de détection (40 ms), la limite est atteinte
                    Limite_atteinte = true;
                end
                
            end
            
            if Limite_atteinte % Si la limite est atteinte mais qu'on dépasse les 600
                Limite_atteinte = false;
                compteur = compteur + indic;
            end
            % Calcul de l'amplitude max de négativité
            
            
            if compteur>0
                frequence =1;
                [Pmin, indice] = min(phasicSL(:, j));
                if Pmin > 0
                    Pmin =0;
                end
                amplitude = Pmin * 100 / tonicSL(indice,j);
            else 
                frequence = 0;
                amplitude = 0;
            end
           




                % Calcul temps phase desac BAISSER
            indic = 0; % Variable pour vérifier la longueur des phases de désactivation
            Limite_atteinte = false; % variable bouléene pour enregistrer le fait que les phases de désactivation sont assez longues (ou pas)
            compteur2 = 0; % Si la désactivation est assez longue, elle est comptée dans cette variable
            Limite_basse_detection = round(emg_frequency * limite_en_temps); %Limite d'image à atteindre pour considérer la phase négative 40ms, arrondi à l'image près
            for f = 1 : 750% Une boucle pour tester toutes les valeurs du phasic
                
                if phasicSR(f, j) < 0-3*abs(SD(1, comp)) % Si la valeur est inf à zero indic est incrementé
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
                
                if indic >Limite_basse_detection*emg_frequency/timeSR(1,acqui) % Si la variable indicateur augmente et dépasse la limite de détection (40 ms), la limite est atteinte
                    Limite_atteinte = true;
                end
            end
            
            % Calcul de l'amplitude max de négativité
            
            if Limite_atteinte % Si la limite est atteinte mais qu'on dépasse les 600
                Limite_atteinte = false;
                compteur2 = compteur2 + indic;
            end

            
            if compteur2>0
                frequence2 =1;
                [Pmin, indice] = min(phasicSR(:, j));
                if Pmin > 0
                    Pmin =0;
                end
                amplitude2 = Pmin * 100 / tonicSR(indice,j);

            else 
                frequence2 = 0;
                amplitude2 = 0;
            end
           
        %% Enregistrement des données
        
%             Donnees_EMG(YY).QuantifDesac(1, j) = compteur*timeSL(1,acqui)/1000;  % Pour l'avoir en temps
            Donnees_EMG(YY).QuantifDesac(1, j) = compteur/10;  % Pour l'avoir %
%             Donnees_EMG(YY).QuantifDesac(2, j) = compteur2*timeSR(1,acqui)/1000; % Pour l'avoir en temps  
            Donnees_EMG(YY).QuantifDesac(2, j) = compteur2/10; % Pour l'avoir %
            Donnees_EMG(YY).QuantifDesac(3, j) = amplitude; % Amplitudes des mvts se lever
            Donnees_EMG(YY).QuantifDesac(4, j) = amplitude2; % Amplitudes des mvts se rassoir
            Donnees_EMG(YY).QuantifDesac(5, j) = frequence;  % Fréquence des désac mvt se lever
            Donnees_EMG(YY).QuantifDesac(6, j) = frequence2; % Fréquence des désac mvt se rassoir
            
            
        end
    end

    %% FIN QUANTIF
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIN QUANTIF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
% NORMALISATION verticale
www=1;
for v=1 : Nb_emgs
    
	EMG_traite.classique.R(:,www:www+length(Donnees.EMG)/2-1) = EMG_traite.classique.R(:,www:www+length(Donnees.EMG)/2-1)./max(abs(EMG_traite.RMS.R(:,www:www+length(Donnees.EMG)/2-1)));
	EMG_traite.classique.B(:,www:www+length(Donnees.EMG)/2-1) = EMG_traite.classique.B(:,www:www+length(Donnees.EMG)/2-1)./max(abs(EMG_traite.RMS.B(:,www:www+length(Donnees.EMG)/2-1)));
    max(abs(EMG_traite.RMS.B(:,www:www+length(Donnees.EMG)/2-1)))
	EMG_traite.classiqueFILT.R(:,www:www+length(Donnees.EMG)/2-1) = EMG_traite.classiqueFILT.R(:,www:www+length(Donnees.EMG)/2-1)./max(abs(EMG_traite.RMS.R(:,www:www+length(Donnees.EMG)/2-1)));
	EMG_traite.classiqueFILT.B(:,www:www+length(Donnees.EMG)/2-1) = EMG_traite.classiqueFILT.B(:,www:www+length(Donnees.EMG)/2-1)./max(abs(EMG_traite.RMS.B(:,www:www+length(Donnees.EMG)/2-1)));

    www = www + length(Donnees.EMG)/2;
end


% Profil moyen + Erreur standard pour les trois types de phasics
w=1;
v=1;
for acqui=1:6:96
    for f=1:Ech_norm_kin


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSERER CODE POUR MOUVEMENT ET GROUP CORRESPONDANT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      

                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,acqui:acqui+5))+std(EMG_traite.classique.R(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,acqui:acqui+5))-std(EMG_traite.classique.R(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,acqui:acqui+5))+std(EMG_traite.classique.B(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,acqui:acqui+5))-std(EMG_traite.classique.B(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSERER CODE POUR MOUVEMENT ET GROUP CORRESPONDANT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    end
    
    w = w + length(Donnees.EMG);
    v=v+1;
    
end


end


YY=24;
nb_sujets =24;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Moyennage des phasics entre les sujets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for muscle=1:Nb_emgs
 
    for a=1:1000
        for c=1:nb_sujets
            count(c) = Donnees_EMG(c).Phasic.Classique.ProfilMoyenSeLever(a,(muscle-1)*3+1);
        end
        Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(a,(muscle-1)*3+1) = mean(count);
        Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(a,(muscle-1)*3+2) = mean(count) + std(count)/sqrt(nb_sujets);
        Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(a,(muscle-1)*3+3) = mean(count) - std(count)/sqrt(nb_sujets);
    end

    for a=1:1000
        for c=1:nb_sujets
            count(c) = Donnees_EMG(c).Phasic.Classique.ProfilMoyenSeRassoir(a,(muscle-1)*3+1);
        end
        Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(a,(muscle-1)*3+1) = mean(count);
        Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(a,(muscle-1)*3+2) = mean(count) + std(count)/sqrt(nb_sujets);
        Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(a,(muscle-1)*3+3) = mean(count) - std(count)/sqrt(nb_sujets);
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Export des données
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


DonneesToExport.EMG_TL = Donnees_EMG_TL;
DonneesToExport.EMG = Donnees_EMG;
DonneesToExport.cinematiques_TL = Donnees_cinematiques_TL;
DonneesToExport.cinematiques = Donnees_cinematiques;


for subject =1:YY
    for acq=1:6
        DonneesToExport.EMG(YY+1).QuantifDesac(subject,96*(acq-1)+1:96*(acq-1)+96)=DonneesToExport.EMG(subject).QuantifDesac(acq,1:96);
    end
end


for subject =1:YY
    for acqui=1:6:576

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSERER CODE POUR MOUVEMENT ET GROUP CORRESPONDANT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,acqui:acqui+5));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,acqui:acqui+5));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSERER CODE POUR MOUVEMENT ET GROUP CORRESPONDANT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end
end


name = append('Donnees_saved_Old_NEW');
disp('Selectionnez le Dossier où enregistre les données.');
[Dossier] = uigetdir ('Selectionnez le Dossier où enregistre les données.');
save([Dossier '/' name ], 'DonneesToExport', '-v7.3');
disp('Données enregistrées avec succès !');
end


young =1;

if young ==1
    arrrr = 22;
    ae=21;
    YY =20;
else
    arrrr = 26;
    ae=25;
    YY = 24;
end


% DonneesToExport.EMG(arrrr).QuantifDesac(:,[1:4,6,8,10,12:20,22,24,26,28:36,38,40,42,44:52,54,56,58,60:68,70,72,74,76:84,86,88,90,92:96])  = [];
% DonneesToExport.EMG(arrrr).QuantifDesacSD(:,[1:4,6,8,10,12:20,22,24,26,28:36,38,40,42,44:52,54,56,58,60:68,70,72,74,76:84,86,88,90,92:96])  = [];

% DonneesToExport.EMG(arrrr).QuantifDesacNZ(:,[1:4,6,8,10,12:20,22,24,26,28:36,38,40,42,44:52,54,56,58,60:68,70,72,74,76:84,86,88,90,92:96])  = [];
% DonneesToExport.EMG(arrrr).QuantifDesacSDNZ(:,[1:4,6,8,10,12:20,22,24,26,28:36,38,40,42,44:52,54,56,58,60:68,70,72,74,76:84,86,88,90,92:96])  = [];

% Pour bras
% DonneesToExport.EMG(21).QuantifDesac(:,[3:16,19:32,35:48,51:64,67:80,83:96])  = [];
% DonneesToExport.EMG(21).QuantifDesacSD(:,[3:16,19:32,35:48,51:64,67:80,83:96])  = [];




