function clusters = get_level ( start_elements, link_tree, num_clusters )
  clusters = {};
  next_ind = start_elements + 1;
  for i = 1:start_elements
    clusters{i} = [i];
  end

  for i = 1:start_elements-num_clusters
    clusters{next_ind} = [clusters{link_tree(i, 1)} clusters{link_tree(i, 2)}];
    clusters{link_tree(i, 1)} = [];
    clusters{link_tree(i, 2)} = [];
    next_ind = next_ind + 1;
  end  

end
