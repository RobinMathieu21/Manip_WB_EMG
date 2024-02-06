clear
load('data_Phasic.mat')
rng('default');
NB_Muscles = 15;


%% Ne tester que la négativité
% X(X>0)=0;




F=5;    %Number of partition folds
C = cvpartition(Y_c,'Kfold',F,'Stratify',true);   %Partition data with stratification
%C = cvpartition(size(X,1),'LeaveOut');
lab = ["YAgo","OAgo","YR1go","OR1go","YR2go","OR2go","YAret","OAret","YR1ret","OR1ret","YR2ret","OR2ret"];
condlist=categorical({'DAD','DPD','DAG','DPG','VLD','BFD','VLG','BFG','ESL1D','ESD7D','ESD7G','TAD','SOLD','TAG','SOLG'});   %Array of the muscles names
condlist = reordercats(condlist,{'DAD','DPD','DAG','DPG','VLD','BFD','VLG','BFG','ESL1D','ESD7D','ESD7G','TAD','SOLD','TAG','SOLG'}); %Reorder the array

switch NB_Muscles
    case 15
        muslist=categorical({'DAD','DPD','DAG','DPG','VLD','BFD','VLG','BFG','ESL1D','ESD7D','ESD7G','TAD','SOLD','TAG','SOLG'});   %Array of the muscles names
        muslist = reordercats(muslist,{'DAD','DPD','DAG','DPG','VLD','BFD','VLG','BFG','ESL1D','ESD7D','ESD7G','TAD','SOLD','TAG','SOLG'}); %Reorder the array
        X(:,10001:11000)=[]; % Pour enlever erecr L1 Gauche
    case 16
        muslist=categorical({'DAD','DPD','DAG','DPG','VLD','BFD','VLG','BFG','ESL1D','ESD7D','ESL1G','ESD7G','TAD','SOLD','TAG','SOLG'});   %Array of the muscles names
        muslist = reordercats(muslist,{'DAD','DPD','DAG','DPG','VLD','BFD','VLG','BFG','ESL1D','ESD7D','ESL1G','ESD7G','TAD','SOLD','TAG','SOLG'}); %Reorder the array
end

% for i=1%:NB_Muscles
% %     sel{i}=[zeros(1,(i-1)*1000),ones(1,1000),zeros(1,(NB_Muscles-i)*1000)];
%     sel{i}=ones(15000);
% end
for i=1:1
    sel{i}=ones(1,15000);
end

for i=1:length(sel)
    for z=1:6

        comp_a=2*(z-1)+1; %%% For young old comparison
        comp_b=2*z;

%     comp_a=z; %%% For direction comparison
% 	comp_b=z+6;

        for k=1:C.NumTestSets
            Xtrain=X(C.training(k),sel{i}==1);
            Xtest=X(C.test(k),sel{i}==1);
            
            Ytrain = Y_c(C.training(k));
            Ytest = Y_c(C.test(k));
    
            %Make the training set
            Xa = Xtrain(Ytrain==lab(comp_a),:);    %Training set for a° angle
            Xb = Xtrain(Ytrain==lab(comp_b),:);    %Training set for 90° angle
            Ya = Ytrain(Ytrain==lab(comp_a));      %a° class names
            Yb = Ytrain(Ytrain==lab(comp_b));      %90° class names
            Xtr = [Xa;Xb];                    %Fuse to make complete training set
            Ytr = [Ya;Yb];                    %Fuse to make complete class name array for the training set
            
            %Same for the testing set
            Xc = Xtest(Ytest==lab(comp_a),:);
            Xd = Xtest(Ytest==lab(comp_b),:);
            Yc = Ytest(Ytest==lab(comp_a));
            Yd = Ytest(Ytest==lab(comp_b));
            Xte = [Xc;Xd];
            Yte = [Yc;Yd];
            
             M = fitcdiscr(Xtr,Ytr,'discrimType','pseudoLinear');      %Fit the training set and store the model in M
    %         M = fitcsvm(Xtr,Ytr);      %Fit the training set and store the model in M
            %M = fitcdiscr(Xtr,Ytr, 'DiscrimType','pseudoquadratic');
            P = predict(M, Xte);         %Use the model to predict the testing set
            B = (Yte == P);                 %Compare estimated class and actual class
            acc{i,z}(k) = 100*sum(B)/length(B);  %Calculate accuracy
    %         disp(strcat('Muscle :', muslist(i),' ; Condition : ',condlist(z),' ; Fold : ', num2str(k)))
            dist(k,i,z)=norm(M.Mu(1,:)-M.Mu(2,:));
        end
    end
end

% for i=1:length(acc)
%     for z=1:6
%         M_acc(i,z)=mean(acc{i,z});
%         ST(i,z)=std(acc{i,z});
%     end
% end

distM=squeeze(mean(dist,1));
distSTD=squeeze(std(dist,0,1));
for a=1:6
    figure;bar(distM(:,a));hold on;errorbar([1:15],distM(:,a),distSTD(:,a),'.');xticklabels(muslist);
end
