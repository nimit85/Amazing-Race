%{
@function CC = CIS( G )

Runs a modification of CIS (LOS) clustering algorithm that constructs a 
partition of elements in the given graph.

@param G : Edgelist graph representation  
@return CC : Cell array of cell arrays of elements making up the community
             structure
%}
function CC = CIS( G )
    fprintf('Starting CIS Algorithm\n');
    CC = {};
    next_full_cluster = 1;
    while ( 1 )
        % Grab the first key of the network
        V = keys(G);
        [~, nv] = size(V);
        if ( nv == 0 )
            break;
        else
            fprintf('%d keys to go.\n');
        end
        
        cluster = {V{1},};
        next_cluster = 2;
        old_wout = 0;
        old_win = 0;
        N = G(V{1});
        
        % Go through the neighbors of the first element, adding weights to
        % wout
        for n = keys(N)
            old_wout = old_wout + double(N(char(n)));
        end
        
        fringe = get_neighbors(G, cluster);
        % Go through the fringe and add any elements that would increase
        % the density measure ( win / ( win + wout ) )
        for f = fringe
            new_wout = old_wout;
            new_win = old_win;
            
            neighbors = G(char(f));
            for n = keys(neighbors)
                if ( ismember(n, cluster) )
                    new_win = new_win + (neighbors(char(n)));
                    new_wout = new_wout - (neighbors(char(n)));
                else
                    new_wout = new_wout + neighbors(char(n));
                end
            end
            
            if ( (new_win / (new_win + new_wout)) > (old_win / (old_win + old_wout)) )
                cluster{next_cluster} = char(f);
                next_cluster = next_cluster + 1;
                old_wout = new_wout;
                old_win = new_win;
            end
        end
        
        % Go through the cluster and remove any element that would result
        % in an increase of the density.
        i = 1;
        while ( i < next_cluster )
            f = cluster{i};
            new_wout = old_wout;
            new_win = old_win;
 
            neighbors = G(char(f));
            for n = keys(neighbors)
                if ( is_member(n, cluster) )
                    new_win = new_win - (neighbors(char(n)));
                    new_wout = new_wout + (neighbors(char(n)));
                else
                    new_wout = new_wout - neighbors(char(n));
                end
            end
            if ( (new_win / (new_win + new_wout)) > (old_win / (old_win + old_wout)) )
                cluster{i} = cluster{next_cluster - 1};
                cluster{next_cluster-1} = '';
                next_cluster = next_cluster - 1;
                old_wout = new_wout;
                old_win = new_win;
            else 
                i = i + 1;
            end
        end
        cluster = {cluster{1:next_cluster - 1}};
        
        % Remove the elements of the cluster from the graph -> results in a
        % partition
        for m = cluster
            N = G(char(m));
            for n = keys(N)
                remove (G(char(n)), char(m));
            end
            remove(G, char(m));
        end        
        
        % Record cluster
        [~, m] = size(cluster);
        if ( m > 3 )
            CC{next_full_cluster} = cluster;
            next_full_cluster = next_full_cluster + 1;
        end
    end
end

%{
% @function N = get_neighbors( G, C )
% 
% @param G Edgelist representation of network
% @param C Group of elements in the graph
%
% @returns The list of elements that are connected to an element in the
%          given component (C) but are not, themselves, an element of C
%}
function N = get_neighbors( G, C )
    N = {};
    next_id = 1;
    for c = C
        for k = keys(G(char(c)))
           if ( ~is_member(k, C) && ~is_member(k, N) )
             N{next_id} = char(k);
             next_id = next_id + 1;
           end
        end
    end
end

%{
% @function ret = is_member( k, C )
%
% @param k A single element from a graph
% @param C A group of elements from a graph (community or cluster)
%
% @return true if k is in C. False otherwise.
%}
function ret = is_member( k, C )
    ret = sum( ismember(char(k), C) );
end