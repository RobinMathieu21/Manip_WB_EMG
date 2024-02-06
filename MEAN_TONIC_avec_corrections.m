
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% STS YOUNG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch true
        case YY == 16 && m ==1          % STS OLD VLD
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2);
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));

        otherwise 
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2);
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));

            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));
   
end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% STS OLD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch true
        case YY == 12 && m ==5          % STS OLD VLD
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2);
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));

            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+2:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+2:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+2:Nb_emgs*length(Donnees.EMG_lent)+b+o));
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+2:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+2:Nb_emgs*length(Donnees.EMG_lent)+b+o));
            disp("Case 1 ou le VL n'était pas bon !!!!!")
        case YY == 18 && m ==9         % STS OLD ESL1 D
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2);
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));

            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
            disp("Case 2 ou le ESLD 1 n'était pas bon !!!!!")
        otherwise 
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2);
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));

            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));
            Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));
   
end




%%%%%%%%%%%%%%%%%%%%%%

        valueNotCOUNT = 61; 
        switch true
        
            case YY == 1 && (acqui ==valueNotCOUNT  || acqui ==valueNotCOUNT+192  || acqui ==valueNotCOUNT+384)     % STS OLD ESL1G sujet 1 acq 4 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.R(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.R(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.B(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.B(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);

            case YY == 1 && ( acqui ==valueNotCOUNT+96  || acqui ==valueNotCOUNT+288  || acqui ==valueNotCOUNT+480)     % STS OLD ESL1G sujet 1 acq 2 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))+std(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))-std(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))+std(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))-std(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);


       
        
        
           otherwise 
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,acqui:acqui+5))+std(EMG_traite.classique.R(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,acqui:acqui+5))-std(EMG_traite.classique.R(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,acqui:acqui+5))+std(EMG_traite.classique.B(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,acqui:acqui+5))-std(EMG_traite.classique.B(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
    
%                 Donnees_EMG(YY).Phasic.ClassiqueFILT.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classiqueFILT.R(f,www:www+length(Donnees.EMG)/2-1));

        
        end

%%%%%%%%%%%%%%%%%%%%%%


valueNotCOUNT = 61; 
switch true
    case YY == 1 && (acqui ==valueNotCOUNT  || acqui ==valueNotCOUNT+192  || acqui ==valueNotCOUNT+384)     % STS OLD ESL1G sujet 1 acq 4 à virer
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));

     case YY == 1 && ( acqui ==valueNotCOUNT+96  || acqui ==valueNotCOUNT+288  || acqui ==valueNotCOUNT+480)     % STS OLD ESL1G sujet 1 acq 2 à virer
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));

    otherwise 
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,acqui:acqui+5));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,acqui:acqui+5));
end












%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% R1 YOUNG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


switch true
    case YY == 2 && m ==9          % R1 Y
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+5]),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+5]),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+5]));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+5]),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+5]));
                                                                
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]));
        disp("Case 1 ou le ESLD n'était pas bon !!!!!")
   case YY == 2 && m ==11          % R1 Y
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+5]),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+5]),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+5]));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+5]),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+5]));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]));
        disp("Case 1 ou le ESLG n'était pas bon !!!!!")


    case YY == 9 && m ==11        % R1 Y
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        disp("Case 2 ou le ESLG n'était pas bon !!!!!")
    case YY == 9 && m ==7          % R1 Y
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        disp("Case 1 ou le VLG n'était pas bon !!!!!")


    case YY == 12 && m ==9         % R1 Y
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        disp("Case 2 ou le ESLD  n'était pas bon !!!!!")
    case YY == 12 && m ==11          % R1 Y
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        disp("Case 1 ou le ESLG n'était pas bon !!!!!")

     case YY == 18 && m ==9         % R1 Y
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-3),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-3),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-3));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-3),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-3));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-3),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-3),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-3));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-3),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-3));
        disp("Case 2 ou le ESLD  n'était pas bon !!!!!")
    case YY == 18 && m ==11          % R1 Y
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-3),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-3),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-3));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-3),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-3));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-3),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-3),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-3));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-3),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-3));
        disp("Case 1 ou le ESLG n'était pas bon !!!!!")

    otherwise 
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));

end

%%%%%%%%%%%%%%%%%%%%%


       valueNotCOUNT = 25;
        switch true
        
            case YY == 13 && (acqui ==valueNotCOUNT  || acqui ==valueNotCOUNT+192  || acqui ==valueNotCOUNT+384)     % STS OLD ESL1G sujet 1 acq 4 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))+std(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))-std(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))+std(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))-std(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+3 acqui+4]))/sqrt(length(Donnees.EMG)/2);

            case YY == 13 && ( acqui ==valueNotCOUNT+96  || acqui ==valueNotCOUNT+288  || acqui ==valueNotCOUNT+480)     % STS OLD ESL1G sujet 1 acq 2 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.R(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.R(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.B(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.B(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);


       
        
        
           otherwise 
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,acqui:acqui+5))+std(EMG_traite.classique.R(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,acqui:acqui+5))-std(EMG_traite.classique.R(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,acqui:acqui+5))+std(EMG_traite.classique.B(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,acqui:acqui+5))-std(EMG_traite.classique.B(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
    
%                 Donnees_EMG(YY).Phasic.ClassiqueFILT.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classiqueFILT.R(f,www:www+length(Donnees.EMG)/2-1));

        
        end

 %%%%%%%%%%%%%%%%%%%%%%%


valueNotCOUNT = 25;
switch true
    case YY == 13 && (acqui ==valueNotCOUNT || acqui ==valueNotCOUNT+192  || acqui ==valueNotCOUNT+384 )     % R1 Young VLD sujet 13 phasique SL 6 et SR 2
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+2 acqui+3 acqui+4]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+2 acqui+3 acqui+4]));

    case YY == 13 && (acqui ==valueNotCOUNT+96 || acqui ==valueNotCOUNT+288 || acqui ==valueNotCOUNT+480)     % R1 Young VLD sujet 13 phasique SL 6 et SR 2
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));

    otherwise 
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,acqui:acqui+5));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,acqui:acqui+5));
end

valueNotCOUNT = 25;
switch true
    case YY == 13 && (acqui ==valueNotCOUNT || acqui ==valueNotCOUNT+192  || acqui ==valueNotCOUNT+384 )     % R1 Young VLD sujet 13 phasique SL 6 et SR 2
        DonneesToExport.EMG(YY+2).QuantifDesacNZ(subject,1+((acqui-1)/6))=mean(nonzeros(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+2 acqui+3 acqui+4])));
        DonneesToExport.EMG(YY+2).QuantifDesacSDNZ(subject,1+((acqui-1)/6))=std(nonzeros(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+2 acqui+3 acqui+4])));

    case YY == 13 && (acqui ==valueNotCOUNT+96 || acqui ==valueNotCOUNT+288 || acqui ==valueNotCOUNT+480)     % R1 Young VLD sujet 13 phasique SL 6 et SR 2
        DonneesToExport.EMG(YY+2).QuantifDesacNZ(subject,1+((acqui-1)/6))=mean(nonzeros(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+2 acqui+3 acqui+4 acqui+5])));
        DonneesToExport.EMG(YY+2).QuantifDesacSDNZ(subject,1+((acqui-1)/6))=std(nonzeros(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+2 acqui+3 acqui+4 acqui+5])));

    otherwise 
        DonneesToExport.EMG(YY+2).QuantifDesacNZ(subject,1+((acqui-1)/6))=mean(nonzeros(DonneesToExport.EMG(YY+1).QuantifDesac(subject,acqui:acqui+5)));
        DonneesToExport.EMG(YY+2).QuantifDesacSDNZ(subject,1+((acqui-1)/6))=std(nonzeros(DonneesToExport.EMG(YY+1).QuantifDesac(subject,acqui:acqui+5)));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% R1 OLD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch true
    case YY == 5 && m ==7          % R1 O sl 1 4 6 sr 1 
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o+1 a+o+2 a+o+4]),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o+1 a+o+2 a+o+4]),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o+1 a+o+2 a+o+4]));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o+1 a+o+2 a+o+4]),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o+1 a+o+2 a+o+4]));
                                                                
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        disp("Case 1 ou le VLG n'était pas bon !!!!!")
   case YY == 5 && m ==9          % R1 O sl 1 sr 1 
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        disp("Case 1 ou le ESLG n'était pas bon !!!!!")
    case YY == 5 && m ==11        % R1 O sl 1 sr 1 2 6 
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o+2 Nb_emgs*length(Donnees.EMG_lent)+a+o+3 Nb_emgs*length(Donnees.EMG_lent)+a+o+4]),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o+2 Nb_emgs*length(Donnees.EMG_lent)+a+o+3 Nb_emgs*length(Donnees.EMG_lent)+a+o+4]),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o+2 Nb_emgs*length(Donnees.EMG_lent)+a+o+3 Nb_emgs*length(Donnees.EMG_lent)+a+o+4]));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o+2 Nb_emgs*length(Donnees.EMG_lent)+a+o+3 Nb_emgs*length(Donnees.EMG_lent)+a+o+4]),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o+2 Nb_emgs*length(Donnees.EMG_lent)+a+o+3 Nb_emgs*length(Donnees.EMG_lent)+a+o+4]));
        disp("Case 2 ou le ESLG n'était pas bon !!!!!")


    case YY == 6 && m ==5          % R1 O sl 3 sr  
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o+0 a+o+1 a+o+3 a+o+4 a+o+5]),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o+0 a+o+1 a+o+3 a+o+4 a+o+5]),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o+0 a+o+1 a+o+3 a+o+4 a+o+5]));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o+0 a+o+1 a+o+3 a+o+4 a+o+5]),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o+0 a+o+1 a+o+3 a+o+4 a+o+5]));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        disp("Case 1 ou le VLG n'était pas bon !!!!!")


    case YY == 7 && m ==9         % R1 O sl 1 sr 1 
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        disp("Case 2 ou le ESLD  n'était pas bon !!!!!")




     case YY == 23 && m ==5         % R1 O sl 1 sr 1 
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        disp("Case 2 ou le ESLD  n'était pas bon !!!!!")
      
     case YY == 23 && m ==7         % R1 O sl 1 sr 1 
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        disp("Case 2 ou le ESLD  n'était pas bon !!!!!")
           
      case YY == 23 && m ==9         % R1 O sl 1 sr 1 
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        disp("Case 2 ou le ESLD  n'était pas bon !!!!!")
          
     case YY == 23 && m ==11         % R1 O sl 1 sr 1 
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        disp("Case 2 ou le ESLD  n'était pas bon !!!!!")
      

    otherwise 
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));
    
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));

end


%%%%%%%%%%%%%%%%%%%%%


       valueNotCOUNT = 25;
        switch true
        
            case YY == 9 && (acqui ==valueNotCOUNT  || acqui ==valueNotCOUNT+192  || acqui ==valueNotCOUNT+384)     % STS OLD ESL1G sujet 1 acq 4 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+3]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+3]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+3]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+3]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+3]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+3]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+3]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+3]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+3]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+3]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+3]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+3]))+std(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+3]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+3]))-std(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+3]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+3]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+3]))+std(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+3]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+3]))-std(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+3]))/sqrt(length(Donnees.EMG)/2);


           otherwise 
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,acqui:acqui+5))+std(EMG_traite.classique.R(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,acqui:acqui+5))-std(EMG_traite.classique.R(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,acqui:acqui+5))+std(EMG_traite.classique.B(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,acqui:acqui+5))-std(EMG_traite.classique.B(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
    
%                 Donnees_EMG(YY).Phasic.ClassiqueFILT.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classiqueFILT.R(f,www:www+length(Donnees.EMG)/2-1));

        
        end

 %%%%%%%%%%%%%%%%%%%%%%%


valueNotCOUNT = 25;
switch true
    case YY == 9 && (acqui ==valueNotCOUNT || acqui ==valueNotCOUNT+192  || acqui ==valueNotCOUNT+384 )     % R1 old VLD sujet 9 phasic 5 et 6 à virer
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+2 acqui+3]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+2 acqui+3]));

    otherwise 
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,acqui:acqui+5));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,acqui:acqui+5));
end

valueNotCOUNT = 25;
switch true
    case YY == 9 && (acqui ==valueNotCOUNT || acqui ==valueNotCOUNT+192  || acqui ==valueNotCOUNT+384 )     % R1 old VLD sujet 9 phasic 5 et 6 à virer
        DonneesToExport.EMG(YY+2).QuantifDesacNZ(subject,1+((acqui-1)/6))=mean(nonzeros(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+2 acqui+3])));
        DonneesToExport.EMG(YY+2).QuantifDesacSDNZ(subject,1+((acqui-1)/6))=std(nonzeros(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+2 acqui+3])));

    otherwise 
        DonneesToExport.EMG(YY+2).QuantifDesacNZ(subject,1+((acqui-1)/6))=mean(nonzeros(DonneesToExport.EMG(YY+1).QuantifDesac(subject,acqui:acqui+5)));
        DonneesToExport.EMG(YY+2).QuantifDesacSDNZ(subject,1+((acqui-1)/6))=std(nonzeros(DonneesToExport.EMG(YY+1).QuantifDesac(subject,acqui:acqui+5)));
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% R2 YOUNG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


switch true
    case YY == 7 && m == 7          % R2 Y VLG sl 3 sr 3
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+3 a+o+4 a+o+5]),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+3 a+o+4 a+o+5]),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+3 a+o+4 a+o+5]));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+3 a+o+4 a+o+5]),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+3 a+o+4 a+o+5]));
    
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+3 Nb_emgs*length(Donnees.EMG_lent)+a+o+4 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+3 Nb_emgs*length(Donnees.EMG_lent)+a+o+4 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+3 Nb_emgs*length(Donnees.EMG_lent)+a+o+4 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+3 Nb_emgs*length(Donnees.EMG_lent)+a+o+4 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+3 Nb_emgs*length(Donnees.EMG_lent)+a+o+4 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]));

    case YY == 7 && m == 9         % R2 Y ESD sl 3 sr 3
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+3 a+o+4 a+o+5]),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+3 a+o+4 a+o+5]),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+3 a+o+4 a+o+5]));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+3 a+o+4 a+o+5]),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o a+o+1 a+o+3 a+o+4 a+o+5]));
    
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+3 Nb_emgs*length(Donnees.EMG_lent)+a+o+4 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+3 Nb_emgs*length(Donnees.EMG_lent)+a+o+4 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+3 Nb_emgs*length(Donnees.EMG_lent)+a+o+4 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+3 Nb_emgs*length(Donnees.EMG_lent)+a+o+4 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,[Nb_emgs*length(Donnees.EMG_lent)+a+o Nb_emgs*length(Donnees.EMG_lent)+a+o+1 Nb_emgs*length(Donnees.EMG_lent)+a+o+3 Nb_emgs*length(Donnees.EMG_lent)+a+o+4 Nb_emgs*length(Donnees.EMG_lent)+a+o+5]));
    
    case YY == 18 && m ==9         % R1 Y
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-4),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-4),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-4));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-4),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-4));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-4),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-4),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-4));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-4),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-4));
        disp("Case 2 ou le ESLD  n'était pas bon !!!!!")
    case YY == 18 && m ==11          % R1 Y
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-4),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-4),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-4));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-4),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o-4));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-4),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-4),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-4));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-4),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o-4));
        disp("Case 1 ou le ESLG n'était pas bon !!!!!")
    otherwise 
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));
    
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));
           
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% R2 OLD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


switch true
    case YY == 4 && m ==7          % R1 O sl 1 sr 1 
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+1:b+o));
                                                                
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));

   case YY == 4 && m ==9          % R1 O sl 1 2 sr 1 
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+2:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+2:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+2:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+2:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o+2:b+o));
                                                                
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o+1:Nb_emgs*length(Donnees.EMG_lent)+b+o));



    case YY == 13 && m ==5        % R1 O sl 1 3 6
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o+1 a+o+3 a+o+4]),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o+1 a+o+3 a+o+4]),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o+1 a+o+3 a+o+4]));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o+1 a+o+3 a+o+4]),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,[a+o+1 a+o+3 a+o+4]));

        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        disp("Case 2 ou le ESLG n'était pas bon !!!!!")




    otherwise 
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_lever(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,a+o:b+o));
    
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+p) =  mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2);
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+1+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)+std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));
        Donnees_EMG_TL(YY).RMSCutNormProfilMoyen.Se_rassoir(f, m+2+p) = mean(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o),2)-std(Donnees_EMG_TL(YY).RMSCutNorm(f,Nb_emgs*length(Donnees.EMG_lent)+a+o:Nb_emgs*length(Donnees.EMG_lent)+b+o));
     

end

%%%%%%%%%%%%%%%%%%%%%

valueNotCOUNT4 = 61;
valueNotCOUNT3 = 49;
valueNotCOUNT2 = 37;
valueNotCOUNT = 25;

        switch true
%1        
            case YY == 1 && (acqui ==valueNotCOUNT2  || acqui ==valueNotCOUNT2+192  || acqui ==valueNotCOUNT2+384)     % STS OLD ESL1G sujet 1 acq 4 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.R(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.R(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.B(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.B(f,[acqui acqui+1 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
            
%2
            case YY == 9 && (acqui ==valueNotCOUNT  || acqui ==valueNotCOUNT+192  || acqui ==valueNotCOUNT+384)     % STS OLD ESL1G sujet 1 acq 4 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.R(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.R(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.B(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.B(f,[acqui acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
            

      %3
            case YY == 13 && (acqui ==valueNotCOUNT  || acqui ==valueNotCOUNT+192  || acqui ==valueNotCOUNT+384)     % STS OLD ESL1G sujet 1 acq 4 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))+std(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))-std(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))+std(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))-std(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+3 acqui+5]))/sqrt(length(Donnees.EMG)/2);
            
            case YY == 13 && ( acqui ==valueNotCOUNT+96  || acqui ==valueNotCOUNT+288  || acqui ==valueNotCOUNT+480)     % STS OLD ESL1G sujet 1 acq 2 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))+std(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))-std(EMG_traite.classique.R(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))+std(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))-std(EMG_traite.classique.B(f,[acqui acqui+1 acqui+2 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);

      %4
            case YY == 19 && (acqui ==valueNotCOUNT  || acqui ==valueNotCOUNT+192  || acqui ==valueNotCOUNT+384)     % STS OLD ESL1G sujet 1 acq 4 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
            
            case YY == 19 && ( acqui ==valueNotCOUNT+96  || acqui ==valueNotCOUNT+288  || acqui ==valueNotCOUNT+480)     % STS OLD ESL1G sujet 1 acq 2 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);

      %5
            case YY == 19 && (acqui ==valueNotCOUNT2  || acqui ==valueNotCOUNT2+192  || acqui ==valueNotCOUNT2+384)     % STS OLD ESL1G sujet 1 acq 4 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
            
            case YY == 19 && ( acqui ==valueNotCOUNT2+96  || acqui ==valueNotCOUNT2+288  || acqui ==valueNotCOUNT2+480)     % STS OLD ESL1G sujet 1 acq 2 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);

      %6
            case YY == 19 && (acqui ==valueNotCOUNT3  || acqui ==valueNotCOUNT3+192  || acqui ==valueNotCOUNT3+384)     % STS OLD ESL1G sujet 1 acq 4 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
            
            case YY == 19 && ( acqui ==valueNotCOUNT3+96  || acqui ==valueNotCOUNT3+288  || acqui ==valueNotCOUNT3+480)     % STS OLD ESL1G sujet 1 acq 2 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);


          %7
            case YY == 19 && (acqui ==valueNotCOUNT4  || acqui ==valueNotCOUNT4+192  || acqui ==valueNotCOUNT4+384)     % STS OLD ESL1G sujet 1 acq 4 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
            
            case YY == 19 && ( acqui ==valueNotCOUNT4+96  || acqui ==valueNotCOUNT4+288  || acqui ==valueNotCOUNT4+480)     % STS OLD ESL1G sujet 1 acq 2 à virer
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.R(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))+std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))-std(EMG_traite.classique.B(f,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]))/sqrt(length(Donnees.EMG)/2);

    

           otherwise 
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+1) =  mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_lever(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))+std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
                Donnees_EMG(YY).Phasic.TonicLent.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))-std(Donnees_EMG(YY).Phasic.TonicLent.Se_rassoir(f,acqui:acqui+5))/sqrt(length(Donnees.EMG));
        
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classique.R(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+2) = mean(EMG_traite.classique.R(f,acqui:acqui+5))+std(EMG_traite.classique.R(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeLever(f,(v-1)*3+3) = mean(EMG_traite.classique.R(f,acqui:acqui+5))-std(EMG_traite.classique.R(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+1) = mean(EMG_traite.classique.B(f,acqui:acqui+5));
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+2) = mean(EMG_traite.classique.B(f,acqui:acqui+5))+std(EMG_traite.classique.B(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
                Donnees_EMG(YY).Phasic.Classique.ProfilMoyenSeRassoir(f,(v-1)*3+3) = mean(EMG_traite.classique.B(f,acqui:acqui+5))-std(EMG_traite.classique.B(f,acqui:acqui+5))/sqrt(length(Donnees.EMG)/2);
    
%                 Donnees_EMG(YY).Phasic.ClassiqueFILT.ProfilMoyenSeLever(f,(v-1)*3+1) = mean(EMG_traite.classiqueFILT.R(f,www:www+length(Donnees.EMG)/2-1));

        
        end

 %%%%%%%%%%%%%%%%%%%%%%%


valueNotCOUNT4 = 61;
valueNotCOUNT3 = 49;
valueNotCOUNT2 = 37;
valueNotCOUNT = 25;
switch true

    case YY == 1 && (acqui ==valueNotCOUNT2 || acqui ==valueNotCOUNT2+192  || acqui ==valueNotCOUNT2+384 )     % R2 old VLG sujet 1 phasic 3 à virer
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+3 acqui+4 acqui+5]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+3 acqui+4 acqui+5]));

    case YY == 9 && (acqui ==valueNotCOUNT || acqui ==valueNotCOUNT+192  || acqui ==valueNotCOUNT+384 )     % R2 old VLD sujet 9 phasic 2 à virer
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+2 acqui+3 acqui+4 acqui+5]));

    case YY == 13 && (acqui ==valueNotCOUNT || acqui ==valueNotCOUNT+192  || acqui ==valueNotCOUNT+384 )     % R2 old VLD sujet 13 phasic SL 5 et SR 4 à virer
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+2 acqui+3 acqui+5]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+2 acqui+3 acqui+5]));
    case YY == 13 && (acqui ==valueNotCOUNT+96 || acqui ==valueNotCOUNT+288 || acqui ==valueNotCOUNT+480)     
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui acqui+1 acqui+2 acqui+4 acqui+5]));


    case YY == 19 && (acqui ==valueNotCOUNT || acqui ==valueNotCOUNT+192  || acqui ==valueNotCOUNT+384 )     % R2 old VLD sujet 19 phasic SL 1 et SR 1 à virer
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
    case YY == 19 && (acqui ==valueNotCOUNT+96 || acqui ==valueNotCOUNT+288 || acqui ==valueNotCOUNT+480)     
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));

    case YY == 19 && (acqui ==valueNotCOUNT2 || acqui ==valueNotCOUNT2+192  || acqui ==valueNotCOUNT2+384 )     % R2 old VLG sujet 19 phasic SL 5 et SR 4 à virer
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
    case YY == 19 && (acqui ==valueNotCOUNT2+96 || acqui ==valueNotCOUNT2+288 || acqui ==valueNotCOUNT2+480)     % R2 old VLG sujet 19 phasic SL 5 et SR 4 à virer
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
    

    case YY == 19 && (acqui ==valueNotCOUNT3 || acqui ==valueNotCOUNT3+192  || acqui ==valueNotCOUNT3+384 )     % R2 old ESD sujet 19 phasic SL 5 et SR 4 à virer
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
    case YY == 19 && (acqui ==valueNotCOUNT3+96 || acqui ==valueNotCOUNT3+288 || acqui ==valueNotCOUNT3+480)     % R2 old ESD sujet 19 phasic SL 5 et SR 4 à virer
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
     
    case YY == 19 && (acqui ==valueNotCOUNT4 || acqui ==valueNotCOUNT4+192  || acqui ==valueNotCOUNT4+384 )     % R2 old ESG sujet 19 phasic SL 5 et SR 4 à virer
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
    case YY == 19 && (acqui ==valueNotCOUNT4+96 || acqui ==valueNotCOUNT4+288 || acqui ==valueNotCOUNT4+480)     % R2 old ESG sujet 19 phasic SL 5 et SR 4 à virer
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,[acqui+1 acqui+2 acqui+3 acqui+4 acqui+5]));

    otherwise 
        DonneesToExport.EMG(YY+2).QuantifDesac(subject,1+((acqui-1)/6))=mean(DonneesToExport.EMG(YY+1).QuantifDesac(subject,acqui:acqui+5));
        DonneesToExport.EMG(YY+2).QuantifDesacSD(subject,1+((acqui-1)/6))=std(DonneesToExport.EMG(YY+1).QuantifDesac(subject,acqui:acqui+5));
end




