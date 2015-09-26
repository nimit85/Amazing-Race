# A clustering function that takes a list of Amazing Race Image files,
# uses the segmenter to find white connected components in the text
# area of the screenshot, calculates distances between images using a
# made-up metric similar to some sort of weighted-manhattan distance
# thing, and then uses hierarchical clustering (with average
# similarity considered for merging) to find clusters.
#
#@TODO ( James ) figure out a way to rip out the number of clusters so
#that it is a parameter. (Or use automatic cluster number determination?)
function clusters = subset_distance_hierarchical( image_list )
pkg load image
pkg load statistics

components = {};
for f = 1:size(image_list)(1)
%% Crop the image
  components{f} = amazing_race_segmenter( image_list{f}  );
end

%% Cluster the images
distances = [];
for i = 1:size(components)(2)
    for j = i+1:size(components)(2)
      distances = [distances subimage_distance(components{i}, components{j})];
    end
end

%%Hierarchical clustering
link_tree = linkage ( distances, 'average' );

##Cut the hierarchical tree at some point
clusters = get_level (components, link_tree, 15);

end #function subset_distance_hierarchical
