function  plotstem(courbe, valeurs)

for i = 1:10
    i
plot(courbe(:, i));
hold on
stem(valeurs(i, 29), valeurs(i, 23))
stem(valeurs(i, 30), valeurs(i, 24))
stem(valeurs(i, 31), valeurs(i, 25))
stem(valeurs(i, 32), valeurs(i, 26))
reply = input('?')
if reply == 0
    
    close all
else hold off
end
end
reply