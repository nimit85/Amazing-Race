function map_errors()
    %x = [10, 25, 50, 75, 100, 250, 500, 750, 1000, 2500,...
    %        5000, 7500, 10000];
    x = [10000, 20000];
    y = [];
        
    for iter = x
        [e_in, e_out, runtime] = single_run(AmazingUtility.FourEpisodeGroups,...
            iter);
        y = [y, [e_in; e_out; runtime]]; %#ok<AGROW>
    end
    
    plot(x, y(1, :)); % In sample error
    hold on;
    plot(x, y(2, :)); % Out of sample error
    plot(x, y(3, :)); % Timing
end