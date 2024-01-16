% TITRE = 'SE PENCHER                                                                                                      SE REDRESSER';
TITRE = 'SE LEVER                                                                                                      SE RASSOIR'




%% VL D
%%%%% PLOT CONSTRUCTION PHASIC 
for SUJET=2:2

    Titre = append('MOUVEMENT ASSIS/DEBOUT');
            %set(gcf,'position',[200,200,1400,600])
            f = figure('units','normalized','outerposition',[0 0 1 1]);
            t = tiledlayout(4,2,'TileSpacing','Compact');
    
    nexttile     
    plot(DonneesToExport.EMG(SUJET).RMSCutNorm(:,49:60)) % Aller
    ylabel('RMS CUTNORM RAP','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG(SUJET).RMSCutNorm(:,241:252)) % Retour
    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNorm(:,25:30)) % Aller
    ylabel('RMS CUTNORM TONIC','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNorm(:,121:126)) % Retour
    

    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNormProfilMoyen.Se_lever(:,17:19)) % Aller
    ylabel('TONIC moy+/-err std','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNormProfilMoyen.Se_rassoir(:,17:19)) % Retour
    nexttile
    plot(DonneesToExport.EMG(SUJET).Phasic.Classique.Se_lever(:,25:30));hold on; % Aller
    r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');
    ylabel('PHASIC','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG(SUJET).Phasic.Classique.Se_rassoir(:,25:30));hold on; % Retour
    r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');
    title(t,TITRE,'fontweight','bold','fontsize',16)
    
%        saveas(gcf,append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Réunion 15\Images1\Sujet_VLD_',string(SUJET)),'png');
%        saveas(gcf,append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Réunion 15\Images1\Sujet_VLD_11'),'png');
end



%% VL G
%%%%% PLOT CONSTRUCTION PHASIC 
for SUJET=1:4

    Titre = append('MOUVEMENT ASSIS/DEBOUT');
            %set(gcf,'position',[200,200,1400,600])
            f = figure('units','normalized','outerposition',[0 0 1 1]);
            t = tiledlayout(4,2,'TileSpacing','Compact');
    
    nexttile     
    plot(DonneesToExport.EMG(SUJET).RMSCutNorm(:,73:84)) % Aller
    ylabel('RMS CUTNORM RAP','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG(SUJET).RMSCutNorm(:,265:276)) % Retour
    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNorm(:,37:42)) % Aller
    ylabel('RMS CUTNORM TONIC','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNorm(:,133:138)) % Retour
    

    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNormProfilMoyen.Se_lever(:,25:27)) % Aller
    ylabel('TONIC moy+/-err std','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNormProfilMoyen.Se_rassoir(:,25:27)) % Retour
    nexttile
    plot(DonneesToExport.EMG(SUJET).Phasic.Classique.Se_lever(:,37:42));hold on; % Aller
    r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');
    ylabel('PHASIC','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG(SUJET).Phasic.Classique.Se_rassoir(:,37:42));hold on; % Retour
    r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');
    title(t,TITRE,'fontweight','bold','fontsize',16)
    
      saveas(gcf,append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Réunion 15\Images2\Sujet_VLG_',string(SUJET)),'png');
%       saveas(gcf,append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Réunion 15\Images1\Sujet_VLG_11'),'png');
end



%%%%% PLOT CONSTRUCTION PHASIC ERECTEURS L1 D
for SUJET=1:4

    Titre = append('MOUVEMENT ASSIS/DEBOUT');
            %set(gcf,'position',[200,200,1400,600])
            f = figure('units','normalized','outerposition',[0 0 1 1]);
            t = tiledlayout(4,2,'TileSpacing','Compact');
    
    nexttile     
    plot(DonneesToExport.EMG(SUJET).RMSCutNorm(:,97:108)) % Aller
    ylabel('RMS CUTNORM RAP','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG(SUJET).RMSCutNorm(:,289:300)) % Retour289
    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNorm(:,49:54)) % Aller
    ylabel('RMS CUTNORM TONIC','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNorm(:,145:150)) % Retour
    

    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNormProfilMoyen.Se_lever(:,33:35)) % Aller
    ylabel('TONIC moy+/-err std','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNormProfilMoyen.Se_rassoir(:,33:35)) % Retour
    nexttile
    plot(DonneesToExport.EMG(SUJET).Phasic.Classique.Se_lever(:,49:54));hold on; % Aller
    r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');
    ylabel('PHASIC','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG(SUJET).Phasic.Classique.Se_rassoir(:,49:54));hold on; % Retour
    r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');
    title(t,TITRE,'fontweight','bold','fontsize',16)
    
%      saveas(gcf,append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Réunion 15\Images3\Sujet_ESL1D_',string(SUJET)),'png');
%      saveas(gcf,append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Réunion 15\Images1\Sujet_ESL1D_11'),'png');
end



%%%%% PLOT CONSTRUCTION PHASIC ERECTEURS L1 G
for SUJET=1:4

    Titre = append('MOUVEMENT ASSIS/DEBOUT');
            %set(gcf,'position',[200,200,1400,600])
            f = figure('units','normalized','outerposition',[0 0 1 1]);
            t = tiledlayout(4,2,'TileSpacing','Compact');
    
    nexttile     
    plot(DonneesToExport.EMG(SUJET).RMSCutNorm(:,121:132)) % Aller
    ylabel('RMS CUTNORM RAP','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG(SUJET).RMSCutNorm(:,313:324)) % Retour289
    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNorm(:,61:66)) % Aller
    ylabel('RMS CUTNORM TONIC','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNorm(:,157:162)) % Retour
    

    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNormProfilMoyen.Se_lever(:,41:43)) % Aller
    ylabel('TONIC moy+/-err std','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNormProfilMoyen.Se_rassoir(:,41:43)) % Retour
    nexttile
    plot(DonneesToExport.EMG(SUJET).Phasic.Classique.Se_lever(:,61:66));hold on; % Aller
    r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');
    ylabel('PHASIC','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG(SUJET).Phasic.Classique.Se_rassoir(:,61:66));hold on; % Retour
    r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');
    title(t,TITRE,'fontweight','bold','fontsize',16)
    
%       saveas(gcf,append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Réunion 15\Images4\Sujet_ESL1G_',string(SUJET)),'png');
%       saveas(gcf,append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Réunion 15\Images1\Sujet_ESL1G_11'),'png');
end
