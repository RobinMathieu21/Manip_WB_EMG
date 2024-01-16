%% Fonction qui permet � partir des signaux trait�s (RMS) de computer le phasique

function [EMG_phasique , tonic_meanstd, Vmean_RMS_R, Vmean_RMS_B, norm_tonic_R_moy, norm_tonic_B_moy] = compute_emg2_TonicNew_WB(RMS, RMS_R_norm2, RMS_B_norm2, ...
 emg_frequency, tonic_debut, tonic_fin, Idx, limite_en_temps, signal_mvt_lent_R_complet, signal_mvt_lent_B_complet, Nb_emgs, Phasic_lent)   


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

    Phasic_lent_R = Phasic_lent.Se_lever(:, (WW-1)*nb+1:WW*nb);
    Phasic_lent_B = Phasic_lent.Se_rassoir(:, (WW-1)*nb+1:WW*nb);
        
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
    
    % On calcule maintenant la moyenne et l'�cart type des siganux
    % tonics non-liss�s
    nb_signaux = nb/Nb_averaged_trials;
    tonics_R_meanstd = zeros(4, col_rms/Nb_averaged_trials);
    tonics_R_meanstd(1, :) = mean(tonic_debut_R_moy, 'omitnan');
    tonics_R_meanstd(2, :) = mean(tonic_fin_R_moy, 'omitnan');
    tonics_R_meanstd(3, :) = std(tonic_debut_R_moy, 'omitnan');
    tonics_R_meanstd(4, :) = std(tonic_fin_R_moy, 'omitnan');
    disp(append('R =' +string(mean(tonics_R_meanstd(3, :)))));
    tonics_B_meanstd = zeros(4, col_rms/Nb_averaged_trials);
    tonics_B_meanstd(1, :) = mean(tonic_debut_B_moy, 'omitnan');
    tonics_B_meanstd(2, :) = mean(tonic_fin_B_moy, 'omitnan');
    tonics_B_meanstd(3, :) = std(tonic_debut_B_moy, 'omitnan');
    tonics_B_meanstd(4, :) = std(tonic_fin_B_moy, 'omitnan');
    disp(append('B =' +string(mean(tonics_B_meanstd(3, :)))));
    % On normalise les tonics pour avoir le m�me nombre de frames que sur la RMS_cut
    
    for i = 1:col_rms/Nb_averaged_trials
        
         %si les essais ont plusieurs pics (x = essai ou il y a des NaN)
        if isnan(tonics_B_meanstd(3, i)) == 1
            tonics_B_meanstd(:, i) = 1;
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
    end
    
    % On calcule le phasique sur le non liss�
    
    emg_phasique_R_avantNorm = RMS_R_moy - norm_tonic_R_moy;
    emg_phasique_B_avantNorm = RMS_B_moy - norm_tonic_B_moy;
    
    % On normalise les signaux sur 1000 frames
    
    [~,col_o]=size(emg_phasique_R_avantNorm);
    for i=1:col_o
        emg_phasique_classique_R(:,i) = normalize2(emg_phasique_R_avantNorm(1:profil_sizes_R_mean(1, i),i), 'PCHIP', emg_frequency);
        emg_phasique_classique_B(:,i) = normalize2(emg_phasique_B_avantNorm(1:profil_sizes_B_mean(1, i),i), 'PCHIP', emg_frequency);
    end
    
    [~,col_rms_moy]=size(RMS_R_moy);
    for i=1:col_rms_moy
        RMS_R_moy_norm(:,i) = normalize2(RMS_R_moy(1:profil_sizes_R_mean(1, i),i), 'PCHIP', emg_frequency);
        RMS_B_moy_norm(:,i) = normalize2(RMS_B_moy(1:profil_sizes_B_mean(1, i),i), 'PCHIP', emg_frequency);
    end
    
    
    
    %% On calcule le phasic combin� avec comme base le mvt lent mais remis de mani�re � avoir un phasic qui commence et fini � 0
    
    % Allou� de l'espace pour la boucle
    signal_mvt_lent_R_trans(1:emg_frequency,1)=-ones(1, emg_frequency);
    signal_mvt_lent_B_trans(1:emg_frequency,1)=-ones(1, emg_frequency);
    
    % On cr�e une colonne de 1 � 1000 pour pouvoir tourner une matrice � deux colonnes
    for f= 1:emg_frequency
        signal_mvt_lent_R_trans(f,1) = f;
        signal_mvt_lent_B_trans(f,1) = f;
    end
    
    %% pour le mouvement R
    % On Translate le Mouvement R � 0 en soustrayant au mvt lent la diff�rence entre le mvt lent et le tonic
    signal_mvt_lent_R_trans(:,2) = signal_mvt_lent_R - (signal_mvt_lent_R(1,1) -mean(tonics_R_meanstd(1,:)));
    %signal_mvt_lent_R_trans(:,2) = signal_mvt_lent_R - (signal_mvt_lent_R(1,1) - RMS_R_norm2(1,1));
    
    
% % % % % % % % % % % % % %     % On calule l'angle entre le signal translat� et l'horizontal
% % % % % % % % % % % % % %     teta1 = atand((signal_mvt_lent_R_trans(emg_frequency,2)-signal_mvt_lent_R_trans(1,2))/emg_frequency);
% OLD VERSION         % % %     % On calule l'angle entre le tonic et l'horizontal
% % % % % % % % % % % % % %     teta2 = atand((mean(tonics_R_meanstd(2, :))-signal_mvt_lent_R_trans(1,2))/emg_frequency);
% % % % % % % % % % % % % %     %teta2 = atand((RMS_R_norm2(emg_frequency,1)-signal_mvt_lent_R_trans(1,2))/emg_frequency);
% % % % % % % % % % % % % %     % On calule la diff�rence entre ces deux angles
% % % % % % % % % % % % % %     teta = teta1-teta2;
% % % % % % % % % % % % % %     
% % % % % % % % % % % % % %     % On d�finit la matrice de rotation avec cet angle 
% % % % % % % % % % % % % %     if (RMS_R_norm2(emg_frequency,1)-signal_mvt_lent_R_trans(emg_frequency,2))<0
% % % % % % % % % % % % % %         R = [cosd(teta) -sind(teta); sind(teta) cosd(teta)];
% % % % % % % % % % % % % %     else
% % % % % % % % % % % % % %         R = [cosd(teta) sind(teta); -sind(teta) cosd(teta)];
% % % % % % % % % % % % % %     end
    
    % Calcul de l'angle entre la tonic fin et le signal translat�
    teta = acosd(((mean(tonics_R_meanstd(2, :)) - mean(tonics_R_meanstd(1, :))) * (signal_mvt_lent_R_trans(emg_frequency,2) - signal_mvt_lent_R_trans(1,2)) + (emg_frequency - 0) * (emg_frequency - 0)) / (sqrt((mean(tonics_R_meanstd(2, :)) - mean(tonics_R_meanstd(1, :)))^2 + (emg_frequency - 0)^2) * sqrt((signal_mvt_lent_R_trans(emg_frequency,2) - signal_mvt_lent_R_trans(1,2))^2 + (emg_frequency - 0)^2)));

    % On multiplie le signal translat� � la mtrice de rot pour obtenir le
    % signal translat� et 'rotationn�'


    if (mean(tonics_R_meanstd(2, :))<signal_mvt_lent_R_trans(emg_frequency,2))
    	signal_mvt_lent_R_trans_rot(:,1) = signal_mvt_lent_R_trans(:,1) * cosd(teta) + signal_mvt_lent_R_trans(:,2) * sind(teta);
        signal_mvt_lent_R_trans_rot(:,2) = -signal_mvt_lent_R_trans(:,1) * sind(teta) + signal_mvt_lent_R_trans(:,2) * cosd(teta);
        disp('1')
    else
        signal_mvt_lent_R_trans_rot(:,1) = signal_mvt_lent_R_trans(:,1) * cosd(teta) - signal_mvt_lent_R_trans(:,2) * sind(teta);
        signal_mvt_lent_R_trans_rot(:,2) = signal_mvt_lent_R_trans(:,1) * sind(teta) + signal_mvt_lent_R_trans(:,2) * cosd(teta);
        disp('2')
    end
    
    % Calcul du phasic avec le tonic issu du mvt lent translat� et
    % rotationn�
    emg_phasique_combined_R = RMS_R_moy_norm-signal_mvt_lent_R_trans_rot(:,2);
    
    %% Pour le mouvement B
    % Mouvement B
    signal_mvt_lent_B_trans(:,2) = signal_mvt_lent_B - (signal_mvt_lent_B(1,1) - mean(tonics_B_meanstd(1,:)));
    %signal_mvt_lent_B_trans(:,2) = signal_mvt_lent_B - (signal_mvt_lent_B(1,1) - RMS_B_norm2(1,1));
% % % % % % % % % % % % % % %     
% % % % % % % % % % % % % % %     % On calule l'angle entre le signal translat� et l'horizontal
% % % % % % % % % % % % % % %     teta1 = atand((signal_mvt_lent_B_trans(emg_frequency,2)-signal_mvt_lent_B_trans(1,2))/emg_frequency);
% % % % % % % % % % % % % % %     % On calule l'angle entre le tonic et l'horizontal
% % % % % % % % % % % % % % %     teta2 = atand((mean(tonics_B_meanstd(2, :))-signal_mvt_lent_B_trans(1,2))/emg_frequency);
% % % % % % % % % % % % % % %     %teta2 = atand((RMS_B_norm2(emg_frequency,1)-signal_mvt_lent_B_trans(1,2))/emg_frequency);
% % % % % % % % % % % % % % %     
% % % % % % % % % % % % % % %     % On calule la diff�rence entre ces deux angles
% % % % % % % % % % % % % % %     teta = teta1-teta2;
% % % % % % % % % % % % % % %     
% % % % % % % % % % % % % % %     % On d�finit la matrice de rotation avec cet angle 
% % % % % % % % % % % % % % %     if (mean(tonics_B_meanstd(2, :))>signal_mvt_lent_B_trans(emg_frequency,2))
% % % % % % % % % % % % % % %         R = [cosd(teta) -sind(teta); -sind(teta) cosd(teta)];
% % % % % % % % % % % % % % %     else
% % % % % % % % % % % % % % %         R = [cosd(teta) sind(teta); sind(teta) cosd(teta)];
% % % % % % % % % % % % % % %     end
% % % % % % % % % % % % % % %     
% % % % % % % % % % % % % % %     % On multiplie le signal translat� � la mtrice de rot pour obtenir le
% % % % % % % % % % % % % % %     % signal translat� et 'rotationn�'
% % % % % % % % % % % % % % %     signal_mvt_lent_B_trans_rot = signal_mvt_lent_B_trans * R;

    % Calcul de l'angle entre la tonic fin et le signal translat�
    teta = acosd(((mean(tonics_B_meanstd(2, :)) - mean(tonics_B_meanstd(1, :))) * (signal_mvt_lent_B_trans(emg_frequency,2) - signal_mvt_lent_B_trans(1,2)) + (emg_frequency - 0) * (emg_frequency - 0)) / (sqrt((mean(tonics_B_meanstd(2, :)) - mean(tonics_B_meanstd(1, :)))^2 + (emg_frequency - 0)^2) * sqrt((signal_mvt_lent_B_trans(emg_frequency,2) - signal_mvt_lent_B_trans(1,2))^2 + (emg_frequency - 0)^2)));

    % On multiplie le signal translat� � la mtrice de rot pour obtenir le
    % signal translat� et 'rotationn�'


    if (mean(tonics_B_meanstd(2, :))<signal_mvt_lent_B_trans(emg_frequency,2))
    	signal_mvt_lent_B_trans_rot(:,1) = signal_mvt_lent_B_trans(:,1) * cosd(teta) + signal_mvt_lent_B_trans(:,2) * sind(teta);
        signal_mvt_lent_B_trans_rot(:,2) = -signal_mvt_lent_B_trans(:,1) * sind(teta) + signal_mvt_lent_B_trans(:,2) * cosd(teta);
        disp('b1')
    else
        signal_mvt_lent_B_trans_rot(:,1) = signal_mvt_lent_B_trans(:,1) * cosd(teta) - signal_mvt_lent_B_trans(:,2) * sind(teta);
        signal_mvt_lent_B_trans_rot(:,2) = signal_mvt_lent_B_trans(:,1) * sind(teta) + signal_mvt_lent_B_trans(:,2) * cosd(teta);
        disp('b2')
    end
    
    % Calcul du phasic avec le tonic issu du mvt lent translat� et
    % rotationn�
    emg_phasique_combined_B = RMS_B_moy_norm-signal_mvt_lent_B_trans_rot(:,2);
    
    
    for f=1:1000
        RMS_R_moy_normProfilmoyen(f,1)=mean(RMS_R_moy_norm(f,:));
        RMS_B_moy_normProfilmoyen(f,1)=mean(RMS_B_moy_norm(f,:));
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
    %% Partie pour quantifier les desacs musculaires sur le phasic           %%        
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [~, nb_col_rms] = size(emg_phasique_combined_R);
    i = 1;
    j = 1;
    while j <= nb_col_rms % On balaye
    %% Calculs quantif desac pour le mvt lever
        
        % Calcul temps phase desac LEVER
        indic = 0; % Variable pour v�rifier la longueur des phases de d�sactivation
        Limite_atteinte = false; % variable boul�ene pour enregistrer le fait que les phases de d�sactivation sont assez longues (ou pas)
        compteur = 0; % Si la d�sactivation est assez longue, elle est compt�e dans cette variable
        Limite_basse_detection = round(emg_frequency * limite_en_temps / (Idx.MD_R(j,1))); %Limite d'image � atteindre pour consid�rer la phase n�gative 40ms, arrondi � l'image pr�s
        for f = 1 : emg_frequency % Une boucle pour tester toutes les valeurs du phasic
            
            if emg_phasique_combined_R(f, j) < -2*mean(tonics_R_meanstd(3, :)) % Si la valeur est inf � zero indic est increment�
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
        [Pmin, indice] = min(emg_phasique_combined_R(:, j));
        if Pmin > 0
            Pmin =0;
        end
        amplitude = Pmin * 100 / signal_mvt_lent_R_trans_rot(indice,2);
        
        if compteur>0
            frequence =1;
        else 
            frequence = 0;
        end
       
            % Calcul temps phase desac BAISSER
        indic = 0; % Variable pour v�rifier la longueur des phases de d�sactivation
        Limite_atteinte = false; % variable boul�ene pour enregistrer le fait que les phases de d�sactivation sont assez longues (ou pas)
        compteur2 = 0; % Si la d�sactivation est assez longue, elle est compt�e dans cette variable
        Limite_basse_detection = round(emg_frequency * limite_en_temps / (Idx.MD_B(j,1))); %Limite d'image � atteindre pour consid�rer la phase n�gative 40ms, arrondi � l'image pr�s
        for f = 1 : emg_frequency % Une boucle pour tester toutes les valeurs du phasic
            
            if emg_phasique_combined_B(f, j) < -2*mean(tonics_R_meanstd(3, :)) % Si la valeur est inf � zero indic est increment�
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
        [Pmin, indice] = min(emg_phasique_combined_B(:, j));
        if Pmin > 0
            Pmin =0;
        end
        amplitude2 = Pmin * 100 / signal_mvt_lent_B_trans_rot(indice,2);
        
        if compteur2>0
            frequence2 =1;
        else 
            frequence2 = 0;
        end
       
    %% Enregistrement des donn�es
    
        EMG_phasique.QuantifDesac(j, (WW-1)*12+1) = compteur*Idx.MD_R(j,1)/emg_frequency;  % Pour l'avoir en temps
        EMG_phasique.QuantifDesac(j, (WW-1)*12+2) = compteur2*Idx.MD_B(j,1)/emg_frequency; % Pour l'avoir en temps  
        EMG_phasique.QuantifDesac(j, (WW-1)*12+5) = amplitude; % Amplitudes des mvts se lever
        EMG_phasique.QuantifDesac(j, (WW-1)*12+6) = amplitude2; % Amplitudes des mvts se rassoir
        EMG_phasique.QuantifDesac(j, (WW-1)*12+9) = frequence;  % Fr�quence des d�sac mvt se lever
        EMG_phasique.QuantifDesac(j, (WW-1)*12+10) = frequence2; % Fr�quence des d�sac mvt se rassoir
        
        j = j+1;

    end
    
    
    % Moyennage des parametres
    L=length(EMG_phasique.QuantifDesac(:,1));
    
    EMG_phasique.QuantifDesac(1, (WW-1)*12 + 3) = mean(EMG_phasique.QuantifDesac(1:L,(WW-1)*12 + 1));    % Moyenne des temps cumul�s/muscle
    EMG_phasique.QuantifDesac(1, (WW-1)*12 + 4) = mean(EMG_phasique.QuantifDesac(1:L,(WW-1)*12 + 2));    % Moyenne des temps cumul�s/muscle
    EMG_phasique.QuantifDesac(1, (WW-1)*12 + 7) = mean(EMG_phasique.QuantifDesac(1:L,(WW-1)*12 + 5));    % Moyenne des amplitudes/muscle
    EMG_phasique.QuantifDesac(1, (WW-1)*12 + 8) = mean(EMG_phasique.QuantifDesac(1:L,(WW-1)*12 + 6));    % Moyenne des amplitudes/muscle
    EMG_phasique.QuantifDesac(1, (WW-1)*12 + 11) = mean(EMG_phasique.QuantifDesac(1:L,(WW-1)*12 + 9));   % Moyenne des fr�quence/muscle
    EMG_phasique.QuantifDesac(1, (WW-1)*12 + 12) = mean(EMG_phasique.QuantifDesac(1:L,(WW-1)*12 + 10));  % Moyenne des fr�quence/muscle
    
    
    
    
    
    % On construit les r�sultats
        
        EMG_phasique.classique.R(:,(WW-1)*nb/2+1:WW*nb/2) = emg_phasique_classique_R;
        EMG_phasique.classique.B(:,(WW-1)*nb/2+1:WW*nb/2) = emg_phasique_classique_B;
    
        EMG_phasique.combined.R(:,(WW-1)*nb/2+1:WW*nb/2) = emg_phasique_combined_R;
        EMG_phasique.combined.B(:,(WW-1)*nb/2+1:WW*nb/2) = emg_phasique_combined_B;
    
        EMG_phasique.RMS.R(:,(WW-1)*nb/2+1:WW*nb/2) = RMS_R_moy_norm;
        EMG_phasique.RMS.B(:,(WW-1)*nb/2+1:WW*nb/2) = RMS_B_moy_norm;
    
        tonic_meanstd.R(:,(WW-1)*nb/2+1:WW*nb/2) = tonics_R_meanstd;
        tonic_meanstd.B(:,(WW-1)*nb/2+1:WW*nb/2) = tonics_B_meanstd;

end

