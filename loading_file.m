% This file is used to view the raw data

% Load the mat file
loaded_data = load('Replace with path of data');

% Extract signal and time data
data = loaded_data.daq.DAQ_DATA;
time = loaded_data.daq.t;

stackedplot(time,signal);
