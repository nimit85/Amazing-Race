%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Serves as the go-between for the Amazing Race Model and GUI. In essence
%    the Model should be able to be used stand-alone style, but some
%    logic leaked up to this level.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef AmazingController < handle
    properties
        gui
        model
        
        current_image_preview_index
    end
    
    methods
        function obj = AmazingController(gui, model)
            obj.gui = gui;
            obj.model = model;
            
            current_image_preview_index = -1;
        end
        
        function register_callbacks(obj)
            obj.gui.h_bdir.Callback = {@obj.choosedir_Callback};
            obj.gui.h_baddteam.Callback = {@obj.addteam_Callback};
            obj.gui.h_bdropteam.Callback = {@obj.dropteam_Callback};
            obj.gui.h_bcis.Callback = {@obj.cis_Callback};
            obj.gui.h_bcalcstats.Callback = {@obj.calcstats_Callback};
            obj.gui.h_bclear.Callback = {@obj.clearteam_Callback};
            obj.gui.h_bsave.Callback = {@obj.save_Callback};
            obj.gui.h_bloadS19.Callback = {@obj.s19_Callback};
            obj.gui.h_bloadS20.Callback = {@obj.s20_Callback};
            obj.gui.h_bloadS21.Callback = {@obj.s21_Callback};
            obj.gui.h_bloadS22.Callback = {@obj.s22_Callback};
            obj.gui.h_bloadS23.Callback = {@obj.s23_Callback};
            obj.gui.h_bloadS24.Callback = {@obj.s24_Callback};
            
            obj.gui.h_etargettop.Callback = ...
                {@obj.changeBoundaries_Callback};
            obj.gui.h_etargetbot.Callback = ...
                {@obj.changeBoundaries_Callback};
            obj.gui.h_etargetleft.Callback = ...
                {@obj.changeBoundaries_Callback};
            obj.gui.h_etargetright.Callback = ...
                {@obj.changeBoundaries_Callback};
            
            obj.gui.h_tresults.CellSelectionCallback = ...
                {@obj.selectfile_Callback};
            obj.gui.h_bprevimage.Callback = ...
                {@obj.prevfilepreview_Callback};
            obj.gui.h_bnextimage.Callback = ...
                {@obj.nextfilepreview_Callback};
        end
        
        %% Callback for user choosing working directory - causes
        %%     popup
        function choosedir_Callback(obj, ~, ~)            
            obj.model.directory.path = uigetdir(...
                '/home/james/Documents/Amazing-Race-Video/');
            tif_files = dir([obj.model.directory.path, '/*tif']);
            obj.model.directory.images = {tif_files.name};
            obj.model.directory.sortImages();
            obj.gui.h_tresults.Data = obj.model.directory.images';
            
            obj.gui.h_tdirnotice.String = obj.model.directory.path;
            [~, team_count] = size(obj.model.teams);
            for i = 1:team_count
                obj.model.teams{i}.membership = ...
                    zeros(size(obj.model.directory.images));
            end
        end
        
        %% User wants to add a new team
        function addteam_Callback(obj, ~, ~)
            % Checks for empty team name before added
            % Duplicates ARE ALLOWED
            new_team_name = obj.gui.h_eteam.String;
            if ( size(new_team_name) == 0 )
                return;
            end
            obj.model.AddTeam(new_team_name, ...
                size(obj.model.directory.images));
            obj.UpdateTeamData() % EXTREMELY inefficient, but this 
                                 % project needs to get got

            % Clears input box
            obj.gui.h_eteam.String = '';
            
            % Updates feedback panel
            obj.UpdateTeamFeedback();
        end
        
        %% User selects a file in directory tab
        function selectfile_Callback(obj, ~, event)
            obj.current_image_preview_index = event.Indices(1);
            I = imread(char(strcat(obj.model.directory.path, '/', ...
                obj.gui.h_tresults.Data{obj.current_image_preview_index, 1})));
            imshow(I, 'Parent', obj.gui.h_aimagepreview);
        end
        
        function nextfilepreview_Callback(obj, ~, ~)
            table_size = size(obj.gui.h_tresults.Data);
            
            obj.current_image_preview_index = ...
                mod(obj.current_image_preview_index + 1, table_size(1));
            
            I = imread(char(strcat(obj.model.directory.path, '/', ...
                obj.gui.h_tresults.Data{obj.current_image_preview_index, 1})));
            imshow(I, 'Parent', obj.gui.h_aimagepreview);
        end
        
        function prevfilepreview_Callback(obj, ~, ~)
            table_size = size(obj.gui.h_tresults.Data);
            
            obj.current_image_preview_index = ...
                mod(obj.current_image_preview_index - 1, table_size(1));
            
            I = imread(char(strcat(obj.model.directory.path, '/', ...
                obj.gui.h_tresults.Data{obj.current_image_preview_index, 1})));
            imshow(I, 'Parent', obj.gui.h_aimagepreview);
        end
        
        %% User want to delete a team
        function dropteam_Callback(obj, ~, ~)
            team_name = obj.gui.h_eteam.String;
            
            [~, team_count] = size(obj.model.teams);
            matches = [];
            
            for i = team_count:-1:1
                if ( strcmp(team_name, obj.model.teams{i}.name) )
                    matches = [matches i]; %#ok<AGROW>
                end
            end
            
            for m = matches
                obj.model.teams(m) = [];
                obj.gui.h_tfeatures.Data(m, :) = [];
            end
            
            % Clears input box
            obj.gui.h_eteam.String = '';
            
            % Updates feedback panel
            obj.UpdateTeamFeedback();            
        end
        
        function clearteam_Callback(obj, ~, ~)
            obj.model.teams = {};
            obj.gui.h_tfeatures.Data = {};
            % Updates feedback panel
            obj.UpdateTeamFeedback();
        end
        
        %% Refreshes the team information panel of the gui
        function UpdateTeamFeedback(obj)
            new_team_string = 'Teams: ';
            
            [teamnum, ~] = size(obj.gui.h_tfeatures.Data);
            
            if teamnum >= 1
                new_team_string = [new_team_string, ' ', ...
                    obj.gui.h_tfeatures.Data{1,1}];
            end
                
            for i = 2:teamnum
                new_team_string = [new_team_string ', ' ...
                    obj.gui.h_tfeatures.Data{i, 1}];
            end
            
            obj.gui.h_tteams.String = new_team_string;
        end
        
        function UpdateTeamData(obj)
            obj.gui.h_tfeatures.Data = {};
          
            [~, team_count] = size(obj.model.teams);
            if ( team_count == 0 )
                return;
            end
                
            [~, stat_count] = size(obj.model.teams{1}.stats);
            for i = 1:team_count
                obj.gui.h_tfeatures.Data{i, 1} = ...
                    char(obj.model.teams{i}.name);
                for j = 2:1 + stat_count
                    obj.gui.h_tfeatures.Data{i, j} = ...
                        obj.model.teams{i}.stats(j - 1);
                end
            end
        end
        
        %% Calls the clustering function and uses user prompts to designate
        %%    which teams are associated with which clusters.
        function cis_Callback(obj, ~, ~)
            % Full Screenshots      
            top = str2num(obj.gui.h_etargettop.String);
            if isempty(top)
                top = 570;
                warndlg('Invalid Top Value, using default (570)');
            end
            
            bot = str2num(obj.gui.h_etargetbot.String);
            if isempty(bot)
                bot = 600;
                warndlg('Invalid Bottom Value, using default (600)');
            end
            
            left = str2num(obj.gui.h_etargetleft.String);
            if isempty(left)
                left = 250;
                warndlg('Invalid Left Value, using default (250)');
            end
            
            right = str2num(obj.gui.h_etargetright.String);
            if isempty(right)
                right = 750;
                warndlg('Invalid Right Value, using default (750)');
            end
            
            table_size = size(obj.gui.h_tresults.Data);
             if table_size == 0
                return        
             end
             
             I = imread(char(strcat(obj.model.directory.path, '/', ...
                 obj.gui.h_tresults.Data{1,1})));
             [x, y, ~] = size(I);

             if ( top > x ) || (right > y)
                 warndlg('Boundary Overflow');
                 return
             end
             
             if ( top < 0 ) || ( bot < 0 )
                 warndlg('Boudnary Underflow');
                 return
             end
                 
             
            if ( top > bot ) || (right < left)
                warndlg('Invalid Boundaries');
                return
            end
            
            lambda = str2num(obj.gui.h_elambda.String);
            if isempty(lambda)
                lambda = 0.7;
                warndlg('Invalid Lambda Value, using default (0.7)');
            end
            
            whitethresh = str2num(obj.gui.h_ewthreshold.String);
            if isempty(whitethresh)
                whitethresh = 120;
                warndlg('Invalid Whitethresh Value, using default (120)');
            end
            
            min_white_pixels = str2num(obj.gui.h_ewmin.String);
            if isempty(min_white_pixels)
                min_white_pixels = 1000;
                warndlg('Invalid MinWhitePixels Value, using default (1000)');
            end
            
            G = Graph(obj.model, (top:bot), (left:right), lambda, ...
                whitethresh, min_white_pixels);
            
            partition = CIS(G);
            [~, xp] = size(partition);
            if ( xp == 0 )
                return
            end
            
            % Directory probably could have been passed whole
            c_team = ClassifyClusterController( ...
                    ClassifyClusterGUI(), ClassifyClusterModel( ...
                    partition, obj.model.directory.path, ... 
                    obj.model.directory.images), obj.model.teams);
            c_team.register_callbacks();
            c_team.show();
            uiwait(c_team.gui.fig);
        end
        
        function changeBoundaries_Callback(obj, ~, ~)
          table_size = size(obj.gui.h_tresults.Data);
          if table_size == 0
              return        
          end
            
          if isempty(obj.current_image_preview_index)
              return
          end
            
          I = imread(char(strcat(obj.model.directory.path, '/', ...
              obj.gui.h_tresults.Data{obj.current_image_preview_index, ...
              1})));
          
          top = str2num(obj.gui.h_etargettop.String);
            if isempty(top)
                top = 570;
                warndlg('Invalid Top Value, using default (570)');
            end
            
            bot = str2num(obj.gui.h_etargetbot.String);
            if isempty(bot)
                bot = 600;
                warndlg('Invalid Bottom Value, using default (600)');
            end
            
            left = str2num(obj.gui.h_etargetleft.String);
            if isempty(left)
                left = 250;
                warndlg('Invalid Left Value, using default (250)');
            end
            
            right = str2num(obj.gui.h_etargetright.String);
            if isempty(right)
                right = 750;
                warndlg('Invalid Right Value, using default (750)');
            end
            
            if (left < right) && (top < bot)
               [xx, yy, ~] = size(I);
               tt = max(0, top - 5);
               bb = min(xx, bot + 5);
               ll = max(0, left - 5);
               rr = min(yy, right + 5);
               I(tt:top, left:right, 1:2) = 255;
               I(bot:bb, left:right, 1:2) = 255;
               I(top:bot, ll:left, 1:2) = 255;
               I(top:bot, right:rr, 1:2) = 255;
               
               I(top, left:right, 3) = 0;
               I(bot, left:right, 3) = 0;
               I(top:bot, left, 3) = 0;
               I(top:bot, right, 3) = 0;
            else
               warndlg('Invalid Boundaries for preview');
            end
          
          imshow(I, 'Parent', obj.gui.h_acpreview);
        end
        
        function calcstats_Callback(obj, ~, ~)
            obj.model.CalculateTeamStatistics();
            obj.UpdateTeamData();
        end
        
        function save_Callback(obj, ~, ~)
            features = obj.gui.h_tfeatures.Data; %#ok<NASGU>
            save([obj.model.directory.path '/features.mat'], 'features');
        end
        
        function s19_Callback(obj, ~, ~)
            obj.clearteam_Callback();
            for team = AmazingUtility.Season19TeamList
                obj.gui.h_eteam.String = team;
                obj.addteam_Callback();
            end
        end
        
        function s20_Callback(obj, ~, ~)
            obj.clearteam_Callback();
            for team = AmazingUtility.Season20TeamList
                obj.gui.h_eteam.String = team;
                obj.addteam_Callback();
            end
        end
        
        function s21_Callback(obj, ~, ~)
            obj.clearteam_Callback();
            for team = AmazingUtility.Season21TeamList
                obj.gui.h_eteam.String = team;
                obj.addteam_Callback();
            end
        end
        
        function s22_Callback(obj, ~, ~)
            obj.clearteam_Callback();
            for team = AmazingUtility.Season22TeamList
                obj.gui.h_eteam.String = team;
                obj.addteam_Callback();
            end
        end
        
        function s23_Callback(obj, ~, ~)
            obj.clearteam_Callback();
            for team = AmazingUtility.Season23TeamList
                obj.gui.h_eteam.String = team;
                obj.addteam_Callback();
            end
        end
        
        function s24_Callback(obj, ~, ~)
            obj.clearteam_Callback();
            for team = AmazingUtility.Season24TeamList 
                obj.gui.h_eteam.String = team;
                obj.addteam_Callback();
            end
        end
    end
end