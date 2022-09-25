clc
clear all
clf
tic
 fs = 1000000; % Sampling frequency (samples per second) 
 dt = 1/fs; % seconds per sample 
 StopTime = 1; % seconds 
 F = 17; % Sine wave frequency (hertz) 
 t = (0:dt:StopTime)'; % sampling vector 
 
 data = sin(2*pi*F*t); %data points
 subplot(2,1,1)
 
 plot(t,data)
 title('Input Signal')
 xlabel('Time Elapsed (s)');


z = hilbert(data);
instfrq = fs/(2*pi)*diff(unwrap(angle(z)));

 subplot(2,1,2)
 
plot(instfrq)
 title('Transformed Instantaneous Frequency')
 xlabel('Sample Number');
 ylabel('Frequency (Hz)')
mean(instfrq)
toc

