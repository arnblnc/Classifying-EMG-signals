function newData = addNewData(label, features, feature_table)
    % Creates matrix of labels to store movement type
    labels = addlabels(label, features);

    % Convert the features matrix to a table
    newData = array2table(features, 'VariableNames', feature_table.Properties.VariableNames(1:32));
    
    % Add the labels to the new data
    newData.Movement = labels;
end