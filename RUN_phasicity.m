color0Y =[217/255,95/255,2/255];
VALUE = 125;

Titre = append('MOUVEMENT ASSIS/DEBOUT');
f = figure('units','normalized','outerposition',[0 0 1 1]);
t = tiledlayout(2,2,'TileSpacing','Compact');

%% 1
y1 = DonneesToExport2.EMG(3).Phasic.Classique.ProfilMoyenSeLever(:,13);
[max1, posmax1] = max(y1);
y1cut = y1(posmax1-VALUE:posmax1+VALUE,:);
x1=(1:1:length(y1cut))';

nexttile 
plot(y1);

nexttile 
f = fit(x1,y1cut,'gauss1')
plot(f,x1,y1cut)
Coeff = f.a1/f.c1;
title(append('A = ',string(f.a1),'   C = ',string(f.c1),'      ----        A/C = ',string(Coeff)),'color',color0Y)

%% 2
y2 = DonneesToExport.EMG(6).Phasic.Classique.ProfilMoyenSeLever(:,13);
[max2, posmax2] = max(y2);
y2cut = y2(posmax2-VALUE:posmax2+VALUE,:);
x2=(1:1:length(y2cut))';

nexttile 
plot(y2);

nexttile 
f2 = fit(x2,y2cut,'gauss1')
plot(f2,x2,y2cut)
Coeff2 = f2.a1/f2.c1;
title(append('A = ',string(f2.a1),'   C = ',string(f2.c1),'      ----        A/C = ',string(Coeff2)),'color',color0Y)



%% RMS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make up some data. (You should use your real data in place of x.)
data = DonneesToExport.EMG(4).RMSCutNormProfilMoyen.Se_lever(:,17);
plot(data)

pHat = lognfit(data);
m=pHat(1);
v=pHat(2);

pd = makedist('Lognormal','mu',log(m^2/sqrt(v+m^2)),'sigma',sqrt(log(1+(v/(m^2)))));
x = (1:length(data))';
y = pdf(pd,x);
plot(y)




