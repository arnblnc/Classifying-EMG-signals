function features = extract_features(data)
    % Initialise an empty matrix to store the features
    features = [];

    % Loop over each window
    for i = 1:length(data)
        % Get the current window
        window = data{i};

        window_features = [];

        % Loop over each column (channel) of the window
        for j = 1:size(window,2)
            % Get the data for the current channel
            channel_data = transpose(window(:,j));
            
            % Compute features
            mav_fe = jfemg('mav',channel_data);
            zc_fe = jfemg('zc',channel_data);
            ssc_fe = jfemg('ssc',channel_data);
            wl_fe = jfemg('ewl',channel_data); % Enhanced WL
            
            % Append features to the window's feature vector
            window_features = [window_features mav_fe zc_fe ssc_fe wl_fe];
        end
        
        % Append the window's feature vector to the matrix of features
        features = [features; window_features];
    end
end