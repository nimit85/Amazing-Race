# Runs through all screenshots in the directory, asks for a label
# Stores the label in 
function generate_ground_truth_set( test_directory )
	 # Read in image information - all images should be called
	 #                                      
         # screenshotxxxxxxx.tiff
	 #                                      
         # This format can change if we want it to though
	 
	 clustered_images = {};
	 ground_truth = {};
	 truth_file = [test_directory "ground_truth.mat"];

	 if ( exist ( truth_file ) )
	   load ( truth_file );
	 end
	 
         files = readdir(test_directory);
         for f = size(files)(1):-1:1
             if ( size ( regexp(files{f}, "screenshot.*\.tiff") )(2)  == 0 )
                files(f) = "";
             else
		 size ( regexp(files{f}, "screenshot.*\.tiff") )(2)
		 files{f}
                 files{f} = [test_directory files{f}];
             end
         end

	 for f = size(files)(1):-1:1
	     #SUPER INEFFICIENT WHY ARE CELL ARRAYS SO WEIRD! AHHHHHHHHHHH.
	     already_clustered = 0;
	     for j = 1:size(clustered_images)(2)
		 if ( strcmp ( clustered_images{j}, files{f} ) == 1 )
		    already_clustered = 1;
		    break;
		 end
	     end

	     if ( already_clustered > 0 )
		continue;
	     end

	     # Gets the cluster index
	     imshow(files{f});
	     index = input ( "Insert the community number for image: \
" );

	    
	     if ( index )
		
	       # Manual break if the corpus is too big
	       if ( index == 0 )
		 break;
	       end
	       
	       # Adds to appropriate cluster
	       [num_col, num_row] = size(ground_truth);
	       if ( num_row < index )
		 ground_truth{index} = {};
	       end
	       ground_truth{index} = {ground_truth{index} files{f}};
	       clustered_images = {clustered_images files{f}};
	     else 
		  break;
	     end
	 end

	 #Saves when done
	 save truth_file ground_truth;
end
