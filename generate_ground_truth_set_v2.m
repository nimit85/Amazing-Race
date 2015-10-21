% Runs through all screenshots in the directory, asks for a label
% Stores the label in
function generate_ground_truth_set_v2(test_directory)
% Read in image information - all images should be called
%
% screenshotxxxxxxx.tiff
%
% This format can change if we want it to though - changed to numbers
% everywhere, instead of using strings
close all;

ground_truth = zeros(1,2);
truth_file = [test_directory '/ground_truth.mat'];

if exist(truth_file,'file')
    load(truth_file);
end

disp([ground_truth, size(ground_truth,1) + 1]);


files = dir([test_directory, '/*.tiff']);
tobedoneFiles = [];

% only track files that have not been clustered yet
for f = 1 : size(files,1)
    if size(regexp(files(f).name,'screenshot*'),2)  ~= 0
        addIndex = str2double(strrep(strrep(files(f).name,'screenshot','')...
            ,'.tiff',''));
        tobedoneFiles = [tobedoneFiles, addIndex];
    end
end

for f = 1 : length(tobedoneFiles)
    if any(ground_truth(:,2) == tobedoneFiles(f))
        continue;
    end
    
    % This wont be required when file naming is changed.
    if tobedoneFiles(f) < 10
        I = imread([test_directory '/screenshot000' int2str(...
            tobedoneFiles(f)) '.tiff']);
    elseif tobedoneFiles(f) >= 10 && tobedoneFiles(f) < 100
        I = imread([test_directory '/screenshot00' int2str(...
            tobedoneFiles(f)) '.tiff']);
    elseif tobedoneFiles(f) >= 100 && tobedoneFiles(f) < 1000
        I = imread([test_directory '/screenshot0' int2str(...
            tobedoneFiles(f)) '.tiff']);
    else
        I = imread([test_directory '/screenshot' int2str(...
            tobedoneFiles(f)) '.tiff']);
    end
    
    % show image so user can decide can annotate with cluster number
    imshow(I);
    index = input ('Insert the cluster number for image:');
    
    if index
        % Manual break if the corpus is too big
        if index == 0
            break;
        end
        
        % Adds to appropriate cluster
        % ground truth format - [image number, cluster number]
        ground_truth(tobedoneFiles(f),:) = [tobedoneFiles(f), index];               
    else
        break;
    end
end

% save_command = sprintf('save %s ground_truth clustered_images',truth_file);
% eval(save_command);
save(truth_file,'ground_truth');
end