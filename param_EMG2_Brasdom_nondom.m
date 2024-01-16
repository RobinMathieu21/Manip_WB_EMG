


% Fonction permettant de calculer les paramètres des bouffées positives et
% négatives sur l'EMG phasique

function [Results] = param_EMG2_Brasdom_nondom(emg_phasique, meanstd_tonic, Min_emg_duration, emg_frequency, anticip, ICvalue, Tresholdvalue, Vmean_RMS_R, Vmean_RMS_B, Cutoff_emg, Kin_R, Kin_B, muscletype, EMD, Profil_tonic_R, Profil_tonic_B)

[lig_r, col_r] = size(emg_phasique.smooth.R);
[lig_b, col_b] = size(emg_phasique.smooth.B);


% On fait une matrice de test des résultats
Results.test = zeros(4, 10);
Results.R(1:(col_r-1), 1) = 1;
Results.R(1:(col_r-1), 7) = 1;
Results.B(1:(col_b-1), 1) = 1;
Results.B(1:(col_b-1), 7) = 1;


%Pour chaque essai dans la première direction

for f = 1:(col_r-1)

%% On trouve le pic de le bouffée positive

% onset = Kin_R(f, 6); Si on veut calculer l'EMD

onset = anticip*emg_frequency;
Cut = ones(Min_emg_duration*emg_frequency, 1)*ICvalue*meanstd_tonic.brut.R(3, f);
Cut_neg = -Cut;

% if muscletype == 2
%     T_Vpeak = onset+Kin_R(f, 4)*emg_frequency-EMD*emg_frequency;
%     [max_bouffee_pos, ind_max_bouffee_pos] = max(emg_phasique.nonsmooth.brut.R(150:650, f));
%     ind_max_bouffee_pos = ind_max_bouffee_pos+150;
% else
%     [max_bouffee_pos, ind_max_bouffee_pos] = max(emg_phasique.nonsmooth.brut.R(150:810, f));
%     ind_max_bouffee_pos = ind_max_bouffee_pos+150;
%     
% end
% % On vérifie si la valeur dépasse l'intervalle de confiance du tonic start
% if max_bouffee_pos<ICvalue*meanstd_tonic.brut.R(3, f)
%     Results.R(f, 1) = 0;
% end

% On vérifie si la valeur dépasse la valeur seuil de l'EMGMax

% if max_bouffee_pos<Tresholdvalue
%     Results.R(f, 1) = 0;
% end

% On cherche le début et la fin de la bouffée
i = 1;


while sum(emg_phasique.nonsmooth.brut.R(i:(i+Min_emg_duration*emg_frequency)-1, f) > Cut) ~= 50 && i<lig_r-50
    i = i+1;
end

indice_bouffee_pos_start = i;

j = indice_bouffee_pos_start;

while sum(emg_phasique.nonsmooth.brut.R(j:(j+Min_emg_duration*emg_frequency)-1, f) > Cut) ~= 0 && j<lig_r-50
    j = j+1;
end

indice_bouffee_pos_end = j;

% On vérifie que la bouffée dure plus de 50ms

if indice_bouffee_pos_end-indice_bouffee_pos_start < (Min_emg_duration*emg_frequency)
    Results.R(f, 1) = 0;
end
    

%% Pareil pour la bouffée négative

% [max_bouffee_neg, ind_max_bouffee_neg] = min(emg_phasique.nonsmooth.brut.R(150:650, f));
% ind_max_bouffee_neg = ind_max_bouffee_neg+150;


% % On vérifie si la valeur dépasse l'intervalle de confiance du tonic start
% if max_bouffee_neg>-ICvalue*meanstd_tonic.brut.R(3, f)
%     Results.R(f, 7) = 0;
% end

% if max_bouffee_neg>-0.1*max_bouffee_pos
%     Results.R(f, 7) = 0;
% end

% On cherche le début et la fin de la bouffée
i = 1;


while sum(emg_phasique.nonsmooth.brut.R(i:(i+Min_emg_duration*emg_frequency)-1, f) < Cut_neg) ~= 50 && i<lig_r-50
    i = i+1;
end

indice_bouffee_neg_start = i;

j = indice_bouffee_neg_start;

while sum(emg_phasique.nonsmooth.brut.R(j:(j+Min_emg_duration*emg_frequency)-1, f) < Cut_neg) ~= 0 && j<lig_r-50
    j = j+1;
end

indice_bouffee_neg_end = j;

% On calcule le tonic au moement de la bouffée négative

norm_tonic = mean(Profil_tonic_R(indice_bouffee_neg_start:indice_bouffee_neg_end, f));
norm_tonic_area = sum((Profil_tonic_R(indice_bouffee_neg_start:indice_bouffee_neg_end, f)));
bouffeeneg_norm = zeros(indice_bouffee_neg_end-indice_bouffee_neg_start+1, 1);
a = 1;
for k = indice_bouffee_neg_start:indice_bouffee_neg_end
    bouffeeneg_norm(a, 1) = emg_phasique.nonsmooth.brut.R(k, f)/Profil_tonic_R(k, f);
    a = a+1;
end
    
% On vérifie que la bouffée dure plus de 50ms

if indice_bouffee_neg_end-indice_bouffee_neg_start < (Min_emg_duration*emg_frequency)
    Results.R(f, 7) = 0;
end

if Results.R(f, 1) == 0
indice_bouffee_pos_start = NaN;
indice_bouffee_pos_end = NaN;
end

if Results.R(f, 7) == 0
    
indice_bouffee_neg_start = NaN;
indice_bouffee_neg_end = NaN;  
end




%% On calcule les paramètres des bouffées

% On calcule le début et la fin de la bouffée positive par rapport au début du
% mouvement cinématique ainsi que sa durée

% Cas où les bouffées ne sont pas détectées


if  Results.R(f, 1) == 0
    bouffee_pos_start = NaN;
    bouffee_pos_end = NaN;
    duree_bouffee_pos = NaN;
    max_bouffee_pos = NaN;
    aire_bouffee_pos = NaN;
else
    bouffee_pos_start = (indice_bouffee_pos_start-onset)/emg_frequency;
bouffee_pos_end = (indice_bouffee_pos_end-onset)/emg_frequency;

duree_bouffee_pos = (indice_bouffee_pos_end-indice_bouffee_pos_start)/emg_frequency;

% On calcule le max et l'aire de la bouffée sur le signal non lissé

aire_bouffee_pos = aire_trapz(indice_bouffee_pos_start, indice_bouffee_pos_end, emg_phasique.nonsmooth.brut.R(:, f));
[max_bouffee_pos, ind_max_bouffee_pos] = max(emg_phasique.nonsmooth.brut.R(indice_bouffee_pos_start:indice_bouffee_pos_end, f));
end

if  Results.R(f, 7) == 0
    bouffee_neg_start = NaN;
    bouffee_neg_end = NaN;
    duree_bouffee_neg = NaN;
    max_bouffee_neg = NaN;
    aire_bouffee_neg = NaN;

else

% On fait la même chose sur la bouffée négative

bouffee_neg_start = (indice_bouffee_neg_start-onset)/emg_frequency;
bouffee_neg_end = (indice_bouffee_neg_end-onset)/emg_frequency;

duree_bouffee_neg = (indice_bouffee_neg_end-indice_bouffee_neg_start)/emg_frequency;
duree_bouffee_neg = duree_bouffee_neg/Kin_R(f, 2);

aire_bouffee_neg = aire_trapz(indice_bouffee_neg_start, indice_bouffee_neg_end, emg_phasique.nonsmooth.brut.R(:, f));
max_bouffee_neg = min(bouffeeneg_norm)*100;
end

% On calcule l'aire sur la phase d'accélération et sur la phase de
% décélération

accel_start = onset-(EMD*emg_frequency);

if accel_start<0
    accel_start = 100;
end

accel_end = onset+round(Kin_R(f, 14)*emg_frequency)-EMD*emg_frequency;

decel_start = accel_end;

decel_end = onset+round(Kin_R(f, 2)*emg_frequency)-EMD*emg_frequency;

aire_accel = trapz(emg_phasique.nonsmooth.brut.R(accel_start:accel_end, f));
aire_decel = trapz(emg_phasique.nonsmooth.brut.R(decel_start:decel_end, f));

aire_pos_accel = 0;
aire_neg_accel = 0;

for m = accel_start:accel_end
    if emg_phasique.nonsmooth.brut.R(m, f) < 0
        aire_neg_accel = aire_neg_accel+emg_phasique.nonsmooth.brut.R(m, f);
        
    else
        aire_pos_accel = aire_pos_accel+emg_phasique.nonsmooth.brut.R(m, f);
        
    end
    
    aire_pos_decel = 0;
    aire_neg_decel = 0;
    
end

for m = decel_start:decel_end
    if emg_phasique.nonsmooth.brut.R(m, f) < 0
        aire_neg_decel = aire_neg_decel+emg_phasique.nonsmooth.brut.R(m, f);
        
    else
        aire_pos_decel = aire_pos_decel+emg_phasique.nonsmooth.brut.R(m, f);
        
    end
    
end

if Results.R(f, 1) ~= 0
    
    q30 = trapz(emg_phasique.nonsmooth.brut.R(indice_bouffee_pos_start:indice_bouffee_pos_start+29, f));
    
else 
    q30 = NaN;
    
end

% On remplit les paramètres dans un tableau


aire_bouffee_neg = (aire_bouffee_neg/norm_tonic_area)*duree_bouffee_neg*100;

Results.R(f, 2) = bouffee_pos_start;
Results.R(f, 3) = bouffee_pos_end;
Results.R(f, 4) = duree_bouffee_pos;
Results.R(f, 5) = max_bouffee_pos;
Results.R(f, 6) = aire_bouffee_pos;
Results.R(f, 8) = bouffee_neg_start;
Results.R(f, 9) = bouffee_neg_end;
Results.R(f, 10) = duree_bouffee_neg;
Results.R(f, 11) = max_bouffee_neg;
Results.R(f, 12) = aire_bouffee_neg; 
Results.R(f, 13) = aire_accel;
Results.R(f, 14) = aire_pos_accel;
Results.R(f, 15) = aire_neg_accel;
Results.R(f, 16) = aire_decel;
Results.R(f, 17) = aire_pos_decel;
Results.R(f, 18) = aire_neg_decel;
Results.R(f, 19) = q30;
Results.R(f, 20) = Vmean_RMS_R(f);
Results.R(f, 21) = Kin_R(f, 1);
Results.R(f, 22) = Kin_R(f, 4);

if Results.R(f, 1) == 0
    Results.R(f, 23) = NaN;
    Results.R(f, 24) = NaN;
else
Results.R(f, 23) = emg_phasique.nonsmooth.brut.R(indice_bouffee_pos_start, f);
Results.R(f, 24) = emg_phasique.nonsmooth.brut.R(indice_bouffee_pos_end, f);
end

if Results.R(f, 7) == 0
    Results.R(f, 25) = NaN;
    Results.R(f, 26) = NaN;
else
Results.R(f, 25) = emg_phasique.nonsmooth.brut.R(indice_bouffee_neg_start, f);
Results.R(f, 26) = emg_phasique.nonsmooth.brut.R(indice_bouffee_neg_end, f);
end
ind_max_bouffee_neg = a-1;
% Results.R(f, 27) = ind_max_bouffee_pos;
Results.R(f, 28) = ind_max_bouffee_neg;
Results.R(f, 29) = indice_bouffee_pos_start;
Results.R(f, 30) = indice_bouffee_pos_end;
Results.R(f, 31) = indice_bouffee_neg_start;
Results.R(f, 32) = indice_bouffee_neg_end;

end

%% On fait la même chose pour la seconde direction

for f = 1:(col_b-1)

%% On trouve le pic de le bouffée positive

% onset = Kin_R(f, 6); Si on veut calculer l'EMD

onset = anticip*emg_frequency;
Cut = ones(Min_emg_duration*emg_frequency, 1)*ICvalue*meanstd_tonic.brut.R(3, f);
Cut_neg = -Cut;
% if muscletype == 2
%     T_Vpeak = onset+Kin_R(f, 4)*emg_frequency-EMD*emg_frequency;
%     [max_bouffee_pos, ind_max_bouffee_pos] = max(emg_phasique.nonsmooth.brut.R(150:650, f));
%     ind_max_bouffee_pos = ind_max_bouffee_pos+150;
% else
%     [max_bouffee_pos, ind_max_bouffee_pos] = max(emg_phasique.nonsmooth.brut.R(150:810, f));
%     ind_max_bouffee_pos = ind_max_bouffee_pos+150;
%     
% end
% % On vérifie si la valeur dépasse l'intervalle de confiance du tonic start
% if max_bouffee_pos<ICvalue*meanstd_tonic.brut.R(3, f)
%     Results.R(f, 1) = 0;
% end

% On vérifie si la valeur dépasse la valeur seuil de l'EMGMax

% if max_bouffee_pos<Tresholdvalue
%     Results.R(f, 1) = 0;
% end

% On cherche le début et la fin de la bouffée
i = 1;


while sum(emg_phasique.nonsmooth.brut.B(i:(i+Min_emg_duration*emg_frequency)-1, f) > Cut) ~= 50 && i<lig_b-50
    i = i+1;
end

indice_bouffee_pos_start = i;

j = indice_bouffee_pos_start;

while sum(emg_phasique.nonsmooth.brut.B(j:(j+Min_emg_duration*emg_frequency)-1, f) > Cut) ~= 0 && j<lig_b-50
    j = j+1;
end

indice_bouffee_pos_end = j;

% On vérifie que la bouffée dure plus de 50ms

if indice_bouffee_pos_end-indice_bouffee_pos_start < (Min_emg_duration*emg_frequency)
    Results.B(f, 1) = 0;
end
    

%% Pareil pour la bouffée négative

% [max_bouffee_neg, ind_max_bouffee_neg] = min(emg_phasique.nonsmooth.brut.R(150:650, f));
% ind_max_bouffee_neg = ind_max_bouffee_neg+150;


% % On vérifie si la valeur dépasse l'intervalle de confiance du tonic start
% if max_bouffee_neg>-ICvalue*meanstd_tonic.brut.R(3, f)
%     Results.R(f, 7) = 0;
% end

% if max_bouffee_neg>-0.1*max_bouffee_pos
%     Results.R(f, 7) = 0;
% end

% On cherche le début et la fin de la bouffée. Je pars de 200 pour ne pas
% trouver de bouffée avant le début du mouvement par erreur
i = 200;


while sum(emg_phasique.nonsmooth.brut.B(i:(i+Min_emg_duration*emg_frequency)-1, f) < Cut_neg) ~= 50 && i<lig_b-50
    i = i+1;
end

indice_bouffee_neg_start = i;

j = indice_bouffee_neg_start;

while sum(emg_phasique.nonsmooth.brut.B(j:(j+Min_emg_duration*emg_frequency)-1, f) < Cut_neg) ~= 0 && j<lig_b-50
    j = j+1;
end

indice_bouffee_neg_end = j;

% On calcule le tonic au moement de la bouffée négative

norm_tonic = mean(Profil_tonic_B(indice_bouffee_neg_start:indice_bouffee_neg_end, f));
norm_tonic_area = sum((Profil_tonic_B(indice_bouffee_neg_start:indice_bouffee_neg_end, f)));
bouffeeneg_norm = zeros(indice_bouffee_neg_end-indice_bouffee_neg_start+1, 1);
a = 1;
for k = indice_bouffee_neg_start:indice_bouffee_neg_end
    bouffeeneg_norm(a, 1) = emg_phasique.nonsmooth.brut.B(k, f)/Profil_tonic_B(k, f);
    a = a+1;
end
    
% On vérifie que la bouffée dure plus de 50ms

if indice_bouffee_neg_end-indice_bouffee_neg_start < (Min_emg_duration*emg_frequency)
    Results.B(f, 7) = 0;
end

if Results.B(f, 1) == 0
indice_bouffee_pos_start = NaN;
indice_bouffee_pos_end = NaN;
end

if Results.B(f, 7) == 0
    
indice_bouffee_neg_start = NaN;
indice_bouffee_neg_end = NaN;  
end




%% On calcule les paramètres des bouffées

% On calcule le début et la fin de la bouffée positive par rapport au début du
% mouvement cinématique ainsi que sa durée

% Cas où les bouffées ne sont pas détectées


if  Results.B(f, 1) == 0
    bouffee_pos_start = NaN;
    bouffee_pos_end = NaN;
    duree_bouffee_pos = NaN;
    max_bouffee_pos = NaN;
    aire_bouffee_pos = NaN;
else
    bouffee_pos_start = (indice_bouffee_pos_start-onset)/emg_frequency;
bouffee_pos_end = (indice_bouffee_pos_end-onset)/emg_frequency;

duree_bouffee_pos = (indice_bouffee_pos_end-indice_bouffee_pos_start)/emg_frequency;

% On calcule le max et l'aire de la bouffée sur le signal non lissé

aire_bouffee_pos = aire_trapz(indice_bouffee_pos_start, indice_bouffee_pos_end, emg_phasique.nonsmooth.brut.B(:, f));
[max_bouffee_pos, ind_max_bouffee_pos] = max(emg_phasique.nonsmooth.brut.B(indice_bouffee_pos_start:indice_bouffee_pos_end, f));
end

if  Results.B(f, 7) == 0
    bouffee_neg_start = NaN;
    bouffee_neg_end = NaN;
    duree_bouffee_neg = NaN;
    max_bouffee_neg = NaN;
    aire_bouffee_neg = NaN;

else

% On fait la même chose sur la bouffée négative

bouffee_neg_start = (indice_bouffee_neg_start-onset)/emg_frequency;
bouffee_neg_end = (indice_bouffee_neg_end-onset)/emg_frequency;

duree_bouffee_neg = (indice_bouffee_neg_end-indice_bouffee_neg_start)/emg_frequency;
duree_bouffee_neg = duree_bouffee_neg/Kin_B(f, 2);
max_bouffee_neg = min(bouffeeneg_norm)*100;
aire_bouffee_neg = aire_trapz(indice_bouffee_neg_start, indice_bouffee_neg_end, emg_phasique.nonsmooth.brut.B(:, f));

end

% On calcule l'aire sur la phase d'accélération et sur la phase de
% décélération

accel_start = onset-(EMD*emg_frequency);

if accel_start<0
    accel_start = 100;
end

accel_end = onset+round(Kin_B(f, 14)*emg_frequency)-EMD*emg_frequency;

decel_start = accel_end;

decel_end = onset+round(Kin_B(f, 2)*emg_frequency)-EMD*emg_frequency;

aire_accel = trapz(emg_phasique.nonsmooth.brut.B(accel_start:accel_end, f));
aire_decel = trapz(emg_phasique.nonsmooth.brut.B(decel_start:decel_end, f));

aire_pos_accel = 0;
aire_neg_accel = 0;

for m = accel_start:accel_end
    if emg_phasique.nonsmooth.brut.B(m, f) < 0
        aire_neg_accel = aire_neg_accel+emg_phasique.nonsmooth.brut.B(m, f);
        
    else
        aire_pos_accel = aire_pos_accel+emg_phasique.nonsmooth.brut.B(m, f);
        
    end
    
    aire_pos_decel = 0;
    aire_neg_decel = 0;
    
end

for m = decel_start:decel_end
    if emg_phasique.nonsmooth.brut.B(m, f) < 0
        aire_neg_decel = aire_neg_decel+emg_phasique.nonsmooth.brut.B(m, f);
        
    else
        aire_pos_decel = aire_pos_decel+emg_phasique.nonsmooth.brut.B(m, f);
        
    end
    
end

if Results.B(f, 1) ~= 0
    
    q30 = trapz(emg_phasique.nonsmooth.brut.B(indice_bouffee_pos_start:indice_bouffee_pos_start+29, f));
    
else 
    q30 = NaN;
    
end

% On remplit les paramètres dans un tableau

aire_bouffee_neg = (aire_bouffee_neg/norm_tonic_area)*duree_bouffee_neg*100;

Results.B(f, 2) = bouffee_pos_start;
Results.B(f, 3) = bouffee_pos_end;
Results.B(f, 4) = duree_bouffee_pos;
Results.B(f, 5) = max_bouffee_pos;
Results.B(f, 6) = aire_bouffee_pos;
Results.B(f, 8) = bouffee_neg_start;
Results.B(f, 9) = bouffee_neg_end;
Results.B(f, 10) = duree_bouffee_neg;
Results.B(f, 11) = max_bouffee_neg;
Results.B(f, 12) = aire_bouffee_neg; 
Results.B(f, 13) = aire_accel;
Results.B(f, 14) = aire_pos_accel;
Results.B(f, 15) = aire_neg_accel;
Results.B(f, 16) = aire_decel;
Results.B(f, 17) = aire_pos_decel;
Results.B(f, 18) = aire_neg_decel;
Results.B(f, 19) = q30;
Results.B(f, 20) = Vmean_RMS_B(f);
Results.B(f, 21) = Kin_B(f, 1);
Results.B(f, 22) = Kin_B(f, 4);

if Results.B(f, 1) == 0
    Results.B(f, 23) = NaN;
    Results.B(f, 24) = NaN;
else
Results.B(f, 23) = emg_phasique.nonsmooth.brut.B(indice_bouffee_pos_start, f);
Results.B(f, 24) = emg_phasique.nonsmooth.brut.B(indice_bouffee_pos_end, f);
end

if Results.B(f, 7) == 0
    Results.B(f, 25) = NaN;
    Results.B(f, 26) = NaN;
else
Results.B(f, 25) = emg_phasique.nonsmooth.brut.B(indice_bouffee_neg_start, f);
Results.B(f, 26) = emg_phasique.nonsmooth.brut.B(indice_bouffee_neg_end, f);
end
ind_max_bouffee_neg = a-1;
% Results.B(f, 27) = ind_max_bouffee_pos;
Results.B(f, 28) = ind_max_bouffee_neg;
Results.B(f, 29) = indice_bouffee_pos_start;
Results.B(f, 30) = indice_bouffee_pos_end;
Results.B(f, 31) = indice_bouffee_neg_start;
Results.B(f, 32) = indice_bouffee_neg_end;

end