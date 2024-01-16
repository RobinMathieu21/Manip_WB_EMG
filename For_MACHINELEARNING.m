for i =1:16
    Y=[Y;[DonneesToExportY.EMG(i).RMSCutNorm(:,49:60).',DonneesToExportY.EMG(i).RMSCutNorm(:,61:72).',DonneesToExportY.EMG(i).RMSCutNorm(:,73:84).',DonneesToExportY.EMG(i).RMSCutNorm(:,85:96).',DonneesToExportY.EMG(i).RMSCutNorm(:,97:108).',DonneesToExportY.EMG(i).RMSCutNorm(:,109:120).', DonneesToExportY.EMG(i).RMSCutNorm(:,121:132).', DonneesToExportY.EMG(i).RMSCutNorm(:,133:144).']];  
    O=[O;[DonneesToExportO.EMG(i).RMSCutNorm(:,49:60).',DonneesToExportO.EMG(i).RMSCutNorm(:,61:72).',DonneesToExportO.EMG(i).RMSCutNorm(:,73:84).',DonneesToExportO.EMG(i).RMSCutNorm(:,85:96).',DonneesToExportO.EMG(i).RMSCutNorm(:,97:108).',DonneesToExportO.EMG(i).RMSCutNorm(:,109:120).', DonneesToExportO.EMG(i).RMSCutNorm(:,121:132).', DonneesToExportO.EMG(i).RMSCutNorm(:,133:144).']];
end


t=tsne(X,'NumDimensions',3);
scatter3(t(Y1==1,1),t(Y1==1,2),t(Y1==1,3))
hold on
 scatter3(t(Y1==0,1),t(Y1==0,2),t(Y1==0,3))

 Y1=[zeros(192,1);ones(192,1)];