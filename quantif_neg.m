    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
    %% Partie pour quantifier les desacs musculaires sur le phasic CLASSIQUE %%        
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    emg_frequency=1000;
    limite_en_temps = 0.04;
muscle = 13;
%VLD 13 
%VLG = 19
%ESL1D = 25;
%ESL1G = 31;

muscle2 = 25; %VLD
%VLD 25
%VLG = 37
%ESL1D = 49;
%ESL1G = 61;
% 
% for participant=1:15 
% figure;plot(Donnees_EMG(participant).TonicSoustrait.R(:,25:30));
% end

for participant=1:16    

for ab=1:6
    tonic_seLever(:,ab) = normalize2(nonzeros(Donnees_EMG(participant).TonicSoustrait.R(:,(muscle2-1)+ab)), 'PCHIP', 1000); 
    tonic_seRassoir(:,ab) = normalize2(nonzeros(Donnees_EMG(participant).TonicSoustrait.B(:,(muscle2-1)+ab)), 'PCHIP', 1000); 
end

for az = 1:1000
    tonic_seLever_mean(az,:)=mean(tonic_seLever(az,:));
    tonic_seRassoir_mean(az,:)=mean(tonic_seRassoir(az,:));
end

emg_phasique_R_avantNorm_FILT=Donnees_EMG(participant).Phasic.ClassiqueFILT.ProfilMoyenSeLever(:,muscle);   
emg_phasique_B_avantNorm_FILT=Donnees_EMG(participant).Phasic.ClassiqueFILT.ProfilMoyenSeRassoir(:,muscle);  
    
norm_tonic_R_moy = tonic_seLever_mean(:,1);
norm_tonic_B_moy = tonic_seRassoir_mean(:,1);

    %% Calculs quantif desac pour le mvt lever
        
        % Calcul temps phase desac LEVER
        indic = 0; % Variable pour vérifier la longueur des phases de désactivation
        Limite_atteinte = false; % variable bouléene pour enregistrer le fait que les phases de désactivation sont assez longues (ou pas)
        compteur = 0; % Si la désactivation est assez longue, elle est comptée dans cette variable
        Limite_basse_detection = round(emg_frequency * limite_en_temps); %Limite d'image à atteindre pour considérer la phase négative 40ms, arrondi à l'image près
        for f = 1 : length(emg_phasique_R_avantNorm_FILT(:, 1)) % Une boucle pour tester toutes les valeurs du phasic
            
            if emg_phasique_R_avantNorm_FILT(f, 1) < 0 % Si la valeur est inf à zero indic est incrementé
               indic = indic + 1 ;
            else   % Sinon
                if Limite_atteinte % Soit la limite avait déjà été atteinte (la phase doit donc être comptée)
                    compteur = compteur + indic; % On la compte 
                    indic = 0;    % on remet la variable indic à 0 pour vérifier les suivantes
                    Limite_atteinte = false; % On remet la variable bouléene à Faux 
                else
                    indic = 0; % Si la limite n'avait pas été atteinte on remet simplement l'indicateur à 0
                end
            end
            
            if indic >Limite_basse_detection % Si la variable indicateur augmente et dépasse la limite de détection (40 ms), la limite est atteinte
                Limite_atteinte = true;
            end
            
        end
        
        % Calcul de l'amplitude max de négativité
        [Pmin, indice] = min(emg_phasique_R_avantNorm_FILT);
        if Pmin > 0
            Pmin =0;
        end
        amplitude = Pmin * 100 / norm_tonic_R_moy(indice,1);
        
        if compteur>0
            frequence =1;
        else 
            frequence = 0;
        end
       
            % Calcul temps phase desac BAISSER
        indic = 0; % Variable pour vérifier la longueur des phases de désactivation
        Limite_atteinte = false; % variable bouléene pour enregistrer le fait que les phases de désactivation sont assez longues (ou pas)
        compteur2 = 0; % Si la désactivation est assez longue, elle est comptée dans cette variable
        Limite_basse_detection = round(emg_frequency * limite_en_temps); %Limite d'image à atteindre pour considérer la phase négative 40ms, arrondi à l'image près
        for f = 1 : length(emg_phasique_B_avantNorm_FILT)% Une boucle pour tester toutes les valeurs du phasic
            
            if emg_phasique_B_avantNorm_FILT(f, 1) < 0 % Si la valeur est inf à zero indic est incrementé
               indic = indic + 1 ;
            else   % Sinon
                if Limite_atteinte % Soit la limite avait déjà été atteinte (la phase doit donc être comptée)
                    compteur2 = compteur2 + indic; % On la compte 
                    indic = 0;    % on remet la variable indic à 0 pour vérifier les suivantes
                    Limite_atteinte = false; % On remet la variable bouléene à Faux 
                else
                    indic = 0; % Si la limite n'avait pas été atteinte on remet simplement l'indicateur à 0
                end
            end
            
            if indic >Limite_basse_detection % Si la variable indicateur augmente et dépasse la limite de détection (40 ms), la limite est atteinte
                Limite_atteinte = true;
            end
        end
        
        % Calcul de l'amplitude max de négativité
        [Pmin, indice] = min(emg_phasique_B_avantNorm_FILT);
        if Pmin > 0
            Pmin =0;
        end
        amplitude2 = Pmin * 100 / norm_tonic_B_moy(indice,1);
        
        if compteur2>0
            frequence2 =1;
        else 
            frequence2 = 0;
        end
       
    %% Enregistrement des données
    
        EMG_phasique.QuantifDesac(participant, 1) = (100*compteur/1000);  % Pour l'avoir en temps
        EMG_phasique.QuantifDesac(participant, 2) = (100*compteur2/1000); % Pour l'avoir en temps  
        EMG_phasique.QuantifDesac(participant, 3) = amplitude; % Amplitudes des mvts se lever
        EMG_phasique.QuantifDesac(participant, 4) = amplitude2; % Amplitudes des mvts se rassoir
        EMG_phasique.QuantifDesac(participant, 5) = frequence;  % Fréquence des désac mvt se lever
        EMG_phasique.QuantifDesac(participant, 6) = frequence2; % Fréquence des désac mvt se rassoir
        
 
end