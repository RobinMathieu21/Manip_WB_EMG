%% Fonction qui permet à partir des signaux traités (RMS) de computer le phasique

function [EMG_phasique , tonic_meanstd, Vmean_RMS_R, Vmean_RMS_B, norm_tonic_R_moy, norm_tonic_B_moy,profil_sizes_R_mean_exact,profil_sizes_B_mean_exact] = compute_emg2_TonicNew_WB(RMS,  ~, ~, ...
 emg_frequency, tonic_debut, tonic_fin, Idx, limite_en_temps, signal_mvt_lent_R_complet, signal_mvt_lent_B_complet, Nb_emgs, ~, ordre_filtre_phasic, ~)   


EMG_phasique = {};
anticip = Idx.anticip;
EMD = Idx.EMD;
nb = Idx.nb;
Nb_averaged_trials = Idx.Nb_averaged_trials;

[~, RMS_col] = size(RMS);

%On coupe les matrices en 2 pour avoir les essais sur une direction
for WW=1: Nb_emgs

    RMS_R = RMS(:, (WW-1)*nb+1:WW*nb);
    RMS_B = RMS(:, (RMS_col/2)+(WW-1)*nb+1:(RMS_col/2)+WW*nb);
    
    tonic_debut_R = tonic_debut(:, (WW-1)*nb+1:WW*nb);
    tonic_debut_B = tonic_debut(:, (RMS_col/2)+(WW-1)*nb+1:(RMS_col/2)+WW*nb);
    
    tonic_fin_R = tonic_fin(:, (WW-1)*nb+1:WW*nb);
    tonic_fin_B = tonic_fin(:, (RMS_col/2)+(WW-1)*nb+1:(RMS_col/2)+WW*nb);

    signal_mvt_lent_R = signal_mvt_lent_R_complet(:,(WW-1)*4+1);
    signal_mvt_lent_B = signal_mvt_lent_B_complet(:,(WW-1)*4+1);
        
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
    Vmean_RMS_R = zeros(nb, 1);
    Vmean_RMS_B = zeros(nb, 1);
    MD_MEAN_R = zeros(nb, 1);
    MD_MEAN_B = zeros(nb, 1);
    
    for f = 1:Nb_averaged_trials:(nb)-Nb_averaged_trials+1
        Vmean_RMS_R(a) = mean(V_RMS_R(f:f+Nb_averaged_trials-1));
        Vmean_RMS_B(a) = mean(V_RMS_B(f:f+Nb_averaged_trials-1));
        MD_MEAN_R(a) = mean(Idx.MD_R(f:f+Nb_averaged_trials-1));
        MD_MEAN_B(a) = mean(Idx.MD_B(f:f+Nb_averaged_trials-1));
        a = a+1;
    end
    
    % On moyenne les signaux RMS bruts et normalisés en durée
    
    % Les profils sont normalisés en durée avant d'être moyennés. On prend la
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
    profil_sizes_R_mean_exact = profil_sizes_R_mean;
    profil_sizes_B_mean_exact = profil_sizes_B_mean;
    
    profil_sizes_R_mean = 10.*round(profil_sizes_R_mean./10);
    profil_sizes_B_mean = 10.*round(profil_sizes_B_mean./10);
    
    
    % On normalise les essais à la taille correspondante
    d = 1;
    RMS_R_norm = zeros(lig_rms, col_rms);
    RMS_B_norm = zeros(lig_rms_B, col_rms);
    
    for f = 1:Nb_averaged_trials:(col_rms-Nb_averaged_trials+1)
        RMS_R_norm(1:profil_sizes_R_mean(1, d), f) = normalize2(RMS_R(1:profil_sizes_R(1, f), f), 'PCHIP', profil_sizes_R_mean(1, d));
        RMS_R_norm(1:profil_sizes_R_mean(1, d), f+1) = normalize2(RMS_R(1:profil_sizes_R(1, f+1), f+1), 'PCHIP', profil_sizes_R_mean(1, d));
    
        RMS_B_norm(1:profil_sizes_B_mean(1, d), f) = normalize2(RMS_B(1:profil_sizes_B(1, f), f), 'PCHIP', profil_sizes_B_mean(1, d));
        RMS_B_norm(1:profil_sizes_B_mean(1, d), f+1) = normalize2(RMS_B(1:profil_sizes_B(1, f+1), f+1), 'PCHIP', profil_sizes_B_mean(1, d));
    
       d = d+1; 
    end
    
    RMS_R_moy = meantrials(RMS_R_norm, Nb_averaged_trials);
    RMS_B_moy = meantrials(RMS_B_norm, Nb_averaged_trials);
    RMS_R_moy = RMS_R_moy(1:max(profil_sizes_R_mean), :);
    RMS_B_moy = RMS_B_moy(1:max(profil_sizes_B_mean), :);
    
    % On moyenne aussi le tonic
    tonic_debut_R_moy = meantrials(tonic_debut_R, Nb_averaged_trials);
    tonic_debut_B_moy = meantrials(tonic_debut_B, Nb_averaged_trials);
    
    tonic_fin_R_moy = meantrials(tonic_fin_R, Nb_averaged_trials);
    tonic_fin_B_moy = meantrials(tonic_fin_B, Nb_averaged_trials);
    
    % On calcule maintenant la moyenne et l'écart type des siganux
    % tonics non-lissés
    nb_signaux = nb/Nb_averaged_trials;
    tonics_R_meanstd = zeros(4, col_rms/Nb_averaged_trials);
    tonics_R_meanstd(1, :) = mean(tonic_debut_R_moy, 'omitnan');
    tonics_R_meanstd(2, :) = mean(tonic_fin_R_moy, 'omitnan');
    tonics_R_meanstd(3, :) = std(tonic_debut_R_moy, 'omitnan');
    tonics_R_meanstd(4, :) = std(tonic_fin_R_moy, 'omitnan');
%     disp(append('R =' +string(mean(tonics_R_meanstd(3, :)))));
    tonics_B_meanstd = zeros(4, col_rms/Nb_averaged_trials);
    tonics_B_meanstd(1, :) = mean(tonic_debut_B_moy, 'omitnan');
    tonics_B_meanstd(2, :) = mean(tonic_fin_B_moy, 'omitnan');
    tonics_B_meanstd(3, :) = std(tonic_debut_B_moy, 'omitnan');
    tonics_B_meanstd(4, :) = std(tonic_fin_B_moy, 'omitnan');
%     disp(append('B =' +string(mean(tonics_B_meanstd(3, :)))));
    % On normalise les tonics pour avoir le même nombre de frames que sur la RMS_cut
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% NOUVELLE VERSION (avec tonic lent) %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for i = 1:col_rms/Nb_averaged_trials
        
         %si les essais ont plusieurs pics (x = essai ou il y a des NaN)
        if isnan(tonics_B_meanstd(3, i)) == 1
            tonics_B_meanstd(:, i) = 1;
        end
        % Signaux non-lissés
        % ON PREND EN COMPTE LES SIGNAUX DES MVTS LENTS ENTRE 'ANTICIP' et
        % LENGTH - ANTICIP

        norm_tonic_R_moy(1:profil_sizes_R_mean(1, i), i) = normalize2(signal_mvt_lent_R, 'PCHIP', profil_sizes_R_mean(1, i));
        norm_tonic_B_moy(1:profil_sizes_B_mean(1, i), i) = normalize2(signal_mvt_lent_B, 'PCHIP', profil_sizes_B_mean(1, i));


%         norm_tonic_R_moy(EMD:profil_sizes_R_mean(1, i)-EMD, i) = normalize2(signal_mvt_lent_R, 'PCHIP', profil_sizes_R_mean(1, i)-2*EMD+1);
%         norm_tonic_B_moy(EMD:profil_sizes_B_mean(1, i)-EMD, i) = normalize2(signal_mvt_lent_B, 'PCHIP', profil_sizes_B_mean(1, i)-2*EMD+1);

%         transition_R_deb(1,1)=tonics_R_meanstd(1, i); transition_R_deb(2,1)=norm_tonic_R_moy(EMD,i);
%         transition_B_deb(1,1)=tonics_B_meanstd(1, i); transition_B_deb(2,1)=norm_tonic_B_moy(EMD,i);
%         norm_tonic_R_moy(1:EMD-1, i) = normalize2(transition_R_deb, 'PCHIP', EMD-1);
%         norm_tonic_B_moy(1:EMD-1, i) = normalize2(transition_B_deb, 'PCHIP', EMD-1);
% 
%         transition_R_fin(2,1)=tonics_R_meanstd(2, i); transition_R_fin(1,1)=norm_tonic_R_moy(profil_sizes_R_mean(1, i)-EMD-1,i);
%         transition_B_fin(2,1)=tonics_B_meanstd(2, i); transition_B_fin(1,1)=norm_tonic_B_moy(profil_sizes_B_mean(1, i)-EMD-1,i);
%         norm_tonic_R_moy(profil_sizes_R_mean(1, i)-EMD:profil_sizes_R_mean(1, i), i) = normalize2(transition_R_fin, 'PCHIP', EMD+1);
%         norm_tonic_B_moy(profil_sizes_B_mean(1, i)-EMD:profil_sizes_B_mean(1, i), i) = normalize2(transition_B_fin, 'PCHIP', EMD+1);
        
    end
   
 %%%%%%%%%%%%%%%%%%%% NOUVELLE VERSION (OLD VERSION)  avec interpol comme mvt bras %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for i = 1:col_rms/Nb_averaged_trials
        
         %si les essais ont plusieurs pics (x = essai ou il y a des NaN)
        if isnan(tonics_B_meanstd(3, i)) == 1
            tonics_B_meanstd(:, i) = 1;
        end
        % Signaux non-lissés
        % ON PREND EN COMPTE LES SIGNAUX DES MVTS LENTS ENTRE 'ANTICIP' et
        % LENGTH - ANTICIP

        for g = 1:EMD
            norm_tonic_R_moy_OLD(g, i) = tonics_R_meanstd(1, i);
            norm_tonic_B_moy_OLD(g, i) = tonics_B_meanstd(1, i);
        end

        for g = 0:EMD
            norm_tonic_R_moy_OLD(profil_sizes_R_mean(1, i)-g, i) = tonics_R_meanstd(2, i);
            norm_tonic_B_moy_OLD(profil_sizes_B_mean(1, i)-g, i) = tonics_B_meanstd(2, i);
        end

        transition_R_deb(1,1)=tonics_R_meanstd(1, i); transition_R_deb(2,1)=tonics_R_meanstd(2, i);
        transition_B_deb(1,1)=tonics_B_meanstd(1, i); transition_B_deb(2,1)=tonics_B_meanstd(2, i);
        norm_tonic_R_moy_OLD(EMD+1:profil_sizes_R_mean(1, i)-EMD-1, i) = normalize2(transition_R_deb, 'PCHIP', profil_sizes_R_mean(1, i)-2*EMD-1);
        norm_tonic_B_moy_OLD(EMD+1:profil_sizes_R_mean(1, i)-EMD-1, i) = normalize2(transition_B_deb, 'PCHIP', profil_sizes_R_mean(1, i)-2*EMD-1);
        
    end
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    % On calcule le phasique sur le non lissé
    
    emg_phasique_R_avantNorm = RMS_R_moy - norm_tonic_R_moy;
    emg_phasique_B_avantNorm = RMS_B_moy - norm_tonic_B_moy;

%     disp(length(RMS_R_moy))
%     disp(length(norm_tonic_R_moy_OLD))
%     emg_phasique_R_avantNorm_OLD = RMS_R_moy - norm_tonic_R_moy_OLD;
%     emg_phasique_B_avantNorm_OLD = RMS_B_moy - norm_tonic_B_moy_OLD;

    emg_phasique_R_avantNorm_FILT = butter_emgs(emg_phasique_R_avantNorm, 1000,  ordre_filtre_phasic, 10, 'low-pass', 'false', 'centered');
    emg_phasique_B_avantNorm_FILT = butter_emgs(emg_phasique_B_avantNorm, 1000,  ordre_filtre_phasic, 10, 'low-pass', 'false', 'centered');
    
    % On normalise les signaux sur 1000 frames
    
    [~,col_o]=size(emg_phasique_R_avantNorm);
    for i=1:col_o
        emg_phasique_classique_R(:,i) = normalize2(emg_phasique_R_avantNorm(1:profil_sizes_R_mean(1, i),i), 'PCHIP', emg_frequency);
        emg_phasique_classique_B(:,i) = normalize2(emg_phasique_B_avantNorm(1:profil_sizes_B_mean(1, i),i), 'PCHIP', emg_frequency);
%         emg_phasique_classique_OLD_R(:,i) = normalize2(emg_phasique_R_avantNorm_OLD(1:profil_sizes_R_mean(1, i),i), 'PCHIP', emg_frequency);
%         emg_phasique_classique_OLD_B(:,i) = normalize2(emg_phasique_B_avantNorm_OLD(1:profil_sizes_B_mean(1, i),i), 'PCHIP', emg_frequency);
        emg_phasique_classique_R_FILT(:,i) = normalize2(emg_phasique_R_avantNorm_FILT(1:profil_sizes_R_mean(1, i),i), 'PCHIP', emg_frequency); % Linear method
        emg_phasique_classique_B_FILT(:,i) = normalize2(emg_phasique_B_avantNorm_FILT(1:profil_sizes_B_mean(1, i),i), 'PCHIP', emg_frequency);
        emg_phasique_tonicNorm_R(:,i) = normalize2(norm_tonic_R_moy(1:profil_sizes_R_mean(1, i),i), 'PCHIP', emg_frequency); % Linear method
        emg_phasique_tonicNorm_B(:,i) = normalize2(norm_tonic_B_moy(1:profil_sizes_B_mean(1, i),i), 'PCHIP', emg_frequency);
    end
    
    [~,col_rms_moy]=size(RMS_R_moy);
    for i=1:col_rms_moy
        RMS_R_moy_norm(:,i) = normalize2(RMS_R_moy(1:profil_sizes_R_mean(1, i),i), 'PCHIP', emg_frequency);
        RMS_B_moy_norm(:,i) = normalize2(RMS_B_moy(1:profil_sizes_B_mean(1, i),i), 'PCHIP', emg_frequency);
    end
    

    %quantif


    
    EMG_phasique.classiqueFILT.R(:,(WW-1)*nb/2+1:WW*nb/2) = emg_phasique_classique_R_FILT;
    EMG_phasique.classiqueFILT.B(:,(WW-1)*nb/2+1:WW*nb/2) = emg_phasique_classique_B_FILT;
    

    % On construit les résultats
        
    EMG_phasique.classique.R(:,(WW-1)*nb/2+1:WW*nb/2) = emg_phasique_classique_R;
    EMG_phasique.classique.B(:,(WW-1)*nb/2+1:WW*nb/2) = emg_phasique_classique_B;

%     EMG_phasique.classiqueOLD.R(:,(WW-1)*nb/2+1:WW*nb/2) = emg_phasique_classique_OLD_R;
%     EMG_phasique.classiqueOLD.B(:,(WW-1)*nb/2+1:WW*nb/2) = emg_phasique_classique_OLD_B;

    EMG_phasique.RMS.R(:,(WW-1)*nb/2+1:WW*nb/2) = RMS_R_moy_norm;
    EMG_phasique.RMS.B(:,(WW-1)*nb/2+1:WW*nb/2) = RMS_B_moy_norm;

    EMG_phasique.TonicSoustrait.R(:,(WW-1)*nb/2+1:WW*nb/2) = emg_phasique_tonicNorm_R;
    EMG_phasique.TonicSoustrait.B(:,(WW-1)*nb/2+1:WW*nb/2) = emg_phasique_tonicNorm_B;

    tonic_meanstd.R(:,(WW-1)*nb/2+1:WW*nb/2) = tonics_R_meanstd;
    tonic_meanstd.B(:,(WW-1)*nb/2+1:WW*nb/2) = tonics_B_meanstd;

end

