%% Test EMG Process
function [emg_rms, ...
    emg_filt, emg_rect_filt, ...
    emg_data_filtre_rms_lig, emg_data_filtre_lig, ...
    emg_data_filtre_rect_second_lig] = compute_emg_WB_pos_alea(emg_data, Nb_emgs, emg_frequency, ...
    emg_band_pass_Freq, emg_low_pass_Freq, rms_window_step)

%% On construit les matrices de r�sultats
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

    % On cr�e la matrice de la bonne taille
    emg_data_filtre_rms = ones(emg_data_filtre_lig-rms_window_step, emg_data_filtre_col)*999;

    % On calcule la rms 
    for f = 1:(emg_data_filtre_lig-rms_window_step) 
        emg_data_filtre_rms(f) = aire_trapz(f, (f + rms_window_step-1), emg_data_filtre);
    end

    % On calcule la taille de la matrice du signal rms
    [emg_data_filtre_rms_lig, ~] = size(emg_data_filtre_rms);
  
    % On remplit les matrices de r�sultats provisoires
    emg_rms_test(1:emg_data_filtre_rms_lig, i) = emg_data_filtre_rms;
    emg_filt_test(1:emg_data_filtre_lig, i) = emg_data_filtre ;
    emg_rect_filt_test(1:emg_data_filtre_lig, i) = emg_data_filtre_rect_second;

    %On calcule les vraies matrices de r�sultats

    emg_rms = emg_rms_test(1:emg_data_filtre_rms_lig, :);
    emg_filt = emg_filt_test(1:emg_data_filtre_lig, :);
    emg_rect_filt = emg_rect_filt_test(1:emg_data_filtre_lig, :);
end
