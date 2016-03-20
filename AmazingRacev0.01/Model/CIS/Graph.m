%{
% @function G = Graph(model, bound_x, bound_y, ...
%      similarity_threshold, white_thresh)
%
% @param bound_x, bound_y The boundary to crop the image to in order to 
%                           focus on important area
   %     (570:600) (250:750) for full screenshot
% @param similarity_threshold The minimum value of the similarity between
%                             two images for them to be considered 
%                             connected in the graph.
%       0.7 ish seems to work
% @param white_thresh The minimum value for a pixel to be considered active
%                       (white pixels in our case)
%      100-120
%
% @param min_white_pixels Threshold for the minimum number of pixels that
%                need to be 'white' (value about white_thresh), in order
%                for the image to be considered for clustering 
%
%       1000
%
% @return G An edge-list representation of a network. G['A'] holds the
%           neighbors of the node 'A'. If 'B' is a neighbor, G['A']['B']
%           holds the similarity value of the images (weight of the edge)
%}
function G = Graph( model, bound_x, bound_y, ...
    similarity_threshold, white_thresh, min_white_pixels )    
    % Goes through files in directory
    [file_size, ~] = size(model.directory.images);

    % Tracking data structures
    G = containers.Map;
    loaded_files = cell(file_size, 1);
    file_density = zeros(file_size, 1);

    % Reads files, crops them, removes large/small areas of picture and
    %     saves them in memory (costly for large sets?) Also caches the 
    %     number of white pixels in each screenshot of interest.
    h_wait = waitbar(0, 'Reading And Analyzing Files');
    for i = 1:file_size
        if mod(i, 100) == 0
            waitbar(i / file_size, h_wait);
        end
        I = imread([model.directory.images{i}]);
        I = remove_large_and_small(I(bound_x, bound_y) > white_thresh);
        loaded_files{i} = I;
        file_density(i) = sum(sum(I));
    end
    
    
    % Goes through all pairs of images and calculates the similarity.
    % If they are similar enough, an edge is added to the graph.
    
    waitbar(0, h_wait, 'Calculating Similarities for Graph')
    for i = 1:file_size
        if mod(i,100) == 0
            waitbar(i / file_size, h_wait);
        end
        % Skips screenshots that don't have enough whitespace in them for 
        %    text (arbitrary threshold)
        if (sum(sum(loaded_files{i})) < min_white_pixels)
            continue            
        end
        for j = i+1:file_size
            sim = jaccard_pixels(loaded_files{i}, loaded_files{j}, min(file_density(i), file_density(j)));
            if ( sim > similarity_threshold )
                if ( isKey(G, model.directory.images{i}) )
                    submap = G(model.directory.images{i});
                    submap(model.directory.images{j}) = sim;
                else
                    G(model.directory.images{i}) = containers.Map;
                    submap = G(model.directory.images{i});
                    submap(model.directory.images{j}) = sim;
                end

                if ( isKey(G, model.directory.images{j}) )
                    submap = G(model.directory.images{j});
                    submap(model.directory.images{i}) = sim;
                else
                    G(model.directory.images{j}) = containers.Map;
                    submap = G(model.directory.images{j});
                    submap(model.directory.images{i}) = sim;
                end
            end
        end
    end
    
    close(h_wait);
end

%{
% @function m = matching_pixels ( i1, i2, dens )
%
% @param i1, i2 Binary matrices to compare
% @param dens Basically just a normalizer. Not sure why it's called dens
%
% @return m : Fraction of similar white pixels (in i1 and i2) to dens,
%             which should probably be the number of white pixels in
%             the binary matrix with the lower number of pixels.
%}
function m = matching_pixels ( i1, i2, dens )    %#ok<*DEFNU>
    sim = i1 & i2;
    m = sum(sum(sim)) / dens;
end

function m = jaccard_pixels ( i1, i2, ~ ) %#ok<*DEFNU>
    m = ( sum(sum(i1 & i2)) / sum( sum( i1 | i2 )) );
end