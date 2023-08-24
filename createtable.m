function feature_table = createtable(emgds, movement_labels, feature_table, fs, lowcut, highcut, window_size, overlap_size)
    % Initialise an index variable before the loop
    currentFileIndex = 1;

    while hasdata(emgds)
        % Read file
        file_data = read(emgds);
    
        % Get the movement from the file name
        [~, file_name] = fileparts(emgds.Files{currentFileIndex});
        movement = file_name(1:4);
        % Get the label for the movement
        label = movement_labels(movement);
    
        % Processing data
        filtered_data = process_data(file_data, fs, lowcut, highcut);
        segmented_data = segment_data(filtered_data, window_size, overlap_size);
        features = extract_features(segmented_data);
        
        % Gathers feature and label data and appends it to a table
        newData = addNewData(label, features, feature_table);
    
        % Append the new data to the main table
        feature_table = [feature_table; newData];
    
        % Increment the index for the next iteration
        currentFileIndex = currentFileIndex + 1;
    end
end