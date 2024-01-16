delai = ones(1, 200)
for f = 1:10

    tpv = 250+Donnees_cinematiques.Profils_means.Results.R(f, 4)*1000;
    
v2 = EMG_traite.DP.smooth.R(1:tpv, f);

[ligemg, ~] = size(v2);
v1 = normalize2(Donnees_cinematiques.antvelocity.R(1:tpv/10, f), 'PCHIP', ligemg);
for k = 1:200

v1 = v1+k;
a = corrcoef(v1, v2)
delai(1, k) = a(1, 2);
end    
end

