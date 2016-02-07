function [e_in_avg, e_out_avg, avg_run_time] = single_run(folder_list, max_iter)
    tic;
    % Load all information - features and positions
    all_features = {};
    for dir_group = folder_list
        group_features = {};
        for dir = dir_group{1}
            ffile = ['../Amazing-Race-Video/' char(dir{1}) '/features.mat'];
            pfile = ['../Amazing-Race-Video/' char(dir{1}) '/positions.mat'];
            load(char(ffile))
            load(char(pfile))
            
            [teams_appeared, ~] = size(positions); %#ok<NODEF> 
                                                    %Loaded from file
            [current_teams, ~] = size(group_features);
            [feature_teams, feature_count_plus_one] = size(features);
            
            if (teams_appeared < current_teams)
               group_features = group_features(1:teams_appeared, :); 
            end   
            if (teams_appeared < feature_teams)
               features = features(1:teams_appeared, :);
            end
           
            group_features = [group_features, ...
                features(:, 2:feature_count_plus_one - 1), ...
                positions(:, 2)]; %#ok<AGROW>
        end
        all_features = [all_features; {group_features}]; %#ok<AGROW>
    end
    
    % Each chunk represents a season
    [chunks, ~] = size(all_features);
    E_in = 0;
    E_out = 0;
    
    % Hold out the i^th chunk - one at a time
    for i = 1:chunks
        X = [];
        y = [];
        
        for j = 1:chunks
            if ( i == j )
                continue
            end
            
           [team_count, ~] = size(all_features{j});
           % Combine all but i
           local_features = all_features{j};
           X = [X; local_features]; %#ok<AGROW>
           
           % y all but i
           new_y = ones(1, team_count);
           new_y(4:team_count) = -1;
           y = [y, new_y];        %#ok<AGROW>
        end
        % 'Train' pPLA algorithm on data with one season left out
        X = cell2mat(X);
        [e_in, w] = pPLA(X, y, max_iter);
        e_in
        y' - sign(X * w')
        
        % Construct data for left out season
        left_out = all_features{i};
        [team_count, ~] = size(left_out);
        X = cell2mat(left_out);
        y = ones(1, team_count);
        y(4:team_count) = -1;
 
        % Find the error for the left out season
        e_out = CalcErrors(X, y, w);
        
        % Record stats
        E_in = E_in + e_in;
        E_out = E_out + e_out;
    end
    
    %Report Average
    e_in_avg = E_in / chunks;
    e_out_avg = E_out / chunks;
    avg_run_time = toc;
end