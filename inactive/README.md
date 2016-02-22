VERSION 0.0.1 -------------------------------------------------------------------
All framework logic for:

(i) generating a test set folder consisting of a set of
  images and a ground_truth clustering. Run generate_ground_truth_set on a folder.
  It will iterate through all screenshotxxxx.tiff files, showing each to the user,
  who can then enter a cluster label ( should be 1 - 20, see below ). The clusters
  are saved in ground_truth.mat in a cell format (cell{1} = first cluster, etc).

(ii) Running a clustering algorithm and examining the results with a validater.
     Validate.m has a function validate(), which takes a handle to a clustering
     algorithm ( which should take a cell array of strings as input and return
     a cell array of cell arrays of strings that represent clusters ), a handle to
     a validation algorithm ( which takes the clusterer output and calculates a 
     metric value ), and a directory ( which holds the images and ground truth
     clustering to use). 

Example: run validate(@subset_distance_hierarchical, @stub_verifier, "FirstHundred/")
	 [NOTE: the trailing / NEEDS TO BE THERE]
   After adding the FirstHundred directory (or change the directory passed). Should
   return 0.24, but that's because the validater is just a stub which returns 0.24.

Questions about this release? Email thomp80n2pn@gmail.com (or call)
---------------------------------------------------------------------------------

# Amazing-Race
Basic Repo
Segmentation code.
Stroke detection code.
