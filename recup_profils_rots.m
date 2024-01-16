function [profil_positionz, profil_vitesse, rot_coude, rot_poignet] = recup_profils_rots(pos_doigt, pos_epaule, ...
  pos_coude, pos_poignet, Frequence_acquisition, Cutoff)

%On derive la position pour avoir la vitesse 3D
        vitesse_test = sqrt(derive(pos_doigt(:, 1), 1).^2+derive(pos_doigt(:, 2), 1).^2+derive(pos_doigt(:, 3), 1).^2);
        
        vitesse = vitesse_test./(1/Frequence_acquisition);
        
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
        
        %Pareil pour trouver le moment où la vitesse passe en dessosu de
        %10% du pic de vitesse
        
        while (vitesse(b, 1)> Cutoff*pic_vitesse && b<lignes)
            b = b+1;
        end
        
        fin = b;
    
        
        %On crée une matrice correspondant au profil de vitesse
        
        profil_vitesse = vitesse(debut:fin, 1);
        
        % on crée une matrice correspondant au profil de position en z
        profil_positionz = pos_doigt(debut:fin, 3);
        
        % on normalise les profils en durée
        
        profil_vitesse = normalize2(profil_vitesse, 'spline', 100);
        profil_positionz = normalize2(profil_positionz, 'spline', 100);
        
        %% On calcule maintenant la rotation du coude et celle du poignet
        
        % on calcule les angles au début du mouvement
        
        coude_epaule = sqrt((pos_epaule(debut, 1)-pos_coude(debut, 1)).^2+(pos_epaule(debut, 2)-pos_coude(debut, 2)).^2+(pos_epaule(debut, 3)-pos_coude(debut, 3)).^2);
        coude_poignet = sqrt((pos_poignet(debut, 1)-pos_coude(debut, 1)).^2+(pos_poignet(debut, 2)-pos_coude(debut, 2)).^2+(pos_poignet(debut, 3)-pos_coude(debut, 3)).^2);
        poignet_doigt = sqrt((pos_doigt(debut, 1)-pos_poignet(debut, 1)).^2+(pos_doigt(debut, 2)-pos_poignet(debut, 2)).^2+(pos_doigt(debut, 3)-pos_poignet(debut, 3)).^2);
        doigt_coude = sqrt((pos_doigt(debut, 1)-pos_coude(debut, 1)).^2+(pos_doigt(debut, 2)-pos_coude(debut, 2)).^2+(pos_doigt(debut, 3)-pos_coude(debut, 3)).^2);
        epaule_poignet = sqrt((pos_epaule(debut, 1)-pos_poignet(debut, 1)).^2+(pos_epaule(debut, 2)-pos_poignet(debut, 2)).^2+(pos_epaule(debut, 3)-pos_poignet(debut, 3)).^2);
        
        angle_coude_debut = acosd((coude_poignet^2+coude_epaule^2-epaule_poignet^2)/(2*coude_poignet*coude_epaule));
        angle_poignet_debut = acosd((coude_poignet^2+poignet_doigt^2-doigt_coude^2)/(2*coude_poignet*poignet_doigt));
        
        % On calcule les angles à la fin du mouvement
        
        coude_epaule = sqrt((pos_epaule(fin, 1)-pos_coude(fin, 1)).^2+(pos_epaule(fin, 2)-pos_coude(fin, 2)).^2+(pos_epaule(fin, 3)-pos_coude(fin, 3)).^2);
        coude_poignet = sqrt((pos_poignet(fin, 1)-pos_coude(fin, 1)).^2+(pos_poignet(fin, 2)-pos_coude(fin, 2)).^2+(pos_poignet(fin, 3)-pos_coude(fin, 3)).^2);
        poignet_doigt = sqrt((pos_doigt(fin, 1)-pos_poignet(fin, 1)).^2+(pos_doigt(fin, 2)-pos_poignet(fin, 2)).^2+(pos_doigt(fin, 3)-pos_poignet(fin, 3)).^2);
        doigt_coude = sqrt((pos_doigt(fin, 1)-pos_coude(fin, 1)).^2+(pos_doigt(fin, 2)-pos_coude(fin, 2)).^2+(pos_doigt(fin, 3)-pos_coude(fin, 3)).^2);
        epaule_poignet = sqrt((pos_epaule(fin, 1)-pos_poignet(fin, 1)).^2+(pos_epaule(fin, 2)-pos_poignet(fin, 2)).^2+(pos_epaule(fin, 3)-pos_poignet(fin, 3)).^2);
        
        angle_coude_fin = acosd((coude_poignet^2+coude_epaule^2-epaule_poignet^2)/(2*coude_poignet*coude_epaule));
        angle_poignet_fin = acosd((coude_poignet^2+poignet_doigt^2-doigt_coude^2)/(2*coude_poignet*poignet_doigt));
        
        rot_coude = angle_coude_fin-angle_coude_debut;
        rot_coude = rot_coude*(180/pi);
        rot_poignet = angle_poignet_fin-angle_poignet_debut;
        rot_poignet = rot_poignet*(180/pi);
