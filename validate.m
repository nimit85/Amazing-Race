% Validate is a function to automatically test a clustering function
% against a known ground truth. The test directory passed SHOULD have
% the trailing '/'
% 
% cluster_function should take a vector of strings representing the
% names of the (Amazing Race) image files to be clustered. It should
% return a cell array consisting of cell arrays of strings that represent
% the clusters.
% 
% similarity_function should take two cell arrays. Each entry in each
% cell array should be a cell array of strings, representing the members
% of each cluster. It returns a 'goodness-of-fit' measure for the
% detected cluster structure as measured against the given ground truth
function similarity_score = validate(cluster_function, ...
				      similarity_function, test_directory)
	 % Read in image information - all images should be called
	 % screenshotxxxxxxx.tiff
	 % This format can change if we want it to though
	 files = readdir(test_directory);
	 for f = size(files,1):-1:1
	     if ( size ( regexp(files{f}, 'screenshot.*\.tiff'),2) == 0 )
		files(f) = '';
	     else
		 files{f} = [test_directory files{f}];
	     end
	 end
	 
	 % Run the clustering algorithm
	 detected = feval (cluster_function, files);

	 % Read in the ground truth from a file in the same directory
	 load ([test_directory 'ground_truth.mat']);

	 % Return the similarity measure
	 similarity_score =  feval (similarity_function,ground_truth,detected);
end 
