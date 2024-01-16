%delete(findall(0));


close all
clear all

mvt = 3; % 1 pour STS/BTS, 2 pour Reach1 et 3 pour Reach2

newcolors = [
128/255 0/255 0/255
230/255 25/255 75/255
245/255 130/255 48/255
255/255 225/255 25/255
210/255 245/255 60/255
60/255 180/255 75/255
70/255 240/255 240/255
0/255 130/255 200/255
145/255 30/255 180/255
240/255 50/255 230/255
128/255 128/255 128/255
170/255 110/255 40/255
0 0 0];

        color0=[28/255,156/255,67/255]; % Pour la couleur du premier mvt des Ã¢gÃ©s
        color1=[65/255,211/255,183/255]; % Pour la couleur du second mvt des Ã¢gÃ©s
        color0Y=[217/255,95/255,2/255]; % Pour la couleur du premier mvt des jeunes
        color1Y=[233/255,148/255,63/255]; % Pour la couleur du second mvt des jeunes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% PLOT EMG PHASIC 
Titre = append('MOUVEMENT ASSIS/DEBOUT');
%set(gcf,'position',[200,200,1400,600])
f = figure('units','normalized','outerposition',[0 0 1 1]);
t = tiledlayout(4,4,'TileSpacing','Compact');

color5=[80/255,121/255,63/255]; % Pour la couleur de la ligne en y=0
i1=13; title1 = ' Right Vastuls Lateralis'; 


for mvt = 1:4

        switch mvt
        case 1
            title_mvt = 'Signaux non refiltrés                                                                                                                        Signaux filtrés butterworth 10hz passe bas';
            fileY = 'D:\DATA MANIP 1\DONNES EMG réunion 4 RMS 200\Donnees_saved_Young.mat'; 
            title_add= 'STS _ '; title_add2= 'BTS _ ';
            path = append("G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Stats\Réunion 5\Test RMS et filtre",'\');


            load(fileY);
            Donnees_EMGY = DonneesToExport.EMG;
            YYy = length(Donnees_EMGY)-1;
 
            nexttile % JEUNE SE LEVER
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeLever(:,i1));hold on;
                legend('1','2','3','4','5','6','7','8','9','10','11','Position',[0 0.4 0.05 0.3])
                legend('Orientation','vertical')
                legend('boxoff')
            end
            title(append(title_add,title1, ' RMS 200ms'),'color',color0Y)
            
            nexttile % JEUNE SE RASSOIR
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeRassoir(:,i1));hold on; 
            end
            title(append(title_add2,title1),'color',color1Y)
            
            for b=1:YYy
                data_emg_filt_selever(:,b) = butter_emgs(Donnees_EMGY(:,b).Phasic.Classique.ProfilMoyenSeLever(:,i1), 1000,  3, 10, 'low-pass', 'false', 'centered');
                data_emg_filt_serassoir(:,b) = butter_emgs(Donnees_EMGY(:,b).Phasic.Classique.ProfilMoyenSeRassoir(:,i1), 1000,  3, 10, 'low-pass', 'false', 'centered');
            end

                        nexttile % JEUNE SE LEVER
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(data_emg_filt_selever(:,i));hold on;
                legend('1','2','3','4','5','6','7','8','9','10','11','Position',[0 0.4 0.05 0.3])
                legend('Orientation','vertical')
                legend('boxoff')
            end
            title(append(title_add,title1, ' RMS 200ms'),'color',color0Y)
            
            nexttile % JEUNE SE RASSOIR
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(data_emg_filt_serassoir(:,i));hold on; 
            end
            title(append(title_add2,title1),'color',color1Y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 2
            title_mvt = 'RMS 100';
            fileY = 'D:\DATA MANIP 1\DONNES EMG réunion 4 RMS 100\Donnees_saved_Young.mat';
            title_add= 'STS _ '; title_add2= 'BTS _ ';
            path = append("G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Stats\Réunion 5\Test RMS et filtre",'\');

            
            load(fileY);
            Donnees_EMGY = DonneesToExport.EMG;
            YYy = length(Donnees_EMGY)-1;
            nexttile % JEUNE SE LEVER
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeLever(:,i1));hold on;
                legend('1','2','3','4','5','6','7','8','9','10','11','Position',[0 0.4 0.05 0.3])
                legend('Orientation','vertical')
                legend('boxoff')
            end
            title(append(title_add,title1, ' RMS 100ms'),'color',color0Y)
            
            nexttile % JEUNE SE RASSOIR
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeRassoir(:,i1));hold on; 
            end
            title(append(title_add2,title1),'color',color1Y)


            for b=1:YYy
                data_emg_filt_selever(:,b) = butter_emgs(Donnees_EMGY(:,b).Phasic.Classique.ProfilMoyenSeLever(:,i1), 1000,  3, 10, 'low-pass', 'false', 'centered');
                data_emg_filt_serassoir(:,b) = butter_emgs(Donnees_EMGY(:,b).Phasic.Classique.ProfilMoyenSeRassoir(:,i1), 1000,  3, 10, 'low-pass', 'false', 'centered');
            end

                        nexttile % JEUNE SE LEVER
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(data_emg_filt_selever(:,i));hold on;
                legend('1','2','3','4','5','6','7','8','9','10','11','Position',[0 0.4 0.05 0.3])
                legend('Orientation','vertical')
                legend('boxoff')
            end
            title(append(title_add,title1, ' RMS 100ms'),'color',color0Y)
            
            nexttile % JEUNE SE RASSOIR
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(data_emg_filt_serassoir(:,i));hold on; 
            end
            title(append(title_add2,title1,' '),'color',color1Y)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 3
            title_mvt = 'RMS 50';
            fileY = 'D:\DATA MANIP 1\DONNES EMG réunion 4 RMS 50\Donnees_saved_Young.mat';
            title_add= 'STS _ '; title_add2= 'BTS _ ';
            path = append("G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Stats\Réunion 5\Test RMS et filtre",'\');

            
            load(fileY);
            Donnees_EMGY = DonneesToExport.EMG;
            YYy = length(Donnees_EMGY)-1;
            nexttile % JEUNE SE LEVER
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeLever(:,i1));hold on;
                legend('1','2','3','4','5','6','7','8','9','10','11','Position',[0 0.4 0.05 0.3])
                legend('Orientation','vertical')
                legend('boxoff')
            end
            title(append(title_add,title1, ' RMS 50ms'),'color',color0Y)
            
            nexttile % JEUNE SE RASSOIR
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeRassoir(:,i1));hold on; 
            end
            title(append(title_add2,title1),'color',color1Y)

                        for b=1:YYy
                data_emg_filt_selever(:,b) = butter_emgs(Donnees_EMGY(:,b).Phasic.Classique.ProfilMoyenSeLever(:,i1), 1000,  3, 10, 'low-pass', 'false', 'centered');
                data_emg_filt_serassoir(:,b) = butter_emgs(Donnees_EMGY(:,b).Phasic.Classique.ProfilMoyenSeRassoir(:,i1), 1000,  3, 10, 'low-pass', 'false', 'centered');
            end

                        nexttile % JEUNE SE LEVER
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(data_emg_filt_selever(:,i));hold on;
                legend('1','2','3','4','5','6','7','8','9','10','11','Position',[0 0.4 0.05 0.3])
                legend('Orientation','vertical')
                legend('boxoff')
            end
            title(append(title_add,title1,' RMS 50ms'),'color',color0Y)
            
            nexttile % JEUNE SE RASSOIR
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(data_emg_filt_serassoir(:,i));hold on; 
            end
            title(append(title_add2,title1),'color',color1Y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        case 4
            title_mvt = 'Signaux non refiltrés                                                                                                                        Signaux filtrés butterworth ordre 3 à 10hz passe bas';
            fileY = 'D:\DATA MANIP 1\DONNES EMG réunion 4 RMS 10\Donnees_saved_Young.mat';
            title_add= 'STS _ '; title_add2= 'BTS _ ';
            path = append("G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 1\Resultats\Stats\Réunion 5\Test RMS et filtre",'\');

            
            load(fileY);
            Donnees_EMGY = DonneesToExport.EMG;
            YYy = length(Donnees_EMGY)-1;
            nexttile % JEUNE SE LEVER
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeLever(:,i1));hold on;
                legend('1','2','3','4','5','6','7','8','9','10','11','Position',[0 0.4 0.05 0.3])
                legend('Orientation','vertical')
                legend('boxoff')
            end
            title(append(title_add,title1,' RMS 10ms'),'color',color0Y)
            
            nexttile % JEUNE SE RASSOIR
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(Donnees_EMGY(i).Phasic.Classique.ProfilMoyenSeRassoir(:,i1));hold on; 
            end
            title(append(title_add2,title1),'color',color1Y)

                        for b=1:YYy
                data_emg_filt_selever(:,b) = butter_emgs(Donnees_EMGY(:,b).Phasic.Classique.ProfilMoyenSeLever(:,i1), 1000,  3, 10, 'low-pass', 'false', 'centered');
                data_emg_filt_serassoir(:,b) = butter_emgs(Donnees_EMGY(:,b).Phasic.Classique.ProfilMoyenSeRassoir(:,i1), 1000,  3, 10, 'low-pass', 'false', 'centered');
            end

                        nexttile % JEUNE SE LEVER
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(data_emg_filt_selever(:,i));hold on;
                legend('1','2','3','4','5','6','7','8','9','10','11','Position',[0 0.4 0.05 0.3])
                legend('Orientation','vertical')
                legend('boxoff')
            end
            title(append(title_add,title1,' RMS 10ms'),'color',color0Y)
            
            nexttile % JEUNE SE RASSOIR
            r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'color',color5);hold on;
            for i=1:YYy
                colororder(newcolors)
                plot(data_emg_filt_serassoir(:,i));hold on; 
            end
            title(append(title_add2,title1),'color',color1Y)
            
        end


        

        

        

        

        
        
        
        

        
   
        
        
        title(t,title_mvt)
        xlabel(t,'Normalized time')
        ylabel(t,'Integrated EMG (mV)')
%         
%         saveas(gcf,path,'png');
    
end





