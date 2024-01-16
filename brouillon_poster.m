% 
% %%%%%%% PLOTS POSTER %%%%%%%%%%%%
% % PLOT construction PHASIC 
% Titre = append('MOUVEMENT ASSIS/DEBOUT -  Muscle : ');
%                 fig = figure('Name',Titre,'NumberTitle','off');
%                 set(gcf,'position',[200,200,1050,350])
% plot(Donnees_EMG_TL.RMSCutNormProfilMoyen.Se_lever(:,37));hold on;
% plot(Donnees_EMG.RMSCutNormProfilMoyen.Se_lever(:,37))
% %plot(Donnees_EMG.Phasic.TonicLent.ProfilMoyenSeLever(:,30));hold on;
% %r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'r');
% titre = append('SE lever - ');
% 
% legend('Slow movement', 'Fast movement','Position',[0 0.5 0.1 0.3]);

% for i=1:10
%     Titre = append('sujet',string(i));
%     fig = figure('Name',Titre,'NumberTitle','off');
%     plot(Donnees_EMG(i).Phasic.Classique.ProfilMoyenSeLever(:,16:18));
% end

for mvt = 1:1
    for muscles = 1:2

    switch mvt
    case 1
        file = 'D:\DATA MANIP 1\DONNES EMG\ASSIS\Donnees_saved_Old.mat'; title_mvt = 'YOUNG                                                                      STS / BTS movement                                                                      OLD';
        fileY = 'D:\DATA MANIP 1\DONNES EMG\ASSIS\Donnees_saved_Young.mat'; 
        title_add= 'STS _ '; title_add2= 'BTS _ ';
        path = append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Stats\Réunion 2\Graphs\ASSIS','\Mean_');
    case 2
        file = 'D:\DATA MANIP 1\DONNES EMG\Reach1\Donnees_saved_Old.mat'; title_mvt = 'YOUNG                                                                      Short distance reach movement                                                                      OLD';
        fileY = 'D:\DATA MANIP 1\DONNES EMG\Reach1\Donnees_saved_Young.mat'; 
        title_add= 'Bending _ '; title_add2= 'Bounce back _ ';
        path = append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Stats\Réunion 2\Graphs\REACH1','\Mean_');
    case 3
        file = 'D:\DATA MANIP 1\DONNES EMG\Reach2\Donnees_saved_Old.mat'; title_mvt = 'YOUNG                                                                      Long distance reach movement                                                                      OLD';
        fileY = 'D:\DATA MANIP 1\DONNES EMG\Reach2\Donnees_saved_Young.mat'; 
        title_add= 'Bending _ '; title_add2= 'Bounce back _ ';
        path = append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Stats\Réunion 2\Graphs\REACH2','\Mean_');
        
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
        i2=16; title2 = ' Right Biceps Femoris';
        i3=19; title3 = ' Left Vastuls Lateralis';
        i4=22; title4 = ' Left Biceps Femoris';
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
    %% Plot 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
YY = length(Donnees_EMG)-1;
YYy = length(Donnees_EMGY)-1;


% Enregistrement des quantifs par mouvements 
Quantif.Young(mvt).SAVED = Donnees_EMGY(YYy+1).Phasic.MoyenneQuantif; 
Quantif.Old(mvt).SAVED  = Donnees_EMG(YY+1).Phasic.MoyenneQuantif;

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
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i1+1),'color',color0Y); hold on; 
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i1+2),'color',color0Y); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i1+1); flipud(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i1+2))],color0Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i1),'k');title(append(title_add,title1))

nexttile % JEUNE SE RASSOIR
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i1+1),'color',color1Y); hold on;
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i1+2),'color',color1Y); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i1+1); flipud(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i1+2))],color1Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i1),'k'); title(append(title_add2,title1))

nexttile % AGE SE LEVER 
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i1+1),'color',color0); hold on; 
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i1+2),'color',color0); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i1+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i1+2))],color0, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i1),'k');title(append(title_add,title1))

nexttile % AGE SE RASSOIR
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i1+1),'color',color1); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i1+2),'color',color1); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i1+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i1+2))],color1, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i1),'k'); title(append(title_add2,title1))



%% LE 2eme MUSCLE
nexttile % JEUNE SE LEVER
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i2+1),'color',color0Y); hold on;
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i2+2),'color',color0Y); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i2+1); flipud(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i2+2))],color0Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i2),'k'); title(append(title_add,title2))

nexttile % JEUNE SE RASSOIR
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i2+1),'color',color1Y); hold on;
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i2+2),'color',color1Y); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i2+1); flipud(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i2+2))],color1Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on; 
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i2),'k'); title(append(title_add2,title2))

nexttile  % AGE SE LEVER
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i2+1),'color',color0); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i2+2),'color',color0); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i2+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i2+2))],color0, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i2),'k'); title(append(title_add,title2))

nexttile % AGE SE RASSOIR
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i2+1),'color',color1); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i2+2),'color',color1); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i2+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i2+2))],color1, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on; 
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i2),'k'); title(append(title_add2,title2))



%% LE 3eme MUSCLE
nexttile % JEUNE SE LEVER
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i3+1),'color',color0Y); hold on;
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i3+2),'color',color0Y); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i3+1); flipud(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i3+2))],color0Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i3),'k'); title(append(title_add,title3))

nexttile % JEUNE SE RASSOIR
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i3+1),'color',color1Y); hold on;
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i3+2),'color',color1Y); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i3+1); flipud(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i3+2))],color1Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on; 
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i3),'k'); title(append(title_add2,title3))

nexttile % AGE SE LEVER
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i3+1),'color',color0); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i3+2),'color',color0); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i3+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i3+2))],color0, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i3),'k'); title(append(title_add,title3))

nexttile % AGE SE RASSOIR
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i3+1),'color',color1); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i3+2),'color',color1); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i3+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i3+2))],color1, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on; 
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i3),'k'); title(append(title_add2,title3))



%% LE 4eme MUSCLE
nexttile % JEUNE SE LEVER
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i4+1),'color',color0Y); hold on;
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i4+2),'color',color0Y); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i4+1); flipud(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i4+2))],color0Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeLever(:,i4),'k'); title(append(title_add,title4))
 
nexttile % JEUNE SE RASSOIR
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i4+1),'color',color1Y); hold on;
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i4+2),'color',color1Y); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i4+1); flipud(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i4+2))],color1Y, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMGY(YYy+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i4),'k'); title(append(title_add2,title4))

nexttile % AGE SE LEVER
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i4+1),'color',color0); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i4+2),'color',color0); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i4+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i4+2))],color0, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i4),'k'); title(append(title_add,title4))

nexttile % AGE SE RASSOIR
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i4+1),'color',color1); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i4+2),'color',color1); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i4+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i4+2))],color1, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i4),'k'); title(append(title_add2,title4))





title(t,title_mvt)
xlabel(t,'Normalized time')
ylabel(t,'Integrated EMG (mV)')
% saveas(gcf,path,'png');

    end

% for i=1:length(Donnees_EMG(YY+1).Phasic.MoyenneQuantif)/4
%    Donnees_EMG(YY+1).Phasic.MoyenneQuantif(:,i*4-3) = [];
%    Donnees_EMG(YY+1).Phasic.MoyenneQuantif(:,i*4-2) = [];
%    disp(append('First ', string(i*4-3)));
%    disp(append('Second ', string(i*4-2)));
% end
% for i=1:length(Donnees_EMGY(YYy+1).Phasic.MoyenneQuantif)/4
%    Donnees_EMGY(YYy+1).Phasic.MoyenneQuantif(:,i*4-3) = [];
%    Donnees_EMGY(YYy+1).Phasic.MoyenneQuantif(:,i*4-2) = [];
%    disp(append('First ', string(i*4-3)));
%    disp(append('Second ', string(i*4-2)));
% end
% 
% Donnees_EMGY(YYy+1).Phasic.MoyenneQuantif( :,  A(:,6) > B ) = [];


%     switch mvt
%     case 1
%         M = Donnees_EMGY(YYy+1).Phasic.MoyenneQuantif; 
%         writematrix(M,'G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Stats\Réunion 2\STS.csv')
%     case 2
%         M = Donnees_EMGY(YYy+1).Phasic.MoyenneQuantif; 
%         writematrix(M,'G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Stats\Réunion 2\R1.csv')
%     case 3
%        M = Donnees_EMGY(YYy+1).Phasic.MoyenneQuantif; 
%         writematrix(M,'G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Stats\Réunion 2\R2.csv')
%     end
end




