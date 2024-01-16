%% Fonction qui permet à partir des signaux traités (RMS) de computer le phasique

function [EMG_phasique, tonic_meanstd, Vmean_RMS_R, Vmean_RMS_B, norm_tonic_R_moy, norm_tonic_B_moy] = compute_emg2_Brasdom_nondom(RMS, RMS_Norm, emg_low_pass_Freq, ...
 emg_frequency, tonic_debut, tonic_fin, localmax, Idx, ~, ~)   

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

RMS_Norm_R = RMS_Norm(:, 1:(RMS_col/2));
RMS_Norm_B = RMS_Norm(:, ((RMS_col/2)+1):RMS_col);

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


% On crée la matrice de vitesse moyenne pour chaque direction

V_RMS_R = Idx.Vmean_R;
V_RMS_B = Idx.Vmean_B;
a = 1;
Vmean_RMS_R = zeros(RMS_col/2, 1);
Vmean_RMS_B = zeros(RMS_col/2, 1);
for f = 1:Nb_averaged_trials:(RMS_col/2)-Nb_averaged_trials+1
    Vmean_RMS_R(a) = mean(V_RMS_R(f:f+Nb_averaged_trials-1));
    Vmean_RMS_B(a) = mean(V_RMS_B(f:f+Nb_averaged_trials-1));
    a = a+1;
end

% On moyenne par trois les signaux RMS bruts et normalisés en durée

% Les profils sont normalisés en durée avant d'être moyennés. On prend la
% taille moyenne des 3 essais

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

% On moyenne les tailles par 3
profil_sizes_R_mean = meantrials(profil_sizes_R, Nb_averaged_trials);
profil_sizes_B_mean = meantrials(profil_sizes_B, Nb_averaged_trials);

profil_sizes_R_mean = 10.*round(profil_sizes_R_mean./10);
profil_sizes_B_mean = 10.*round(profil_sizes_B_mean./10);


% On normalise les essais à la taille correspondante
d = 1;
RMS_R_norm = zeros(lig_rms, col_rms);
RMS_B_norm = zeros(lig_rms_B, col_rms);
for f = 1:Nb_averaged_trials:(col_rms-Nb_averaged_trials+1)
    RMS_R_norm(1:profil_sizes_R_mean(1, d), f) = normalize2(RMS_R(1:profil_sizes_R(1, f), f), 'PCHIP', profil_sizes_R_mean(1, d));
    RMS_R_norm(1:profil_sizes_R_mean(1, d), f+1) = normalize2(RMS_R(1:profil_sizes_R(1, f+1), f+1), 'PCHIP', profil_sizes_R_mean(1, d));
    if Nb_averaged_trials == 3
    RMS_R_norm(1:profil_sizes_R_mean(1, d), f+2) = normalize2(RMS_R(1:profil_sizes_R(1, f+2), f+2), 'PCHIP', profil_sizes_R_mean(1, d));
    end
    RMS_B_norm(1:profil_sizes_B_mean(1, d), f) = normalize2(RMS_B(1:profil_sizes_B(1, f), f), 'PCHIP', profil_sizes_B_mean(1, d));
    RMS_B_norm(1:profil_sizes_B_mean(1, d), f+1) = normalize2(RMS_B(1:profil_sizes_B(1, f+1), f+1), 'PCHIP', profil_sizes_B_mean(1, d));
    if Nb_averaged_trials == 3
    RMS_B_norm(1:profil_sizes_B_mean(1, d), f+2) = normalize2(RMS_B(1:profil_sizes_B(1, f+2), f+2), 'PCHIP', profil_sizes_B_mean(1, d));
    end
   d = d+1; 
end
RMS_R_moy = meantrials(RMS_R_norm, Nb_averaged_trials);
RMS_B_moy = meantrials(RMS_B_norm, Nb_averaged_trials);
RMS_R_moy = RMS_R_moy(1:max(profil_sizes_R_mean), :);
RMS_B_moy = RMS_B_moy(1:max(profil_sizes_B_mean), :);
% On moyenne aussi par 3 le tonic

tonic_debut_R_moy = meantrials(tonic_debut_R, Nb_averaged_trials);
tonic_debut_B_moy = meantrials(tonic_debut_B, Nb_averaged_trials);

tonic_fin_R_moy = meantrials(tonic_fin_R, Nb_averaged_trials);
tonic_fin_B_moy = meantrials(tonic_fin_B, Nb_averaged_trials);

% On crée une matrice des RMS moyennées lissées
RMS_R_moy_smooth = butter_emgs(RMS_R_moy, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');
RMS_B_moy_smooth = butter_emgs(RMS_B_moy, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');

% On crée une matrice des tonics moyennés et lissés

 tonic_debut_R_moy_smooth = butter_emgs(tonic_debut_R_moy, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');
 tonic_debut_B_moy_smooth = butter_emgs(tonic_debut_B_moy, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');
 
 tonic_fin_R_moy_smooth = butter_emgs(tonic_fin_R_moy, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');
 tonic_fin_B_moy_smooth = butter_emgs(tonic_fin_B_moy, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');

% On calcule maintenant la moyenne et l'écart type des siganux
% tonics non-lissés

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

% Pareil avec les tonics lissés

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

% On normalise les tonics pour avoir le même nombre de frames que sur la RMS_cut

for i = 1:col_rms/Nb_averaged_trials
    
     %si les 3 essais ont plusieurs pics (x = essai ou il y a des NaN)
    if isnan(tonics_B_meanstd(3, i)) == 1
        tonics_B_meanstd(:, i) = 1;
        tonics_B_smooth_meanstd(:, i) = 1;
    end
    % Signaux non-lissés
    
    
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
   
        
        
    % Signaux lissés
    norm_tonic_R_moy_smooth(:, i) = normalize2(tonics_R_smooth_meanstd(1:2, i), 'PCHIP', size(RMS_R_moy_smooth, 1));
    norm_tonic_B_moy_smooth(:, i) = normalize2(tonics_B_smooth_meanstd(1:2, i), 'PCHIP', size(RMS_B_moy_smooth, 1));
%     norm_tonic_R_moy_smooth_norm(:, i) = normalize2(tonics_R_smooth_meanstd(1:2, i), 'PCHIP', 1000);
%     norm_tonic_B_moy_smooth_norm(:, i) = normalize2(tonics_B_smooth_meanstd(1:2, i), 'PCHIP', 1000);
% %     
end

%     % J'utilise la valeur d'EMG à 90° pour pondérer le tonic
%     % je sors le max de chaque signal de Torque
%     % Uniquement en condition horizontale
%     if Idx.data_sequence == 1
%     [~, indmax_R] = max(Torque.SGT_R);
%     [~, indmax_B] = max(Torque.SGT_B);
%     
%     % je vais chercher la valeur d'EMG correspondant
%     max_R = zeros(1, 10);
%     max_B = zeros(1, 10);
%     
%     for k = 1:col_rms/3
%     
%         max_R(1, k) = norm_tonic_R_moy(indmax_R(1, k)*10-EMD, k);
%         max_B(1, k) = norm_tonic_B_moy(indmax_B(1, k)*10-EMD, k);
%         
%     end
%         
%     emg90_theorique = mean([mean(max_R), mean(max_B)]);
%     
%     % je mets une sécurité au cas où l'EMG à 90 serait trop diférent de
%     % l'EMGthéorique
%     
%     coefficient_emg = emg_90/emg90_theorique;
%     
%     if coefficient_emg > 1.1
%         coefficient_emg = 1.1;
%     end
%     
%     if coefficient_emg < 0.9
%         coefficient_emg = 0.9;
%     end
%         
%         
%    cosangle_R = Torque.SGT_R/Idx.gvalue/Idx.dist_cdr_cdm/Idx.masse_bras;
%    cosangle_B = Torque.SGT_B/Idx.gvalue/Idx.dist_cdr_cdm/Idx.masse_bras;
%    
%    [lig_angle_R, ~] = size(cosangle_R);
%    [lig_angle_B, ~] = size(cosangle_B);
%    size_angle_R = zeros(1, col_rms/3);
%    size_angle_B = zeros(1, col_rms/3);   
%    % Il faut connaître la taille de chaque signal angulaire
%    
% for f = 1:col_rms/3
%     
%     for b = 1:lig_angle_R
%    
%         if cosangle_R(b, f) ~= 0
%         size_angle_R(1, f) = size_angle_R(1, f)+1;
%         end
%     
%     end
%     
%     for c = 1:lig_angle_B
%    
%         if cosangle_B(c, f) ~= 0
%         size_angle_B(1, f) = size_angle_B(1, f)+1;
%         end
%     
%     end
% end
%    
%    
%    for k = 1:col_rms/3
%        size_R = profil_sizes_R_mean(1, k);
%        size_B = profil_sizes_B_mean(1, k); 
%        
%        cosangle_R_norm = normalize2(cosangle_R(1:size_angle_R(1, k), k), 'PCHIP', size_R);
%        cosangle_B_norm = normalize2(cosangle_B(1:size_angle_B(1, k), k), 'PCHIP', size_B);
%        
%        for h = 175:size_R-326
%            norm_tonic_R_moy(h, k) = norm_tonic_R_moy(h, k)*cosangle_R_norm(h+EMD)*coefficient_emg;
%        end
%        
%        for h = 175:size_B-326
%            norm_tonic_B_moy(h, k) = norm_tonic_B_moy(h, k)*cosangle_B_norm(h+EMD)*coefficient_emg;
%        end
%        
%    end
%        
%     end
    
% On calcule le phasique sur le non lissé

emg_phasique_R = RMS_R_moy - norm_tonic_R_moy;
emg_phasique_B = RMS_B_moy - norm_tonic_B_moy;

% emg_phasique_R_norm = RMS_Norm_R_moy - norm_tonic_R_moy_norm;
% emg_phasique_B_norm = RMS_Norm_B_moy - norm_tonic_B_moy_norm;

% Et sur le lissé

emg_phasique_R_smooth = butter_emgs(emg_phasique_R, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');
emg_phasique_B_smooth = butter_emgs(emg_phasique_B, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');

%emg_phasique_R_smooth_norm = RMS_R_moy_smooth_norm - norm_tonic_R_moy_smooth_norm;
%emg_phasique_B_smooth_norm = RMS_B_moy_smooth_norm - norm_tonic_B_moy_smooth_norm;

% On rajoute un profil moyen, je laisse la colonne en hard pour l'instant   
    emg_phasique_R(:, (col_rms/Nb_averaged_trials)+1) = profilmoyen(emg_phasique_R);
    emg_phasique_B(:, (col_rms/Nb_averaged_trials)+1) = profilmoyen(emg_phasique_B);
    
%     emg_phasique_R_norm(:, (RMS_col/6)+1) = profilmoyen(emg_phasique_R_norm);
%     emg_phasique_B_norm(:, (RMS_col/6)+1) = profilmoyen(emg_phasique_B_norm);
    
    emg_phasique_R_smooth(:, (col_rms/Nb_averaged_trials)+1) = profilmoyen(emg_phasique_R_smooth);
    emg_phasique_B_smooth(:, (col_rms/Nb_averaged_trials)+1) = profilmoyen(emg_phasique_B_smooth);
    
    %emg_phasique_R_smooth_norm(:, (RMS_col/6)+1) = profilmoyen(emg_phasique_R_smooth_norm);
    %emg_phasique_B_smooth_norm(:, (RMS_col/6)+1) = profilmoyen(emg_phasique_B_smooth_norm);
    
    % On construit les résultats
    
    EMG_phasique.nonsmooth.brut.R = emg_phasique_R;
    EMG_phasique.nonsmooth.brut.B = emg_phasique_B;
    
%     EMG_phasique.nonsmooth.norm.R = emg_phasique_R_norm;
%     EMG_phasique.nonsmooth.norm.B = emg_phasique_B_norm;
    
    EMG_phasique.smooth.R = emg_phasique_R_smooth;
    EMG_phasique.smooth.B = emg_phasique_B_smooth;
    
    %EMG_phasique.smooth.norm.R = emg_phasique_R_smooth_norm;
    %EMG_phasique.smooth.norm.B = emg_phasique_B_smooth_norm;

    tonic_meanstd.brut.R = tonics_R_meanstd;
    tonic_meanstd.brut.B = tonics_B_meanstd;
    
    tonic_meanstd.smooth.R = tonics_R_smooth_meanstd;
    tonic_meanstd.smooth.B = tonics_B_smooth_meanstd;    


