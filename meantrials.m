function [results] = meantrials(matrice, nbessais)

[lig_matrice, col_matrice] = size(matrice);

results = ones(lig_matrice, col_matrice/nbessais)*99;

a = 0;

for f = 1:nbessais:col_matrice
a = a+1;
    cut = matrice(:, f:(f+(nbessais-1)));
    
    cut = mean(cut, 2, 'omitnan');
    
    results(:, a) = cut;
    
end
    
    

