% Creates a file datastore
folder_path = 'Replace with directory of data store';
files = dir(fullfile(folder_path, '*.mat'));
file_paths = fullfile(folder_path, {files.name});
emgds = fileDatastore(file_paths,'ReadFcn',@load);

% Create a Map that associates movements with labels
movement_labels = containers.Map( ...
    {'C001', 'C008', 'C009', 'C010', 'C011', 'C016', 'C018'}, ...
    {'rest', 'elbow flexion', 'elbow extension', 'pronation', ...
    'supernation', 'hand open', 'grips'});

% Define variable names
varNames = {'MAV_ch1', 'ZC_ch1', 'SSC_ch1', 'WL_ch1', ...
            'MAV_ch2', 'ZC_ch2', 'SSC_ch2', 'WL_ch2', ...
            'MAV_ch3', 'ZC_ch3', 'SSC_ch3', 'WL_ch3', ...
            'MAV_ch4', 'ZC_ch4', 'SSC_ch4', 'WL_ch4', ...
            'MAV_ch5', 'ZC_ch5', 'SSC_ch5', 'WL_ch5', ...
            'MAV_ch6', 'ZC_ch6', 'SSC_ch6', 'WL_ch6', ...
            'MAV_ch7', 'ZC_ch7', 'SSC_ch7', 'WL_ch7', ...
            'MAV_ch8', 'ZC_ch8', 'SSC_ch8', 'WL_ch8', ...
            'Movement'};

% Define the variable types
varTypes = [repmat({'double'}, 1, 32), {'cell'}];
% Create an empty table with the specified size and variable names
feature_table = table('Size', [0, 33], 'VariableTypes', varTypes, 'VariableNames', varNames);

fs = 1000; % Hz
lowcut = 10; % Hz
highcut = 499; % Hz
window_size = 300;  % ms
overlap_size = 150;  % ms

% Creates table of features
feature_table = createtable(emgds, movement_labels, feature_table, fs, lowcut, highcut, window_size, overlap_size);

% Extracts and stores the features and labels seperately to be used in training
features = feature_table{:, 1:32};
labels = feature_table.Movement;

% Split the data into training and test sets
rng(1); % For reproducibility
cvPartition = cvpartition(labels, 'Holdout', 0.3);
trainingData = features(cvPartition.training,:);
trainingLabels = labels(cvPartition.training);
testData = features(cvPartition.test,:);
testLabels = labels(cvPartition.test);


% Perform 10-fold cross-validation
svm = fitcecoc(trainingData, trainingLabels);
cvmodel = crossval(svm, 'KFold', 10);
classError = kfoldLoss(cvmodel); % Compute the classification error
% fprintf('10-fold cross-validated classification error: %.2f%%\n', classError*100);

% Training Over Entire Dataset
Mdl = fitcecoc(trainingData, trainingLabels);

% Evaluation
predictedLabels = predict(Mdl, testData);

% Confusion matrix
confusionMat = confusionmat(testLabels, predictedLabels);
confusionchart(testLabels, predictedLabels, "Title", 'SVM Model', ...
    "ColumnSummary","column-normalized","RowSummary","row-normalized");

% Accuracy
accuracy = sum(diag(confusionMat)) / sum(confusionMat(:));
fprintf('Accuracy on the test set: %.2f%%\n', accuracy*100);

% % Calculate Individual Class Errors
% numClasses = size(confusionMat, 1); % Number of classes
% classError = zeros(numClasses, 1);
% for i = 1:numClasses % Compute class error for each class
%     correctClassifications = confusionMat(i, i);
%     totalInstances = sum(confusionMat(i, :));
%     classError(i) = (totalInstances - correctClassifications) / totalInstances;
% end
% for i = 1:numClasses % Display class error
%     fprintf('Class %d Error: %.2f%%\n', i, classError(i)*100);
% end

% Overall Classification Error
classificationError = loss(Mdl, testData, testLabels);
fprintf('Overall Class Error: %.2f%%\n', classificationError*100);

% Precision, Recall, F1-Score
numClasses = numel(unique(testLabels));
precision = zeros(numClasses, 1);
recall = zeros(numClasses, 1);
f1 = zeros(numClasses, 1);
for i = 1:numClasses
    precision(i) = confusionMat(i,i) / sum(confusionMat(:,i));
    recall(i) = confusionMat(i,i) / sum(confusionMat(i,:));
    f1(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i));
end
avgPrecision = mean(precision, 'omitnan');
avgRecall = mean(recall, 'omitnan');
avgF1 = mean(f1, 'omitnan');
fprintf('Precision: %.3f\n', avgPrecision);
fprintf('Recall: %.3f\n', avgRecall);
fprintf('F1 Score: %.3f\n', avgF1);

% Log Loss
logLoss = loss(Mdl, testData, testLabels, 'BinaryLoss', 'logit');
fprintf('Log Loss: %.3f\n', logLoss);
