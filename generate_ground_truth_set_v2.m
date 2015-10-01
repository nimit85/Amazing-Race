% Runs through all screenshots in the directory, asks for a label
% Stores the label in
function generate_ground_truth_set_v2(test_directory)
% Read in image information - all images should be called
%
% screenshotxxxxxxx.tiff
%
% This format can change if we want it to though - changed to numbers
% everywhere, instead of using strings

clustered_images = [];
ground_truth = zeros(1,2);
truth_file = [test_directory '/ground_truth.mat'];

if exist (truth_file,'file')
    load (truth_file);
end

clustered_images
next_image = size(clustered_images,2) + 1;
disp(next_image);

files = dir([test_directory, '/*.tiff']);
tobedoneFiles = [];

% only track files that have not been clustered yet
for f = size(files,1) : -1 : 1
    if size(regexp(files(f).name,'screenshot*'),2)  ~= 0
        addIndex = str2double(strrep(strrep(files(f).name,'screenshot',''),'.tiff',''));
        tobedoneFiles = [tobedoneFiles, addIndex];
    end
end

for f = 1 : length(tobedoneFiles)
    % SUPER INEFFICIENT WHY ARE CELL ARRAYS SO WEIRD! AHHHHHHHHHHH.
    if intersect(clustered_images,tobedoneFiles(f))
        continue;
    end
    
    % Gets the cluster index
    
    % this wont be required when file naming is changed.
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
    imshow(I);
    index = input ('Insert the community number for image:');
    
    if index
        % Manual break if the corpus is too big
        if index == 0
            break;
        end
        
        % Adds to appropriate cluster
        [~, num_row] = size(ground_truth);

        % will always fail when the ground truth file is empty, or am I
        % missing something here? Had to commend to run code.
%         if num_row < index
%             ground_truth(index) = [];
%         end
        
        % ground truth format - [cluster number, image number]
        ground_truth(index,:) = [index, tobedoneFiles(f)];
        clustered_images(next_image) = tobedoneFiles(f);
        next_image = next_image + 1;
    else
        break;
    end
end

% I dont exactly understand what you're doing here, can you explain? Are
% you attempting to simply print a message to screen?
% save_command = sprintf('save %s ground_truth clustered_images',truth_file);
% eval(save_command);
save(truth_file,'clustered_images');
end