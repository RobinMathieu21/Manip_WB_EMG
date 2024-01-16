%% Fonction qui permet de calculer les diff�rents param�tres � partir des signaux de torque pour chaque mouvement
% On entre la matrice des SGT et des SIT (chaque colonne repr�sente un
% mouvement) et on ressort les param�tres

function [ParamTorque] = param_torques(SGT, SIT, Frequence_acquisition)


%On calcule la r�sultante des 2 Torques
ResultingTorque = SIT-SGT;

% On cr�e la matrice de r�sultats
ParamTorque = zeros(10, 5);
ParamTorque(:, 3:5) = NaN;
[ligmat, colmat] = size(SIT);
% Pour chaque mouvement

for f = 1:colmat
    
    % On check si il existe un moment o� la r�sultante est postive (c�d
    % quand le SIT est sup�rieur au SGT)
    
    for g = 1:ligmat
        if ResultingTorque(g, f) > 0
            ParamTorque(f, 1) = 1;
        end
    end
    
    % On calcule l'aire de 10ms avant � 10ms apr�s le pic d'acc�l�ration
    
    [peak, ind_peak] = max(ResultingTorque(1:round(ligmat/2), f));
    aroundpeak_area = trapz(ResultingTorque(ind_peak-5:ind_peak+5, f));
    
    ParamTorque(f, 2) = aroundpeak_area;
    
    % Si il existe un moment o� la r�sultante est positive
    
    if ParamTorque(f, 1) == 1
        
        % On calcule la dur�e, l'amplitude et l'aire du moment o� elle est
        % positive
        
        % Le pic est calcul� plus haut = amplitude
        
        ParamTorque(f, 3) = peak;
        
        % On calcule la dur�e
        
        a = ind_peak;
        b = ind_peak;
        
        while ResultingTorque(a, f) > 0 && a>1
            a = a-1;
        end
        
        while ResultingTorque(b, f) > 0 && b<ligmat
            b = b+1;
        end
    
    positive_duration = (b-a)/Frequence_acquisition;
    
    ParamTorque(f, 4) = positive_duration;
    
    % On calcule l'aire de positivit�
    
    positive_area = aire_trapz(a, b, ResultingTorque(:, f));
    
    ParamTorque(f, 5) = positive_area;
    
    end
    
end
    
    
    
    
    