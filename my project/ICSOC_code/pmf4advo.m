% Code is revised by Haibin 
% Original Code provided by R. Salakhutdinov
%
%%load data and randomly select 10 percent for testing and 90 for training.
load advoby3.mat % Triplets: {truster_id, trustee_id, rating}
index=randperm(size(advo,1));
probe_vec=advo(index(1:round(size(advo,1)/10)),:); %10percent as testing dataset
train_vec=advo(index(round((size(advo,1)/10)+1):end),:); % 90 percent as training dataset
%%Initialization
restart=1;
rand('state',0); 	%% reset the seed generator, so that generate the same sequence of numbers, % for standard uniform distribution
randn('state',0); 	%% for standard normal distribution
if restart==1 		%% restart is a var been set value (1) before the pmf.m module.
    restart=0;		%% so that, will not set again.
    epsilon=50;       % Learning rate
    Beta = 0.02; %coefficient of regularization
    Gamma=0.02;
    lambda  = 0.01; % Regularization parameter
    momentum=0.8;  %% used in UPDATE movie and user FEATURES, in the paper, it said to be 0.9
    epoch=1; 		%% iteration
    maxepoch=10; 	%% RUN the factorization for 50 iterations
    mean_rating = mean(train_vec(:,3)); 	%% the moviedata includes two dataset, one is train_vec for training, and the other probe_vec for evaluation
    num_v = 7425;  % Number of trustees	,also the maximum number of movie-ID, actually it's 3706 different movies.
    num_u = 7425;  % Number of trustors, also the maximum number of user-ID
    num_factor = 10; % Rank 10 decomposition,this is the pre-defined size for latent features
    w_V     = 0.1*randn(num_v, num_factor); % Movie feature vectors % initial values by RAND ( Normally distributed pseudorandom numbers)
    w_U     = 0.1*randn(num_u, num_factor); % User feature vecators % initial values by RAND
    w_V_inc = zeros(num_v, num_factor);		%% all zeros, used for updating Movie features
    w_U_inc = zeros(num_u, num_factor);		%% all zeros, used for updating User features
end


        S1=similarityab(train_vec,num_u);
        S2=simAB(train_vec,num_u); %Compute the NEW SIMILARITY 7425 by 7425
        trustM=trustAB(train_vec,num_u,0.5);


for epoch = epoch:maxepoch
    train_vec = train_vec(randperm(length(train_vec)),:);	%% pick up some rows of train_vec, but with changed order
    N=length(train_vec); % number training triplets per batch
    index_u   = double(train_vec(:,1));	%% get per-100000 users (user-ID), batch lines and 1 column
    index_v   = double(train_vec(:,2));	%% get per-100000 movies (movie-ID),=trustee
    rating = double(train_vec(:,3));	%% get per-100000 ratings (rating value),
    rating = rating-mean_rating; % Default prediction is the mean rating. %% mean_rating = mean(train_vec(:,3)) = 3.5816,
    pred_out = sum(w_V(index_v,:).*w_U(index_u,:),2);	%% .* operator is "Array Multiplication" of matrices, Fij = Aij * Bij %% then summarize the values of each row, pred_out is a n x 1 vector.
    
    %%%%%%%%%%%%%% Compute Gradients %%%%%%%%%%%%%%%%%%%
    IO = repmat(2*(pred_out - rating),1,num_factor);		%% create a matrix of N * num_feat, copying the value of 2*(pred_out - rating).
    I_v =IO.*w_U(index_u,:) + lambda*w_V(index_v,:);		%% get the gradient of M = (pred_out-rating) * P + lambda * M, for the per-N movies
    I_u=IO.*w_V(index_v,:) + lambda*w_U(index_u,:);		%% get the gradient of P = (pred_out-rating) * M + lambda * P, for the per-N users
    
    dw_V = zeros(num_v,num_factor);						%% same size of w1_M1, just ZERO, for adding the values from Ix_m
    dw_U = zeros(num_u,num_factor);



        for i=1:num_v
            for f=1:length(S2(i,:))
                dw_U(index_u(i),:)=dw_U(index_u(i),:)+Gamma*trustM(i,f)*S1(i,f)*S2(i,f)*(w_U(index_u(i),:)-w_U(index_u(f),:)); % Individual-based Regularization from Michael Lyu.
            end
        end

                    
    for i=1:N
        dw_V(index_v(i),:) =  dw_V(index_v(i),:) +  I_v(i,:);	%% the aa_v(i) is Movie-ID, ii is the natual order in Ix_M.
        dw_U(index_u(i),:) =  dw_U(index_u(i),:) +  I_u(i,:);	%% the aa_u(i) is User-ID, ii is the natual order in Ix_p.
    end                                                      %%%% Update movie and user features
    w_V_inc = momentum*w_V_inc + epsilon*dw_V/N*9;			%% momentum, epsilon and N are all parameters, to-be-adjusted.
    w_V =  w_V - w_V_inc;									%% update the latent feature values. and the w1_M1 is a global var, to be used during the epoch-loop
    w_U_inc = momentum*w_U_inc + epsilon*dw_U/N*9;
    w_U =  w_U - w_U_inc; %% and the w1_P1 is a global var, to be used during the epoch-loop
    
    % end 	%% come to hear, complete a cycle of update M and P features.
    
    %%%%%%%%%%%%%% Compute Predictions after Paramete Updates %%%%%%%%%%%% from here use the latest latent features to update the Ratings (pred_out)
    pred_out = sum(w_V(index_v,:).*w_U(index_u,:),2);				%% M (*) P
    f_s = sum( (pred_out - rating).^2 + 0.5*lambda*( sum( (w_V(index_v,:).^2 + w_U(index_u,:).^2),2)));%% calculate the difference, or the LOST, f_s%% [ (R - Rmf)^2 + 0.5*lambda*[ Mf^2 + Pf^2 ]fro ]fro%% refer to formula (4) of the PMF paper.
    err_train(epoch) = sqrt(f_s/N);
    % save for prompt/display purpose (of training set)
    
    %%% Compute predictions on the validation set %%%%%%%%%%%%%%%%%%%%%%
    NN= length(probe_vec); % validation data
    index_u = double(probe_vec(:,1));		%% all the user_ID in probe_vec
    index_v = double(probe_vec(:,2));		%% all the movie_ID
    rating = double(probe_vec(:,3));		%% all the ratings
    pred_out = sum(w_V(index_v,:).*w_U(index_u,:),2) + mean_rating;		%% now, using the M and P to calculate prediction for probe_vec
    pred_out(find(pred_out>0.9))=0.9; % Clip predictions 		%% forcely make the ratings between r <= 5
    pred_out(find(pred_out<0.1))=0.1;							%% forcely make the ratings between 1 <= r
    err_valid(epoch) = sqrt(sum((pred_out- rating).^2)/NN);			%% again, calculate the SQRT of the difference (of validation set)
    fprintf(1, 'epoch %4i ÑµÁ· RMSE %6.4f  ²âÊÔ RMSE %6.4f  \n', ...
        epoch, err_train(epoch), err_valid(epoch));	%% epoch 1 batch 9, Training RMSE 12.6473  Test RMSE 36.8897
    if (rem(epoch,10))==0					%% control the times of iterations (10 times only)
        save pmf_weight w_V w_U		%% save to pmf_weight for further calculation (BPMF)
    end
end