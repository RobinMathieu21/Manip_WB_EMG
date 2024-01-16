%% Fonction qui permet de calculer les différents paramètres à partir des signaux de torque pour chaque mouvement
% On entre la matrice des SGT et des SIT (chaque colonne représente un
% mouvement) et on ressort les paramètres

function [ParamTorque] = param_torques(SGT, SIT, Frequence_acquisition)


%On calcule la résultante des 2 Torques
ResultingTorque = SIT-SGT;

% On crée la matrice de résultats
ParamTorque = zeros(10, 5);
ParamTorque(:, 3:5) = NaN;
[ligmat, colmat] = size(SIT);
% Pour chaque mouvement

for f = 1:colmat
    
    % On check si il existe un moment où la résultante est postive (càd
    % quand le SIT est supérieur au SGT)
    
    for g = 1:ligmat
        if ResultingTorque(g, f) > 0
            ParamTorque(f, 1) = 1;
        end
    end
    
    % On calcule l'aire de 10ms avant à 10ms après le pic d'accélération
    
    [peak, ind_peak] = max(ResultingTorque(1:round(ligmat/2), f));
    aroundpeak_area = trapz(ResultingTorque(ind_peak-5:ind_peak+5, f));
    
    ParamTorque(f, 2) = aroundpeak_area;
    
    % Si il existe un moment où la résultante est positive
    
    if ParamTorque(f, 1) == 1
        
        % On calcule la durée, l'amplitude et l'aire du moment où elle est
        % positive
        
        % Le pic est calculé plus haut = amplitude
        
        ParamTorque(f, 3) = peak;
        
        % On calcule la durée
        
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
    
    % On calcule l'aire de positivité
    
    positive_area = aire_trapz(a, b, ResultingTorque(:, f));
    
    ParamTorque(f, 5) = positive_area;
    
    end
    
end
    
    
    
    
    