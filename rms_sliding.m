function [RMS] = rms_sliding(signal, lignes, rms_window_step)

% On calcule la rms 
    for f = 1:(lignes-rms_window_step)
        
        RMS(f) = aire_trapz(f, (f + rms_window_step-1), signal);
    end