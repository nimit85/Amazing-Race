% validateResults is a function to automatically test a clustering function
% against a known ground truth.

% similarity_function should take 2 integer arrays. Each entry in the
% integer array lists its cluster membership. It returns a 
% 'goodness-of-fit' measure for the detected cluster structure as measured 
% against the given ground truth

function wt_matching = validateResults(test_directory,numClust)
% Read in image information - all images should be called
% screenshotxxxxxxx.tiff
% This format can change if we want it to though
files = dir([test_directory '/*.tiff']);

% Run the clustering algorithm
% change option to reflect season-based changes (mainly font changes)
option = 1;
cluster_function = @clusterResults;
detected = cluster_function(test_directory, files, option, numClust);

% Read in the ground truth from a file in the same directory
load([test_directory '/ground_truth.mat']);

% Return the similarity measure
similarity_function = @getFScore;
wt_matching = similarity_function(ground_truth(:,2), detected);
end
