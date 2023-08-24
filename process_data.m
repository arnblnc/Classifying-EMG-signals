function final_filtered_data = process_data(data, fs, lowcut, highcut)

    % Extract the DAQ_DATA
    emg_data = data.daq.DAQ_DATA;

    % Cutoff frequency matrix
    cutoff = [lowcut highcut]/(fs/2);

    [b,a] = butter(2, cutoff, 'bandpass');  % Butterworth filter
    bandpass_filtered_data = filter(b, a, emg_data);

    % Notch filter
    notch_freq = 60;  % Notch frequency
    notch_width = 30;  % Notch width
    wo = notch_freq/(fs/2);  % Normalized frequency
    bw = wo/notch_width;  % Bandwidth
    [bn,an] = iirnotch(wo, bw);  % IIR notch filter design
    notch_filtered_data = filter(bn, an, bandpass_filtered_data);

    % The final filtered data
    final_filtered_data = notch_filtered_data;
end