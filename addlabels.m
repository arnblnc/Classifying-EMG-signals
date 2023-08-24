function labels = addlabels(label, features)
    % Initialise and empty matrix to store labels
    labels = [];

    % Loop over labels matrix
    for i = 1:size(features, 1)
        labels = [labels; label];
    end

    labels = cellstr(labels);
end