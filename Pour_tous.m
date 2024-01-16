

plot(Donnees.cinematiques.Vel_cut_norm(:,13:end),'-r'); hold on;
plot(Donnees.cinematiques.Vel_cut_norm(:,1:12),'-b'); 

for SUJ=1:24
%     figure;
%     plot(Donnees_cinematiques(SUJ).Vel_cut_norm(:,13:end),'-r'); hold on;
%     plot(Donnees_cinematiques(SUJ).Vel_cut_norm(:,1:12),'-b'); 
    a(SUJ)=mean(Donnees_cinematiques(SUJ).Results_trial_by_trial(1:12,4)) - mean(Donnees_cinematiques(SUJ).Results_trial_by_trial(13:24,4));
end


for SUJ=1:24

    a(SUJ)=mean(Donnees_cinematiques(SUJ).Results_trial_by_trial(1:12,3)) - mean(Donnees_cinematiques(SUJ).Results_trial_by_trial(13:24,3));
end