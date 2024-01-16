
close all
clear all
Nb_Young = 19
Nb_OLD = 24

for mvt = 1:1
    for muscles = 1:1


%             file = 'D:\DATA MANIP 1\DONNES EMG\ASSIS\Donnees_saved_Old.mat'; 
            fileY = 'D:\DATA MANIP 1\DONNES EMG\BRASD\Donnees_saved_Young.mat'; title_mvt = 'YOUNG                                                               Arm movements                                                                      OLD';
%             file = 'C:\Users\robin\Desktop\DONNES EMG\ASSIS\Donnees_saved_Old.mat'; title_mvt = 'OLD                                                                      STS / BTS movement                                                                      OLD';
%             fileY = 'C:\Users\robin\Desktop\DONNES EMG\ASSIS\Donnees_saved_Young.mat'; 
            title_add= 'Upward _ '; title_add2= 'Downward _ ';
            path = append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Réunion 6','\');
%             path = append('C:\Users\robin\Desktop\Drive google\6A - THESE\MANIP 1\Resultats\Stats\Réunion 3\Graphs\ASSIS','\');
       

color0=[28/255,156/255,67/255]; % Pour la couleur du premier mvt des âgés
color1=[65/255,211/255,183/255]; % Pour la couleur du second mvt des âgés
color0Y=[217/255,95/255,2/255]; % Pour la couleur du premier mvt des jeunes
color1Y=[233/255,148/255,63/255]; % Pour la couleur du second mvt des jeunes


color5=[80/255,121/255,63/255]; % Pour la couleur de la ligne en y=0
% load(file);
% Donnees_EMG = DonneesToExport.EMG;
load(fileY);
Donnees_EMGY = DonneesToExport.EMG;


        %% POUR LES MUSCLES des bras
            i1=1; title1 = ' Anterior Deltoid'; 
            i2=4; title2 = ' Posterior Deltoid';
            path = append(path,'Bras');
             
    % 


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Mean + Erreur stand
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% YOUNG
for sujet=1:Nb_Young
    DAD_seLever_mean(:,sujet) = Donnees_EMGY(sujet).Phasic.Classique.ProfilMoyenSeLever(:,i1);
    DAD_seRassoir_mean(:,sujet) = Donnees_EMGY(sujet).Phasic.Classique.ProfilMoyenSeRassoir(:,i1);

    DPD_seLever_mean(:,sujet) = Donnees_EMGY(sujet).Phasic.Classique.ProfilMoyenSeLever(:,i2);
    DPD_seRassoir_mean(:,sujet) = Donnees_EMGY(sujet).Phasic.Classique.ProfilMoyenSeRassoir(:,i2);

end

% VLG_seLever_mean(:,13)=[];VLG_seRassoir_mean(:,13)=[];
% VLG_seLever_mean(:,6)=[];VLG_seRassoir_mean(:,6)=[];
% ESL1D_seLever_mean(:,6)=[];ESL1D_seRassoir_mean(:,6)=[];
% ESL1G_seLever_mean(:,3:7)=[];ESL1G_seRassoir_mean(:,3:7)=[];
% ESL1G_seLever_mean(:,1)=[];ESL1G_seRassoir_mean(:,1)=[];
for a=1:1000
    % Se lever
    DAD_seLever_mean_mean(a,1) = mean(DAD_seLever_mean(a,:));
    DAD_seLever_mean_mean(a,2) = mean(DAD_seLever_mean(a,:))+std(DAD_seLever_mean(a,:))/sqrt(Nb_Young-1);
    DAD_seLever_mean_mean(a,3) = mean(DAD_seLever_mean(a,:))-std(DAD_seLever_mean(a,:))/sqrt(Nb_Young-1);

    DPD_seLever_mean_mean(a,1) = mean(DPD_seLever_mean(a,:));
    DPD_seLever_mean_mean(a,2) = mean(DPD_seLever_mean(a,:))+std(DPD_seLever_mean(a,:))/sqrt(Nb_Young-1);
    DPD_seLever_mean_mean(a,3) = mean(DPD_seLever_mean(a,:))-std(DPD_seLever_mean(a,:))/sqrt(Nb_Young-1);


    % Se rassoir
    DAD_seRassoir_mean_mean(a,1) = mean(DAD_seRassoir_mean(a,:));
    DAD_seRassoir_mean_mean(a,2) = mean(DAD_seRassoir_mean(a,:))+std(DAD_seRassoir_mean(a,:))/sqrt(Nb_Young-1);
    DAD_seRassoir_mean_mean(a,3) = mean(DAD_seRassoir_mean(a,:))-std(DAD_seRassoir_mean(a,:))/sqrt(Nb_Young-1);

    DPD_seRassoir_mean_mean(a,1) = mean(DPD_seRassoir_mean(a,:));
    DPD_seRassoir_mean_mean(a,2) = mean(DPD_seRassoir_mean(a,:))+std(DPD_seRassoir_mean(a,:))/sqrt(Nb_Young-1);
    DPD_seRassoir_mean_mean(a,3) = mean(DPD_seRassoir_mean(a,:))-std(DPD_seRassoir_mean(a,:))/sqrt(Nb_Young-1);


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% OLD
% for sujet=1:Nb_OLD
%     VLD_seLever_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeLever(:,i1);
%     VLD_seRassoir_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeRassoir(:,i1);
% 
%     VLG_seLever_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeLever(:,i2);
%     VLG_seRassoir_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeRassoir(:,i2);
% 
%     ESL1D_seLever_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeLever(:,i3);
%     ESL1D_seRassoir_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeRassoir(:,i3);
% 
%     ESL1G_seLever_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeLever(:,i4);
%     ESL1G_seRassoir_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeRassoir(:,i4);
% 
% end
% VLD_seLever_OLD_mean(:,11)=[];VLD_seRassoir_OLD_mean(:,11)=[];
% VLG_seLever_OLD_mean(:,11)=[];VLG_seRassoir_OLD_mean(:,11)=[];
% VLG_seLever_OLD_mean(:,9)=[];VLG_seRassoir_OLD_mean(:,9)=[];
% ESL1D_seLever_OLD_mean(:,12)=[];ESL1D_seRassoir_OLD_mean(:,12)=[];
% 
% for a=1:1000
%     % Se lever
%     VLD_seLever_OLD_mean_mean(a,1) = mean(VLD_seLever_OLD_mean(a,:));
%     VLD_seLever_OLD_mean_mean(a,2) = mean(VLD_seLever_OLD_mean(a,:))+std(VLD_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-3);
%     VLD_seLever_OLD_mean_mean(a,3) = mean(VLD_seLever_OLD_mean(a,:))-std(VLD_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-3);
% 
%     VLG_seLever_OLD_mean_mean(a,1) = mean(VLG_seLever_OLD_mean(a,:));
%     VLG_seLever_OLD_mean_mean(a,2) = mean(VLG_seLever_OLD_mean(a,:))+std(VLG_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-5);
%     VLG_seLever_OLD_mean_mean(a,3) = mean(VLG_seLever_OLD_mean(a,:))-std(VLG_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-5);
% 
%     ESL1D_seLever_OLD_mean_mean(a,1) = mean(ESL1D_seLever_OLD_mean(a,:));
%     ESL1D_seLever_OLD_mean_mean(a,2) = mean(ESL1D_seLever_OLD_mean(a,:))+std(ESL1D_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-4);
%     ESL1D_seLever_OLD_mean_mean(a,3) = mean(ESL1D_seLever_OLD_mean(a,:))-std(ESL1D_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-4);
% 
%     ESL1G_seLever_OLD_mean_mean(a,1) = mean(ESL1G_seLever_OLD_mean(a,:));
%     ESL1G_seLever_OLD_mean_mean(a,2) = mean(ESL1G_seLever_OLD_mean(a,:))+std(ESL1G_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-4);
%     ESL1G_seLever_OLD_mean_mean(a,3) = mean(ESL1G_seLever_OLD_mean(a,:))-std(ESL1G_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-4);
% 
%     % Se rassoir
%     VLD_seRassoir_OLD_mean_mean(a,1) = mean(VLD_seRassoir_OLD_mean(a,:));
%     VLD_seRassoir_OLD_mean_mean(a,2) = mean(VLD_seRassoir_OLD_mean(a,:))+std(VLD_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-3);
%     VLD_seRassoir_OLD_mean_mean(a,3) = mean(VLD_seRassoir_OLD_mean(a,:))-std(VLD_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-3);
% 
%     VLG_seRassoir_OLD_mean_mean(a,1) = mean(VLG_seRassoir_OLD_mean(a,:));
%     VLG_seRassoir_OLD_mean_mean(a,2) = mean(VLG_seRassoir_OLD_mean(a,:))+std(VLG_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-5);
%     VLG_seRassoir_OLD_mean_mean(a,3) = mean(VLG_seRassoir_OLD_mean(a,:))-std(VLG_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-5);
% 
%     ESL1D_seRassoir_OLD_mean_mean(a,1) = mean(ESL1D_seRassoir_OLD_mean(a,:));
%     ESL1D_seRassoir_OLD_mean_mean(a,2) = mean(ESL1D_seRassoir_OLD_mean(a,:))+std(ESL1D_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-4);
%     ESL1D_seRassoir_OLD_mean_mean(a,3) = mean(ESL1D_seRassoir_OLD_mean(a,:))-std(ESL1D_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-4);
% 
%     ESL1G_seRassoir_OLD_mean_mean(a,1) = mean(ESL1G_seRassoir_OLD_mean(a,:));
%     ESL1G_seRassoir_OLD_mean_mean(a,2) = mean(ESL1G_seRassoir_OLD_mean(a,:))+std(ESL1G_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-4);
%     ESL1G_seRassoir_OLD_mean_mean(a,3) = mean(ESL1G_seRassoir_OLD_mean(a,:))-std(ESL1G_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-4);
% 
% end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Plot 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YY = length(Donnees_EMG)-2;
YYy = length(Donnees_EMGY)-2;



for f=1:1000
    g(f,:)=f;
end

% PLOT EMG PHASIC 
Titre = append('MOUVEMENT BRAS DROIT');
%set(gcf,'position',[200,200,1400,600])
f = figure('units','normalized','outerposition',[0 0 1 1]);
t = tiledlayout(2,2,'TileSpacing','Compact');

%% LE 1er MUSCLE
nexttile % JEUNE SE LEVER
plot(DAD_seLever_mean_mean(:,2),'color',color0Y); axis([0 1000 -1 1]);hold on; 
plot(DAD_seLever_mean_mean(:,3),'color',color0Y); hold on;
patch([g(:); flipud(g(:))],[DAD_seLever_mean_mean(:,2); flipud(DAD_seLever_mean_mean(:,3))],color0Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(DAD_seLever_mean_mean(:,1),'k');title(append(title_add,title1))

nexttile % JEUNE SE RASSOIR
plot(DAD_seRassoir_mean_mean(:,2),'color',color1Y);axis([0 1000 -1 1]); hold on;
plot(DAD_seRassoir_mean_mean(:,3),'color',color1Y); hold on;
patch([g(:); flipud(g(:))],[DAD_seRassoir_mean_mean(:,2); flipud(DAD_seRassoir_mean_mean(:,3))],color1Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(DAD_seRassoir_mean_mean(:,1),'k'); title(append(title_add2,title1))

% nexttile % AGE SE LEVER 
% plot(VLD_seLever_OLD_mean_mean(:,2),'color',color0);axis([0 1000 -1 1]); hold on; 
% plot(VLD_seLever_OLD_mean_mean(:,3),'color',color0); hold on;
% patch([g(:); flipud(g(:))],[VLD_seLever_OLD_mean_mean(:,2); flipud(VLD_seLever_OLD_mean_mean(:,3))],color0, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
% r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
% plot(VLD_seLever_OLD_mean_mean(:,1),'k');title(append(title_add,title1))
% 
% nexttile % AGE SE RASSOIR
% plot(VLD_seRassoir_OLD_mean_mean(:,2),'color',color1);axis([0 1000 -1 1]); hold on;
% plot(VLD_seRassoir_OLD_mean_mean(:,3),'color',color1); hold on;
% patch([g(:); flipud(g(:))],[VLD_seRassoir_OLD_mean_mean(:,2); flipud(VLD_seRassoir_OLD_mean_mean(:,3))],color1, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
% r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
% plot(VLD_seRassoir_OLD_mean_mean(:,1),'k'); title(append(title_add2,title1))
% 


%% LE 2eme MUSCLE
nexttile % JEUNE SE LEVER
plot(DPD_seLever_mean_mean(:,2),'color',color0Y); axis([0 1000 -1 1]);hold on; 
plot(DPD_seLever_mean_mean(:,3),'color',color0Y); hold on;
patch([g(:); flipud(g(:))],[DPD_seLever_mean_mean(:,2); flipud(DPD_seLever_mean_mean(:,3))],color0Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(DPD_seLever_mean_mean(:,1),'k');title(append(title_add,title2))

nexttile % JEUNE SE RASSOIR
plot(DPD_seRassoir_mean_mean(:,2),'color',color1Y);axis([0 1000 -1 1]); hold on;
plot(DPD_seRassoir_mean_mean(:,3),'color',color1Y); hold on;
patch([g(:); flipud(g(:))],[DPD_seRassoir_mean_mean(:,2); flipud(DPD_seRassoir_mean_mean(:,3))],color1Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(DPD_seRassoir_mean_mean(:,1),'k'); title(append(title_add2,title2))

% nexttile % AGE SE LEVER 
% plot(VLG_seLever_OLD_mean_mean(:,2),'color',color0);axis([0 1000 -1 1]); hold on; 
% plot(VLG_seLever_OLD_mean_mean(:,3),'color',color0); hold on;
% patch([g(:); flipud(g(:))],[VLG_seLever_OLD_mean_mean(:,2); flipud(VLG_seLever_OLD_mean_mean(:,3))],color0, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
% r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
% plot(VLG_seLever_OLD_mean_mean(:,1),'k');title(append(title_add,title2))
% 
% nexttile % AGE SE RASSOIR
% plot(VLG_seRassoir_OLD_mean_mean(:,2),'color',color1);axis([0 1000 -1 1]); hold on;
% plot(VLG_seRassoir_OLD_mean_mean(:,3),'color',color1); hold on;
% patch([g(:); flipud(g(:))],[VLG_seRassoir_OLD_mean_mean(:,2); flipud(VLG_seRassoir_OLD_mean_mean(:,3))],color1, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
% r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
% plot(VLG_seRassoir_OLD_mean_mean(:,1),'k'); title(append(title_add2,title2))




title(t,title_mvt)
xlabel(t,'Normalized time')
ylabel(t,'Integrated EMG')
% saveas(gcf,path,'png');

    end
end





%%
%%
%%
%%



newcolors = [
230/255 25/255 75/255
60/255 180/255 75/255
255/255 225/255 25/255
0 130/255 200/255
245/255 130/255 48/255
145/255 30/255 180/255
70/255 240/255 240/255
240/255 50/255 230/255
210/255 245/255 60/255
250/255 190/255 212/255 
0/255 128/255 128/255 
220/255 190/255 255/255 
170/255 110/255 40/255 
255/255 250/255 200/255 
128/255 0/255 0
0 0 0
170/255 255/255 195/255 
128/255 128/255 0
255/255 215/255 180/255 
0/255 0/255 128/255 
128/255 128/255 128/255 
255/255 255/255 255/255];




%% PLOT CONSTRUCTION PHASIC DA
for SUJET=4:4

    Titre = append('MOUVEMENT ASSIS/DEBOUT');
            %set(gcf,'position',[200,200,1400,600])
            f = figure('units','normalized','outerposition',[0 0 1 1]);
            t = tiledlayout(4,2,'TileSpacing','Compact');
    
    nexttile     
    colororder(newcolors)
    plot(DonneesToExport.EMG(SUJET).RMSCutNorm(:,1:12)) % Aller
    ylabel('RMS CUTNORM RAP','fontweight','bold','fontsize',11)
    nexttile
    colororder(newcolors)
    plot(DonneesToExport.EMG(SUJET).RMSCutNorm(:,193:204)) % Retour
    nexttile
    colororder(newcolors)
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNorm(:,1:6)) % Aller
    ylabel('RMS CUTNORM TONIC','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNorm(:,97:102)) % Retour

    nexttile
    colororder(newcolors)
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNormProfilMoyen.Se_lever(:,1:3)) % Aller
    ylabel('TONIC moy+/-err std','fontweight','bold','fontsize',11)
    nexttile
    colororder(newcolors)
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNormProfilMoyen.Se_rassoir(:,1:3)) % Retour
    nexttile
    colororder(newcolors)
    plot(DonneesToExport.EMG(SUJET).Phasic.Classique.Se_lever(:,1:6));hold on; % Aller
    r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');
    ylabel('PHASIC','fontweight','bold','fontsize',11)
    legend
    nexttile
    colororder(newcolors)
    plot(DonneesToExport.EMG(SUJET).Phasic.Classique.Se_rassoir(:,1:6));hold on; % Retour
    legend
    r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');
    title(t,'SE PENCHER                                                                                                      SE REDRESSER','fontweight','bold','fontsize',16)
    
%       saveas(gcf,append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Réunion 15\Images\Sujet',string(SUJET)),'png');
end



%% PLOT CONSTRUCTION PHASIC DP
for SUJET=1:19

    Titre = append('MOUVEMENT ASSIS/DEBOUT');
            %set(gcf,'position',[200,200,1400,600])
            f = figure('units','normalized','outerposition',[0 0 1 1]);
            t = tiledlayout(4,2,'TileSpacing','Compact');
    
    nexttile     
    colororder(newcolors)
    plot(DonneesToExport.EMG(SUJET).RMSCutNorm(:,13:24)) % Aller
    ylabel('RMS CUTNORM RAP','fontweight','bold','fontsize',11)
    nexttile
    colororder(newcolors)
    plot(DonneesToExport.EMG(SUJET).RMSCutNorm(:,205:215)) % Retour
    nexttile
    colororder(newcolors)
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNorm(:,7:12)) % Aller
    ylabel('RMS CUTNORM TONIC','fontweight','bold','fontsize',11)
    nexttile
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNorm(:,103:108)) % Retour

    nexttile
    colororder(newcolors)
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNormProfilMoyen.Se_lever(:,5:7)) % Aller
    ylabel('TONIC moy+/-err std','fontweight','bold','fontsize',11)
    nexttile
    colororder(newcolors)
    plot(DonneesToExport.EMG_TL(SUJET).RMSCutNormProfilMoyen.Se_rassoir(:,5:7)) % Retour
    nexttile
    colororder(newcolors)
    plot(DonneesToExport.EMG(SUJET).Phasic.Classique.Se_lever(:,7:12));hold on; % Aller
    r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');
    ylabel('PHASIC','fontweight','bold','fontsize',11)
    legend
    nexttile
    colororder(newcolors)
    plot(DonneesToExport.EMG(SUJET).Phasic.Classique.Se_rassoir(:,7:12));hold on; % Retour
    legend
    r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'green');
    title(t,'SE PENCHER                                                                                                      SE REDRESSER','fontweight','bold','fontsize',16)
    
%       saveas(gcf,append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Réunion 15\Images\Sujet',string(SUJET)),'png');
end














