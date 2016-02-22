% INPUT: cluster_function should take a vector of strings representing the
% names of the (Amazing Race) image files to be clustered. It also takes
% the directory name containing the image files, option to determine which
% image cropper to use based on seasonal changes in text, and number
% of clusters.
% OUTPUT: It should return the cluster membership of the image files

function indexPos = clusterResults(test_directory, fileList, ...
    option, numClust)
% Currently option is not used - will be used when different clustering
% files are used for different seasons based on text-based changes
% read image files, chop down to only text area (***apply segmentation
% maybe, undecided)

if option == 1
    matSize = {323:356,144:500};
end
m = max(matSize{1}) - min(matSize{1}) + 1;
n = max(matSize{2}) - min(matSize{2}) + 1;

allIm = zeros(size(fileList,1),m*n,1);
for iter = 1 : size(fileList,1)
    imFile = imread([test_directory, '/', fileList(iter).name]);
    
    imCrop = rgb2gray(imFile(matSize{1},matSize{2},:));
    allIm(iter,:) = reshape(imCrop,m*n,1);
end

indexPos = kmeans(allIm,numClust);
end