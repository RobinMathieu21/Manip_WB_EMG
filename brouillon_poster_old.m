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

old = true;
mvt = 2; % 1 pour STS/BTS, 2 pour Reach1 et 3 pour Reach2
if old == true
    switch mvt
    case 1
        file = 'D:\DATA MANIP 1\DONNES EMG\ASSIS\Donnees_saved_Old.mat';
    case 2
        file = 'D:\DATA MANIP 1\DONNES EMG\Reach1\Donnees_saved_Old.mat';
    case 3
        file = 'D:\DATA MANIP 1\DONNES EMG\Reach2\Donnees_saved_Old.mat';
        
    end
    color0=[28/255,156/255,67/255]; % Pour la couleur du premier mvt des âgés
    color1=[65/255,211/255,183/255]; % Pour la couleur du second mvt des âgés
else
    switch mvt
    case 1
        file = 'D:\DATA MANIP 1\DONNES EMG\ASSIS\Donnees_saved_Young.mat';
    case 2
        file = 'D:\DATA MANIP 1\DONNES EMG\Reach1\Donnees_saved_Young.mat';
    case 3
        file = 'D:\DATA MANIP 1\DONNES EMG\Reach2\Donnees_saved_Young.mat';
    end
    color0=[217/255,95/255,2/255]; % Pour la couleur du premier mvt des jeunes
    color1=[233/255,148/255,63/255]; % Pour la couleur du second mvt des jeunes
end

color5=[80/255,121/255,63/255]; % Pour la couleur de la ligne en y=0
load(file);
Donnees_EMG = DonneesToExport.EMG;

%% CHOIX DES MUSCLES
% POUR LES MUSCLES des cuisses
i1=13;
i2=16;
i3=19;
i4=22;
i5=22;
% %% POUR LES MUSCLES DES BRAS
% i1=1;
% i2=4;
% i3=7;
% i4=10;
% i5=10;
% %% POUR LES MUSCLES DU DOS
% i1=25;
% i2=28;
% i3=31;
% i4=34;
% i5=34;
% %% POUR LES MUSCLES DES JAMBES
% i1=37;
% i2=40;
% i3=43;
% i4=46;
% i5=46;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
YY = length(Donnees_EMG)-1;
xlabel('Normalized time') 
ylabel('Integrated EMG (mV)') 

for f=1:1000
    g(f,:)=f;
end

% PLOT EMG PHASIC 
Titre = append('MOUVEMENT ASSIS/DEBOUT');
%set(gcf,'position',[200,200,1400,600])
f = figure('units','normalized','outerposition',[0 0 1 1]);
t.TileSpacing = 'compact';

subplot(10,4,1) 
nexttile
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i1+1),'color',color0); hold on; 
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i1+2),'color',color0); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i1+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i1+2))],color0, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i1),'k');
subplot(10,4,2) 
nexttile
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i1+1),'color',color1); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i1+2),'color',color1); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i1+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i1+2))],color1, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i1),'k');


subplot(10,4,3)
nexttile
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i2+1),'color',color0); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i2+2),'color',color0); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i2+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i2+2))],color0, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i2),'k');
subplot(10,4,4)
nexttile
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i2+1),'color',color1); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i2+2),'color',color1); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i2+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i2+2))],color1, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on; 
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i2),'k');

subplot(10,4,5)
nexttile
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i3+1),'color',color0); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i3+2),'color',color0); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i3+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i3+2))],color0, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i3),'k'); 
subplot(10,4,6)
nexttile
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i3+1),'color',color1); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i3+2),'color',color1); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i3+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i3+2))],color1, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on; 
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i3),'k');

subplot(10,4,7)
nexttile
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i4+1),'color',color0); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i4+2),'color',color0); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i4+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i4+2))],color0, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i4),'k'); 
subplot(10,4,8)
nexttile
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i4+1),'color',color1); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i4+2),'color',color1); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i4+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i4+2))],color1, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i4),'k');

subplot(10,4,9)
nexttile
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i5+1),'color',color0); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i5+2),'color',color0); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i5+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i5+2))],color0, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeLever(:,i5),'k');
subplot(10,4,10)
nexttile
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i5+1),'color',color1); hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i5+2),'color',color1); hold on;
patch([g(:); flipud(g(:))],[Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i5+1); flipud(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i5+2))],color1, 'FaceAlpha',0.8, 'EdgeColor','none');hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
plot(Donnees_EMG(YY+1).Phasic.MOYENNE_ClassiqueSeRassoir(:,i5),'k');

han=axes(f,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'yourYLabel');
xlabel(han,'yourXLabel');
xlabel(han,'Normalized time') 
ylabel(han,'Integrated EMG (mV)') 




