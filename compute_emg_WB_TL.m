%% Test EMG Process
function [rms_cuts, rms_cuts_norm, emg_rms, ...
    emg_filt, emg_rect_filt, ...
    rms_cut_lig, emg_data_filtre_rms_lig, emg_data_filtre_lig, ...
    emg_data_filtre_rect_second_lig] = compute_emg_WB_TL(emg_data, Nb_emgs, emg_frequency, ...
    emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step, ...
    onset, offset, emg_div_kin_freq, anticip, emg_ech_norm, duration_tonic, anticip_tonic)

%% On construit les matrices de résultats
    rms_cuts_test = ones(1000, Nb_emgs);
    rms_cuts_norm_test = ones(1000, Nb_emgs)*99;
    emg_rms_test = ones(10000, Nb_emgs)*99;
    emg_filt_test = ones(10000, Nb_emgs)*99;
    emg_rect_filt_test = ones(10000, Nb_emgs)*99;   

for i = 1: Nb_emgs
    %On effectue un premier filtre passe-bande
    emg_data_filtre = butter_emgs(emg_data(:, i), emg_frequency,  5, emg_band_pass_Freq, 'band-pass', 'false', 'centered');

    % On sauvegarde la taille du signal
    [emg_data_filtre_lig, emg_data_filtre_col]=size(emg_data_filtre);

    %On rectifie (abs) le signal
    emg_data_filtre_rect = abs(emg_data_filtre);
    emg_data_filtre = emg_data_filtre_rect;

    % On effectue un second filtre passe-bas
    emg_data_filtre_rect_second = butter_emgs(emg_data_filtre_rect, emg_frequency,  5, emg_low_pass_Freq, 'low-pass', 'false', 'centered');
    [emg_data_filtre_rect_second_lig, ~] = size(emg_data_filtre_rect_second);

    % On crée la matrice de la bonne taille
    emg_data_filtre_rms = ones(emg_data_filtre_lig-rms_window_step, emg_data_filtre_col)*999;

    % On calcule la rms 
    for f = 1:(emg_data_filtre_lig-rms_window_step) 
        emg_data_filtre_rms(f) = aire_trapz(f, (f + rms_window_step-1), emg_data_filtre);
    end
    
    % On calcule le tonic au début et à la fin du mouvement
    

    % On calcule la taille de la matrice du signal rms
    [emg_data_filtre_rms_lig, ~] = size(emg_data_filtre_rms);

    %On recoupe le signal rms avec la cinématique

    %rms_cut = emg_data_filtre_rms((onset*emg_div_kin_freq)-(emg_div_kin_freq-1)-(anticip*emg_frequency) : (offset*emg_div_kin_freq)+(anticip*emg_frequency), : );
    rms_cut = emg_data_filtre_rms((onset*emg_div_kin_freq)-(anticip*emg_frequency) : (offset*emg_div_kin_freq)-(anticip*emg_frequency), : );
%     rms_cut = emg_data_filtre_rms((onset*emg_div_kin_freq)-(anticip*emg_frequency) : end, : );
    %rms_cut = emg_data_filtre_rms((onset*emg_div_kin_freq): (offset*emg_div_kin_freq), : );

    % On calcule la taille de la matrice rms_cut

    [rms_cut_lig, rms_cut_col] = size(rms_cut);

    % On normalise la matrice rms_cut en durée
    rms_cut_norm = normalize2(rms_cut, 'PCHIP', emg_ech_norm);

    % On remplit les matrices de résultats provisoires
    rms_cuts_test(1:rms_cut_lig, i) = rms_cut;
    rms_cuts_norm_test(:, i) = rms_cut_norm;
    emg_rms_test(1:emg_data_filtre_rms_lig, i) = emg_data_filtre_rms;
    emg_filt_test(1:emg_data_filtre_lig, i) = emg_data_filtre ;
    emg_rect_filt_test(1:emg_data_filtre_lig, i) = emg_data_filtre_rect_second;

    %On calcule les vraies matrices de résultats
    rms_cuts = rms_cuts_test(1:rms_cut_lig, :);
    rms_cuts_norm = rms_cuts_norm_test;
    emg_rms = emg_rms_test(1:emg_data_filtre_rms_lig, :);
    emg_filt = emg_filt_test(1:emg_data_filtre_lig, :);
    emg_rect_filt = emg_rect_filt_test(1:emg_data_filtre_lig, :);
end
