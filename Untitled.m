
delai = ones(1, 10)
for f = 1:10
[lig, ~] = size((Donnees_cinematiques.antvelocity.B));
    tpv = 250+lig*10;
    
v2 = EMG_traite.DA.smooth.B(1:tpv, f);

[ligemg, ~] = size(v2);

v1 = normalize2(Donnees_cinematiques.antvelocity.B(:, f), 'PCHIP', ligemg)

delai(1, f)  = finddelay(v1, v2);

figure
subplot(2,1,1)
plot(v1), hold on
subplot(2,1,2)
plot(v2), hold off

pause
    
end




hy

result = mean(delai)