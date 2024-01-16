for f = 1:10
    
    delai = {}
    
   delai(f) = finddelay(Donnees_cinematiques.VelCutSort(:, f), EMG_traite.Biceps.smooth.B(:, f));
   
end

delai