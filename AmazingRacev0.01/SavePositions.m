function SavePositions(team_names, plist, target_directory)
  [~, team_count] = size(plist);
  positions = cell(team_count, 2);
  
  for i = 1:team_count
      positions{i, 1} = team_names{i};
      positions{i, 2} = plist(i);
  end
  
  save([target_directory 'positions.mat'], 'positions');
end