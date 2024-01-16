load('C:\Users\robin\Desktop\V999 emd 2\R1 jeune\Donnees_saved_Young.mat')


anticip_rap_aller1 = 0.075; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Aller Pre
anticip_rap_aller2 = 0; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Aller Post
anticip_rap_retour1 = 0.075; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Retour Pre
anticip_rap_retour2 = 0;   %0;%POUR STS       % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Reour Post

for azazaz =1:16
    for VARR = 49:60
        f = figure('units','normalized','outerposition',[0 0 1 1]);
        plot(DonneesToExport.EMG(azazaz).RMS(:,VARR),'LineWidth',2);hold on; % PLOT RMS
        
        y = ylim; % current y-axis limits
        x = xlim; % current y-axis limits
        
        debut_1 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,1))*5;
        fin_1 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,2))*5;   % PLOT DEBUT FIN MVT 1
        plot([debut_1 debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
        plot([fin_1 fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1


        value = 1;
        meandebut = mean(DonneesToExport.EMG(azazaz).RMS(1:1000,VARR));
        stddebut = std(DonneesToExport.EMG(azazaz).RMS(1:1000,VARR));
        while DonneesToExport.EMG(azazaz).RMS(value,VARR)-meandebut<10*stddebut
            value=value+1;
        end
        plot([value value],[y(1) y(2)],'b'); hold on;
        valuess(VARR-48,azazaz) = debut_1-value; 
        save_start_mvt1= debut_1-value; 
        
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

        titre = append('Sujet numéro ',string(azazaz),' acquisition numéro ', string(VARR-48));
        title(titre,'fontweight','bold','fontsize',16)

 
    end
end





%%%%%%%%%%%%%%%%   LENT   %%%%%%%%%%%%%%%%%
anticip_rap_aller1 = 0.075; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Aller Pre
anticip_rap_aller2 = -0.075; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Aller Post
anticip_rap_retour1 = 0.075; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Retour Pre
anticip_rap_retour2 = -0.075;   %0;%POUR STS       % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Reour Post

for azazaz =1:2
    for VARR = 25:30
            f = figure('units','normalized','outerposition',[0 0 1 1]);
            plot(DonneesToExport.EMG_TL(azazaz).RMS(:,VARR),'LineWidth',2);hold on; 

            y = ylim; % current y-axis limits
            x = xlim; % current y-axis limits
            
            debut_1 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin2(VARR-24,1))*5;
            fin_1 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin2(VARR-24,2))*5;  % PLOT DEBUT FIN MVT 1
            plot([debut_1 debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
            plot([fin_1 fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
            
            debut_1 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin2(VARR-24,1)-anticip_rap_aller1*200)*5;
            fin_1 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin2(VARR-24,2)+anticip_rap_aller2*200)*5; % PLOT DEBUT FIN MVT 1 avec EMD
            plot([debut_1 debut_1],[y(1) y(2)],'g'); hold on; % debut mvt 1
            plot([fin_1 fin_1],[y(1) y(2)],'g'); hold on; % fin mvt 1
           
            
            debut_2 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin2(VARR-24,3))*5;
            fin_2 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin2(VARR-24,4))*5; % PLOT DEBUT FIN MVT 2
            plot([debut_2 debut_2],[y(1) y(2)],'r'); hold on; % debut mvt 2
            plot([fin_2 fin_2],[y(1) y(2)],'r'); hold on; % fin mvt 2
            
            debut_2 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin2(VARR-24,3)-anticip_rap_retour1*200)*5;
            fin_2 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin2(VARR-24,4)+anticip_rap_retour2*200)*5; % PLOT DEBUT FIN MVT 2 avec EMD
            plot([debut_2 debut_2],[y(1) y(2)],'g'); hold on; % debut mvt 2
            plot([fin_2 fin_2],[y(1) y(2)],'g'); hold on; % fin mvt 2

            titre = append('TONIC   Sujet num ',string(azazaz),' acquisition num ', string(VARR-24));
            title(titre,'fontweight','bold','fontsize',16)
    end
end




 
%%
%%%%% PLOT CONSTRUCTION PHASIC
for SUJET=1:20

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
    title(t,'SE PENCHER                                                                                                      SE REDRESSER','fontweight','bold','fontsize',16)
    
%       saveas(gcf,append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Réunion 15\Images\Sujet',string(SUJET)),'png');
end

%%%%% PLOT CONSTRUCTION PHASIC ERECTEURS
for SUJET=1:20

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
    title(t,'SE PENCHER                                                                                                      SE REDRESSER','fontweight','bold','fontsize',16)
    
     saveas(gcf,append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Réunion 15\Images\Sujet',string(SUJET)),'png');
end

%% MEAN

    Titre = append('MOUVEMENT WBR 2');
            %set(gcf,'position',[200,200,1400,600])
            f = figure('units','normalized','outerposition',[0 0 1 1]);
            t = tiledlayout(2,2,'TileSpacing','Compact');
            nexttile
plot(DonneesToExport.EMG(21).Phasic.MOYENNE_ClassiqueSeLever(:,13:15));hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');axis([0 1000 -0.5 1]); 
ylabel('Phasic Vast lat droit','fontweight','bold','fontsize',16)
nexttile
plot(DonneesToExport.EMG(21).Phasic.MOYENNE_ClassiqueSeRassoir(:,13:15));hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');axis([0 1000 -0.5 1]); 
nexttile
plot(DonneesToExport.EMG(21).Phasic.MOYENNE_ClassiqueSeLever(:,19:21));hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');axis([0 1000 -0.5 1]); 
ylabel('Phasic Vast lat gauche','fontweight','bold','fontsize',16)
nexttile
plot(DonneesToExport.EMG(21).Phasic.MOYENNE_ClassiqueSeRassoir(:,19:21));hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');axis([0 1000 -0.5 1]); 

title(t,'SE PENCHER                                                                                                      SE REDRESSER','fontweight','bold','fontsize',16)

%% MEAN EREC
Titre = append('MOUVEMENT WBR 2');
            %set(gcf,'position',[200,200,1400,600])
            f = figure('units','normalized','outerposition',[0 0 1 1]);
            t = tiledlayout(2,2,'TileSpacing','Compact');
            nexttile
plot(DonneesToExport.EMG(21).Phasic.MOYENNE_ClassiqueSeLever(:,25:27));hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');axis([0 1000 -0.5 1]); 
ylabel('Phasic Erec L1 droit','fontweight','bold','fontsize',16)
nexttile
plot(DonneesToExport.EMG(21).Phasic.MOYENNE_ClassiqueSeRassoir(:,25:27));hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');axis([0 1000 -0.5 1]); 
nexttile
plot(DonneesToExport.EMG(21).Phasic.MOYENNE_ClassiqueSeLever(:,31:33));hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');axis([0 1000 -0.5 1]); 
ylabel('Phasic Erec L1 gauche','fontweight','bold','fontsize',16)
nexttile
plot(DonneesToExport.EMG(21).Phasic.MOYENNE_ClassiqueSeRassoir(:,31:33));hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');axis([0 1000 -0.5 1]); 

title(t,'SE PENCHER                                                                                                      SE REDRESSER','fontweight','bold','fontsize',16)



%% Tous les suejts

    Titre = append('MOUVEMENT ASSIS/DEBOUT');
            %set(gcf,'position',[200,200,1400,600])
            f = figure('units','normalized','outerposition',[0 0 1 1]);
            t = tiledlayout(2,2,'TileSpacing','Compact');
            nexttile

    for AAA=1:18
        plot(DonneesToExport.EMG(AAA).Phasic.Classique.ProfilMoyenSeLever(:,13));hold on;
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');axis([0 1000 -1 1]); 
        ylabel('Phasic Vast lat droit','fontweight','bold','fontsize',16)
    end
    nexttile
    for AAA=1:18
        plot(DonneesToExport.EMG(AAA).Phasic.Classique.ProfilMoyenSeRassoir(:,13));hold on;
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');axis([0 1000 -1 1]); 
    end
    nexttile
    for AAA=1:18
        plot(DonneesToExport.EMG(AAA).Phasic.Classique.ProfilMoyenSeLever(:,19));hold on;
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');axis([0 1000 -1 1]); 
        ylabel('Phasic Vast lat gauche','fontweight','bold','fontsize',16)
    end
    nexttile
    for AAA=1:18
        plot(DonneesToExport.EMG(AAA).Phasic.Classique.ProfilMoyenSeRassoir(:,19));hold on;
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');axis([0 1000 -1 1]); 
    end
    
title(t,'SE LEVER                                                                                                      SE RASSOIR','fontweight','bold','fontsize',16)

%% Pour comparer deux méthodes

anticip_rap_aller1 = 0.235;%+0.160; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Aller Pre
anticip_rap_aller2 = 0.085;%-0.075; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Aller Post
anticip_rap_retour1 = 0.235;%+0.160; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Retour Pre
anticip_rap_retour2 = 0.085;%-0.075;   %0;%POUR STS       % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Reour Post

for azazaz =16:18
    for VARR = 49:60
            Titre = append('MOUVEMENT ASSIS/DEBOUT');
            f = figure('units','normalized','outerposition',[0 0 1 1]);
            t = tiledlayout(1,1,'TileSpacing','Compact');
%     
%         nexttile  
%         plot(DonneesToExport.EMG(azazaz).RMS(:,VARR),'LineWidth',2);hold on; % PLOT RMS
%         
%         y = ylim; % current y-axis limits
%         x = xlim; % current y-axis limits
%         
%         debut_1 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,1))*5;
%         fin_1 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,2))*5;   % PLOT DEBUT FIN MVT 1
%         plot([debut_1 debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
%         plot([fin_1 fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
%         
%         debut_1 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,1)-anticip_rap_aller1*200)*5;
%         fin_1 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,2)+anticip_rap_aller2*200)*5;   % PLOT DEBUT FIN MVT 1 avec EMD
%         plot([debut_1 debut_1],[y(1) y(2)],'g'); hold on; % debut mvt 1
%         plot([fin_1 fin_1],[y(1) y(2)],'g'); hold on; % fin mvt 1
%         
%         
%         debut_2 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,3))*5;
%         fin_2 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,4))*5;     % PLOT DEBUT FIN MVT 2
%         plot([debut_2 debut_2],[y(1) y(2)],'r'); hold on; % debut mvt 2
%         plot([fin_2 fin_2],[y(1) y(2)],'r'); hold on; % fin mvt 2
%         
%         debut_2 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,3)-anticip_rap_retour1*200)*5;
%         fin_2 = (DonneesToExport.cinematiques(azazaz).debut_fin(VARR-48,4)+anticip_rap_retour2*200)*5;   % PLOT DEBUT FIN MVT 2 avec EMD
%         plot([debut_2 debut_2],[y(1) y(2)],'g'); hold on; % debut mvt 2
%         plot([fin_2 fin_2],[y(1) y(2)],'g'); hold on; % fin mvt 2
% 
%         titre = append('Découpage classique 5% déplacement XYZ épaule  _  Sujet numéro ',string(azazaz),' acquisition numéro ', string(VARR-48));
%         title(titre,'fontweight','bold','fontsize',16)
% 
%         %% KNEE
%         nexttile   
%         plot(DonneesToExportKnee.EMG(azazaz).RMS(:,VARR),'LineWidth',2);hold on; % PLOT RMS
%         
%         y = ylim; % current y-axis limits
%         x = xlim; % current y-axis limits
%         
%         debut_1 = (DonneesToExportKnee.cinematiques(azazaz).debut_fin(VARR-48,1))*5;
%         fin_1 = (DonneesToExportKnee.cinematiques(azazaz).debut_fin(VARR-48,2))*5;   % PLOT DEBUT FIN MVT 1
%         plot([debut_1 debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
%         plot([fin_1 fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
%         
%         debut_1 = (DonneesToExportKnee.cinematiques(azazaz).debut_fin(VARR-48,1)-anticip_rap_aller1*200)*5;
%         fin_1 = (DonneesToExportKnee.cinematiques(azazaz).debut_fin(VARR-48,2)+anticip_rap_aller2*200)*5;   % PLOT DEBUT FIN MVT 1 avec EMD
%         plot([debut_1 debut_1],[y(1) y(2)],'g'); hold on; % debut mvt 1
%         plot([fin_1 fin_1],[y(1) y(2)],'g'); hold on; % fin mvt 1
%         
%         
%         debut_2 = (DonneesToExportKnee.cinematiques(azazaz).debut_fin(VARR-48,3))*5;
%         fin_2 = (DonneesToExportKnee.cinematiques(azazaz).debut_fin(VARR-48,4))*5;     % PLOT DEBUT FIN MVT 2
%         plot([debut_2 debut_2],[y(1) y(2)],'r'); hold on; % debut mvt 2
%         plot([fin_2 fin_2],[y(1) y(2)],'r'); hold on; % fin mvt 2
%         
%         debut_2 = (DonneesToExportKnee.cinematiques(azazaz).debut_fin(VARR-48,3)-anticip_rap_retour1*200)*5;
%         fin_2 = (DonneesToExportKnee.cinematiques(azazaz).debut_fin(VARR-48,4)+anticip_rap_retour2*200)*5;   % PLOT DEBUT FIN MVT 2 avec EMD
%         plot([debut_2 debut_2],[y(1) y(2)],'g'); hold on; % debut mvt 2
%         plot([fin_2 fin_2],[y(1) y(2)],'g'); hold on; % fin mvt 2
% 
%         titre = append('Découpage 5% amplitude sur genou en Z Int');
%         title(titre,'fontweight','bold','fontsize',16)
% 
%         %% COM
%         nexttile   
%         plot(DonneesToExportCOM.EMG(azazaz).RMS(:,VARR),'LineWidth',2);hold on; % PLOT RMS
%         
%         y = ylim; % current y-axis limits
%         x = xlim; % current y-axis limits
%         
%         debut_1 = (DonneesToExportCOM.cinematiques(azazaz).debut_fin2(VARR-48,1))*5;
%         fin_1 = (DonneesToExportCOM.cinematiques(azazaz).debut_fin2(VARR-48,2))*5;   % PLOT DEBUT FIN MVT 1
%         plot([debut_1 debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
%         plot([fin_1 fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
%         
%         debut_1 = (DonneesToExportCOM.cinematiques(azazaz).debut_fin2(VARR-48,1)-anticip_rap_aller1*200)*5;
%         fin_1 = (DonneesToExportCOM.cinematiques(azazaz).debut_fin2(VARR-48,2)+anticip_rap_aller2*200)*5;   % PLOT DEBUT FIN MVT 1 avec EMD
%         plot([debut_1 debut_1],[y(1) y(2)],'g'); hold on; % debut mvt 1
%         plot([fin_1 fin_1],[y(1) y(2)],'g'); hold on; % fin mvt 1
%         
%         
%         debut_2 = (DonneesToExportCOM.cinematiques(azazaz).debut_fin2(VARR-48,3))*5;
%         fin_2 = (DonneesToExportCOM.cinematiques(azazaz).debut_fin2(VARR-48,4))*5;     % PLOT DEBUT FIN MVT 2
%         plot([debut_2 debut_2],[y(1) y(2)],'r'); hold on; % debut mvt 2
%         plot([fin_2 fin_2],[y(1) y(2)],'r'); hold on; % fin mvt 2
%         
%         debut_2 = (DonneesToExportCOM.cinematiques(azazaz).debut_fin2(VARR-48,3)-anticip_rap_retour1*200)*5;
%         fin_2 = (DonneesToExportCOM.cinematiques(azazaz).debut_fin2(VARR-48,4)+anticip_rap_retour2*200)*5;   % PLOT DEBUT FIN MVT 2 avec EMD
%         plot([debut_2 debut_2],[y(1) y(2)],'g'); hold on; % debut mvt 2
%         plot([fin_2 fin_2],[y(1) y(2)],'g'); hold on; % fin mvt 2
% 
%         titre = append('Découpage 5% amplitude sur COM en Z Int ');
%         title(titre,'fontweight','bold','fontsize',16)

        %% SHO int
        nexttile   
        plot(DonneesToExportSHO.EMG(azazaz).RMS(:,VARR),'LineWidth',2);hold on; % PLOT RMS
        
        y = ylim; % current y-axis limits
        x = xlim; % current y-axis limits
        
        debut_1 = (DonneesToExportSHO.cinematiques(azazaz).debut_fin(VARR-48,1))*5;
        fin_1 = (DonneesToExportSHO.cinematiques(azazaz).debut_fin(VARR-48,2))*5;   % PLOT DEBUT FIN MVT 1
        plot([debut_1 debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
        plot([fin_1 fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
        
        value = 1;
        meandebut = mean(DonneesToExportSHO.EMG(azazaz).RMS(1:1000,VARR));
        stddebut = std(DonneesToExportSHO.EMG(azazaz).RMS(1:1000,VARR));
        while DonneesToExportSHO.EMG(azazaz).RMS(value,VARR)-meandebut<10*stddebut
            value=value+1;
        end
        plot([value value],[y(1) y(2)],'b'); hold on;
        valuess(VARR-48,azazaz) = debut_1-value; 
        save_start_mvt1= debut_1-value; 

% 
%         debut_1 = (DonneesToExportSHO.cinematiques(azazaz).debut_fin(VARR-48,1)-anticip_rap_aller1*200)*5;
%         fin_1 = (DonneesToExportSHO.cinematiques(azazaz).debut_fin(VARR-48,2)+anticip_rap_aller2*200)*5;   % PLOT DEBUT FIN MVT 1 avec EMD
%         plot([debut_1 debut_1],[y(1) y(2)],'b'); hold on; % debut mvt 1
%         plot([fin_1 fin_1],[y(1) y(2)],'b'); hold on; % fin mvt 1
        
        
        debut_2 = (DonneesToExportSHO.cinematiques(azazaz).debut_fin(VARR-48,3))*5;
        fin_2 = (DonneesToExportSHO.cinematiques(azazaz).debut_fin(VARR-48,4))*5;     % PLOT DEBUT FIN MVT 2
        plot([debut_2 debut_2],[y(1) y(2)],'r'); hold on; % debut mvt 2
        plot([fin_2 fin_2],[y(1) y(2)],'r'); hold on; % fin mvt 2
        
%         value = debut_2-save_start_mvt1;
%         plot([value value],[y(1) y(2)],'b'); hold on;
        
%         debut_2 = (DonneesToExportSHO.cinematiques(azazaz).debut_fin(VARR-48,3)-anticip_rap_retour1*200)*5;
%         fin_2 = (DonneesToExportSHO.cinematiques(azazaz).debut_fin(VARR-48,4)+anticip_rap_retour2*200)*5;   % PLOT DEBUT FIN MVT 2 avec EMD
%         plot([debut_2 debut_2],[y(1) y(2)],'b'); hold on; % debut mvt 2
%         plot([fin_2 fin_2],[y(1) y(2)],'b'); hold on; % fin mvt 2

        titre = append('Découpage 5% amplitude sur Epaule en Z Int ');
        title(titre,'fontweight','bold','fontsize',16)
 
    end
end
% 
% 
% %% Pour comparer la répétabilité 
% for SUJET =1:5
%     Titre = append('MOUVEMENT ASSIS/DEBOUT');
%             %set(gcf,'position',[200,200,1400,600])
%             f = figure('units','normalized','outerposition',[0 0 1 1]);
%             t = tiledlayout(2,2,'TileSpacing','Compact');
%     
%     nexttile     
%     plot(DonneesToExportKnee.EMG(SUJET).RMSCutNorm(:,49:60)) % Aller
%     ylabel('RMS CUTNORM RAP','fontweight','bold','fontsize',11)
%     nexttile
%     plot(DonneesToExportSHO.EMG(SUJET).RMSCutNorm(:,241:252)) % Retour
%     nexttile
%     plot(DonneesToExportSHO.EMG_TL(SUJET).RMSCutNorm(:,25:30)) % Aller
%     ylabel('RMS CUTNORM TONIC','fontweight','bold','fontsize',11)
%     nexttile
%     plot(DonneesToExportSHO.EMG_TL(SUJET).RMSCutNorm(:,121:126)) % Retour
% end
% 
% SUJET =1;
%     nexttile     
%     plot(DonneesToExportKnee.EMG(SUJET).RMSCutNorm(:,49:60)) % Aller
%     ylabel('RMS CUTNORM RAP','fontweight','bold','fontsize',11)
%     nexttile
%     plot(DonneesToExportKnee.EMG(SUJET).RMSCutNorm(:,241:252)) % Retour
%     nexttile
%     plot(DonneesToExportKnee.EMG_TL(SUJET).RMSCutNorm(:,25:30)) % Aller
%     ylabel('RMS CUTNORM TONIC','fontweight','bold','fontsize',11)
%     nexttile
%     plot(DonneesToExportKnee.EMG_TL(SUJET).RMSCutNorm(:,121:126)) % Retour                                                                                                SE RASSOIR','fontweight','bold','fontsize',16)
%  
% 
% 
% 
    %% REPRODUCTIBILITE


for SUJET =1:5
            Titre = append('MOUVEMENT ASSIS/DEBOUT');
            f = figure('units','normalized','outerposition',[0 0 1 1]);
            t = tiledlayout(4,2,'TileSpacing','Compact');
    
        nexttile  
        plot(DonneesToExport.EMG(SUJET).RMSCutNorm(:,49:60),'LineWidth',2);hold on; % PLOT RMS
        nexttile
        plot(DonneesToExport.EMG(SUJET).RMSCutNorm(:,241:252),'LineWidth',2);hold on; % PLOT RMS

        titre = append('Découpage classique étendu 200ms 5% déplacement XYZ épaule  _  Sujet numéro ',string(SUJET));
        title(titre,'fontweight','bold','fontsize',16)

        %% KNEE
        nexttile   
        plot(DonneesToExportKnee.EMG(SUJET).RMSCutNorm(:,49:60),'LineWidth',2);hold on; % PLOT RMS
        nexttile
        plot(DonneesToExportKnee.EMG(SUJET).RMSCutNorm(:,241:252),'LineWidth',2);hold on; % PLOT RMS

        titre = append('Découpage étendu 200ms 5% amplitude sur genou en Z Int');
        title(titre,'fontweight','bold','fontsize',16)

        %% COM
        nexttile   
        plot(DonneesToExportCOM.EMG(SUJET).RMSCutNorm(:,49:60),'LineWidth',2);hold on; % PLOT RMS
        nexttile
        plot(DonneesToExportCOM.EMG(SUJET).RMSCutNorm(:,241:252),'LineWidth',2);hold on; % PLOT RMS

        titre = append('Découpage étendu 200ms 5% amplitude sur COM en Z Int ');
        title(titre,'fontweight','bold','fontsize',16)

        %% SHO int
        nexttile   
        plot(DonneesToExportSHO.EMG(SUJET).RMSCutNorm(:,49:60),'LineWidth',2);hold on; % PLOT RMS
        nexttile
        plot(DonneesToExportSHO.EMG(SUJET).RMSCutNorm(:,241:252),'LineWidth',2);hold on; % PLOT RMS

        titre = append('Découpage étendu 200ms 5% amplitude sur Epaule en Z Int ');
        title(titre,'fontweight','bold','fontsize',16)
end









%% COMP METHODES MVTS LENTS



anticip_rap_aller1 = 0.235;%0.075;%+0.160; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Aller Pre
anticip_rap_aller2 = 0.085;%-0.075; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Aller Post
anticip_rap_retour1 = 0.235;%0.075;%+0.160; % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Retour Pre
anticip_rap_retour2 = 0.085;%-0.075;   %0;%POUR STS       % Temps à soustraire lors du recoupage du rms_cut pour trouver le début de la bouffée MVT RAPIDE Reour Post

for azazaz =1:5
    for VARR = 25:30
            Titre = append('MOUVEMENT ASSIS/DEBOUT');
            f = figure('units','normalized','outerposition',[0 0 1 1]);
            t = tiledlayout(4,1,'TileSpacing','Compact');
    
        nexttile  
        plot(DonneesToExport.EMG_TL(azazaz).RMS(:,VARR),'LineWidth',2);hold on; % PLOT RMS
        
        y = ylim; % current y-axis limits
        x = xlim; % current y-axis limits
        
        debut_1 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,1))*5;
        fin_1 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,2))*5;   % PLOT DEBUT FIN MVT 1
        plot([debut_1 debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
        plot([fin_1 fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
        
        debut_1 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,1)-anticip_rap_aller1*200)*5;
        fin_1 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,2)+anticip_rap_aller2*200)*5;   % PLOT DEBUT FIN MVT 1 avec EMD
        plot([debut_1 debut_1],[y(1) y(2)],'g'); hold on; % debut mvt 1
        plot([fin_1 fin_1],[y(1) y(2)],'g'); hold on; % fin mvt 1
        
        
        debut_2 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,3))*5;
        fin_2 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,4))*5;     % PLOT DEBUT FIN MVT 2
        plot([debut_2 debut_2],[y(1) y(2)],'r'); hold on; % debut mvt 2
        plot([fin_2 fin_2],[y(1) y(2)],'r'); hold on; % fin mvt 2
        
        debut_2 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,3)-anticip_rap_retour1*200)*5;
        fin_2 = (DonneesToExport.cinematiques_TL(azazaz).debut_fin(VARR-24,4)+anticip_rap_retour2*200)*5;   % PLOT DEBUT FIN MVT 2 avec EMD
        plot([debut_2 debut_2],[y(1) y(2)],'g'); hold on; % debut mvt 2
        plot([fin_2 fin_2],[y(1) y(2)],'g'); hold on; % fin mvt 2

        titre = append('Découpage classique 5% déplacement XYZ épaule  _  Sujet numéro ',string(azazaz),' acquisition numéro ', string(VARR-24));
        title(titre,'fontweight','bold','fontsize',16)

        %% KNEE
        nexttile   
        plot(DonneesToExportKnee.EMG_TL(azazaz).RMS(:,VARR),'LineWidth',2);hold on; % PLOT RMS
        
        y = ylim; % current y-axis limits
        x = xlim; % current y-axis limits
        
        debut_1 = (DonneesToExportKnee.cinematiques_TL(azazaz).debut_fin(VARR-24,1))*5;
        fin_1 = (DonneesToExportKnee.cinematiques_TL(azazaz).debut_fin(VARR-24,2))*5;   % PLOT DEBUT FIN MVT 1
        plot([debut_1 debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
        plot([fin_1 fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
        
        debut_1 = (DonneesToExportKnee.cinematiques_TL(azazaz).debut_fin(VARR-24,1)-anticip_rap_aller1*200)*5;
        fin_1 = (DonneesToExportKnee.cinematiques_TL(azazaz).debut_fin(VARR-24,2)+anticip_rap_aller2*200)*5;   % PLOT DEBUT FIN MVT 1 avec EMD
        plot([debut_1 debut_1],[y(1) y(2)],'g'); hold on; % debut mvt 1
        plot([fin_1 fin_1],[y(1) y(2)],'g'); hold on; % fin mvt 1
        
        
        debut_2 = (DonneesToExportKnee.cinematiques_TL(azazaz).debut_fin(VARR-24,3))*5;
        fin_2 = (DonneesToExportKnee.cinematiques_TL(azazaz).debut_fin(VARR-24,4))*5;     % PLOT DEBUT FIN MVT 2
        plot([debut_2 debut_2],[y(1) y(2)],'r'); hold on; % debut mvt 2
        plot([fin_2 fin_2],[y(1) y(2)],'r'); hold on; % fin mvt 2
        
        debut_2 = (DonneesToExportKnee.cinematiques_TL(azazaz).debut_fin(VARR-24,3)-anticip_rap_retour1*200)*5;
        fin_2 = (DonneesToExportKnee.cinematiques_TL(azazaz).debut_fin(VARR-24,4)+anticip_rap_retour2*200)*5;   % PLOT DEBUT FIN MVT 2 avec EMD
        plot([debut_2 debut_2],[y(1) y(2)],'g'); hold on; % debut mvt 2
        plot([fin_2 fin_2],[y(1) y(2)],'g'); hold on; % fin mvt 2

        titre = append('Découpage 5% amplitude sur genou en Z Int');
        title(titre,'fontweight','bold','fontsize',16)

        %% COM
        nexttile   
        plot(DonneesToExportCOM.EMG_TL(azazaz).RMS(:,VARR),'LineWidth',2);hold on; % PLOT RMS
        
        y = ylim; % current y-axis limits
        x = xlim; % current y-axis limits
        
        debut_1 = (DonneesToExportCOM.cinematiques_TL(azazaz).debut_fin2(VARR-24,1))*5;
        fin_1 = (DonneesToExportCOM.cinematiques_TL(azazaz).debut_fin2(VARR-24,2))*5;   % PLOT DEBUT FIN MVT 1
        plot([debut_1 debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
        plot([fin_1 fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
        
        debut_1 = (DonneesToExportCOM.cinematiques_TL(azazaz).debut_fin2(VARR-24,1)-anticip_rap_aller1*200)*5;
        fin_1 = (DonneesToExportCOM.cinematiques_TL(azazaz).debut_fin2(VARR-24,2)+anticip_rap_aller2*200)*5;   % PLOT DEBUT FIN MVT 1 avec EMD
        plot([debut_1 debut_1],[y(1) y(2)],'g'); hold on; % debut mvt 1
        plot([fin_1 fin_1],[y(1) y(2)],'g'); hold on; % fin mvt 1
        
        
        debut_2 = (DonneesToExportCOM.cinematiques_TL(azazaz).debut_fin2(VARR-24,3))*5;
        fin_2 = (DonneesToExportCOM.cinematiques_TL(azazaz).debut_fin2(VARR-24,4))*5;     % PLOT DEBUT FIN MVT 2
        plot([debut_2 debut_2],[y(1) y(2)],'r'); hold on; % debut mvt 2
        plot([fin_2 fin_2],[y(1) y(2)],'r'); hold on; % fin mvt 2
        
        debut_2 = (DonneesToExportCOM.cinematiques_TL(azazaz).debut_fin2(VARR-24,3)-anticip_rap_retour1*200)*5;
        fin_2 = (DonneesToExportCOM.cinematiques_TL(azazaz).debut_fin2(VARR-24,4)+anticip_rap_retour2*200)*5;   % PLOT DEBUT FIN MVT 2 avec EMD
        plot([debut_2 debut_2],[y(1) y(2)],'g'); hold on; % debut mvt 2
        plot([fin_2 fin_2],[y(1) y(2)],'g'); hold on; % fin mvt 2

        titre = append('Découpage 5% amplitude sur COM en Z Int ');
        title(titre,'fontweight','bold','fontsize',16)

        %% SHO int
        nexttile   
        plot(DonneesToExportSHO.EMG_TL(azazaz).RMS(:,VARR),'LineWidth',2);hold on; % PLOT RMS
        
        y = ylim; % current y-axis limits
        x = xlim; % current y-axis limits
        
        debut_1 = (DonneesToExportSHO.cinematiques_TL(azazaz).debut_fin(VARR-24,1))*5;
        fin_1 = (DonneesToExportSHO.cinematiques_TL(azazaz).debut_fin(VARR-24,2))*5;   % PLOT DEBUT FIN MVT 1
        plot([debut_1 debut_1],[y(1) y(2)],'r'); hold on; % debut mvt 1
        plot([fin_1 fin_1],[y(1) y(2)],'r'); hold on; % fin mvt 1
        
%         value = 1;
%         meandebut = mean(DonneesToExportSHO.EMG_TL(azazaz).RMS(1:1000,VARR));
%         stddebut = std(DonneesToExportSHO.EMG_TL(azazaz).RMS(1:1000,VARR));
%         while DonneesToExportSHO.EMG(azazaz).RMS(value,VARR)-meandebut<10*stddebut
%             value=value+1;
%         end
%         plot([value value],[y(1) y(2)],'b'); hold on;
%         valuess(VARR-24,azazaz) = debut_1-value; 


        debut_1 = (DonneesToExportSHO.cinematiques_TL(azazaz).debut_fin(VARR-24,1)-anticip_rap_aller1*200)*5;
        fin_1 = (DonneesToExportSHO.cinematiques_TL(azazaz).debut_fin(VARR-24,2)+anticip_rap_aller2*200)*5;   % PLOT DEBUT FIN MVT 1 avec EMD
        plot([debut_1 debut_1],[y(1) y(2)],'g'); hold on; % debut mvt 1
        plot([fin_1 fin_1],[y(1) y(2)],'g'); hold on; % fin mvt 1
        
        
        debut_2 = (DonneesToExportSHO.cinematiques_TL(azazaz).debut_fin(VARR-24,3))*5;
        fin_2 = (DonneesToExportSHO.cinematiques_TL(azazaz).debut_fin(VARR-24,4))*5;     % PLOT DEBUT FIN MVT 2
        plot([debut_2 debut_2],[y(1) y(2)],'r'); hold on; % debut mvt 2
        plot([fin_2 fin_2],[y(1) y(2)],'r'); hold on; % fin mvt 2
        
        debut_2 = (DonneesToExportSHO.cinematiques_TL(azazaz).debut_fin(VARR-24,3)-anticip_rap_retour1*200)*5;
        fin_2 = (DonneesToExportSHO.cinematiques_TL(azazaz).debut_fin(VARR-24,4)+anticip_rap_retour2*200)*5;   % PLOT DEBUT FIN MVT 2 avec EMD
        plot([debut_2 debut_2],[y(1) y(2)],'g'); hold on; % debut mvt 2
        plot([fin_2 fin_2],[y(1) y(2)],'g'); hold on; % fin mvt 2

        titre = append('Découpage 5% amplitude sur Epaule en Z Int ');
        title(titre,'fontweight','bold','fontsize',16)
 

    end
end



for q=1:16
    for qq = 1:12
        val(q*(qq-1)+1,1) = valuess(qq,q);
        qq*(q-1)+1
    end
end





DonneesToExport.cinematiques(1).debut_fin  





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% AJOUT avec Debut fin pour verif
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for YY=1:18

    DonneesToExport.cinematiques(1).TempsRapSL(:,YY)=(DonneesToExport.cinematiques(YY).debut_fin(1:12,2)-DonneesToExport.cinematiques(YY).debut_fin(1:12,1))./200;
    
    DonneesToExport.cinematiques(1).TempsRapSR(:,YY)=(DonneesToExport.cinematiques(YY).debut_fin(1:12,4)-DonneesToExport.cinematiques(YY).debut_fin(1:12,3))./200;
end

sujet = 0
for YY=1:12:216
    sujet=sujet+1;
     timing(YY:YY+11,1) =DonneesToExport.cinematiques(1).TempsRapSL(1:12,sujet); 

end


