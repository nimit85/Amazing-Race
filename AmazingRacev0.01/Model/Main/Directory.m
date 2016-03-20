%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @class Directory
% 
% Represents a group of screenshots that compose a single data chunk of
% interest (i.e. an episode). Screenshots should have the format '%d.tif' -
% that is, a number followed by the tif extension.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef Directory < handle
    properties
        path
        images
    end
    
    methods
        function obj = Directory()
           obj.path = '';
           obj.images = {};
        end
        
        
        % Reads the screenshots from a directory
        %%% DEPRECATED
        function status = LoadDirectory( obj, directory_name )
            obj.path = directory_name;
            obj.images = obj.getTIF();
            tsize = size(obj.images);
            if ( tsize(2) == 0 )
                status = AmazingUtility.EMPTY_DIR;
            else 
                obj.sortImages();
                status = AmazingUtility.SUCCESS;
            end
        end
        
        function status = LoadImageList(obj, config)
            R = readtable(config);
            obj.images = table2cell(R(:,1));
            
            status = AmazingUtility.SUCCESS;
        end
        
        % Retrieves the files in the directory that end with the tif
        % extension
        %
        % @TODO : Error Checking?
        function filenames = getTIF( obj )
            obj.path
            if ( strcmp(obj.path, '') ~= 1 )
                files = dir([obj.path, '/*.tif']);
                filenames = {files.name};     
            end
        end
        
        function sortImages( obj )
            remove_ext = sort(cellfun(@getnumber, obj.images));
            numcell = num2cell(remove_ext);
            obj.images = cellfun(@appendExt, numcell, 'UniformOutput', false);
            
            function result = getnumber ( filename ) 
                result = str2double(filename(1:strfind(filename, '.') - 1));
            end
            
            function result = appendExt ( filename )
                result = [num2str(filename) '.tif'];
            end
        end
    end
end