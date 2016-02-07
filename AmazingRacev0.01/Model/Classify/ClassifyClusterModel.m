%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Information needed for associating clusters with teams
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef ClassifyClusterModel < handle
    properties
        all_files
        file_list
        current_index
        file_path
    end
    methods
        function obj = ClassifyClusterModel(cluster, path, files)
            obj.file_list = cluster;
            obj.current_index = 1;
            obj.file_path = path;
            obj.all_files = files;
        end
        
        function filename = getNext( obj, delta )
            [~, file_size] = size(obj.file_list);
            obj.current_index = mod((obj.current_index - 1) + delta, file_size) + 1;
           
            filename = obj.file_list{obj.current_index};
        end
        
        function ResetCluster ( obj, cluster ) 
            obj.file_list = cluster;
            obj.current_index = 1;    
        end
        
        function ResetPath ( obj, path )
            obj.file_path = path;
        end
    end
end