% Script name: SIMULATION_DRIVER.m
%% =========== Version 1.10 Control Date ===========
%% Date Created: May.08.2016
%% Ver.1.10.0
%%
%% Date Modified: Jun.09.2016
%% Add a setupInfo variable to collect some integers;
%% Ver.1.10.1
%%
%% Date Modified: Jun.13.2016
%% Use dataGeneratingLink.m rather than dataGenerating.m
%% Use estimateLink.m rather than estimate.m
%% Date Modified: Nov.27.2016
%% Add one more input for dataGenerating.m
%% which is a container cell containing b1-b9 handles
%% Ver.1.10.2
%%
%% Remark:(some related versions)
%% {
%% Date Modified: TBD
%% Change SIM_SETUP for CV only
%% Ver.1.11.0
%%
%% Date Modified: TBD
%% Change SIM_SETUP for RASE only
%% Ver.1.12.0
%%
%% Date Modified: TBD
%% Change SIM_SETUP for CV and RASE
%% Ver.1.13.0
%% }
%%
%% ========== Description =======
%% This is a driver script that organizes every functions and scripts
%% to finish simulation process (neither for cross-validation nor
%% RASE).
%%
%% =========== Def. of Variables ======
%% gridPoint (vector):
%% the vector of grid-points;
%% (Defined by SIM_SETUP)
%% (Ver. default/current)
%%
%% windowSize (real number):
%% width of every local window;
%% (Defined by SIM_SETUP)
%% (Ver. default/current)
%%
%% simRound (integer):
%% # of simulations executing;
%% (Defined by SIM_SETUP)
%% (Ver. default/current)
%%
%% sampleSize (integer):
%% sample size in simulation;
%% (Defined by SIM_SETUP)
%% (Ver. default/current)
%% 
%% paraNum (integer):
%% # of independent variables;
%% (Defined by SIM_SETUP)
%% (Ver. default/current)
%%
%% resNum (integer):
%% # of possible values for response var.;
%% (Defined by SIM_SETUP)
%% (Ver. default/current)
%%
%% estimateCoefficientCube (3D matrix cube):
%% dim: ((resNum-1)*paraNum*2, gridNum, simRound)
%% the matrix store all estimated Coefficients;
%% also include a and b, which is in linear expansion;
%% (Defined by SIM_SETUP)
%% (Ver. default/current)
%%
%% intercept (boolean/integer):
%% '1' means with intercept, '0' means without intercept;
%% remark: if w/ intercept, paraNum = # of ind. var. + 1;
%% if w/out intercept, paraNum = # of ind. var.;
%% (Defined by SIM_SETUP)
%% (Ver. default/current)
%%
%% i (integer) :
%% the index of the round of simulations, min is 1 and max is simRound;
%% (Ver. default/current)
%%
%% data (matrix):
%% first column is response variable
%% which is a matrix form, with 1st column "response var."
%% with the following columns are "intercept 1s" (optional)
%% with the following columns are "indepdendent var."
%% with the following columns are "time var."
%% with the following columns are "true coefficients";
%% (Ver. default/current)
%%
%% simulationResult (matrix):
%% first column is the vector of gridPoint;
%% with the following column is the first estimated coefficient;
%% with the following column is the first true coefficient;
%% ...
%% with the following column is the last estimated coefficient;
%% with the following column is the last true coefficient;
%% (Ver. default/current)
%%
%% setupInfo (vector):
%% the 1st element is simRound;
%% the 2nd element is sampleSize;
%% the 3rd element is paraNum;
%% the 4th element is resNum;
%% the 5th element is intercept;
%% (Defined by SIM_SETUP.m)
%% (Ver. 1.10.1)
%%
%% ========== Def. of Functions ========
%% dataGenerating ():
%% Output: dataset generated (defined variable data)
%% Input: sampleSize, paraNum, resNum, intercept
%% (Ver. default/current)
%% Input: setupInfo, handles
%% (Ver. Ver.1.10.1)
%%
%% dataGeneratingLink ():
%% Output: Same as dataGenerating;
%% Input: Same as dataGenerating + i;
%% Remark: 
%% To save time and make code run successfully every time,
%% this function will read multiple *.csv files from disk.
%% These files are generated by dataGenerating function,
%% and tested by mnl.m,
%% which is a process using built-in function mnrfit.m;
%% (Ver. 1.10.2)
%%
%% estimate ():
%% Output: one page of estimateCoefficientCube
%% Input: data, paraNum, resNum, intercept, gridPoint, windowSize
%% (Ver. default/current)
%%
%% estimateLink ():
%% Output: Same as estimate;
%% Input: Same as estimate + i;
%% (Ver. 1.10.2)
%%
%% manipulateResult ():
%% Output: simulationResult;
%% Input: estimateCoefficientCube, gridPoint, paraNum, resNum, b1~b9;
%% (Ver. default/current)
%%

%% ========== Def. of Scripts ========
%% SIM_SETUP: set up every parameters required in simulation
%% (Ver. default/current)
%%
%% CONDITION_DISPLAY: display setupInfo and windowSize information
%% (Ver. default/current)
%%
%% COEFFICIENT_PLOT: plot the estimated coefficients and true coefficients
%% (Ver. default/current)
%%

%% =========== Def. of Cotainers ======
%% handles (cell)
%% the dimension of the cell is 9 * 1,
%% a container that contains function handles from b1 to b9;
%% (Defined by SIM_SETUP)
%% (Ver. default/current)

%% ========== CODING START ==========
SIM_SETUP;

SIM_CORE;
% % initial the dimension of "estimateCoefficientCube" again
% % since if not, compiler will warn us...
% % actually we have initialized it in SIM_SETUP.m
% simRound = setupInfo(1);
% paraNum = setupInfo(3);
% resNum = setupInfo(4);
% gridNum = length(gridPoint);
% 
% estimatemnrfitCoefficientCube = zeros( ...
%     (resNum-1)*paraNum, gridNum, simRound);
% 
% % estimateCoefficientCube = zeros((resNum-1)*paraNum*2, ...
% %     gridNum, simRound);
% 
% % Simulation starts:
% 
% for i = 1:simRound
% 
% %     fprintf('');
% 
% %     The previous functions (no matter for generate or estimate)
% %     are both using quite many single parameters.
% %     The second ones are using a compacted parameter 
% %     setupInfo, which means we prefer the 
% %     Version 1.10.1.
% %     Hope you can understand.
% 
%     data = dataGenerating(setupInfo, handles);
% 
% %     data = dataGeneratingLink(i, setupInfo);
%     
% %     estimate:
% 
%     estimatemnrfitCoefficientCube(:,:,i) = ...
%         estimatemnrfit(data, setupInfo, gridPoint, windowSize);
%     
% %     estimateCoefficientCube(:,:,i) = ...
% %         estimate(data, setupInfo, windowSize);
% % 	estimateCoefficientCube(:,:,i) = ...
% % 		estimateLink(i, setupInfo, windowSize);
% 
% end
% 
% clear i;
% 
% % The purpose to clear data is because this variable has been changed
% % so many times. Remaining it won't give us any information which is
% % dramatic important. Especially when we use dataGeneratingLink function,
% % all the data can be seen from a folder.
% 
% % clear data;
% 
% clear simRound paraNum resNum gridNum;
% 
% % When simulation ended, it is required to do some manipulation for the
% % result.
% % The first one is also using too many single variables as parameters,
% % we use setupInfo in the Version 1.10.1.

% simulationResult = manipulateResult( ...
%     estimateCoefficientCube, gridPoint, paraNum, resNum, ...
%     b1, b2, b3, b4, b5, b6, b7, b8, b9);
% simulationResult = manipulateResult(estimateCoefficientCube, ...
%     setupInfo, gridPoint, b1, b2, b3, b4, b5, b6, b7, b8, b9);

% simulationResult = manipulateResult(estimateCoefficientCube, ...
%     setupInfo, gridPoint);

% This statement maybe deleted later.
% clear gridPoint;


% This script will help us to display information we need to know about the
% simulation.

% CONDITION_DISPLAY;

% This script will give us estimated plot graphs.

% COEFFICIENT_PLOT;

%% ========== CODING END ==========