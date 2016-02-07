%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Holds information about the working information directory and active 
%    teams for the Amazing Race Prediction project
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef AmazingModel < handle
    properties
        directory
        teams
        clusters
    end
    
    methods
        function obj = AmazingModel()
            obj.directory = Directory();
            obj.teams = {};
        end
        
        %% Appends a new team to the end of the list of active teams 
        %%    Team names CAN be duplicates (not representing the same team)
        function success = AddTeam(obj, team_name, membership_size)
            [~, ty] = size(obj.teams);
            obj.teams{ty + 1} = Team(team_name, membership_size);
            success = AmazingUtility.SUCCESS;
        end 
        
        %% Call through to the underlying team calculations.
        function CalculateTeamStatistics(obj)
            for team = obj.teams
                team{1}.CalculateStatistics();
            end
        end
    end
end