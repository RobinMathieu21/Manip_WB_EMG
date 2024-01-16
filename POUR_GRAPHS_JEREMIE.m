load('C:\Users\robin\Desktop\V999 16Y TEST 2\Donnees_saved_Old.mat')
load('C:\Users\robin\Desktop\V999 16Y 16O meilleur tonic\Donnees_saved_Young.mat')

% AGES
for a=1:16
    plot(DonneesToExportOld_old.EMG(a).Phasic.Classique.ProfilMoyenSeLever(:,13)); hold on; %% SE LEVER
end

for a=1:16
    plot(DonneesToExportOld_old.EMG(a).Phasic.Classique.ProfilMoyenSeRassoir(:,13)); hold on; %% SE Rassoir
end

% JEUNES
for a=1:16
    plot(DonneesToExportYoung_old.EMG(a).Phasic.Classique.ProfilMoyenSeLever(:,13)); hold on; %% SE LEVER
end

for a=1:16
    plot(DonneesToExportYoung_old.EMG(a).Phasic.Classique.ProfilMoyenSeRassoir(:,13)); hold on; %% SE Rassoir
end

% New découpage
%% Pour plot RMS
% AGES
for a=1:16
    figure;plot(DonneesToExportOld.EMG(a).RMSCutNorm(:,49:60)); %% SE LEVER
end

for a=1:16
    figure;plot(DonneesToExportOld.EMG(a).RMSCutNorm(:,241:252)); %% SE RASSOIR
end

% JEUNES
for a=1:16
    figure;plot(DonneesToExport.EMG(a).RMSCutNorm(:,49:60)); %% SE LEVER
end
for a=1:16
    figure;plot(DonneesToExport.EMG(a).RMSCutNorm(:,241:252)); %% SE RASSOIR
end



%% Pour plot Phasic
% AGES
for a=1:16
    figure;plot(DonneesToExportOld.EMG(a).Phasic.Classique.Se_lever(:,25:30)); %% SE LEVER
end

for a=1:16
    figure;plot(DonneesToExportOld.EMG(a).Phasic.Classique.Se_rassoir(:,25:30)); %% SE RASSOIR
end

% JEUNES
for a=1:16
    figure;plot(DonneesToExport.EMG(a).Phasic.Classique.Se_lever(:,25:30)); %% SE LEVER
end
for a=1:16
    figure;plot(DonneesToExportOld.EMG(a).Phasic.Classique.Se_rassoir(:,25:30)); %% SE RASSOIR
end