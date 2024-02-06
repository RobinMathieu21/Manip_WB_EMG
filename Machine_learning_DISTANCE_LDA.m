 

for z=1:6

clearvars -except Accuracy and z and good
load('data_Phasic.mat')
rng('default');

NB_Muscles = 15;
comp_a=2*(z-1)+1;
    comp_b=2*z;

% X(X>0)=0;


F=5;    %Number of partition folds
C = cvpartition(Y_c,'Kfold',F,'Stratify',true);   %Partition data with stratification
%C = cvpartition(size(X,1),'LeaveOut');
lab = ["YAgo","OAgo","YR1go","OR1go","YR2go","OR2go","YAret","OAret","YR1ret","OR1ret","YR2ret","OR2ret"];




switch NB_Muscles
    case 15
        muslist=categorical({'DAD','DPD','DAG','DPG','VLD','BFD','VLG','BFG','ESL1D','ESD7D','ESD7G','TAD','SOLD','TAG','SOLG'});   %Array of the muscles names
        muslist = reordercats(muslist,{'DAD','DPD','DAG','DPG','VLD','BFD','VLG','BFG','ESL1D','ESD7D','ESD7G','TAD','SOLD','TAG','SOLG'}); %Reorder the array
        X(:,10001:11000)=[]; % Pour enlever erecr L1 Gauche
    case 16
        muslist=categorical({'DAD','DPD','DAG','DPG','VLD','BFD','VLG','BFG','ESL1D','ESD7D','ESL1G','ESD7G','TAD','SOLD','TAG','SOLG'});   %Array of the muscles names
        muslist = reordercats(muslist,{'DAD','DPD','DAG','DPG','VLD','BFD','VLG','BFG','ESL1D','ESD7D','ESL1G','ESD7G','TAD','SOLD','TAG','SOLG'}); %Reorder the array
end

Xa = X(Y_c==lab(comp_a),:);    %ing set for a° angle
        Xb = X(Y_c==lab(comp_b),:);    %ing set for 90° angle
        Ya = Y_c(Y_c==lab(comp_a));      %a° class names
        Yb = Y_c(Y_c==lab(comp_b));      %90° class names
        Xtr = [Xa;Xb];                    %Fuse to make complete training set
        Ytr = [Ya;Yb];   

        SommeA = sum(Xa);
        SommeB = sum(Xb);
        good = find(SommeA~=0 & SommeB~=0);
        

for k = 1:F
        Xtrain=X(C.training(k),:);
        Xtest=X(C.test(k),:);
        
        Ytrain = Y_c(C.training(k));
        Ytest = Y_c(C.test(k));
        %Make the training set
        Xa = Xtrain(Ytrain==lab(comp_a),:);    %Training set for a° angle
        Xb = Xtrain(Ytrain==lab(comp_b),:);    %Training set for 90° angle
        Ya = Ytrain(Ytrain==lab(comp_a));      %a° class names
        Yb = Ytrain(Ytrain==lab(comp_b));      %90° class names
        Xtr = [Xa;Xb];                    %Fuse to make complete training set
        Ytr = [Ya;Yb];                    %Fuse to make complete class name array for the training set
        Xtr=Xtr(:,good);

        %Same for the testing set
        Xc = Xtest(Ytest==lab(comp_a),:);
        Xd = Xtest(Ytest==lab(comp_b),:);
        Yc = Ytest(Ytest==lab(comp_a));
        Yd = Ytest(Ytest==lab(comp_b));
        Xte = [Xc;Xd];
        Xte=Xte(:,good);
        Yte = [Yc;Yd];
        
        [Clas(k,:),A]=fscchi2(Xtr,Ytr);

        M = fitcdiscr(Xtr,Ytr,'discrimType','pseudoLinear');         %Fit the training set and store the model in M
%         dist(i,z)=norm(M.Mu(:,1)-M.Mu(:,2));
        P = predict(M, Xte);         %Use the model to predict the testing set
        B = (Yte == P);                 %Compare estimated class and actual class
        acc(k) = 100*sum(B)/length(B);  %Calculate accuracy

        for i = 1:NB_Muscles
            muscles(k,i) = mean(A((i-1)*1000+1:i*1000));
        end
end


Accuracy(z) = mean(acc);
end

% 
M_dist=mean(muscles,1);
ST_dist=std(muscles,[],1);
[~,I] = sort(muscles,2);
Classement(comp_a,:)=mean(I);
% 
% figure;
% hold on
% bar([1:NB_Muscles],M_acc,'FaceColor',[0.75 0.75 0.75])
% errorbar([1:NB_Muscles],M_acc,ST,'k.','MarkerFaceColor','k')
% xticks([1:NB_Muscles])
% xticklabels(muslist)