% Load the mat file
loaded_data = load('/Users/Aaron/Library/CloudStorage/OneDrive-Personal/Documents/Control Robotic Arm/Data/C008_20130528_072811_072820.mat');

% Extract signal and time data
data = loaded_data.daq.DAQ_DATA;
time = loaded_data.daq.t;

stackedplot(time,signal);
