%% Fonction permettant de rajouter une colonne profil moyen à la fin d'une matrice

function [matrice] = profilmoyen(matricedepart)

[lig, col] = size(matricedepart);

for f = 1:lig
    
    matrice(f, 1) = mean(matricedepart(f, :));
    
end

