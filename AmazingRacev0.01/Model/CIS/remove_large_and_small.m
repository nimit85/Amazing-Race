%{
% @function res_mat = remove_large_and_small ( mat )
%
% Removes connected components that do not lie in a specified range (100 to
%  1000 pixels.) INPUT MATRIX IS BASICALLY DELETED (everything should be 0 after).
%
% @param mat Binary input matrix
%
% @return res_mat Input matrix without connected components > max_size or <
%                  min_size
%}
function res_mat = remove_large_and_small( mat ) 
    res_mat = zeros(size(mat));
    [x, y] = size( mat );
    % Goes through each pixel.
    for i = 1:x
        for j = 1:y      
            % For each white pixel, expands to find connected component
            if ( mat(i, j) ~= 0 )
                current_component = zeros(size(mat));
                current_component(i, j) = 1;
                to_check = [i+1, j+1; i+1, j; i+1,j-1; i,j+1; i,j-1;i-1,j+1;i-1,j;i-1,j-1];
                while size(to_check, 1) > 0 
                    if ( ( to_check(1, 1) > 0 ) && ( to_check(1, 1) <= x ) && (to_check(1, 2) > 0 ) && (to_check(1, 2) <= y) )
                        if ( (mat(to_check(1,1), to_check(1, 2) ) ~= 0) && (current_component(to_check(1, 1), to_check(1, 2)) == 0) )
                            current_component(to_check(1, 1), to_check(1, 2)) = 1;
                            xx = to_check(1, 1);
                            yy = to_check(1, 2);
                            to_check = [to_check; xx+1, yy+1;xx+1, yy;xx+1,yy-1;xx,yy+1;xx,yy-1;xx-1,yy+1;xx-1,yy;xx-1,yy-1];
                        end
                    end
                    to_check(1, :) = [];
                end
                
                % If correct size, added to result. Either way, removed
                % from input matrix.
                c_size = sum ( sum ( current_component ) );
                if ( ( c_size < 1000 ) && ( c_size > 100 ) )
                    res_mat = res_mat | current_component;
                end
                mat = mat - current_component;
            end
        end
    end
end