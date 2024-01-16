

muscle =16;
for SUJET =1:24
    for VARR = 49:60
        muscle=0;
        Phases(VARR-48+muscle,SUJET) = mean(DonneesToExport.EMG(SUJET).Phases_Stables(:,VARR));
    end
    for VARR = 73:84
        muscle=12;
        Phases(VARR-72+muscle,SUJET) = mean(DonneesToExport.EMG(SUJET).Phases_Stables(:,VARR));
    end
    for VARR = 97:108
        muscle=24;
        Phases(VARR-96+muscle,SUJET) = mean(DonneesToExport.EMG(SUJET).Phases_Stables(:,VARR)); 
    end
    for VARR = 121:132
        muscle=36;
        Phases(VARR-120+muscle,SUJET) = mean(DonneesToExport.EMG(SUJET).Phases_Stables(:,VARR));
    end

end



for SUJET =1:24
    PhasesMEAN(1,SUJET) = mean(Phases(1:12,SUJET));

    PhasesMEAN(2,SUJET) = mean(Phases(13:24,SUJET));

    PhasesMEAN(3,SUJET) = mean(Phases(25:36,SUJET));

    PhasesMEAN(4,SUJET) =  mean(Phases(37:48,SUJET));
end