%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Information needed for associating clusters with teams
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef ClassifyClusterModel < handle
    properties
        all_files
        full_clusters
        file_list
        current_cluster
        current_index
        file_path
        max_cluster 
    end
    methods
        function obj = ClassifyClusterModel(all_clusters, path, files)
            [~, obj.max_cluster] = size(all_clusters);
            obj.full_clusters = all_clusters;
            obj.file_list = all_clusters{1};
            obj.current_cluster = 1;
            obj.current_index = 1;
            obj.file_path = path;
            obj.all_files = files;
        end
        
        function filename = getNext( obj, delta )
            [~, file_size] = size(obj.file_list);
            obj.current_index = mod((obj.current_index - 1) + delta, file_size) + 1;
           
            filename = obj.file_list{obj.current_index};
        end
        
        function ResetCluster ( obj ) 
            obj.current_cluster = obj.current_cluster + 1;
            obj.file_list = obj.full_clusters{obj.current_cluster};
            obj.current_index = 1;    
        end
        
        function ResetPath ( obj, path )
            obj.file_path = path;
        end
    end
end