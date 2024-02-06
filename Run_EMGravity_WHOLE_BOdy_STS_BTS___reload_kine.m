
%% Script -----EMG----- pour manip mvts whole body
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
emg_band_pass_Freq = [30 300]; % Passe_bande du filtre EMG
emg_low_pass_Freq = 20; % Fr�quence passe_bas lors du second filtre du signal emg. 100 est la fr�quence habituelle chez les humains (cf script J�r�mie)
emg_ech_norm = 1000; % Fr�quence d'�chantillonage du signal EMG
param_moyenne = 100; % Nb images pour moyenner la position pendant phases stables
param_moyenne2 = 200/5; % Nb images pour moyenner la position pendant phases stables
nb_images_to_add=param_moyenne/2;
delay2 = 40; % Nb d'images (Cin�matiques) � ajouter pour compenser l'EMD et les 5% mvts rapides
delay = 0;
pourcen_amp = 0.05;

% Donn�es pour le traitement EMG
anticip = 0.25; % Temps � soustraire lors du recoupage du rms_cut pour trouver le d�but de la bouff�e
emg_frequency = 1000; % Fr�quence d'acquisition du signal EMG
%Nb_averaged_trials = 2; % Indicate the number of EMG traces to be averaged 
Nb_emgs = 16; % Sp�cification du nombre de channels EMG
rms_window = 200; % Time in ms of the window used to compute sliding root mean square of EMG
rms_window_step = (rms_window/1000)*emg_frequency;
emg_div_kin_freq = emg_frequency/Frequence_acquisition; %used to synchronized emg cutting (for sliding rms) with regard to kinematics
NB_SD = 15; % Nombre d'�cart-types utilis� pour d�tecter le d�but/fin du mouvement lent
limite_en_temps = 0.01; % en ms, correspond au temps minimal pour consid�rer une d�sactivation
duration_tonic = 250; % Dur�e (en ms) de moyennage du tonic
anticip_tonic = 250; % Dur�e (en ms) pour avoir le dernier point du tonic avant le mouvement et le premier point du tonic apr�s le mouvement
EMD = 0.133;%0.076; % d�lai electrom�canique moyen de tous les muscles
Nb_averaged_trials = 2;

%% Importation des donn�es

%On selectionne le repertoire
disp('Selectionnez le Dossier regroupant les essais lents');
[Dossier] = uigetdir ('Selectionnez le Dossier o� ex�cuter le Script');

if (Dossier ~= 0) %Si on clique sur un dossier
    
    Extension = '*.mat'; %Traite tous les .mat
    Chemin = fullfile(Dossier, Extension); % On construit le chemin
    ListeFichier = dir(Chemin); % On construit la liste des fichiers

% %% On cr�e les matrices de r�sultats
% 
%     Donnees = {};
%     Donnees_EMG(YY) = {};
%     Donnees_cinematiques_TL = {};
    Premiere_fois = true; % Pour n'effecteur certaines actions de lecture des labels qu'une seule fois
    
%% On proc�de au balayage fichier par fichier
    disp('POST TRAITEMENT MOUVEMENTS LENTS')
    disp(append('Il y a ', string(numel(ListeFichier)),' fichiers � analyser.'));
    
    for YY = 1: numel(ListeFichier)
        Fichier_traite = [Dossier '\' ListeFichier(YY).name]; %On charge le fichier .mat
        disp(append('i = ',string(YY)));
        load (Fichier_traite);
    
        if Premiere_fois 
            Nb_emgs = length(Donnees.EMG_lent(1).C3DLENT.EMG.Labels); %% On compte le nombre d'EMG pr�sents dans le fichier
            Premiere_fois = false;
            disp(append('Il y a ',string(Nb_emgs),' signaux EMG'));
        end
    
    
            %% MVT LENTS
            %On recharge les donn�es cin�matiques des mvts lents
        Donnees_cinematiques_TL(YY) = Donnees.cinematiques_TL;
    
    
            %% MVT RAPIDES
            %On recharge les donn�es cin�matiques des mvts rapides
        Donnees_cinematiques(YY) = Donnees.cinematiques;     
    
    end

end


%% MOYENNE
nb_sujets =YY;

count_rap = 1;
count_lent = 1;
for i=1:nb_sujets
    L_rapide=length(Donnees_cinematiques(i).Results_trial_by_trial)/2;
    Donnees_cinematiques(YY+1).Results_trial_by_trial.Moyenne(count_rap:count_rap+L_rapide-1,1) = Donnees_cinematiques(i).Results_trial_by_trial(1:L_rapide,2); 
    Donnees_cinematiques(YY+1).Results_trial_by_trial.Moyenne(count_rap:count_rap+L_rapide-1,2) = Donnees_cinematiques(i).Results_trial_by_trial(L_rapide+1:L_rapide*2,2); 
    disp(append('entre ',string(count_rap), ' et ',string(count_rap+L_rapide-1),' Avec i ',string(i)))
    count_rap = count_rap + L_rapide;
    
    L_lent=length(Donnees_cinematiques_TL(i).Results_trial_by_trial)/2;
    Donnees_cinematiques_TL(YY+1).Results_trial_by_trial.Moyenne(count_lent:count_lent+L_lent-1,1) = Donnees_cinematiques_TL(i).Results_trial_by_trial(1:L_lent,2); 
    Donnees_cinematiques_TL(YY+1).Results_trial_by_trial.Moyenne(count_lent:count_lent+L_lent-1,2) = Donnees_cinematiques_TL(i).Results_trial_by_trial(L_lent+1:L_lent*2,2); 
    disp(append('entre ',string(count_lent), ' et ',string(count_lent+L_lent-1),' Avec i ',string(i)))
    count_lent = count_lent + L_lent;

end









%% MVTS RAPIDES
A = mean(Donnees_cinematiques(YY+1).Results_trial_by_trial.Moyenne(:,1));
B = std(Donnees_cinematiques(YY+1).Results_trial_by_trial.Moyenne(:,1));

disp(append('MVT 1 ____ MD Rapide ',string(A), ' +/- ',string(B)))

A = mean(Donnees_cinematiques(YY+1).Results_trial_by_trial.Moyenne(:,2));
B = std(Donnees_cinematiques(YY+1).Results_trial_by_trial.Moyenne(:,2));

disp(append('MVT 2 ____ MD Rapide ',string(A), ' +/- ',string(B)))


%% MVTS LENTS
A = mean(Donnees_cinematiques_TL(YY+1).Results_trial_by_trial.Moyenne(:,1));
B = std(Donnees_cinematiques_TL(YY+1).Results_trial_by_trial.Moyenne(:,1));

disp(append('MVT 1 ____ MD Lent ',string(A), ' +/- ',string(B)))


A = mean(Donnees_cinematiques_TL(YY+1).Results_trial_by_trial.Moyenne(:,2));
B = std(Donnees_cinematiques_TL(YY+1).Results_trial_by_trial.Moyenne(:,2));

disp(append('MVT 2 ____ MD Lent ',string(A), ' +/- ',string(B)))
% 
% for i=1:YY
%     figure;plot(Donnees_cinematiques(i).Results_trial_by_trial(:,2))
% end


for aza = 1:YY
    Moyenne(aza,1) = mean(nonzeros(Donnees_cinematiques(YY+1).Results_trial_by_trial.Moyenne(12*(aza-1)+1:12*(aza-1)+12,1)));
    Moyenne(aza,2) = mean(nonzeros(Donnees_cinematiques(YY+1).Results_trial_by_trial.Moyenne(12*(aza-1)+1:12*(aza-1)+12,2)));
end

for aza = 1:YY
    Moyenne(aza,3) = mean(nonzeros(Donnees_cinematiques_TL(YY+1).Results_trial_by_trial.Moyenne(6*(aza-1)+1:6*(aza-1)+6,1)));
    Moyenne(aza,4) = mean(nonzeros(Donnees_cinematiques_TL(YY+1).Results_trial_by_trial.Moyenne(6*(aza-1)+1:6*(aza-1)+6,2)));
end

