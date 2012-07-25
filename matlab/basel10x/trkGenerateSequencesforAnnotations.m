function [] = trkGenerateSequencesforAnnotations(folder, resultsFolder, SeqIndexStr)

% define the folder locations and filenames of the images
Gfolder = [folder 'green/'];
Rfolder = [folder 'red/'];
Gfiles = dir([Gfolder '*.TIF']);%#ok
Rfiles = dir([Rfolder '*.TIF']);

if ~exist('TMAX', 'var'); TMAX =  length(Rfiles); end; % number of time steps

R = trkReadImages(TMAX, Rfolder);
% G = trkReadImages(TMAX, Gfolder);
RG = cell(size(R));

for t = 1:TMAX
    %G{t} = uint8(255*mat2gray(G{t}));
    R{t} = 255-uint8(255*mat2gray(R{t}));
    G{t} = zeros(size(R{t}), 'uint8');
    RG{t} = zeros(size(R{1}, 1), size(R{1}, 2), 3, 'uint8');
    RG{t}(:, :, 1) = R{t};
    RG{t}(:, :, 2) = G{t};
end

movfile = [SeqIndexStr 'OriginalRed'];
trkMovie(RG, resultsFolder, resultsFolder, movfile); fprintf('\n');
