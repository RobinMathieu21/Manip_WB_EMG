
clear all
close all



NB_SUJETS =24;







disp('Selectionnez le Dossier regroupant donnees');
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');

Extension = '*.mat'; %Traite tous les .mat
Chemin = fullfile(Dossier, Extension); % On construit le chemin
ListeFichier = dir(Chemin); % On construit la liste des fichiers

%% On procède au balayage fichier par fichier
    
Fichier_traite = [Dossier '\' ListeFichier(1).name]; %On charge le fichier .mat
load (Fichier_traite);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
    %% Partie pour quantifier les desacs musculaires sur le phasic CLASSIQUE %%        
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for YY = 1:NB_SUJETS

%normalisation 


    www=1;
    for v = 1 : 16
        phasicSL(:,www:www+6-1) = DonneesToExport.EMG(YY).Phasic.Classique.Se_lever(:,www:www+6-1)./max(max(abs(DonneesToExport.EMG(YY).Phasic.RMS_combined.R(:,www:www+6-1))));
        phasicSR(:,www:www+6-1) = DonneesToExport.EMG(YY).Phasic.Classique.Se_rassoir(:,www:www+6-1)./max(max(abs(DonneesToExport.EMG(YY).Phasic.RMS_combined.B(:,www:www+6-1))));

        tonicSL(:,www:www+6-1) = DonneesToExport.EMG(YY).TonicSoustrait.R(:,www:www+6-1)./max(max(abs(DonneesToExport.EMG(YY).Phasic.RMS_combined.R(:,www:www+6-1))));
	    tonicSR(:,www:www+6-1) = DonneesToExport.EMG(YY).TonicSoustrait.B(:,www:www+6-1)./max(max(abs(DonneesToExport.EMG(YY).Phasic.RMS_combined.B(:,www:www+6-1))));

        SD(:,v) = DonneesToExport.EMG(YY).Phases_Stables_SD(1,v)/max(max(abs(DonneesToExport.EMG(YY).Phasic.RMS_combined.R(:,www:www+6-1))));
    
        www = www + 6;
    end



    timeSL = DonneesToExport.EMG(YY).Temps.Se_lever;
    timeSR = DonneesToExport.EMG(YY).Temps.Se_rassoir;



%         signal = phasicSL(:,acqui);
%         Valneg = find(signal<= 0);    
%         AIRE_NEG = trapz(signal(Valneg));
% 
%         signal = phasicSR(:,acqui);
%         Valneg = find(signal<= 0);    
%         AIRE_NEG2 = trapz(signal(Valneg));





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
                N_A = trapz(phasicSL(f-indic+1:f,j));
                T_A = trapz(tonicSL(f-indic+1:f,j));
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
                N_A = trapz(phasicSR(f-indic+1:f,j));
                T_A = trapz(tonicSR(f-indic+1:f,j));
                INDEX_SR = cat(1,INDEX_SR,(N_A/T_A)*indic);
            end

            if isempty( INDEX_SR )
                INDEX_SR = 0;
            end

        %% Enregistrement des données
        
            Donnees_EMG(YY).QuantifDesacAREA(1, j) = sum(INDEX_SL)/10;  % Pour l'avoir % 
            Donnees_EMG(YY).QuantifDesacAREA(2, j) = sum(INDEX_SR)/10; % Pour l'avoir %
            Donnees_EMG(YY).QuantifDesacAREA(3, j) = mean(INDEX_SL(1))/10; % Amplitudes des mvts se lever
            Donnees_EMG(YY).QuantifDesacAREA(4, j) = mean(INDEX_SR(1))/10; % Amplitudes des mvts se rassoir
       
            
        end
    end

















     %% Enregistrement des données
%     
%         Donnees_EMG(YY).QuantifDesacAREA(1, j) = AIRE_NEG/10;  % Pour l'avoir %
%         Donnees_EMG(YY).QuantifDesacAREA(2, j) = AIRE_NEG2/10; % Pour l'avoir %
%         Donnees_EMG(YY).QuantifDesacAREA(3, j) = AIRE_NEG*mean(timeSL(1,1:6))/1000;  % Pour l'avoir en temps
%         Donnees_EMG(YY).QuantifDesacAREA(4, j) = AIRE_NEG2*mean(timeSR(1,1:6))/1000;  % Pour l'avoir en temps
%         
%         



    %% FIN QUANTIF
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIN QUANTIF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end





for subject =1:NB_SUJETS
    for acq=1:4
        Donnees_EMG(NB_SUJETS+1).QuantifDesacAREA(subject,96*(acq-1)+1:96*(acq-1)+96)= Donnees_EMG(subject).QuantifDesacAREA(acq,1:96);
    end
end


for subject =1:YY
    for acqui=1:6:384

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSERER CODE POUR MOUVEMENT ET GROUP CORRESPONDANT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        Donnees_EMG(NB_SUJETS+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,acqui:acqui+5));
        % STS Young et R2 YOUNG %% 
        Donnees_EMG(NB_SUJETS+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,acqui:acqui+5));

%%%%%%%%%%%%%%
%         valueNotCOUNT = 61; 
%         switch true
%             case YY == 1 && (acqui ==valueNotCOUNT  || acqui==valueNotCOUNT+192)     % STS OLD
%                 Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
%                 Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
%         
%              case YY == 1 && ( acqui ==valueNotCOUNT+96  || acqui ==valueNotCOUNT+288)     % STS OLD 
%                 Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));
%                 Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));
%         
%             otherwise 
%                 Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,acqui:acqui+5));
%                 Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,acqui:acqui+5));
%         end
%%%%%%%%%%%%%%%%
%% R1 YOUNG
%         valueNotCOUNT = 25;
%         switch true
%             case YY == 13 && (acqui ==valueNotCOUNT || acqui ==valueNotCOUNT+192)     % R1 Young 
%                 Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+1 acqui+2 acqui+3 acqui+4]));
%                 Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+1 acqui+2 acqui+3 acqui+4]));
%         
%             case YY == 13 && (acqui ==valueNotCOUNT+96 || acqui ==valueNotCOUNT+288)     % R1 Young 
%                 Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
%                 Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
%         
%             otherwise 
%                 Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,acqui:acqui+5));
%                 Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,acqui:acqui+5));
%         end
%%%%%%%%%%%%%%%%%%%%%
% valueNotCOUNT = 25;
% switch true
%     case YY == 9 && (acqui ==valueNotCOUNT || acqui ==valueNotCOUNT+192 )     % R1 old 
%         Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+1 acqui+2 acqui+3]));
%         Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+1 acqui+2 acqui+3]));
% 
%     otherwise 
%         Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,acqui:acqui+5));
%         Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,acqui:acqui+5));
% end
%%%%%%%%%%
% R2 OLD
% valueNotCOUNT4 = 61;
% valueNotCOUNT3 = 49;
% valueNotCOUNT2 = 37;
% valueNotCOUNT = 25;
% switch true
% 
%     case YY == 1 && (acqui ==valueNotCOUNT2 || acqui ==valueNotCOUNT2+192 )     % R2 old VLG sujet 1 phasic 3 à virer
%         Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+1 acqui+3 acqui+4 acqui+5]));
%         Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+1 acqui+3 acqui+4 acqui+5]));
% 
%     case YY == 9 && (acqui ==valueNotCOUNT || acqui ==valueNotCOUNT+192 )     % R2 old VLD sujet 9 phasic 2 à virer
%         Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
%         Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
% 
%     case YY == 13 && (acqui ==valueNotCOUNT || acqui ==valueNotCOUNT+192  )     % R2 old VLD sujet 13 phasic SL 5 et SR 4 à virer
%         Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+1 acqui+2 acqui+3 acqui+5]));
%         Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+1 acqui+2 acqui+3 acqui+5]));
%     case YY == 13 && (acqui ==valueNotCOUNT+96 || acqui ==valueNotCOUNT+288 || acqui ==valueNotCOUNT+480)     
%         Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));
%         Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));
% 
% 
%     case YY == 19 && (acqui ==valueNotCOUNT || acqui ==valueNotCOUNT+192 )     % R2 old VLD sujet 19 phasic SL 1 et SR 1 à virer
%         Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
%         Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
%     case YY == 19 && (acqui ==valueNotCOUNT+96 || acqui ==valueNotCOUNT+288 )     
%         Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
%         Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
% 
%     case YY == 19 && (acqui ==valueNotCOUNT2 || acqui ==valueNotCOUNT2+192 )     % R2 old VLG sujet 19 phasic SL 5 et SR 4 à virer
%         Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
%         Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
%     case YY == 19 && (acqui ==valueNotCOUNT2+96 || acqui ==valueNotCOUNT2+288)     % R2 old VLG sujet 19 phasic SL 5 et SR 4 à virer
%         Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
%         Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
%     
% 
%     case YY == 19 && (acqui ==valueNotCOUNT3 || acqui ==valueNotCOUNT3+192  )     % R2 old ESD sujet 19 phasic SL 5 et SR 4 à virer
%         Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
%         Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
%     case YY == 19 && (acqui ==valueNotCOUNT3+96 || acqui ==valueNotCOUNT3+288 )     % R2 old ESD sujet 19 phasic SL 5 et SR 4 à virer
%         Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
%         Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
%      
%     case YY == 19 && (acqui ==valueNotCOUNT4 || acqui ==valueNotCOUNT4+192 )     % R2 old ESG sujet 19 phasic SL 5 et SR 4 à virer
%         Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
%         Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
%     case YY == 19 && (acqui ==valueNotCOUNT4+96 || acqui ==valueNotCOUNT4+288 )     % R2 old ESG sujet 19 phasic SL 5 et SR 4 à virer
%         Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
%         Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
% 
%     otherwise 
%         Donnees_EMG(YY+2).QuantifDesacAREA(subject,1+((acqui-1)/6))=mean(Donnees_EMG(YY+1).QuantifDesacAREA(subject,acqui:acqui+5));
%         Donnees_EMG(YY+2).QuantifDesacAREA_SD(subject,1+((acqui-1)/6))=std(Donnees_EMG(YY+1).QuantifDesacAREA(subject,acqui:acqui+5));
% end

%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSERER CODE POUR MOUVEMENT ET GROUP CORRESPONDANT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end
end





%Pour aire bras
Donnees_EMG(NB_SUJETS+2).QuantifDesacAREA(:,[2:16,18:32,34:48,50:64])  = [];
% Donnees_EMG(NB_SUJETS+2).QuantifDesacAREA_SD(:,[2:16,18:32,34:48,50:64])  = [];

%Pour aire WB
% Donnees_EMG(NB_SUJETS+2).QuantifDesacAREA(:,[1:4,6,8,10,12:16,   17:20,22,24,26,28:32,   33:36,38,40,41,44:48,   49:52,54,56,58,60:64])  = [];
% Donnees_EMG(NB_SUJETS+2).QuantifDesacAREA_SD(:,[1:4,6,8,10,12:16,   17:20,22,24,26,28:32,   33:36,38,40,41,44:48,   49:52,54,56,58,60:64])  = [];

% for aaaa=1:NB_SUJETS
%     Donnees_EMG(1).Quantif(aaaa,1) = mean(DonneesToExport.EMG(aaaa).Temps.Se_lever);
%     Donnees_EMG(1).Quantif(aaaa,2) = mean(DonneesToExport.EMG(aaaa).Temps.Se_rassoir);
% end





