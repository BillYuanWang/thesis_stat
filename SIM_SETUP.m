%% Script name: SIM_SETUP.m
%% =========== Version 1.10 Control Date ===========
%% Date Created: May.08.2016
%% Create SIM_SETUP for simulation only
%% Add function handles for data generating
%% Ver.1.10.0 (default)
%%
%% Date Modified: Jun.08.2016
%% Created a variable named "setupInfo" to collect some individual var.s
%% Date Modified: Nov.26.2016
%% Create a container cell to store handles for later use
%% Ver.1.10.1
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
%% This code should be run before simulation.
%% It will be called in SIMULATION_DRIVER.m.
%% Each parameter could be modified if necessary.
%% This "set up" is only for simple simulation
%% without cross-validation method, which means
%% window size (bandwidth) is pre-fixed.
%%
%% =========== Def. of Variables ======
%% gridPoint (vector):
%% the vector of grid-points;
%% (Ver. default/current)
%%
%% windowSize (real number):
%% width of every local window, also called bandwidth;
%% (Ver. default/current)
%%
%% simRound (integer):
%% # of simulations executing;
%% (Ver. default/current)
%%
%% sampleSize (integer):
%% sample size in simulation;
%% (Ver. default/current)
%% 
%% paraNum (integer):
%% # of independent variables (some changes, see variable "intercept");
%% (Ver. default/current)
%%
%% resNum (integer):
%% # of possible values for response var.;
%% (Ver. default/current)
%%
%% estimateCoefficientCube (matrix cube):
%% dim: ((resNum-1)*paraNum*2, gridNum, simRound)
%% the matrix store all estimated Coefficients;
%% also include a and b, which is in linear expansion;
%% In this script, this variable is initialized only.
%% (Ver. default/current)
%%
%% intercept (boolean/integer):
%% '1' means with intercept, '0' means withour intercept;
%% Remark: if w/ intercept, paraNum = # of ind. var. + 1;
%% if w/out intercept, paraNum = # of ind. var.;
%% (Ver. default/current)
%%
%% setupInfo (vector):
%% collection of some of variables above;
%% the 1st element is simRound;
%% the 2nd element is sampleSize;
%% the 3rd element is paraNum;
%% the 4th element is resNum;
%% the 5th element is intercept;
%% (Ver. 1.10.1)
%%
%% ========== Def. of Functions ========
%% gatherInfo ();
%% Output: setupInfo;
%% Input: simRound, sampleSize, paraNum, resNum, intercept;
%% (Ver. 1.10.1)
%%
%% =========== Def. of Function Handles ======
%% b1~b9 (handles):
%% true functions of the time variable;
%% (Ver. default/current)
%%

%% =========== Def. of Cotainers ======
%% handles (cell)
%% the dimension of the cell is 9 * 1,
%% a container that contains function handles from b1 to b9;
%% (Ver. default/current)
%%

%% ========== CODING START ==========
% clc;

% The codes below is used to clear all existing variables,
% if we cannot see clearly or if we want to avoid ambiguity.
prompt = 'Do you want to clear all variables? Y/N [Y]: ';
str = input(prompt,'s');
if isempty(str) || strcmp(str,'Y') || strcmp(str,'y')
    CLEANER;
else
    clear str;
end

simRound = 1;

%% ========= GENERATING SET UP =========
sampleSize = 20;

paraNum = 3;

resNum = 3;

% If the model includes intercept, the value of this var. should be 1
% otherwise it should be 0.
% intercept = 0;
intercept = 1;

handles = cell(10,1);

b1 = @(time)time;                   handles{1} = b1;
b2 = @(time)(time).^2;              handles{2} = b2;
b3 = @(time)(time).^3;              handles{3} = b3;
b4 = @(time)sin(time);              handles{4} = b4;
b5 = @(time)cos(time);              handles{5} = b5;
b6 = @(time)exp(time);              handles{6} = b6;
b7 = @(time)(-1)*(time).^2;         handles{7} = b7;
b8 = @(time)sin(2*time);         handles{8} = b8;
b9 = @(time)cos(2*time);         handles{9} = b9;
b10= @(time)(-1)*exp(time);         handles{10}= b10;

%% ========= ESTIMATION SET UP =========
gridPoint = -2:.04:2;

% Since this code is for fixed bandwidth only,
% this variable is an integer rather than a vector.
windowSize = .45;

% We don't fix the number of the grid points.
% We calculate it from the dimention of the grid-point-vector.
% gridNum = length(gridPoint);

% initial the dimension of "estimatemnrfitCoefficientCube"
% estimatemnrfitCoefficientCube = zeros( ...
%     (resNum-1)*paraNum, gridNum, simRound);

% initial the dimension of "estimateCoefficientCube"
% estimateCoefficientCube = zeros((resNum-1)*paraNum*2, ...
%     gridNum, simRound);

setupInfo = gatherInfo( ...
    simRound, sampleSize, paraNum, resNum, intercept);

%% ========= CLEAR MIDDLE STEP SET UP VARIABLES =========
% clear str;
clear prompt;
clear gridNum;
clear simRound sampleSize paraNum resNum intercept;
clear b1 b2 b3 b4 b5 b6 b7 b8 b9 b10;

%% ========== CODING END ==========
