%BROUILLON




for i=1:16
    Titre = append('Muscle'+string(i));
    fig = figure('Name',Titre,'NumberTitle','off');
    plot(Donnees_EMG.Phasic.TonicLent.ProfilMoyenSeLever(:,(i-1)*3+1));hold on;
    plot(Donnees_EMG.Phasic.Classique.ProfilMoyenSeLever(:,(i-1)*3+1));hold on;
    plot(Donnees_EMG.Phasic.Combined.ProfilMoyenSeLever(:,(i-1)*3+1)); 
    legend('Lent','Classique','Combined')
end


for i=1:16
    Titre = append('Muscle'+string(i));
    fig = figure('Name',Titre,'NumberTitle','off');
    plot(Donnees_EMG.Phasic.TonicLent.ProfilMoyenSeRassoir(:,(i-1)*3+1));hold on;
    plot(Donnees_EMG.Phasic.Classique.ProfilMoyenSeRassoir(:,(i-1)*3+1));hold on;
    plot(Donnees_EMG.Phasic.Combined.ProfilMoyenSeRassoir(:,(i-1)*3+1)); 
    legend('Lent','Classique','Combined')
end

Titre = append('Classique');
fig = figure('Name',Titre,'NumberTitle','off');
for i=1:10
%     Titre = append(ListeFichier(i).name);
%     fig = figure('Name',Titre,'NumberTitle','off');    
%     plot(Donnees_EMG(i).TonicSoustrait.R(:,25:30));hold on; 
    plot(Donnees_EMG(i).Phasic.Classique.ProfilMoyenSeLever(:,13));hold on;
    colororder(newcolors)
    legend(ListeFichier(:).name)
end

count=0;
for a=1:1000
    for c=1:10
        count = Donnees_EMG(c).Phasic.Classique.ProfilMoyenSeLever(a,13)+count;
    end
    PF(a,1) = count/10;
    count=0;
end
newcolors = [0 0.4470 0.7410
    0.8500 0.3250 0.0980
    0.9290 0.6940 0.1250
    0.4940 0.1840 0.5560
    0.4660 0.6740 0.1880
    0.3010 0.7450 0.9330
    0.6350 0.0780 0.1840
    0 1 0
    1 0 0
    0 0 0
    137/255 137/255 137/255
    0 227/255 137/255];
         

for i=1:10
    Titre = ListeFichier(i).name;
    fig = figure('Name',Titre,'NumberTitle','off');
    plot(Donnees_EMG(i).RMSCut(:,49:60),'DisplayName','Donnees_EMG(7).RMSCut(:,49:60)');
    colororder(newcolors)
    legend('1','2','3','4','5','6','7','8','9','10','11','12')
end






for i=1:10
    disp(i)
    for j=1:12
        baseline = mean(Donnees_EMG(i).RMSCut(1:100,48+j));
        disp(baseline)
        deviation = std(Donnees_EMG(i).RMSCut(1:100,48+j));
        a=1;
        b=0;
        for v=100:length(Donnees_EMG(i).RMSCut(:,48+j)) 
            if abs(Donnees_EMG(i).RMSCut(a,48+j)-baseline)>10*deviation
                compteur(i,j)=a;
                b=1;
                break
            else
                a=a+1;
            end
        end
    end
end


mean(mean(compteur))



tes(1,1) = 1;
tes(2,1) = 5;


Titre = append('Classique');
fig = figure('Name',Titre,'NumberTitle','off');
for i=1:10

    plot(RMS_R_moy);hold on;
    plot(norm_tonic_R_moy);hold on;
    plot(emg_phasique_R_avantNorm);
    colororder(newcolors)
end



plot(PF);hold on;
r=[0.1:0.1:1000]; y = zeros(length(r),1);plot(r,y,'r');title(titre);




