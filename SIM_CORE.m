% initial the dimension of "estimateCoefficientCube" again
% since if not, compiler will warn us...
% actually we have initialized it in SIM_SETUP.m
simRound = setupInfo(1);
paraNum = setupInfo(3);
resNum = setupInfo(4);
gridNum = length(gridPoint);

estimatemnrfitCoefficientCube = zeros( ...
    (resNum-1)*paraNum, gridNum, simRound);

% estimateCoefficientCube = zeros((resNum-1)*paraNum*2, ...
%     gridNum, simRound);

% Simulation starts:

for i = 1:simRound

%     fprintf('');

%     The previous functions (no matter for generate or estimate)
%     are both using quite many single parameters.
%     The second ones are using a compacted parameter 
%     setupInfo, which means we prefer the 
%     Version 1.10.1.
%     Hope you can understand.

    data = simDataGenerating(setupInfo, handles);

%     data = dataGeneratingLink(i, setupInfo);
    
    data = simDataNorm(setupInfo, data);    % Normalize the independent 
        % variables so that in the process 
        % of the estiamation, there should not be a feature dominates
        % others.
    
    defaultIndex = 0;    % 0 means the 0th case is default and so on.
    data = simDataModifyDefault(data, defaultIndex);    % By changing the 
        % default case (y = 0) would change the estimation of coefficients 
        % in our model. These two lines of codes are just for debuging if 
        % we generate the data in the correct way.
    
%     estimate:

    estimatemnrfitCoefficientCube(:,:,i) = ...
        estimatemnrfit(data, setupInfo, gridPoint, windowSize);
    
%     estimateCoefficientCube(:,:,i) = ...
%         estimate(data, setupInfo, windowSize);
% 	estimateCoefficientCube(:,:,i) = ...
% 		estimateLink(i, setupInfo, windowSize);

end

clear i;

% The purpose to clear data is because this variable has been changed
% so many times. Remaining it won't give us any information which is
% dramatic important. Especially when we use dataGeneratingLink function,
% all the data can be seen from a folder.

% clear data;

clear simRound paraNum resNum gridNum;

% When simulation ended, it is required to do some manipulation for the
% result.
% The first one is also using too many single variables as parameters,
% we use setupInfo in the Version 1.10.1.