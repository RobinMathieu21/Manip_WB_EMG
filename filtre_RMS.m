% 
% for i=1:4
%     for j=1:4
%         nexttile
%         title2 = append('i=',string(i),' ; j=',string(j));
%         [c,lags] = xcorr(acq(:,i),acq(:,j),'normalized');
%         plot(lags,c);title(title2)
% %         mean(c)
%     end
% end
% 
% 
% 
% 
% xcorr
% 
% 
% [c,lags] = xcorr(acq(1:1000,1),acq(1:1000,2));
% stem(lags,c)
% 

close all
clear all

% VARIABLES pour calcul EMG
emg_frequency = 1000; % Fréquence d'acquisition du signal EMG
rms_window = 500; % Time in ms of the window used to compute sliding root mean square of EMG
rms = 0;

for i=1:2 % Nb sujets
        % Pour chaque sujet i = i+1
    i
    [Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');
    Extension = '*.mat'; %Traite tous les .mat

    DossierColor_rouge = append(Dossier, '\ROUGE');
    DossierColor_blanc = append(Dossier, '\BLANC');
    DossierColor_bleu = append(Dossier, '\BLEU');
    DossierColor_repos = append(Dossier, '\REPOS');
    rms = 0;
    for rms_window = [10 100 500]
        rms = 1 + rms;
        rms_window_step = (rms_window/1000)*emg_frequency;


        for position=1:4
            position
            switch position
                case 1
                    Chemin = fullfile(DossierColor_rouge, Extension); Path = DossierColor_rouge;
                case 2
                    Chemin = fullfile(DossierColor_blanc, Extension); Path = DossierColor_blanc;
                case 3
                    Chemin = fullfile(DossierColor_bleu, Extension); Path = DossierColor_bleu;
                case 4
                    Chemin = fullfile(DossierColor_repos, Extension); Path = DossierColor_repos;
            end

            ListeFichier = dir(Chemin); % On construit la liste des fichiers


            for trial=1:8
                trial
                Fichier_traite = [Path '\' ListeFichier(trial).name]; %On charge le fichier .mat
                load (Fichier_traite);
                emg_data = C3D.EMG.Donnees(:,1);

            %% CALCUL RMS 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                data(rms).Position(position).BRUTCOMPLET(i).brutes(1:length(emg_data),trial) = emg_data;
                emg_data_filtre = butter_emgs(emg_data(:, 1), emg_frequency,  5, [30 300], 'band-pass', 'false', 'centered');
                % On sauvegarde la taille du signal
                [emg_data_lig, emg_data_col]=size(emg_data);

                %On rectifie (abs) le signal
                emg_data_rect = abs(emg_data_filtre);
                emg_data_rect_SF = abs(emg_data);

                % On effectue un second filtre passe-bas
                emg_data_filtre_rect_second = butter_emgs(emg_data_rect, emg_frequency,  5, 20, 'low-pass', 'false', 'centered');

                % On crée la matrice de la bonne taille
                emg_data_filtre_rms = ones(emg_data_lig-rms_window_step, emg_data_col)*999;

                % On calcule la rms 
                for f = 1:(emg_data_lig-rms_window_step) 
                    emg_data_filtre_rms(f) = aire_trapz(f, (f + rms_window_step-1), emg_data_filtre_rect_second);
                end
                
                % On calcule la rms sans filtre
                for f = 1:(emg_data_lig-rms_window_step) 
                    emg_data_filtre_rms_SansFiltre(f,:) = aire_trapz(f, (f + rms_window_step-1), emg_data_rect_SF);
                end

                l = length(emg_data_filtre_rms);
                data(rms).Position(position).RMS(i,trial) = mean(emg_data_filtre_rms(round(l/2-500):round(l/2+500),:));
                data(rms).Position(position).RMS_SansFiltre(i,trial) = mean(emg_data_filtre_rms_SansFiltre(round(l/2-500):round(l/2+500),:));
                data(rms).Position(position).RMSCOMPLET(i).RMS(1:length(emg_data_filtre_rms),trial) = emg_data_filtre_rms;
                %figure;plot(emg_data_filtre_rms);

            end
        end
    end
end













% % % % %%%%%%%%%%%% TEST FFT %%%%%%%%%%%
% % % % Fs = 1000;            % Sampling frequency                    
% % % % T = 1/Fs;             % Sampling period       
% % % % L = length(C3D.EMG.Donnees(:,1));             % Length of signal
% % % % t = (0:L-1)*T;        % Time vector
% % % % 
% % % % Y = fft(C3D.EMG.Donnees(:,1));
% % % % 
% % % % P2 = abs(Y/L);
% % % % P1 = P2(1:L/2+1);
% % % % P1(2:end-1) = 2*P1(2:end-1);
% % % % 
% % % % 
% % % % f = Fs*(0:(L/2))/L;
% % % % figure; plot(f(1:end),P1(1:end)) 
% % % % title("Single-Sided Amplitude Spectrum of X(t)")
% % % % xlabel("f (Hz)")
% % % % ylabel("|P1(f)|")
% load census;
% x = data(:,1);
% y = data(:,2);
% 
% 
% 
% f= fit(x,y,'poly2');




