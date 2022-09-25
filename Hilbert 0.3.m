%clear all

clc
 
 clf
 tic
 fs = 1000000; % Sampling frequency (samples per second) 
 dt = 1/fs; % seconds per sample 
 StopTime = 1; % seconds 
 t = (0:dt:StopTime)'; % sampling vector 
 tout=t';
 FreqChg = 100; % Frequency changes
 BaseFreq = 270000;

freqTS = abs(interp1(linspace(t(1),t(end),FreqChg),0.25*BaseFreq+2*BaseFreq*rand(1,FreqChg),t,'spline') );


%centfreq = mean(freqTS);
k = (BaseFreq/fs)*2*pi/BaseFreq;
data = sin(2*pi.*BaseFreq.*t + k*cumsum(freqTS-BaseFreq));
z = hilbert(data);

instfrq = fs/(2*pi)*diff(unwrap(angle(z)));
magField = (fs/(2*pi)*diff(unwrap(angle(z))))./3.498572;
toc

%plots
 subplot(4,1,1)
 plot(t,freqTS)

   title('Actual Frequency of Generated Signal')
  xlabel('Time Elapsed (s)');
  ylabel('Frequency (Hz)')
  %legend('Freq (Hz)','Amplitude','location','southeast')

 subplot(4,1,2)
 plot(t,data)
  title('Input Signal')
  xlabel('Time Elapsed (s)');

subplot(4,1,3)
plot(t,angle(z))
ylabel('Phase (rad.)')


subplot(4,1,4)


plot(tout(1:numel(t)-1),instfrq)
hold on
plot(tout,freqTS)

 title('Hilbert Transformed Frequency and Magnetic Field')
 xlabel('Time Elapsed (s)')
 ylabel('Frequency (Hz)')

 

 ylim([min(freqTS) max(freqTS)])

yyaxis right
plot(tout(1:numel(t)-1),magField)
% xlim([0 numel(t)-1])
 yyaxis right
ylabel('Magnetic Field (nT)')
ylim([(min(freqTS/3.5)) (max(freqTS/3.5))])
 legend('Transformed','Actual','Magnetic Field (RHS)','location','southeast')

%MeanFreq = round(mean(instfrq),5)
toc

hold off
%plot(t,abs(z)) %plot amplitude
