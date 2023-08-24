folder_path = 'C:\Users\adbla\OneDrive\Documents\Control Robotic Arm\20130528_072811~';
files = dir(fullfile(folder_path, '*.mat'));
file_paths = fullfile(folder_path, {files.name});

% Create file datastore
emgds = fileDatastore(file_paths,'ReadFcn',@load);

% Create a Map that associates movements with labels
movement_labels = containers.Map( ...
    {'C001', 'C008', 'C009', 'C010', 'C011', 'C016', 'C018'}, ...
    {'rest', 'elbow flexion', 'elbow extension', 'pronation', ...
    'supernation', 'hand open', 'grips'} ...
);


filedata = read(emgds);

[~, file_name] = fileparts(emgds.Files{1});
movement = file_name(1:4);

movement_labels(movement)

labels = [];



% fs = 1000; % Sampling frequency 
% Ts = 1 / fs; % Period
% t  = 0 : Ts : 0.25; 
% X  = 0.01 * (cos(2 * pi * fs * t) + randn(1, length(t)));
% 
% % Plot sample signal
% plot(t,X);  grid on
% xlabel('Number of samples');
% ylabel('Amplitude');
% 
% f1 = jfemg('mav',X);
% f2 = jfemg('zc',X);
% f3 = jfemg('ssc',X);
% f4 = jfemg('wl',X);
% 
% % Feature vector
% feat = [f1, f2, f3, f4, f4];
