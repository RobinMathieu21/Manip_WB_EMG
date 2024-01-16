%% Test EMG Process
function [rms_cuts, rms_cuts_norm, emg_rms, ...
    emg_filt, emg_rect_filt, tonic_starts, tonic_ends, ...
    rms_cut_lig, emg_data_filtre_rms_lig, emg_data_filtre_lig, ...
    emg_data_filtre_rect_second_lig, anticip_rms, tonic_lig] = compute_emg(emg_data, Nb_emgs, emg_frequency, ...
    emg_band_pass_Freq, emg_low_pass_Freq, type_RMS, rms_window_step, ...
    onset, offset, emg_div_kin_freq, anticip,emg_ech_norm, anticip_tonic, duration_tonic, emgrms_div_kin_freq, size_emg_data)

%% On construit les matrices de résultats
    rms_cuts_test = ones(1000, Nb_emgs);
    rms_cuts_norm_test = ones(1000, Nb_emgs)*99;
    emg_rms_test = ones(10000, Nb_emgs)*99;
    emg_filt_test = ones(10000, Nb_emgs)*99;
    emg_rect_filt_test = ones(10000, Nb_emgs)*99;
    tonic_starts_test = ones(1000,  Nb_emgs)*99;
    tonic_ends_test = ones(1000,  Nb_emgs)*99;   
    
    
    % On spécifie la taille du tonic
    tonic_lig = emg_frequency*(duration_tonic/1000);

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
    % Si on calcule la RMS en sliding
    if type_RMS == 1
        
        % On crée la matrice de la bonne taille
        emg_data_filtre_rms = ones(emg_data_filtre_lig-rms_window_step, emg_data_filtre_col)*999;
        
        % On calcule la rms 
        for f = 1:(emg_data_filtre_lig-rms_window_step)
            
            emg_data_filtre_rms(f) = aire_trapz(f, (f + rms_window_step-1), emg_data_filtre);
        end
        

%         for f = 1:(8375-500)
%             
%             Donnees_EMG_lent.RMS_NEW3(f) = aire_trapz(f, (f + 500-1), Donnees_EMG.Rectifiees.DA(:,1));
%         end
%        Donnees_EMG_lent.RMS_NEW5= rms_gbiomech(Donnees_EMG.Rectifiees.DA(:,1),100,0,1);

        

        % On calcule la taille de la matrice du signal rms
        [emg_data_filtre_rms_lig, ~] = size(emg_data_filtre_rms);
        
        %On recoupe le signal rms avec la cinématique
        
        rms_cut = emg_data_filtre_rms((onset*emg_div_kin_freq)-(emg_div_kin_freq-1)-(anticip*emg_frequency) : (offset*emg_div_kin_freq)+(anticip*emg_frequency), : );
        
        % On calcule la taille de la matrice rms_cut
        
        [rms_cut_lig, rms_cut_col] = size(rms_cut);
        
        % On normalise la matrice rms_cut en durée
        rms_cut_norm = normalize2(rms_cut, 'PCHIP', emg_ech_norm);
        
        
        % On calcule le tonic au début et à la fin du mouvement
        tonic_start(:,i) = emg_data_filtre_rms((onset*emg_div_kin_freq)-(emg_div_kin_freq-1) - ((duration_tonic + anticip_tonic)/1000)*emg_frequency: (onset*emg_div_kin_freq)-(emg_div_kin_freq-1) - (anticip_tonic/1000)*emg_frequency, :) ;
        tonic_end(:,i) = emg_data_filtre_rms((offset*emg_div_kin_freq) + (anticip_tonic/1000)*emg_frequency: (offset*emg_div_kin_freq) + ((duration_tonic + anticip_tonic)/1000)*emg_frequency, :) ;
        
        [tonic_start_lig, ~] = size(tonic_start);
        [tonic_end_lig, ~] = size(tonic_end);
        
        %On calcule l'anticipation pour la rms
        anticip_rms = anticip*emg_frequency;
    
        
    
   
        
        % On remplit les matrices de résultats provisoires
        rms_cuts_test(1:rms_cut_lig, i) = rms_cut;
        rms_cuts_norm_test(:, i) = rms_cut_norm;
        emg_rms_test(1:emg_data_filtre_rms_lig, i) = emg_data_filtre_rms;
        emg_filt_test(1:emg_data_filtre_lig, i) = emg_data_filtre ;
        emg_rect_filt_test(1:emg_data_filtre_lig, i) = emg_data_filtre_rect_second;
        tonic_starts_test(1:tonic_start_lig, i) = tonic_start(:, i);
        tonic_ends_test(1:tonic_end_lig, i) = tonic_end(:, i);

    end

% Boucle pour couper le signal RMS
k = 1;
while tonic_starts_test(k, 1) <99
    k = k+1;
end
     k = k-1;
    
    %On calcule les vraies matrices de résultats
    rms_cuts = rms_cuts_test(1:rms_cut_lig, :);
    rms_cuts_norm = rms_cuts_norm_test;
    emg_rms = emg_rms_test(1:emg_data_filtre_rms_lig, :);
    emg_filt = emg_filt_test(1:emg_data_filtre_lig, :);
    emg_rect_filt = emg_rect_filt_test(1:emg_data_filtre_lig, :);
        
    tonic_starts = tonic_starts_test(1:k, :);
    tonic_ends = tonic_ends_test(1:k, :);
    
    tonic_starts = tonic_starts(1:k, :);
    tonic_ends = tonic_ends(1:k, :);
    tonic_lig = k;
    
end
    
        

    
    
    


        

