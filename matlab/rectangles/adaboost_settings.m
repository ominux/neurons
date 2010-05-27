%% PARAMETERS

EXP_NAME = 'TEST';          % name of experiment

N_features = 2000;          % # of features to consider each boosting round
N_pos = 5000;               % # of requested positive training examples
N_total = 50000;            % # of total training examples
N_SAMPLES = 20000;          % # of negative examples to use when choosing optimal learner parameters
T = 5000;                   % maximum rounds of boosting
VJ = 0;                     % 1 = viola jones rectangles / 0 = our rectangles
RANK = 8;                   % rectangle complexity
CONNECTEDNESS = 0.7;        % probability rectangles will be connected
ANORM = 1;                  % 1 = area-based normalization / 0 = no normalization

IMSIZE = [24 24];           % size of the classification window

host = hostname;                            % compute hostname
date = datestr(now, 'mmmddyyyy-HHMMSS');    % the current date & time

%% folders containing the data sets
DATA_FOLDER = '/osshare/Work/Data/face_databases/EPFL-CVLAB_faceDB/';
pos_train_folder = [DATA_FOLDER 'train/pos/'];
neg_train_folder = [DATA_FOLDER 'non-face_uncropped_images/'];
pos_valid_folder = [DATA_FOLDER 'test/pos/'];
neg_valid_folder = [DATA_FOLDER 'non-face_uncropped_images/'];

results_folder = [pwd '/results/'];
if ~exist(results_folder, 'dir')
    mkdir(results_folder);
end

%% COMPILE ANY MISSING MEX FILES

if ~exist(['weight_sample_mex.' mexext], 'file')
     compile_weight_sample;
end
if ~exist(['AdaBoostClassify_mex.' mexext], 'file')
     compile_weight_sample;
end
if ~exist(['HaarFeature_mex.' mexext], 'file')
     compile_weight_sample;
end
