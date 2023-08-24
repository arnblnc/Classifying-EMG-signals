function frame_cell = segment_data(data, window_size, overlap_size)
    % Get the size of the data
    [r, c] = size(data);
    
    % Initialise an empty cell array to store the windows of data
    frame_cell = {};
    
    % Start index for the first window
    n_start = 1;
    
    % Loop over the data in windows
    while (n_start + window_size <= r)
        % Extract the current window of data
        window = data(n_start:n_start+window_size-1,:);
        
        % Store the window of data in the cell array
        frame_cell{end+1} = window;
        
        % Update the start index for the next window
        n_start = n_start + window_size - overlap_size;
    end
end