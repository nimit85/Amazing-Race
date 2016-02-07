%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interface between GUI and Model for classifying which clusters go
%   with which teams
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef ClassifyClusterController < handle
    properties
        gui
        model
        imax
        teams
        team_button_pressed
    end
   
    methods
        function obj = ClassifyClusterController(ClassifyGUI, ClassifyModel, team_list)
            obj.gui = ClassifyGUI;
            obj.model = ClassifyModel;
            obj.teams = team_list;
            
            obj.imax = axes('Units', 'normalized', ...
            'Position', [0 0 1 1], ...
            'Parent', obj.gui.h_ppreview);
        
            x = 0.025;
            y = 0.35;
            
            h_bteambutton = uicontrol('Style', 'pushbutton', ...
                'String', 'No Team', ...
                'Units', 'normalized', ...
                'Position', [x, y, 0.15, 0.05], ...
                'Parent', obj.gui.fig);

            h_bteambutton.Callback = {@obj.noteam_Callback};

            x = x + 0.2;
            if ( x == 1.025)
                x = 0.025;
                y = y - 0.1;
            end
            
            for team = team_list
                h_bteambutton = uicontrol('Style', 'pushbutton', ...
                    'String', team{1}.name, ...
                    'Units', 'normalized', ...
                    'Position', [x, y, 0.15, 0.05], ...
                    'Parent', obj.gui.fig);
                
                h_bteambutton.Callback = {@obj.teambutton_Callback, team{1}};
                
                x = x + 0.2;
                if ( x == 1.025)
                    x = 0.025;
                    y = y - 0.1;
                end
            end
            
            I = imread(char(strcat(obj.model.file_path, ...
                        '/', obj.model.getNext(0))));
            imshow(I, 'Parent', obj.imax); 
            
            obj.team_button_pressed = false;
        end
        
        function register_callbacks(obj)
            obj.gui.h_bprev.Callback = {@obj.next_Callback, -1};
            obj.gui.h_bnext.Callback = {@obj.next_Callback, 1};
        end
        
        function next_Callback(obj, unused_src, unused_evt, delta)           
            I = imread(char(strcat(obj.model.file_path, ...
                        '/', obj.model.getNext(delta))));
            imshow(I, 'Parent', obj.imax);              
            obj.team_button_pressed = false;
        end
        
        function ResetCluster(obj, cluster)
            obj.model.ResetCluster(cluster);
            
            I = imread(char(strcat(obj.model.file_path, ...
                        '/', obj.model.getNext(0))));
            imshow(I, 'Parent', obj.imax); 
            obj.team_button_pressed = false;
        end
        
        function show(obj)
            obj.gui.fig.Visible = 'on';
        end
        
        function hide(obj)
            obj.gui.fig.Visible = 'off';
        end
        
        function teambutton_Callback(obj, unused_src, unused_evt, team)
            new_mem = zeros(size(obj.model.all_files));
            
            [~, iy] = size(obj.model.all_files);
            for i = 1:iy
                if ismember(obj.model.all_files{i}, obj.model.file_list)
                    new_mem(i) = 1;
                end
            end
            
            
            team.membership = team.membership | new_mem;
            obj.team_button_pressed = true;
        end
        
        function noteam_Callback(obj, unused_src, unused_evt)
            obj.team_button_pressed = true;
        end
    end
end
