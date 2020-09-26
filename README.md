# ECG-Signal-Abnormality-Detection
ECG Signal pre-processing and Machine Learning based abnormality detection

The ECG signal is well known for its nonlinear dynamic behavior which dynamically
changes with respect to time. Each heartbeat is a combination of action impulse waveforms
produced by different specialized cardiac heart tissues. Thus, the presence of variations in
some signal features denotes the abnormality in ECG signal. ECG records are obtained from
MIT-BIH Arrhythmia Database (mitdb) present in physionet.org 
in the length of 10 sec and 1 min. Then these signals are filtered for removing noises and baseline wanders in order to
get accurate value of time domain parameters of signal. This project focus on the extracted
features like QRS Complexes, R-R Intervals and BPM are used as an input for training and
testing the Machine Learning model.

### ECG Dataset : https://archive.physionet.org/cgi-bin/atm/ATM

# Results
Kernalised SVM shows the log-loss of 0.3669 on test data.

# Tools used
- MATLAB – For Data and Feature Extraction
- PYTHON – For Training and Testing the ML Algorithm
