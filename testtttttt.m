

 for comp =1:16
        for acqui=1:6 % On balaye
        %% Calculs quantif desac pour le mvt lever
            j = (comp-1)*6+acqui;

            % Calcul temps phase desac LEVER
            indic = 0; % Variable pour vérifier la longueur des phases de désactivation
            Limite_atteinte = false; % variable bouléene pour enregistrer le fait que les phases de désactivation sont assez longues (ou pas)
            compteur = 0; % Si la désactivation est assez longue, elle est comptée dans cette variable
            Limite_basse_detection = round(1000 * 0.04); %Limite d'image à atteindre pour considérer la phase négative 40ms, arrondi à l'image près
            INDEX_SL = [];
            INDEX_SR = [];
            for f = 1 : 1000 % Une boucle pour tester toutes les valeurs du phasic
                
                if phasicSL(f, j) < 0-3*abs(SD(1, comp)) % Si la valeur est inf à zero indic est incrementé
                   indic = indic + 1 ;

%                    indic
                else   % Sinon
                    if Limite_atteinte % Soit la limite avait déjà été atteinte (la phase doit donc être comptée)
                        compteur = compteur + indic; % On la compte 
                        N_A = trapz(phasicSL(f-indic:f,j));
                        T_A = trapz(tonicSL(f-indic:f,j));
                        INDEX_SL = cat(1,INDEX_SL,(N_A/T_A)*indic);
                        indic = 0;    % on remet la variable indic à 0 pour vérifier les suivantes
                        Limite_atteinte = false; % On remet la variable bouléene à Faux 

                    else
                        indic = 0; % Si la limite n'avait pas été atteinte on remet simplement l'indicateur à 0
                    end
                end
                
                if indic >Limite_basse_detection*1000/timeSL(1,acqui) % Si la variable indicateur augmente et dépasse la limite de détection (40 ms), la limite est atteinte
                    Limite_atteinte = true;
                end
                
            end
            
            if Limite_atteinte % Si la limite est atteinte mais qu'on dépasse les 600
                Limite_atteinte = false;
                compteur = compteur + indic;
                N_A = trapz(phasicSL(f-indic:f,j));
                T_A = trapz(tonicSL(f-indic:f,j));
                INDEX_SL = cat(1,INDEX_SL,(N_A/T_A)*indic);

            end

            if isempty( INDEX_SL )
                INDEX_SL = 0;
            end
            

                % Calcul temps phase desac BAISSER
            indic = 0; % Variable pour vérifier la longueur des phases de désactivation
            Limite_atteinte = false; % variable bouléene pour enregistrer le fait que les phases de désactivation sont assez longues (ou pas)
            compteur2 = 0; % Si la désactivation est assez longue, elle est comptée dans cette variable
            Limite_basse_detection = round(1000 * 0.04); %Limite d'image à atteindre pour considérer la phase négative 40ms, arrondi à l'image près
            for f = 1 : 1000% Une boucle pour tester toutes les valeurs du phasic
                
                if phasicSR(f, j) < 0-3*abs(SD(1, comp)) % Si la valeur est inf à zero indic est incrementé
                   indic = indic + 1 ;
                else   % Sinon
                    if Limite_atteinte % Soit la limite avait déjà été atteinte (la phase doit donc être comptée)
                        compteur2 = compteur2 + indic; % On la compte 
                        N_A = trapz(phasicSR(f-indic:f,j));
                        T_A = trapz(tonicSR(f-indic:f,j));
                        INDEX_SR = cat(1,INDEX_SR,(N_A/T_A)*indic);
                        indic = 0;    % on remet la variable indic à 0 pour vérifier les suivantes
                        Limite_atteinte = false; % On remet la variable bouléene à Faux 
                    else
                        indic = 0; % Si la limite n'avait pas été atteinte on remet simplement l'indicateur à 0
                    end
                end
                
                if indic >Limite_basse_detection*1000/timeSR(1,acqui) % Si la variable indicateur augmente et dépasse la limite de détection (40 ms), la limite est atteinte
                    Limite_atteinte = true;
                end
            end
            
            % Calcul de l'amplitude max de négativité
            
            if Limite_atteinte % Si la limite est atteinte mais qu'on dépasse les 600
                Limite_atteinte = false;
                compteur2 = compteur2 + indic;
                N_A = trapz(phasicSR(f-indic:f,j));
                T_A = trapz(tonicSR(f-indic:f,j));
                INDEX_SR = cat(1,INDEX_SR,(N_A/T_A)*indic);
            end

            if isempty( INDEX_SR )
                INDEX_SR = 0;
            end

        %% Enregistrement des données
        
            Donnees_EMG(YY).QuantifDesac(1, j) = INDEX_SL./10;  % Pour l'avoir % 
            Donnees_EMG(YY).QuantifDesac(2, j) = INDEX_SR./10; % Pour l'avoir %
            Donnees_EMG(YY).QuantifDesac(3, j) = 1/0; % Amplitudes des mvts se lever
            Donnees_EMG(YY).QuantifDesac(4, j) = 1/0; % Amplitudes des mvts se rassoir
            Donnees_EMG(YY).QuantifDesac(5, j) = 1/0;  % Fréquence des désac mvt se lever
            Donnees_EMG(YY).QuantifDesac(6, j) = 1/0; % Fréquence des désac mvt se rassoir
            
            
        end
    end

