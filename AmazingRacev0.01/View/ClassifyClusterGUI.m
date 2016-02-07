%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GUI to (a) show each cluster from CIS one at a time
%        (b) get the team to associate the cluster with
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef ClassifyClusterGUI
   properties
       fig
       
       h_ppreview
       h_bprev
       h_bnext
   end
   methods
       function obj = ClassifyClusterGUI()
           obj.fig = figure('Visible', 'off'); 
           
           obj.h_ppreview = uipanel('Tag', 'PreviewPanel', ...
                'Units', 'normalized', ...
                'Position', [0.0 .5, 1, 0.5], ...
                'Parent', obj.fig);
            
            obj.h_bprev = uicontrol('Style', 'pushbutton', ...
                'String', 'Prev', ...
                'Units', 'normalized', ...
                'Position', [0.25, 0.425, 0.2, 0.05], ...
                'Parent', obj.fig);
            
            obj.h_bnext = uicontrol('Style', 'pushbutton', ...
                'String', 'Next', ...
                'Units', 'normalized', ...
                'Position', [0.55, 0.425, 0.2, 0.05], ...
                'Parent', obj.fig);
       end
   end
end