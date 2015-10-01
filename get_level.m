function clusters = get_level(start_elements, link_tree, num_clusters)
% clusters = {};
[~, num_rows] = size (start_elements);
next_ind = num_rows + 1;

clusters = cell(num_rows,1);
for i = 1:num_rows
    clusters{i} = start_elements(i);
end

for i = 1:num_rows-num_clusters
    clusters{next_ind} = {clusters{link_tree(i, 1)} clusters{link_tree(i,2)}};
    clusters{link_tree(i, 1)} = {};
    clusters{link_tree(i, 2)} = {};
    next_ind = next_ind + 1;
end

end
