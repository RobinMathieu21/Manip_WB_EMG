
for VARR = 49:60
    anticip_rap_aller1 = 0.075; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Aller Pre
    anticip_rap_aller2 = -0.075; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Aller Post
    anticip_rap_retour1 = 0.075; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Retour Pre
    anticip_rap_retour2 = -0.075;   %0;%POUR STS       % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Reour Post


    for azazaz =1:5
        f = figure('units','normalized','outerposition',[0 0 1 1]);
        plot(DonneesToExport.EMG(azazaz).RMS(:,VARR),'LineWidth',2);hold on; % PLOT RMS
        
        y = ylim; % current y-axis limits
        x = xlim; % current y-axis limits
        
        debut_1 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,1))*5;
        fin_1 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,2))*5;   % PLOT DEBUT FIN MVT 1
        plot([debut_1 debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
        plot([fin_1 fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
        
        debut_1 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,1)-anticip_rap_aller1*200)*5;
        fin_1 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,2)+anticip_rap_aller2*200)*5;   % PLOT DEBUT FIN MVT 1 avec EMD
        plot([debut_1 debut_1],[y(1) y(2)],'g'); hold on; % debut mvt 1
        plot([fin_1 fin_1],[y(1) y(2)],'g'); hold on; % fin mvt 1
        
        
        debut_2 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,3))*5;
        fin_2 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,4))*5;     % PLOT DEBUT FIN MVT 2
        plot([debut_2 debut_2],[y(1) y(2)],'r'); hold on; % debut mvt 2
        plot([fin_2 fin_2],[y(1) y(2)],'r'); hold on; % fin mvt 2
        
        debut_2 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,3)-anticip_rap_retour1*200)*5;
        fin_2 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,4)+anticip_rap_retour2*200)*5;   % PLOT DEBUT FIN MVT 2 avec EMD
        plot([debut_2 debut_2],[y(1) y(2)],'g'); hold on; % debut mvt 2
        plot([fin_2 fin_2],[y(1) y(2)],'g'); hold on; % fin mvt 2
    
    end

end





%%%%%%%%%%%%%%%%   LENT   %%%%%%%%%%%%%%%%%


for VARR = 25:30

    anticip_rap_aller1 = 0.075; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Aller Pre
    anticip_rap_aller2 = -0.075; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Aller Post
    anticip_rap_retour1 = 0.075; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Retour Pre
    anticip_rap_retour2 = -0.075;   %0;%POUR STS       % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Reour Post

    for azazaz =7:7
            f = figure('units','normalized','outerposition',[0 0 1 1]);
            plot(DonneesToExport.EMG_TL(azazaz).RMS(:,VARR),'LineWidth',2);hold on; 

            y = ylim; % current y-axis limits
            x = xlim; % current y-axis limits
            
            debut_1 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,1))*5;
            fin_1 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,2))*5;  % PLOT DEBUT FIN MVT 1
            plot([debut_1 debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
            plot([fin_1 fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
            
            debut_1 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,1)-anticip_rap_aller1*200)*5;
            fin_1 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,2)+anticip_rap_aller2*200)*5; % PLOT DEBUT FIN MVT 1 avec EMD
            plot([debut_1 debut_1],[y(1) y(2)],'g'); hold on; % debut mvt 1
            plot([fin_1 fin_1],[y(1) y(2)],'g'); hold on; % fin mvt 1
           
            
            debut_2 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,3))*5;
            fin_2 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,4))*5; % PLOT DEBUT FIN MVT 2
            plot([debut_2 debut_2],[y(1) y(2)],'r'); hold on; % debut mvt 2
            plot([fin_2 fin_2],[y(1) y(2)],'r'); hold on; % fin mvt 2
            
            debut_2 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,3)-anticip_rap_retour1*200)*5;
            fin_2 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,4)+anticip_rap_retour2*200)*5; % PLOT DEBUT FIN MVT 2 avec EMD
            plot([debut_2 debut_2],[y(1) y(2)],'g'); hold on; % debut mvt 2
            plot([fin_2 fin_2],[y(1) y(2)],'g'); hold on; % fin mvt 2
    end
end






%%%% POUR PLOT APRES PROG EMG

for aqa=1:16
    plot(DonneesToExport.EMG(aqa).Phasic.Classique.ProfilMoyenSeLever(:,13));hold on;%plot(Donnees_EMG_TL(aqa).RMSCutNorm(:,25:30))%plot(Donnees_EMG(aqa).RMSCutNorm(:,49:60))%plot(Donnees_EMG(aqa).RMSCutNormProfilMoyen.Se_lever(:,17:19))%
end