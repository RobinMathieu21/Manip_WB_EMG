function [lig_pos, profil_position, poscut_norm, lig_pv, ...
    profil_vitesse_pas_cut, moy_deb, moy_fin, std_deb, std_fin, profil_vitesse, profil_vitesse_norm,profil_vitesse_normV2, MD, rD_PA, rD_PV, rD_PD, PA, PV, PD, MD_V2, rD_PA_V2, rD_PV_V2, rD_PD_V2,...
    debut, fin, debut_V2, fin_V2, nb_pics] = compute_kinematics_WHOLE_BODY_STS_BTS_TL(pos,mid, ...
    Frequence_acquisition, VR, Cutoff, Ech_norm, param_moyenne,pourcen_amp)

%% On calcule les paramètres cinématiques des 2 mouvements
        % On calcule le vecteur position
        vec_position = sqrt(pos(:, 3).^2);%+pos(:, 2).^2+pos(:, 3).^2);

        %On derive la position pour avoir la vitesse 
        vitesse_test = sqrt(derive(pos(:, 1), 1).^2+derive(pos(:, 2), 1).^2+derive(pos(:, 3), 1).^2);
        vitesse = vitesse_test./(1/Frequence_acquisition);
        
        %On derive maintenant la vitesse pour avoir l'accélération 3D
        accel_test = derive(vitesse, 1);
        accel = accel_test./(1/Frequence_acquisition);

                %On définit la taille de la matrice vitesse
        lignes = size(vitesse(:, 1));
        lignes = lignes(1);
        
      



        %% Méthode AMPLITUDE 
        %On calcule l'endroit de début et de fin du profil de position
        if VR ==1            
            a = mid;     %a=1;
            b = mid;     %b = length(pos)-param_moyenne/2;
        end
        
        if VR ==2            
            a = mid;          %a = 1+param_moyenne/2;
            b = mid;          %b = length(pos);
        end
        
        [phase_stable_debut] = vec_position(1:param_moyenne, :);
        moy_deb = mean(phase_stable_debut);
        std_deb = std(phase_stable_debut);
        
        [phase_stable_fin] = vec_position(length(vec_position)-param_moyenne:length(vec_position), :);
        moy_fin = mean(phase_stable_fin);
        std_fin = std(phase_stable_fin);
        

        while (abs(vec_position(a, 1)-moy_deb(:,1)) > pourcen_amp*abs(moy_deb-moy_fin) )
            a=a-1;
        end
        debut = a;


        while (abs(vec_position(b, 1)-moy_fin(:,1)) > pourcen_amp*abs(moy_deb-moy_fin) )
            b = b+1;
        end
        fin = b;

 %%
        %On crée une matrice correspondant au profil de vitesse
        profil_vitesse_pas_cut = vitesse(:, 1);
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
        
        %On normalise le profil de position en durée
        [poscut_norm, newfreq_pos] = normalize2(profil_position, 'spline', Ech_norm);
       
        clear newfreq_pos
        
        %On normalise le profil de vitesse en durée 
        [profil_vitesse_norm, newfreq_vit] = normalize2(profil_vitesse, 'spline', Ech_norm);
        clear newfreq_vit
        %On normalise le profil d'accélération en durée
        [profil_accel_norm, newfrq_acc] = normalize2(profil_accel, 'spline', Ech_norm);
        clear newfrq_acc
        

                %% On calcule la durée du mouvement AVEC AMP
        lig_pv = fin - debut+1;
        MD = (lig_pv/ Frequence_acquisition);
      
        %On calcule rD-PV 
        rD_PV = (indice_PV/lig_pv);
        
        %On calcule rD-PA
        rD_PA = (ind_PA/lig_PA);
        
        %On calcule rD_PD
        rD_PD = (ind_PD/lig_PA);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %% Méthode PIC DE VITESSE


         %On trouve les pics de vitesse et leurs indices dans la matrice
        [pic_vitesse, indice_pic_vitesse] = max(vitesse);

        %On calcule l'endroit de début et de fin du profil de vitesse
        a = indice_pic_vitesse;
        b = indice_pic_vitesse;
        
        %On utilise une boucle while pour trouver le moment ou la vitesse
        %dépasse les 10% du pic de vitesse
        
        while (vitesse(a, 1)> 0.1*pic_vitesse && a>1)
            a = a-1;
        end
        
        debut_V2 = a;
        
        %Pareil pour trouver le moment où la vitesse passe en dessous de
        %10% du pic de vitesse
        
        while (vitesse(b, 1)> 0.1*pic_vitesse && b<lignes)
            b = b+1;
        end
        
        fin_V2 = b;

                % On calcule les paramètres
        
        %On crée une matrice correspondant au profil de vitesse
        profil_vitesse_pas_cut_V2 = vitesse(:, 1);
        profil_vitesse_V2 = vitesse(debut_V2:fin_V2, 1);
        [PV_V2, indice_PV_V2] = max(profil_vitesse_V2);

         %On normalise le profil de vitesse en durée 
        [profil_vitesse_normV2, newfreq_vit] = normalize2(profil_vitesse_V2, 'spline', Ech_norm);
        
        %On crée une matrice correspondant au profil d'accélération
        profil_accel_V2 = accel(debut_V2:fin_V2, 1);
        [PA, ind_PA_V2] = max(profil_accel_V2);
        [PD, ind_PD_V2] = min(profil_accel_V2);
        [lig_PA_V2, col_PA_V2] = size(profil_accel_V2);
        clear col_PA
        
        %On crée une matrice correspondant à la position du doigt pendant le
        %mouvement (le profil de vitesse)
        profil_position_V2 = pos(debut_V2:fin_V2, :);
        lig_pos_V2 = size(profil_position_V2(:, 1));
        lig_pos_V2 = lig_pos_V2(1);
        

        %On calcule la durée du mouvement
        lig_pv_V2 = size(profil_vitesse_V2(: ,1));
        lig_pv_V2 = lig_pv_V2(1);
        MD_V2 = (lig_pv_V2/ Frequence_acquisition);
        
%         %On calcule Vmoy
%         Vmean = mean(profil_vitesse);
%         
%         %On calcule paramètre C = Vmax/Vmean     
%         ParamC = PV/Vmean;
%         
        %On calcule rD-PV 
        rD_PV_V2 = (indice_PV_V2/lig_pv_V2);
        
        %On calcule rD-PA
        rD_PA_V2 = (ind_PA_V2/lig_PA_V2);
        
        %On calcule rD_PD
        rD_PD_V2 = (ind_PD_V2/lig_PA_V2);


          AV = islocalmax(profil_vitesse_V2);
        nb_pics=0;
        for CC=1:length(AV)
            if AV(CC)>0
                nb_pics=nb_pics+1;
            end
        end

        AV = islocalmax(profil_accel_V2);
        nb_pics2=0;
        for CC=1:length(AV)
            if AV(CC)>0
                nb_pics2=nb_pics2+1;
            end
        end

        AV = islocalmin(profil_accel_V2);
        nb_pics3=0;
        for CC=1:length(AV)
            if AV(CC)>0
                nb_pics3=nb_pics3+1;
            end
        end

        if nb_pics3>1 || nb_pics2>1 || nb_pics>1 
            nb_pics=3;
        end
        