
close all
clear all
Nb_Young = 20
Nb_OLD = 24

for mvt = 2:2
    for muscles = 1:1

        switch mvt
        case 1
            file = 'D:\DATA MANIP 1\DONNES EMG\ASSIS\Donnees_saved_Old.mat'; title_mvt = 'YOUNG                                                               STS / BTS movement                                                                      OLD';
            fileY = 'D:\DATA MANIP 1\DONNES EMG\ASSIS\Donnees_saved_Young.mat'; 
%             file = 'C:\Users\robin\Desktop\DONNES EMG\ASSIS\Donnees_saved_Old.mat'; title_mvt = 'OLD                                                                      STS / BTS movement                                                                      OLD';
%             fileY = 'C:\Users\robin\Desktop\DONNES EMG\ASSIS\Donnees_saved_Young.mat'; 
            title_add= 'STS _ '; title_add2= 'BTS _ ';
            path = append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Réunion 6','\');
%             path = append('C:\Users\robin\Desktop\Drive google\6A - THESE\MANIP 1\Resultats\Stats\Réunion 3\Graphs\ASSIS','\');
       
        case 2
            file = 'D:\DATA MANIP 1\DONNES EMG\R1\Donnees_saved_Old.mat'; title_mvt = 'YOUNG                                                                      Short distance reach movement                                                                      OLD';
            fileY = 'D:\DATA MANIP 1\DONNES EMG\R1\Donnees_saved_Young.mat'; 
            title_add= 'Bending _ '; title_add2= 'Bounce back _ ';
            path = append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Stats\Réunion 3\Graphs\REACH1','\');
        case 3
            
            file = 'D:\DATA MANIP 1\DONNES EMG\R2\Donnees_saved_Old.mat'; title_mvt = 'YOUNG                                                                      Long distance reach movement                                                                      OLD';
            fileY = 'D:\DATA MANIP 1\DONNES EMG\R2\Donnees_saved_Young.mat'; 
            title_add= 'Bending _ '; title_add2= 'Bounce back _ ';
            path = append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Stats\Réunion 3\Graphs\REACH2','\');
            
        end
color0=[28/255,156/255,67/255]; % Pour la couleur du premier mvt des âgés
color1=[65/255,211/255,183/255]; % Pour la couleur du second mvt des âgés
color0Y=[217/255,95/255,2/255]; % Pour la couleur du premier mvt des jeunes
color1Y=[233/255,148/255,63/255]; % Pour la couleur du second mvt des jeunes


color5=[80/255,121/255,63/255]; % Pour la couleur de la ligne en y=0
load(file);
Donnees_EMG = DonneesToExport.EMG;
load(fileY);
Donnees_EMGY = DonneesToExport.EMG;

switch muscles
%% CHOIX DES MUSCLES
    case 1
        %% POUR LES MUSCLES des cuisses
            i1=13; title1 = ' Right Vastuls Lateralis'; 
            i2=19; title2 = ' Left Vastuls Lateralis';
            i3=25; title3 = ' Right Erector L1';
            i4=31; title4 = ' Left Erector L1';
            path = append(path,'Cuisses');
             
    % 
    %% POUR LES MUSCLES DES DOS
    case 2

        i1=25; title1 = ' Right Erector L1';
        i2=28; title2 = ' Right Erector D7';
        i3=31; title3 = ' Left Erector L1';
        i4=34; title4 = ' Left Erector D7';
        path = append(path,'Dos');
    % 
    %% POUR LES MUSCLES DU BRAS
    case 3
        i1=1; title1 = ' Right Antérior Deltoïde';
        i2=4; title2 = ' Right Posterior Deltoïde';
        i3=7; title3 = ' Left Antérior Deltoïde';
        i4=10; title4 = ' Left Posterior Deltoïde';
        path = append(path,'Bras');
    
    %% POUR LES MUSCLES DES JAMBES
    case 4
        i1=37; title1 = ' Right Tibialis Anterior';
        i2=40; title2 = ' Right Soleus';
        i3=43; title3 = ' Left Tibialis Anterior';
        i4=46; title4 = ' Left Soleus';
        path = append(path,'Jambes');
end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Mean + Erreur stand
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% YOUNG
for sujet=1:Nb_Young
    VLD_seLever_mean(:,sujet) = Donnees_EMGY(sujet).Phasic.Classique.ProfilMoyenSeLever(:,i1);
    VLD_seRassoir_mean(:,sujet) = Donnees_EMGY(sujet).Phasic.Classique.ProfilMoyenSeRassoir(:,i1);

    VLG_seLever_mean(:,sujet) = Donnees_EMGY(sujet).Phasic.Classique.ProfilMoyenSeLever(:,i2);
    VLG_seRassoir_mean(:,sujet) = Donnees_EMGY(sujet).Phasic.Classique.ProfilMoyenSeRassoir(:,i2);

    ESL1D_seLever_mean(:,sujet) = Donnees_EMGY(sujet).Phasic.Classique.ProfilMoyenSeLever(:,i3);
    ESL1D_seRassoir_mean(:,sujet) = Donnees_EMGY(sujet).Phasic.Classique.ProfilMoyenSeRassoir(:,i3);

    ESL1G_seLever_mean(:,sujet) = Donnees_EMGY(sujet).Phasic.Classique.ProfilMoyenSeLever(:,i4);
    ESL1G_seRassoir_mean(:,sujet) = Donnees_EMGY(sujet).Phasic.Classique.ProfilMoyenSeRassoir(:,i4);

end
VLG_seLever_mean(:,13)=[];VLG_seRassoir_mean(:,13)=[];
ESL1D_seLever_mean(:,17)=[];ESL1D_seRassoir_mean(:,17)=[];
ESL1G_seLever_mean(:,[1,3:7,17])=[];ESL1G_seRassoir_mean(:,[1,3:7,17])=[];
for a=1:1000
    % Se lever
    VLD_seLever_mean_mean(a,1) = mean(VLD_seLever_mean(a,:));
    VLD_seLever_mean_mean(a,2) = mean(VLD_seLever_mean(a,:))+std(VLD_seLever_mean(a,:))/sqrt(Nb_Young-1);
    VLD_seLever_mean_mean(a,3) = mean(VLD_seLever_mean(a,:))-std(VLD_seLever_mean(a,:))/sqrt(Nb_Young-1);

    VLG_seLever_mean_mean(a,1) = mean(VLG_seLever_mean(a,:));
    VLG_seLever_mean_mean(a,2) = mean(VLG_seLever_mean(a,:))+std(VLG_seLever_mean(a,:))/sqrt(Nb_Young-2);
    VLG_seLever_mean_mean(a,3) = mean(VLG_seLever_mean(a,:))-std(VLG_seLever_mean(a,:))/sqrt(Nb_Young-2);

    ESL1D_seLever_mean_mean(a,1) = mean(ESL1D_seLever_mean(a,:));
    ESL1D_seLever_mean_mean(a,2) = mean(ESL1D_seLever_mean(a,:))+std(ESL1D_seLever_mean(a,:))/sqrt(Nb_Young-2);
    ESL1D_seLever_mean_mean(a,3) = mean(ESL1D_seLever_mean(a,:))-std(ESL1D_seLever_mean(a,:))/sqrt(Nb_Young-2);

    ESL1G_seLever_mean_mean(a,1) = mean(ESL1G_seLever_mean(a,:));
    ESL1G_seLever_mean_mean(a,2) = mean(ESL1G_seLever_mean(a,:))+std(ESL1G_seLever_mean(a,:))/sqrt(Nb_Young-8);
    ESL1G_seLever_mean_mean(a,3) = mean(ESL1G_seLever_mean(a,:))-std(ESL1G_seLever_mean(a,:))/sqrt(Nb_Young-8);

    % Se rassoir
    VLD_seRassoir_mean_mean(a,1) = mean(VLD_seRassoir_mean(a,:));
    VLD_seRassoir_mean_mean(a,2) = mean(VLD_seRassoir_mean(a,:))+std(VLD_seRassoir_mean(a,:))/sqrt(Nb_Young-1);
    VLD_seRassoir_mean_mean(a,3) = mean(VLD_seRassoir_mean(a,:))-std(VLD_seRassoir_mean(a,:))/sqrt(Nb_Young-1);

    VLG_seRassoir_mean_mean(a,1) = mean(VLG_seRassoir_mean(a,:));
    VLG_seRassoir_mean_mean(a,2) = mean(VLG_seRassoir_mean(a,:))+std(VLG_seRassoir_mean(a,:))/sqrt(Nb_Young-2);
    VLG_seRassoir_mean_mean(a,3) = mean(VLG_seRassoir_mean(a,:))-std(VLG_seRassoir_mean(a,:))/sqrt(Nb_Young-2);

    ESL1D_seRassoir_mean_mean(a,1) = mean(ESL1D_seRassoir_mean(a,:));
    ESL1D_seRassoir_mean_mean(a,2) = mean(ESL1D_seRassoir_mean(a,:))+std(ESL1D_seRassoir_mean(a,:))/sqrt(Nb_Young-2);
    ESL1D_seRassoir_mean_mean(a,3) = mean(ESL1D_seRassoir_mean(a,:))-std(ESL1D_seRassoir_mean(a,:))/sqrt(Nb_Young-2);

    ESL1G_seRassoir_mean_mean(a,1) = mean(ESL1G_seRassoir_mean(a,:));
    ESL1G_seRassoir_mean_mean(a,2) = mean(ESL1G_seRassoir_mean(a,:))+std(ESL1G_seRassoir_mean(a,:))/sqrt(Nb_Young-8);
    ESL1G_seRassoir_mean_mean(a,3) = mean(ESL1G_seRassoir_mean(a,:))-std(ESL1G_seRassoir_mean(a,:))/sqrt(Nb_Young-8);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OLD
for sujet=1:Nb_OLD
    VLD_seLever_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeLever(:,i1);
    VLD_seRassoir_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeRassoir(:,i1);

    VLG_seLever_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeLever(:,i2);
    VLG_seRassoir_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeRassoir(:,i2);

    ESL1D_seLever_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeLever(:,i3);
    ESL1D_seRassoir_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeRassoir(:,i3);

    ESL1G_seLever_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeLever(:,i4);
    ESL1G_seRassoir_OLD_mean(:,sujet) = Donnees_EMG(sujet).Phasic.Classique.ProfilMoyenSeRassoir(:,i4);

end
VLD_seLever_OLD_mean(:,[5,11])=[];VLD_seRassoir_OLD_mean(:,[5,11])=[];
VLG_seLever_OLD_mean(:,[9:11,13,18])=[];VLG_seRassoir_OLD_mean(:,[9:11,13,18])=[];
ESL1D_seLever_OLD_mean(:,[6,12])=[];ESL1D_seRassoir_OLD_mean(:,[6,12])=[];
ESL1G_seLever_OLD_mean(:,[4,6])=[];ESL1G_seRassoir_OLD_mean(:,[4,6])=[];

for a=1:1000
    % Se lever
    VLD_seLever_OLD_mean_mean(a,1) = mean(VLD_seLever_OLD_mean(a,:));
    VLD_seLever_OLD_mean_mean(a,2) = mean(VLD_seLever_OLD_mean(a,:))+std(VLD_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-3);
    VLD_seLever_OLD_mean_mean(a,3) = mean(VLD_seLever_OLD_mean(a,:))-std(VLD_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-3);

    VLG_seLever_OLD_mean_mean(a,1) = mean(VLG_seLever_OLD_mean(a,:));
    VLG_seLever_OLD_mean_mean(a,2) = mean(VLG_seLever_OLD_mean(a,:))+std(VLG_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-6);
    VLG_seLever_OLD_mean_mean(a,3) = mean(VLG_seLever_OLD_mean(a,:))-std(VLG_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-6);

    ESL1D_seLever_OLD_mean_mean(a,1) = mean(ESL1D_seLever_OLD_mean(a,:));
    ESL1D_seLever_OLD_mean_mean(a,2) = mean(ESL1D_seLever_OLD_mean(a,:))+std(ESL1D_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-3);
    ESL1D_seLever_OLD_mean_mean(a,3) = mean(ESL1D_seLever_OLD_mean(a,:))-std(ESL1D_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-3);

    ESL1G_seLever_OLD_mean_mean(a,1) = mean(ESL1G_seLever_OLD_mean(a,:));
    ESL1G_seLever_OLD_mean_mean(a,2) = mean(ESL1G_seLever_OLD_mean(a,:))+std(ESL1G_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-3);
    ESL1G_seLever_OLD_mean_mean(a,3) = mean(ESL1G_seLever_OLD_mean(a,:))-std(ESL1G_seLever_OLD_mean(a,:))/sqrt(Nb_OLD-3);

    % Se rassoir
    VLD_seRassoir_OLD_mean_mean(a,1) = mean(VLD_seRassoir_OLD_mean(a,:));
    VLD_seRassoir_OLD_mean_mean(a,2) = mean(VLD_seRassoir_OLD_mean(a,:))+std(VLD_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-3);
    VLD_seRassoir_OLD_mean_mean(a,3) = mean(VLD_seRassoir_OLD_mean(a,:))-std(VLD_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-3);

    VLG_seRassoir_OLD_mean_mean(a,1) = mean(VLG_seRassoir_OLD_mean(a,:));
    VLG_seRassoir_OLD_mean_mean(a,2) = mean(VLG_seRassoir_OLD_mean(a,:))+std(VLG_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-6);
    VLG_seRassoir_OLD_mean_mean(a,3) = mean(VLG_seRassoir_OLD_mean(a,:))-std(VLG_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-6);

    ESL1D_seRassoir_OLD_mean_mean(a,1) = mean(ESL1D_seRassoir_OLD_mean(a,:));
    ESL1D_seRassoir_OLD_mean_mean(a,2) = mean(ESL1D_seRassoir_OLD_mean(a,:))+std(ESL1D_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-3);
    ESL1D_seRassoir_OLD_mean_mean(a,3) = mean(ESL1D_seRassoir_OLD_mean(a,:))-std(ESL1D_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-3);

    ESL1G_seRassoir_OLD_mean_mean(a,1) = mean(ESL1G_seRassoir_OLD_mean(a,:));
    ESL1G_seRassoir_OLD_mean_mean(a,2) = mean(ESL1G_seRassoir_OLD_mean(a,:))+std(ESL1G_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-3);
    ESL1G_seRassoir_OLD_mean_mean(a,3) = mean(ESL1G_seRassoir_OLD_mean(a,:))-std(ESL1G_seRassoir_OLD_mean(a,:))/sqrt(Nb_OLD-3);

end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Plot 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
YY = length(Donnees_EMG)-2;
YYy = length(Donnees_EMGY)-2;


% % Enregistrement des quantifs par mouvements 
% Quantif.Young(mvt).SAVED = Donnees_EMGY(YYy+1).Phasic.MoyenneQuantif; 
% Quantif.Old(mvt).SAVED  = Donnees_EMG(YY+1).Phasic.MoyenneQuantif;

for f=1:1000
    g(f,:)=f;
end

% PLOT EMG PHASIC 
Titre = append('MOUVEMENT ASSIS/DEBOUT');
%set(gcf,'position',[200,200,1400,600])
f = figure('units','normalized','outerposition',[0 0 1 1]);
t = tiledlayout(4,4,'TileSpacing','Compact');

%% LE 1er MUSCLE
nexttile % JEUNE SE LEVER
plot(VLD_seLever_mean_mean(:,2),'color',color0Y); axis([0 1000 -1 1]);hold on; 
plot(VLD_seLever_mean_mean(:,3),'color',color0Y); hold on;
patch([g(:); flipud(g(:))],[VLD_seLever_mean_mean(:,2); flipud(VLD_seLever_mean_mean(:,3))],color0Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(VLD_seLever_mean_mean(:,1),'k');title(append(title_add,title1))

nexttile % JEUNE SE RASSOIR
plot(VLD_seRassoir_mean_mean(:,2),'color',color1Y);axis([0 1000 -1 1]); hold on;
plot(VLD_seRassoir_mean_mean(:,3),'color',color1Y); hold on;
patch([g(:); flipud(g(:))],[VLD_seRassoir_mean_mean(:,2); flipud(VLD_seRassoir_mean_mean(:,3))],color1Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(VLD_seRassoir_mean_mean(:,1),'k'); title(append(title_add2,title1))

nexttile % AGE SE LEVER 
plot(VLD_seLever_OLD_mean_mean(:,2),'color',color0);axis([0 1000 -1 1]); hold on; 
plot(VLD_seLever_OLD_mean_mean(:,3),'color',color0); hold on;
patch([g(:); flipud(g(:))],[VLD_seLever_OLD_mean_mean(:,2); flipud(VLD_seLever_OLD_mean_mean(:,3))],color0, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(VLD_seLever_OLD_mean_mean(:,1),'k');title(append(title_add,title1))

nexttile % AGE SE RASSOIR
plot(VLD_seRassoir_OLD_mean_mean(:,2),'color',color1);axis([0 1000 -1 1]); hold on;
plot(VLD_seRassoir_OLD_mean_mean(:,3),'color',color1); hold on;
patch([g(:); flipud(g(:))],[VLD_seRassoir_OLD_mean_mean(:,2); flipud(VLD_seRassoir_OLD_mean_mean(:,3))],color1, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(VLD_seRassoir_OLD_mean_mean(:,1),'k'); title(append(title_add2,title1))



%% LE 2eme MUSCLE
nexttile % JEUNE SE LEVER
plot(VLG_seLever_mean_mean(:,2),'color',color0Y); axis([0 1000 -1 1]);hold on; 
plot(VLG_seLever_mean_mean(:,3),'color',color0Y); hold on;
patch([g(:); flipud(g(:))],[VLG_seLever_mean_mean(:,2); flipud(VLG_seLever_mean_mean(:,3))],color0Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(VLG_seLever_mean_mean(:,1),'k');title(append(title_add,title2))

nexttile % JEUNE SE RASSOIR
plot(VLG_seRassoir_mean_mean(:,2),'color',color1Y);axis([0 1000 -1 1]); hold on;
plot(VLG_seRassoir_mean_mean(:,3),'color',color1Y); hold on;
patch([g(:); flipud(g(:))],[VLG_seRassoir_mean_mean(:,2); flipud(VLG_seRassoir_mean_mean(:,3))],color1Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(VLG_seRassoir_mean_mean(:,1),'k'); title(append(title_add2,title2))

nexttile % AGE SE LEVER 
plot(VLG_seLever_OLD_mean_mean(:,2),'color',color0);axis([0 1000 -1 1]); hold on; 
plot(VLG_seLever_OLD_mean_mean(:,3),'color',color0); hold on;
patch([g(:); flipud(g(:))],[VLG_seLever_OLD_mean_mean(:,2); flipud(VLG_seLever_OLD_mean_mean(:,3))],color0, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(VLG_seLever_OLD_mean_mean(:,1),'k');title(append(title_add,title2))

nexttile % AGE SE RASSOIR
plot(VLG_seRassoir_OLD_mean_mean(:,2),'color',color1);axis([0 1000 -1 1]); hold on;
plot(VLG_seRassoir_OLD_mean_mean(:,3),'color',color1); hold on;
patch([g(:); flipud(g(:))],[VLG_seRassoir_OLD_mean_mean(:,2); flipud(VLG_seRassoir_OLD_mean_mean(:,3))],color1, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(VLG_seRassoir_OLD_mean_mean(:,1),'k'); title(append(title_add2,title2))



%% LE 3eme MUSCLE
nexttile % JEUNE SE LEVER
plot(ESL1D_seLever_mean_mean(:,2),'color',color0Y); axis([0 1000 -1 1]);hold on; 
plot(ESL1D_seLever_mean_mean(:,3),'color',color0Y); hold on;
patch([g(:); flipud(g(:))],[ESL1D_seLever_mean_mean(:,2); flipud(ESL1D_seLever_mean_mean(:,3))],color0Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(ESL1D_seLever_mean_mean(:,1),'k');title(append(title_add,title3))

nexttile % JEUNE SE RASSOIR
plot(ESL1D_seRassoir_mean_mean(:,2),'color',color1Y);axis([0 1000 -1 1]); hold on;
plot(ESL1D_seRassoir_mean_mean(:,3),'color',color1Y); hold on;
patch([g(:); flipud(g(:))],[ESL1D_seRassoir_mean_mean(:,2); flipud(ESL1D_seRassoir_mean_mean(:,3))],color1Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(ESL1D_seRassoir_mean_mean(:,1),'k'); title(append(title_add2,title3))

nexttile % AGE SE LEVER 
plot(ESL1D_seLever_OLD_mean_mean(:,2),'color',color0);axis([0 1000 -1 1]); hold on; 
plot(ESL1D_seLever_OLD_mean_mean(:,3),'color',color0); hold on;
patch([g(:); flipud(g(:))],[ESL1D_seLever_OLD_mean_mean(:,2); flipud(ESL1D_seLever_OLD_mean_mean(:,3))],color0, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(ESL1D_seLever_OLD_mean_mean(:,1),'k');title(append(title_add,title3))

nexttile % AGE SE RASSOIR
plot(ESL1D_seRassoir_OLD_mean_mean(:,2),'color',color1);axis([0 1000 -1 1]); hold on;
plot(ESL1D_seRassoir_OLD_mean_mean(:,3),'color',color1); hold on;
patch([g(:); flipud(g(:))],[ESL1D_seRassoir_OLD_mean_mean(:,2); flipud(ESL1D_seRassoir_OLD_mean_mean(:,3))],color1, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(ESL1D_seRassoir_OLD_mean_mean(:,1),'k'); title(append(title_add2,title3))



%% LE 4eme MUSCLE
nexttile % JEUNE SE LEVER
plot(ESL1G_seLever_mean_mean(:,2),'color',color0Y); axis([0 1000 -1 1]);hold on; 
plot(ESL1G_seLever_mean_mean(:,3),'color',color0Y); hold on;
patch([g(:); flipud(g(:))],[ESL1G_seLever_mean_mean(:,2); flipud(ESL1G_seLever_mean_mean(:,3))],color0Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(ESL1G_seLever_mean_mean(:,1),'k');title(append(title_add,title4))

nexttile % JEUNE SE RASSOIR
plot(ESL1G_seRassoir_mean_mean(:,2),'color',color1Y);axis([0 1000 -1 1]); hold on;
plot(ESL1G_seRassoir_mean_mean(:,3),'color',color1Y); hold on;
patch([g(:); flipud(g(:))],[ESL1G_seRassoir_mean_mean(:,2); flipud(ESL1G_seRassoir_mean_mean(:,3))],color1Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(ESL1G_seRassoir_mean_mean(:,1),'k'); title(append(title_add2,title4))

nexttile % AGE SE LEVER 
plot(ESL1G_seLever_OLD_mean_mean(:,2),'color',color0);axis([0 1000 -1 1]); hold on; 
plot(ESL1G_seLever_OLD_mean_mean(:,3),'color',color0); hold on;
patch([g(:); flipud(g(:))],[ESL1G_seLever_OLD_mean_mean(:,2); flipud(ESL1G_seLever_OLD_mean_mean(:,3))],color0, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(ESL1G_seLever_OLD_mean_mean(:,1),'k');title(append(title_add,title4))

nexttile % AGE SE RASSOIR
plot(ESL1G_seRassoir_OLD_mean_mean(:,2),'color',color1);axis([0 1000 -1 1]); hold on;
plot(ESL1G_seRassoir_OLD_mean_mean(:,3),'color',color1); hold on;
patch([g(:); flipud(g(:))],[ESL1G_seRassoir_OLD_mean_mean(:,2); flipud(ESL1G_seRassoir_OLD_mean_mean(:,3))],color1, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(ESL1G_seRassoir_OLD_mean_mean(:,1),'k'); title(append(title_add2,title4))





title(t,title_mvt)
xlabel(t,'Normalized time')
ylabel(t,'Integrated EMG')
% saveas(gcf,path,'png');

    end
end
