function [lig_pos, profil_position, poscut_norm, lig_pv, ...
    profil_vitesse, profil_vitesse_norm, MD, rD_PA, rD_PV, rD_PD, PA, PV, PD, Vmean, ParamC, ...
    Amp, Angle, Localmax, debut, fin, Amp_reel, Angle_reel, profil_accel] = compute_kinematics_BrasDom_nondom(pos, pos_epaule, ...
    Frequence_acquisition, VR, Cutoff, Ech_norm, anticip_kin_amp)

%% On calcule les paramètres cinématiques des 2 mouvements
        
        %On derive la position pour avoir la vitesse 3D
        vitesse_test = sqrt(derive(pos(:, 1), 1).^2+derive(pos(:, 2), 1).^2+derive(pos(:, 3), 1).^2);
        vitesse = vitesse_test./(1/Frequence_acquisition);
        
         
        %On derive maintenant la vitesse pour avoir l'accélération 3D
        accel_test = derive(vitesse, 1);
        accel = accel_test./(1/Frequence_acquisition);

        
         %On trouve les pics de vitesse et leurs indices dans la matrice
        [pic_vitesse, indice_pic_vitesse] = max(vitesse);
        
        %On définit la taille de la matrice vitesse
        lignes = size(vitesse(:, 1));
        lignes = lignes(1);
        
        %On calcule l'endroit de début et de fin du profil de vitesse
        a = indice_pic_vitesse;
        b = indice_pic_vitesse;
        
        %On utilise une boucle while pour trouver le moment ou la vitesse
        %dépasse les 10% du pic de vitesse
        
        while (vitesse(a, 1)> Cutoff*pic_vitesse && a>1)
            a = a-1;
        end
        
        debut = a;
        
        %Pareil pour trouver le moment où la vitesse passe en dessous de
        %10% du pic de vitesse
        
        while (vitesse(b, 1)> Cutoff*pic_vitesse && b<lignes)
            b = b+1;
        end
        
        fin = b;
    
        
        %On crée une matrice correspondant au profil de vitesse
        
        profil_vitesse = vitesse(debut:fin, 1);
        [PV, indice_PV] = max(profil_vitesse);
        
        %On crée une matrice correspondant au profil d'accélération
        profil_accel = accel(debut:fin, 1);
        [PA, ind_PA] = max(profil_accel);
        [PD, ind_PD] = min(profil_accel);
        [lig_PA, col_PA] = size(profil_accel);
        clear col_PA
        
        %On crée une matrice correspondant à la position du doigt pendant le
        %mouvement (le profil de vitesse)
        profil_position = pos(debut:fin, :);
        lig_pos = size(profil_position(:, 1));
        lig_pos = lig_pos(1);
        
        %On crée une matrice correspondant à la position de l'épaule pendant le
        %mouvement (le profil de vitesse)
        profil_position_epaule = pos_epaule(debut:fin, :);
        lig_pos_epaule = size(profil_position_epaule(:, 1));
        lig_pos_epaule = lig_pos_epaule(1);
        
        %On normalise le profil de position en durée
        [poscut_norm, newfreq_pos] = normalize2(profil_position, 'spline', Ech_norm);
       
        clear newfreq_pos
        
        %On normalise le profil de vitesse en durée 
        [profil_vitesse_norm, newfreq_vit] = normalize2(profil_vitesse, 'spline', Ech_norm);
        clear newfreq_vit
        %On normalise le profil d'accélération en durée
        [profil_accel_norm, newfrq_acc] = normalize2(profil_accel, 'spline', Ech_norm);
        clear newfrq_acc
        
        % On calcule les paramètres
        
        %On calcule la durée du mouvement
        lig_pv = size(profil_vitesse(: ,1));
        lig_pv = lig_pv(1);
        MD = (lig_pv/ Frequence_acquisition);
        
        %On calcule Vmoy
        Vmean = mean(profil_vitesse);
        
        %On calcule paramètre C = Vmax/Vmean     
        ParamC = PV/Vmean;
        
        %On calcule rD-PV 
        rD_PV = (indice_PV/lig_pv);
        
        %On calcule rD-PA
        rD_PA = (ind_PA/lig_PA);
        
        %On calcule rD_PD
        rD_PD = (ind_PD/lig_PA);
        
        %On calcule l'amplitude
        Amp = sqrt((profil_position(lig_pos, 1)-profil_position(1, 1)).^2+(profil_position(lig_pos, 2)-profil_position(1, 2)).^2+(profil_position(lig_pos, 3)-profil_position(1, 3)).^2);
     
        % Calcul de l'amplitude angulaire
            
        Lgr_bras_start = sqrt((profil_position(1, 1)-profil_position_epaule(1, 1)).^2+(profil_position(1, 2)-profil_position_epaule(1, 2)).^2+(profil_position(1, 3)-profil_position_epaule(1, 3)).^2);
        Lgr_bras_end = sqrt((profil_position(lig_pos, 1)-profil_position_epaule(lig_pos_epaule, 1)).^2+(profil_position(lig_pos, 2)-profil_position_epaule(lig_pos_epaule, 2)).^2+(profil_position(lig_pos, 3)-profil_position_epaule(lig_pos_epaule, 3)).^2);
            
            
        Angle = acos((Lgr_bras_start^2+Lgr_bras_end^2-Amp^2)/(2*Lgr_bras_start*Lgr_bras_end));
        Angle = Angle*(180/pi);
        if Angle<0
        	Angle = -Angle;
        end
            
        Amp_reel = 0;
        Angle_reel = 0;
            
        %On calcule le nombre de maximums locaux
        Localmax = sum(islocalmax(profil_vitesse_norm));
        Localmax = Localmax-1;