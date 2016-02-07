%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @class Team
%
% Defines a group of screenshots which should be conceptually similar in
%     some way. For instances, they all have the same team portrayed in
%     them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef Team < handle
    properties
        name
        
        membership  % Indicator vector for images that are associated with
                    % this team. [directory_images(membership) are images
                    % of this team]
        stats
    end
    
    methods
        function obj = Team( team_name, membership_size )
            obj.name = team_name;
           
            obj.stats = [];
            obj.membership = zeros(membership_size);
        end
        
        function CalculateStatistics(obj)
            % Total # of screenshots for the team
            obj.stats(1) = sum(obj.membership);
            
            [~, n] = size(obj.membership);
            
            starts = [];
            next_start = 1;
            ends = [];
            next_end = 1;
            active = false;
            
            for i = 1:n
                if ( obj.membership(i) && ~active)
                   starts(next_start) = i;
                   next_start = next_start + 1;
                   active = true;
                elseif ( ~obj.membership(i) && active )
                   ends(next_end) = i;
                   next_end = next_end + 1;
                   active = false;
                end
            end
            % # of consecutive runs of screenshots for the team 
            [~, m] = size(starts);
            
            if ( m > 0 )            
            obj.stats(2) = m;
            
            sum_lengths = 0;
            sum_intervals = 0;
            for i = 1:m
                sum_lengths = sum_lengths + (ends(i) - starts(i));
                if ( i < m )
                    sum_intervals = sum_intervals + ends(i+1) - starts(i);
                end
            end
            
            % Avg length of consecutive runs
            obj.stats(3) = sum_lengths / m;
            % Avg time between
            if ( m > 1 )
                obj.stats(4) = sum_intervals / ( m - 1 );
            else
                obj.stats(4) = 0;
            end
            
            % Coverage
            obj.stats(5) = ends(m) - starts(1);
            else 
                obj.stats(2) = -1;
                obj.stats(3) = -1;
                obj.stats(4) = -1;
                obj.stats(5) = -1;
            end
        end
    end
end