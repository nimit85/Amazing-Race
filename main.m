pkg load image
pkg load statistics

%% Each file needs to start with the string 'screenshot'
files = readdir("../Images/");
for f = size(files)(1):-1:1
	  if ( size ( files{f} ) < 10  )
    files(f) = "";
    continue;
  end
  if ( sum ( files{f}(1:10) == "screenshot" ) != 10 )
    files(f)
    files(f) = "";
  end
end

components = {};
for f = 1:100 %size(files)(1
%% Crop the image
  components{f} = amazing_race_segmenter( ["../Images/" files{f}]  );
end

size(components)

%% Cluster the images
distances = [];
for i = 1:size(components)(2)
    for j = i+1:size(components)(2)
      distances = [distances subimage_distance(components{i}, components{j})];
    end
end

%%Hierarchical clustering
link_tree = linkage ( distances, 'average' );

clusters = get_level (size(components)(2), link_tree, 15)
