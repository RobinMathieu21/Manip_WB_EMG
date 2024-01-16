
%% Script -----kinematics----- pour manip mvts whole body
% A executer pour post-traiter les données obtenues lors des manips whole
% body. Ce script est à utiliser pour les données STS/BTS et WB reaching.

close all
clear all


%% Importation des données

%On selectionne le repertoire
disp('Selectionnez le Dossier regroupant les essais');
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');
    
Extension = '*.mat'; %Traite tous les .mat
Chemin = fullfile(Dossier, Extension); % On construit le chemin
ListeFichier = dir(Chemin); % On construit la liste des fichiers

%% On procède au balayage fichier par fichier

    disp(append('Il y a ', string(numel(ListeFichier)),' fichiers à analyser.'));
    for i = 1: numel(ListeFichier)
 
       Fichier_traite = [Dossier '\' ListeFichier(i).name]; %On charge le fichier .mat
       disp(append('i = ',string(i)));
       load (Fichier_traite);
       

        %On coupe le signal de vitesse pour avoir 2 plages contenant chacune un mouvement
        Titredec = append('Découpage mvt lent numéro ', string(i));
        figure('Name',Titredec,'NumberTitle','off');
        plot(acq.data(:,5))
        [Cut] = ginput(14);


        for a=1:14
            %% Detection MVT
            baseline_cine = mean(acq.data(Cut(a)-250:Cut(a)+250,3));
            ecart_cine = 10*std(acq.data(Cut(a)-250:Cut(a)+250,3));
            value_cine = acq.data(round(Cut(a)),3);
            temps_cine = round(Cut(a));
            while value_cine < baseline_cine + ecart_cine && value_cine > baseline_cine - ecart_cine
                temps_cine = temps_cine +1;
                value_cine = acq.data(temps_cine,3);
            end
            data(a,1) = temps_cine;

            %% Detection Bouffée agoniste
            baseline_ago = mean(acq.data(Cut(a)-250:Cut(a)+250,5));
            ecart_ago = 10*std(acq.data(Cut(a)-250:Cut(a)+250,5));
            value_ago = acq.data(round(Cut(a)),5);
            temps_ago = round(Cut(a));
            while value_ago < baseline_ago + ecart_ago && value_ago > baseline_ago - ecart_ago
                temps_ago = temps_ago +1;
                value_ago = acq.data(temps_ago,5);
            end
            data(a,2) = temps_ago;

            %% Detection Bouffée postural
            baseline_postu = mean(acq.data(Cut(a)-250:Cut(a)+250,6));
            ecart_postu = 5*std(acq.data(Cut(a)-250:Cut(a)+250,6));
            value_postu = acq.data(round(Cut(a)),6);
            temps_postu = round(Cut(a));
            while value_postu < baseline_postu + ecart_postu && value_postu > baseline_postu - ecart_postu
                temps_postu = temps_postu +1;
                value_postu = acq.data(temps_postu,6);
                value_postu
            end
            data(a,3) = temps_postu;


        end

        data(:,5) = data(:,1) - data(:,2);
        data(:,6) = data(:,1) - data(:,3);


     end





Titre = append('MOUVEMENT ASSIS/DEBOUT');
%set(gcf,'position',[200,200,1400,600])
f = figure('units','normalized','outerposition',[0 0 1 1]);
t = tiledlayout(3,1,'TileSpacing','Compact');

%% LE 1er MUSCLE
nexttile % 
    plot(acq.data(:,3),'r'); hold on;
     y = ylim;
    for a=1:14
        plot([data(a,1) data(a,1)],[y(1) y(2)],'r'); hold on; % debut mvt 1
    end
    for a=1:14
        y = ylim;
        x = xlim; % current y-axis limits
        x2 = [Cut(a)-250 Cut(a)+250 Cut(a)+250 Cut(a)-250];
        y2 = [y(1) y(1) y(2) y(2)];
        L(3)= patch(x2,y2,'red','FaceAlpha',0.1);
    end


nexttile %
    plot(acq.data(:,5),'b'); hold on;
    y = ylim;
    for a=1:14
        plot([data(a,2) data(a,2)],[y(1) y(2)],'r'); hold on; % debut mvt 1
    end
    for a=1:14
        y = ylim;
        x = xlim; % current y-axis limits
        x2 = [Cut(a)-250 Cut(a)+250 Cut(a)+250 Cut(a)-250];
        y2 = [y(1) y(1) y(2) y(2)];
        L(3)= patch(x2,y2,'blue','FaceAlpha',0.1);
    end


nexttile 
    plot(acq.data(:,6),'g');  hold on;
    y = ylim;
    for a=1:14
        plot([data(a,3) data(a,3)],[y(1) y(2)],'r'); hold on; % debut mvt 1
    end
    for a=1:14
        x = xlim; % current y-axis limits
        x2 = [Cut(a)-250 Cut(a)+250 Cut(a)+250 Cut(a)-250];
        y2 = [y(1) y(1) y(2) y(2)];
        L(3)= patch(x2,y2,'green','FaceAlpha',0.1);
    end


data(16,5)= mean(data(1:14,5));

data(16,6)= mean(data(1:14,6));