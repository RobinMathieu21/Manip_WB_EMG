%% Fonction qui permet � partir des signaux trait�s (RMS) de computer le phasique

function [EMG_phasique, tonic_meanstd, Vmean_RMS_R, Vmean_RMS_B, norm_tonic_R_moy, norm_tonic_B_moy] = compute_emg2_Brasdom_nondom(RMS, RMS_Norm, emg_low_pass_Freq, ...
 emg_frequency, tonic_debut, tonic_fin, localmax, Idx, limite_en_temps, ~, ~)   

EMG_phasique = {};
tonic_meandstd = {};
anticip = Idx.anticip;
EMD = Idx.EMD;
Nb_averaged_trials = Idx.Nb_averaged_trials;

[RMS_lig, RMS_col] = size(RMS);
[tonic_lig, tonic_col] = size(tonic_debut);

%On coupe les matrices en 2 pour avoir les essais sur une direction

RMS_R = RMS(:, 1:(RMS_col/2));
RMS_B = RMS(:, ((RMS_col/2)+1):RMS_col);

tonic_debut_R = tonic_debut(:, 1:(RMS_col/2));
tonic_debut_B = tonic_debut(:, ((RMS_col/2)+1):RMS_col);

tonic_fin_R = tonic_fin(:, 1:(RMS_col/2));
tonic_fin_B = tonic_fin(:, ((RMS_col/2)+1):RMS_col);

    
% On reorganise les matrices en les classant par vitesse du mouvement

idxR = Idx.R;
idxB = Idx.B;

RMS_R = RMS_R(:, idxR);
RMS_B = RMS_B(:, idxB);    
tonic_debut_R = tonic_debut_R(:, idxR);
tonic_debut_B = tonic_debut_B(:, idxB);
tonic_fin_R = tonic_fin_R(:, idxR);
tonic_fin_B = tonic_fin_B(:, idxB);


% On cr�e la matrice de vitesse moyenne pour chaque direction

V_RMS_R = Idx.Vmean_R;
V_RMS_B = Idx.Vmean_B;
a = 1;
Vmean_RMS_R = zeros(RMS_col/2, 1);
Vmean_RMS_B = zeros(RMS_col/2, 1);
MD_MEAN_R = zeros(RMS_col/2, 1);
MD_MEAN_B = zeros(RMS_col/2, 1);

for f = 1:Nb_averaged_trials:(RMS_col/2)-Nb_averaged_trials+1
    Vmean_RMS_R(a) = mean(V_RMS_R(f:f+Nb_averaged_trials-1));
    Vmean_RMS_B(a) = mean(V_RMS_B(f:f+Nb_averaged_trials-1));
    MD_MEAN_R(a) = mean(Idx.MD_R(f:f+Nb_averaged_trials-1));
    MD_MEAN_B(a) = mean(Idx.MD_B(f:f+Nb_averaged_trials-1));
    a = a+1;
end

% On moyenne les signaux RMS bruts et normalis�s en dur�e

% Les profils sont normalis�s en dur�e avant d'�tre moyenn�s. On prend la
% taille moyenne des essais

% On commence par trouver la taille de chaque profil en omettant les zeros
[lig_rms, col_rms] = size(RMS_R);
[lig_rms_B, ~] = size(RMS_B);
profil_sizes_R = zeros(1, col_rms);
profil_sizes_B = zeros(1, col_rms);
for f = 1:col_rms
    
    for b = 1:lig_rms
   
        if RMS_R(b, f) ~= 0
        profil_sizes_R(1, f) = profil_sizes_R(1, f)+1;
        end
    
    end
    
    for c = 1:lig_rms_B
   
        if RMS_B(c, f) ~= 0
        profil_sizes_B(1, f) = profil_sizes_B(1, f)+1;
        end
    
    end
end

% On moyenne les tailles
profil_sizes_R_mean = meantrials(profil_sizes_R, Nb_averaged_trials);
profil_sizes_B_mean = meantrials(profil_sizes_B, Nb_averaged_trials);

profil_sizes_R_mean = 10.*round(profil_sizes_R_mean./10);
profil_sizes_B_mean = 10.*round(profil_sizes_B_mean./10);


% On normalise les essais � la taille correspondante
d = 1;
RMS_R_norm = zeros(lig_rms, col_rms);
RMS_B_norm = zeros(lig_rms_B, col_rms);

for f = 1:Nb_averaged_trials:(col_rms-Nb_averaged_trials+1)
    RMS_R_norm(1:profil_sizes_R_mean(1, d), f) = normalize2(RMS_R(1:profil_sizes_R(1, f), f), 'PCHIP', profil_sizes_R_mean(1, d));
    RMS_R_norm(1:profil_sizes_R_mean(1, d), f+1) = normalize2(RMS_R(1:profil_sizes_R(1, f+1), f+1), 'PCHIP', profil_sizes_R_mean(1, d));
%     if Nb_averaged_trials == 3
%     RMS_R_norm(1:profil_sizes_R_mean(1, d), f+2) = normalize2(RMS_R(1:profil_sizes_R(1, f+2), f+2), 'PCHIP', profil_sizes_R_mean(1, d));
%     end
    RMS_B_norm(1:profil_sizes_B_mean(1, d), f) = normalize2(RMS_B(1:profil_sizes_B(1, f), f), 'PCHIP', profil_sizes_B_mean(1, d));
    RMS_B_norm(1:profil_sizes_B_mean(1, d), f+1) = normalize2(RMS_B(1:profil_sizes_B(1, f+1), f+1), 'PCHIP', profil_sizes_B_mean(1, d));
%     if Nb_averaged_trials == 3
%     RMS_B_norm(1:profil_sizes_B_mean(1, d), f+2) = normalize2(RMS_B(1:profil_sizes_B(1, f+2), f+2), 'PCHIP', profil_sizes_B_mean(1, d));
%     end
   d = d+1; 
end

RMS_R_NonNorm = meantrials(RMS_R, Nb_averaged_trials);
RMS_B_NonNorm = meantrials(RMS_B, Nb_averaged_trials);
RMS_R_moy = meantrials(RMS_R_norm, Nb_averaged_trials);
RMS_B_moy = meantrials(RMS_B_norm, Nb_averaged_trials);
RMS_R_moy = RMS_R_moy(1:max(profil_sizes_R_mean), :);
RMS_B_moy = RMS_B_moy(1:max(profil_sizes_B_mean), :);
% On moyenne aussi le tonic

tonic_debut_R_moy = meantrials(tonic_debut_R, Nb_averaged_trials);
tonic_debut_B_moy = meantrials(tonic_debut_B, Nb_averaged_trials);

tonic_fin_R_moy = meantrials(tonic_fin_R, Nb_averaged_trials);
tonic_fin_B_moy = meantrials(tonic_fin_B, Nb_averaged_trials);

% On cr�e une matrice des RMS moyenn�es liss�es
RMS_R_moy_smooth = butter_emgs(RMS_R_moy, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');
RMS_B_moy_smooth = butter_emgs(RMS_B_moy, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');

% On cr�e une matrice des tonics moyenn�s et liss�s

tonic_debut_R_moy_smooth = butter_emgs(tonic_debut_R_moy, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');
tonic_debut_B_moy_smooth = butter_emgs(tonic_debut_B_moy, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');
 
tonic_fin_R_moy_smooth = butter_emgs(tonic_fin_R_moy, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');
tonic_fin_B_moy_smooth = butter_emgs(tonic_fin_B_moy, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');

% On calcule maintenant la moyenne et l'�cart type des siganux
% tonics non-liss�s

tonics_R_meanstd = zeros(4, col_rms/Nb_averaged_trials);
tonics_R_meanstd(1, :) = mean(tonic_debut_R_moy, 'omitnan');
tonics_R_meanstd(2, :) = mean(tonic_fin_R_moy, 'omitnan');
tonics_R_meanstd(3, :) = std(tonic_debut_R_moy, 'omitnan');
tonics_R_meanstd(4, :) = std(tonic_fin_R_moy, 'omitnan');

tonics_B_meanstd = zeros(4, col_rms/Nb_averaged_trials);
tonics_B_meanstd(1, :) = mean(tonic_debut_B_moy, 'omitnan');
tonics_B_meanstd(2, :) = mean(tonic_fin_B_moy, 'omitnan');
tonics_B_meanstd(3, :) = std(tonic_debut_B_moy, 'omitnan');
tonics_B_meanstd(4, :) = std(tonic_fin_B_moy, 'omitnan');

% Pareil avec les tonics liss�s

tonics_R_smooth_meanstd = zeros(4, col_rms/Nb_averaged_trials);
tonics_R_smooth_meanstd(1, :) = mean(tonic_debut_R_moy_smooth, 'omitnan');
tonics_R_smooth_meanstd(2, :) = mean(tonic_fin_R_moy_smooth, 'omitnan');
tonics_R_smooth_meanstd(3, :) = std(tonic_debut_R_moy_smooth, 'omitnan');
tonics_R_smooth_meanstd(4, :) = std(tonic_fin_R_moy_smooth, 'omitnan');

tonics_B_smooth_meanstd = zeros(4, col_rms/Nb_averaged_trials);
tonics_B_smooth_meanstd(1, :) = mean(tonic_debut_B_moy_smooth, 'omitnan');
tonics_B_smooth_meanstd(2, :) = mean(tonic_fin_B_moy_smooth, 'omitnan');
tonics_B_smooth_meanstd(3, :) = std(tonic_debut_B_moy_smooth, 'omitnan');
tonics_B_smooth_meanstd(4, :) = std(tonic_fin_B_moy_smooth, 'omitnan');

% On normalise les tonics pour avoir le m�me nombre de frames que sur la RMS_cut

for i = 1:col_rms/Nb_averaged_trials
    
     %si les essais ont plusieurs pics (x = essai ou il y a des NaN)
    if isnan(tonics_B_meanstd(3, i)) == 1
        tonics_B_meanstd(:, i) = 1;
        tonics_B_smooth_meanstd(:, i) = 1;
    end
    % Signaux non-liss�s
    
    
    norm_tonic_R_moy(anticip-EMD+1:profil_sizes_R_mean(1, i)-anticip-EMD, i) = normalize2(tonics_R_meanstd(1:2, i), 'PCHIP', profil_sizes_R_mean(1, i)-2*anticip);
    norm_tonic_B_moy(anticip-EMD+1:profil_sizes_B_mean(1, i)-anticip-EMD, i) = normalize2(tonics_B_meanstd(1:2, i), 'PCHIP', profil_sizes_B_mean(1, i)-2*anticip);
    
    for g = 1:anticip-EMD
        norm_tonic_R_moy(g, i) = norm_tonic_R_moy(anticip-EMD+1, i);
        norm_tonic_B_moy(g, i) = norm_tonic_B_moy(anticip-EMD+1, i);
        
    end
    
    for g = 1:anticip+EMD
        norm_tonic_R_moy(profil_sizes_R_mean(1, i)-g+1, i) = norm_tonic_R_moy(profil_sizes_R_mean(1, i)-anticip-EMD, i);
        norm_tonic_B_moy(profil_sizes_B_mean(1, i)-g+1, i) = norm_tonic_B_moy(profil_sizes_B_mean(1, i)-anticip-EMD, i);
        
    end
    
    % Signaux liss�s
    norm_tonic_R_moy_smooth(:, i) = normalize2(tonics_R_smooth_meanstd(1:2, i), 'PCHIP', size(RMS_R_moy_smooth, 1));
    norm_tonic_B_moy_smooth(:, i) = normalize2(tonics_B_smooth_meanstd(1:2, i), 'PCHIP', size(RMS_B_moy_smooth, 1));
% %     
end

    
% On calcule le phasique sur le non liss�

emg_phasique_R_avantNorm = RMS_R_moy - norm_tonic_R_moy;
emg_phasique_B_avantNorm = RMS_B_moy - norm_tonic_B_moy;

% On normalise les signaux sur 1000 frames

[~,col_o]=size(emg_phasique_R_avantNorm);
for i=1:col_o
    emg_phasique_R(:,i) = normalize2(emg_phasique_R_avantNorm(1:profil_sizes_R_mean(1, i),i), 'PCHIP', 1000);
    emg_phasique_B(:,i) = normalize2(emg_phasique_B_avantNorm(1:profil_sizes_B_mean(1, i),i), 'PCHIP', 1000);
    RMS_R_moy_Norm(:,i) = normalize2(RMS_R_moy_smooth(1:profil_sizes_R_mean(1, i),i), 'PCHIP', 1000);
    RMS_B_moy_Norm(:,i) = normalize2(RMS_B_moy_smooth(1:profil_sizes_B_mean(1, i),i), 'PCHIP', 1000);
end

% Et sur le liss�

emg_phasique_R_smooth = butter_emgs(emg_phasique_R, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');
emg_phasique_B_smooth = butter_emgs(emg_phasique_B, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');


%% Partie pour quantifier les desac musculaires

limite_en_temps = 0.04; % en s, correspond au temps minimal pour consid�rer une d�sactivation

[l, nb_col_rms] = size(emg_phasique_R);
i = 1;
j = 1;

while j <= nb_col_rms % On balaye
%% Calculs quantif desac pour le mvt lever

    % Calcul temps phase desac LEVER
    indic = 0; % Variable pour v�rifier la longueur des phases de d�sactivation
    Limite_atteinte = false; % variable boul�ene pour enregistrer le fait que les phases de d�sactivation sont assez longues (ou pas)
    compteur = 0; % Si la d�sactivation est assez longue, elle est compt�e dans cette variable
    Limite_basse_detection = round(1000 * limite_en_temps / MD_MEAN_R(j,1)); %Limite d'image � atteindre pour consid�rer la phase n�gative 40ms, arrondi � l'image pr�s
    for f = 1 : 1000 % Une boucle pour tester toutes les valeurs du phasic
        
        if emg_phasique_R(f, j) < -2*tonics_R_meanstd(3, j) % Si la valeur est inf � zero indic est increment�
           indic = indic + 1 ;
        else   % Sinon
            if Limite_atteinte % Soit la limite avait d�j� �t� atteinte (la phase doit donc �tre compt�e)
                compteur = compteur + indic; % On la compte 
                indic = 0;    % on remet la variable indic � 0 pour v�rifier les suivantes
                Limite_atteinte = false; % On remet la variable boul�ene � Faux 
            else
                indic = 0; % Si la limite n'avait pas �t� atteinte on remet simplement l'indicateur � 0
            end
        end
        
        if indic >Limite_basse_detection % Si la variable indicateur augmente et d�passe la limite de d�tection (40 ms), la limite est atteinte
            Limite_atteinte = true;
        end
        
    end
    
    % Calcul de l'amplitude max de n�gativit�
    [Pmin, indice] = min(emg_phasique_R(:, j));
    if Pmin > 0
        Pmin =0;
    end
    amplitude = Pmin * 100 / RMS_R_moy_Norm(indice,i);
    
    if compteur>0
       frequence =1;
    else frequence = 0;
    end
   
        % Calcul temps phase desac BAISSER
    indic = 0; % Variable pour v�rifier la longueur des phases de d�sactivation
    Limite_atteinte = false; % variable boul�ene pour enregistrer le fait que les phases de d�sactivation sont assez longues (ou pas)
    compteur2 = 0; % Si la d�sactivation est assez longue, elle est compt�e dans cette variable
    Limite_basse_detection = round(1000 * limite_en_temps / MD_MEAN_B(j,1)); %Limite d'image � atteindre pour consid�rer la phase n�gative 40ms, arrondi � l'image pr�s
    for f = 1 : 1000 % Une boucle pour tester toutes les valeurs du phasic
        
        if emg_phasique_B(f, j) < -2*tonics_B_meanstd(3, j) % Si la valeur est inf � zero indic est increment�
           indic = indic + 1 ;
        else   % Sinon
            if Limite_atteinte % Soit la limite avait d�j� �t� atteinte (la phase doit donc �tre compt�e)
                compteur2 = compteur2 + indic; % On la compte 
                indic = 0;    % on remet la variable indic � 0 pour v�rifier les suivantes
                Limite_atteinte = false; % On remet la variable boul�ene � Faux 
            else
                indic = 0; % Si la limite n'avait pas �t� atteinte on remet simplement l'indicateur � 0
            end
        end
        
        if indic >Limite_basse_detection % Si la variable indicateur augmente et d�passe la limite de d�tection (40 ms), la limite est atteinte
            Limite_atteinte = true;
        end
    end
    
    % Calcul de l'amplitude max de n�gativit�
    [Pmin, indice] = min(emg_phasique_B(:, j));
    if Pmin > 0
        Pmin =0;
    end
    amplitude2 = Pmin * 100 / RMS_B_moy_Norm(indice,i);
    
    if compteur2>0
       frequence2 =1;
    else frequence2 = 0;
    end
   
%% Enregistrement des donn�es

    EMG_phasique.QuantifDesac(j, 1) = compteur*MD_MEAN_R(j,1)/1000;  % Pour l'avoir en temps
    EMG_phasique.QuantifDesac(j, 2) = compteur2*MD_MEAN_B(j,1)/1000; % Pour l'avoir en temps  
    EMG_phasique.QuantifDesac(j, 5) = amplitude; % Amplitudes des mvts se lever
    EMG_phasique.QuantifDesac(j, 6) = amplitude2; % Amplitudes des mvts se rassoir
    EMG_phasique.QuantifDesac(j, 9) = frequence;  % Fr�quence des d�sac mvt se lever
    EMG_phasique.QuantifDesac(j, 10) = frequence2; % Fr�quence des d�sac mvt se rassoir
    
    j = j+1;
end


% Moyennage des parametres
L=length(EMG_phasique.QuantifDesac(:,1));

EMG_phasique.QuantifDesac(1, 3)= mean(EMG_phasique.QuantifDesac(1:L,1));    % Moyenne des temps cumul�s/muscle
EMG_phasique.QuantifDesac(1, 4)= mean(EMG_phasique.QuantifDesac(1:L,2));    % Moyenne des temps cumul�s/muscle
EMG_phasique.QuantifDesac(1, 7)= mean(EMG_phasique.QuantifDesac(1:L,5));    % Moyenne des amplitudes/muscle
EMG_phasique.QuantifDesac(1, 8)= mean(EMG_phasique.QuantifDesac(1:L,6));    % Moyenne des amplitudes/muscle
EMG_phasique.QuantifDesac(1, 11)= mean(EMG_phasique.QuantifDesac(1:L,9));   % Moyenne des fr�quence/muscle
EMG_phasique.QuantifDesac(1, 12)= mean(EMG_phasique.QuantifDesac(1:L,10));  % Moyenne des fr�quence/muscle



% On construit les r�sultats
    
    EMG_phasique.nonsmooth.brut.R = emg_phasique_R;
    EMG_phasique.nonsmooth.brut.B = emg_phasique_B;
    
    EMG_phasique.smooth.R = emg_phasique_R_smooth;
    EMG_phasique.smooth.B = emg_phasique_B_smooth;

    tonic_meanstd.brut.R = tonics_R_meanstd;
    tonic_meanstd.brut.B = tonics_B_meanstd;
    
    tonic_meanstd.smooth.R = tonics_R_smooth_meanstd;
    tonic_meanstd.smooth.B = tonics_B_smooth_meanstd;    

% Donnees_to_export = Donnees_TRAITEE.EMG.Quantif;
% 
% disp('Selectionnez le Dossier o� enregistre les donn�es.');
% [Dossier] = uigetdir ('Selectionnez le Dossier o� enregistre les donn�es.');
% save([Dossier '/Bras_gauche'], 'Donnees_to_export');
% delete(findall(0));
% disp('Donn�es enregistr�es avec succ�s !');
