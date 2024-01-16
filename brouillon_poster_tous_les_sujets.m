%delete(findall(0));


close all
clear all

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

newcolors2 = [
255/255 255/255 255/255
60/255 180/255 75/255
255/255 225/255 25/255
0 130/255 200/255
245/255 130/255 48/255
145/255 30/255 180/255
];



% newcolors = [
% 230/255 25/255 75/255
% 230/255 25/255 75/255
% 230/255 25/255 75/255
% 230/255 25/255 75/255
% 230/255 25/255 75/255
% 230/255 25/255 75/255
% 230/255 25/255 75/255
% 0 130/255 200/255
% 0 130/255 200/255
% 230/255 25/255 75/255
% 0 130/255 200/255
% 0 130/255 200/255
% 230/255 25/255 75/255
% 230/255 25/255 75/255
% 230/255 25/255 75/255
% 230/255 25/255 75/255
% 230/255 25/255 75/255
% 230/255 25/255 75/255
% ];
% 
% newcolors2 = [
% 0 130/255 200/255
% 0 130/255 200/255
% 0 130/255 200/255
% 0 130/255 200/255
% 0 130/255 200/255
% 0 130/255 200/255
% 0 130/255 200/255
% 0 130/255 200/255
% 0 130/255 200/255
% 0 130/255 200/255
% 0 130/255 200/255
% 0 130/255 200/255
% 0 130/255 200/255
% 0 130/255 200/255
% 0 130/255 200/255
% 230/255 25/255 75/255
% ];
for mvt = 1:1
    for muscles = 1:2

        switch mvt
        case 1
            file = 'D:\DATA MANIP 1\DONNES EMG\ASSIS\Donnees_saved_Old.mat'; title_mvt = 'YOUNG sans cable                                                                 STS / BTS movement                                                                      OLD sans cable';
            fileY = 'D:\DATA MANIP 1\DONNES EMG\ASSIS\Donnees_saved_Young.mat'; 
%             file = 'C:\Users\robin\Desktop\DONNES EMG\ASSIS\Donnees_saved_Old.mat'; title_mvt = 'OLD                                                                      STS / BTS movement                                                                      OLD';
%             fileY = 'C:\Users\robin\Desktop\DONNES EMG\ASSIS\Donnees_saved_Young.mat'; 
            title_add= 'STS _ '; title_add2= 'BTS _ ';
            path = append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\R�union 18\graphs_new_subjects','\');
%             path = append('C:\Users\robin\Desktop\Drive google\6A - THESE\MANIP 1\Resultats\Stats\R�union 3\Graphs\ASSIS','\');
       
        case 2
            file = 'D:\DATA MANIP 1\DONNES EMG\R1\Donnees_saved_Old.mat'; title_mvt = 'YOUNG                                                                      Short distance reach movement                                                                      OLD';
            fileY = 'D:\DATA MANIP 1\DONNES EMG\R1\Donnees_saved_Young.mat'; 
            title_add= 'Bending _ '; title_add2= 'Bounce back _ ';
            path = append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Stats\R�union 3\Graphs\REACH1','\');
        case 3
            
            file = 'D:\DATA MANIP 1\DONNES EMG\R2\Donnees_saved_Old.mat'; title_mvt = 'YOUNG                                                                      Long distance reach movement                                                                      OLD';
            fileY = 'D:\DATA MANIP 1\DONNES EMG\R2\Donnees_saved_Young.mat'; 
            title_add= 'Bending _ '; title_add2= 'Bounce back _ ';
            path = append('G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Stats\R�union 3\Graphs\REACH2','\');
            
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
             
            case 2
            %% POUR LES MUSCLES DU DOS
            i1=25; title1 = ' Right Erector L1';
            i2=28; title2 = ' Right Erector D7';
            i3=31; title3 = ' Left Erector L1';
            i4=34; title4 = ' Left Erector D7';
            path = append(path,'Dos');

            %% POUR LES MUSCLES DES BRAS
            case 3
            i1=1; title1 = ' Right Antérior Deltoïde';
            i2=4; title2 = ' Right Posterior Deltoïde';
            i3=7; title3 = ' Left Antérior Deltoïde';
            i4=10; title4 = ' Left Posterior Deltoïde';
            path = append(path,'Bras');
            
            case 4
            %% POUR LES MUSCLES DES JAMBES
            i1=37; title1 = ' Right Tibialis Anterior';
            i2=40; title2 = ' Right Soleus';
            i3=43; title3 = ' Left Tibialis Anterior';
            i4=46; title4 = ' Left Soleus';
            path = append(path,'Jambes');
        end
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Plot 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        YY = length(Donnees_EMG)-2;
        YYy = length(Donnees_EMGY)-2;
        
        % Enregistrement des quantifs par mouvements 
%         Quantif.Young(mvt).SAVED = Donnees_EMGY(YYy+1).Phasic.MoyenneQuantif; 
%         Quantif.Old(mvt).SAVED  = Donnees_EMG(YY+1).Phasic.MoyenneQuantif;
        
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
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YYy
            colororder(newcolors2)
            plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeLever(:,i1));axis([0 1000 -1 1]); hold on; 
            legend('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','Position',[0 0.4 0.05 0.3])
            legend('Orientation','vertical')
            legend('boxoff')
        end
        title(append(title_add,title1),'color',color0Y)
        
        nexttile % JEUNE SE RASSOIR
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YYy
            colororder(newcolors2)
            plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeRassoir(:,i1));axis([0 1000 -1 1]); hold on; 
        end
        title(append(title_add2,title1),'color',color1Y)
        
        
        nexttile % AGE SE LEVER
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YY
            colororder(newcolors)
            plot(Donnees_EMG(i).Phasic.Classique.ProfilMoyenSeLever(:,i1));axis([0 1000 -1 1]); hold on; 
            legend('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','Position',[0 0.4 1.95 0.3])
            legend('Orientation','vertical')
            legend('boxoff')
        end
        title(append(title_add,title1),'color',color0)
        
        nexttile % AGE SE RASSOIR
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YY
            colororder(newcolors)
            plot(Donnees_EMG(i).Phasic.Classique.ProfilMoyenSeRassoir(:,i1));axis([0 1000 -1 1]); hold on; 
        end
        title(append(title_add2,title1),'color',color1)
        
        
        %% LE 2eme MUSCLE
        nexttile % JEUNE SE LEVER
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YYy
            colororder(newcolors2)
            plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeLever(:,i2));axis([0 1000 -1 1]); hold on; 
        end
        title(append(title_add,title2),'color',color0Y)
        
        nexttile % JEUNE SE RASSOIR
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YYy
            colororder(newcolors2)
            plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeRassoir(:,i2));axis([0 1000 -1 1]); hold on;  
        end
        title(append(title_add2,title2),'color',color1Y)
        
        
        nexttile % AGE SE LEVER
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YY
            colororder(newcolors)
            plot(Donnees_EMG(i).Phasic.Classique.ProfilMoyenSeLever(:,i2));axis([0 1000 -1 1]); hold on; 
        end
        title(append(title_add,title2),'color',color0)
        
        nexttile % AGE SE RASSOIR
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YY
            colororder(newcolors)
            plot(Donnees_EMG(i).Phasic.Classique.ProfilMoyenSeRassoir(:,i2));axis([0 1000 -1 1]); hold on; 
        end
        title(append(title_add2,title2),'color',color1)
        
        
        
        %% LE 3eme MUSCLE
        nexttile % JEUNE SE LEVER
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YYy
            colororder(newcolors2)
            plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeLever(:,i3));axis([0 1000 -1 1]); hold on;  
        end
        title(append(title_add,title3),'color',color0Y)
        
        nexttile % JEUNE SE RASSOIR
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YYy
            colororder(newcolors2)
            plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeRassoir(:,i3));axis([0 1000 -1 1]); hold on; 
        end
        title(append(title_add2,title3),'color',color1Y)
        
        
        nexttile % AGE SE LEVER
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YY
            colororder(newcolors)
            plot(Donnees_EMG(i).Phasic.Classique.ProfilMoyenSeLever(:,i3));axis([0 1000 -1 1]); hold on;  
        end
        title(append(title_add,title3),'color',color0)
        
        nexttile % AGE SE RASSOIR
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YY
            colororder(newcolors)
            plot(Donnees_EMG(i).Phasic.Classique.ProfilMoyenSeRassoir(:,i3));axis([0 1000 -1 1]); hold on;  
        end
        title(append(title_add2,title3),'color',color1)
        
        
        %% LE 4eme MUSCLE
        nexttile % JEUNE SE LEVER
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YYy
            colororder(newcolors2)
            plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeLever(:,i4));axis([0 1000 -1 1]); hold on; 
        end
        title(append(title_add,title4),'color',color0Y)
        
        nexttile % JEUNE SE RASSOIR
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YYy
            colororder(newcolors2)
            plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeRassoir(:,i4));axis([0 1000 -1 1]); hold on; 
        end
        title(append(title_add2,title4),'color',color1Y)
        
        
        nexttile % AGE SE LEVER
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YY
            colororder(newcolors)
            plot(Donnees_EMG(i).Phasic.Classique.ProfilMoyenSeLever(:,i4));axis([0 1000 -1 1]); hold on; 
        end
        title(append(title_add,title4),'color',color0)
        
        nexttile % AGE SE RASSOIR
        r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
        for i=1:YY
            colororder(newcolors)
            plot(Donnees_EMG(i).Phasic.Classique.ProfilMoyenSeRassoir(:,i4));axis([0 1000 -1 1]); hold on;  
        end
        title(append(title_add2,title4),'color',color1)
        
        
        
        title(t,title_mvt)
        xlabel(t,'Normalized time')
        ylabel(t,'Integrated EMG (mV)')
        
         saveas(gcf,path,'png');
    end
end

%% POUR NE RECUPERER QUE LES QUANTIF MOYENNES PAR SUJET
for mvt=2:2
    Quantif.Old(mvt).SAVED(:, 1:4:end) = [];
    Quantif.Old(mvt).SAVED(:, 1:3:end) = [];
    Quantif.Old(mvt).SAVED(2:6:end, :) = [];
    Quantif.Old(mvt).SAVED(2:5:end, :) = [];
    Quantif.Old(mvt).SAVED(2:4:end, :) = [];
    Quantif.Old(mvt).SAVED(2:3:end, :) = [];
    Quantif.Old(mvt).SAVED(2:2:end, :) = [];

    Quantif.Young(mvt).SAVED(:, 1:4:end) = [];
    Quantif.Young(mvt).SAVED(:, 1:3:end) = [];
    Quantif.Young(mvt).SAVED(2:6:end, :) = [];
    Quantif.Young(mvt).SAVED(2:5:end, :) = [];
    Quantif.Young(mvt).SAVED(2:4:end, :) = [];
    Quantif.Young(mvt).SAVED(2:3:end, :) = [];
    Quantif.Young(mvt).SAVED(2:2:end, :) = [];
end




%%%%%%%%%%%%%%%%
%   TEST  
% CALCUL PHASIC %
%%%%%%%%%%%%%%%%%
for i = 1:11
%     Titre = append('MOUVEMENT ASSIS/DEBOUT');
%     %set(gcf,'position',[200,200,1400,600])
%     f = figure('units','normalized','outerposition',[0 0 1 1]);
%     t = tiledlayout(2,1,'TileSpacing','Compact');
%     
%     plot(DonneesToExport.EMG_TL(i).RMSCutNormProfilMoyen.Se_lever(:,17)); hold on;
% 
%     plot(DonneesToExport.EMG(i).RMSCutNormProfilMoyen.Se_lever(:,17))

    figure;plot(DonneesToExport.EMG_TL(i).RMSCut(:,49:60))
end


