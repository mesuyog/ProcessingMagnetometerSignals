clear all

clc
 
 clf
 tic
 fs = 24000; % Sampling frequency (samples per second) 
 dt = 1/fs; % seconds per sample 
 StopTime = 1; % seconds 
 t = (0:dt:StopTime)'; % sampling vector 
 tout=t';
 FreqChg = 20; % Frequency changes
 BaseFreq = 20;

MagReadings = readmatrix('MagReadings.csv');
InputTime = MagReadings(1:24001,2);
InputFreq = MagReadings(1:24001,4);
SampleNo=1:length(InputFreq);

%freqTS = abs(interp1(linspace(t(1),t(end),FreqChg),0.25*BaseFreq+2*BaseFreq*rand(1,FreqChg),t,'spline') );

W=interp1(InputTime,InputFreq,t, 'linear','extrap') ;
centfreq = mean(InputFreq);
k        = (centfreq/fs)*2*pi/centfreq;
data = sin(2*pi.*centfreq.*t + k*cumsum(InputFreq-centfreq));
z = hilbert(data);

instfrq = fs/(2*pi)*diff(unwrap(angle(z)));
magField = (fs/(2*pi)*diff(unwrap(angle(z))))./3.498572;
toc

%plots
 subplot(4,1,1)
 plot(SampleNo,InputFreq)

   title('Frequency of Data Feed')
  xlabel('Sample #');
  ylabel('Frequency (Hz)')
     xlim([0 length(InputFreq)])
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
plot(tout,InputFreq)

 title('Hilbert Transformed Frequency and Magnetic Field')
 xlabel('Time Elapsed (s)')
 ylabel('Frequency (Hz)')



 ylim([0 max(InputFreq)])

yyaxis right
plot(tout(1:numel(t)-1),magField)
% xlim([0 numel(t)-1])
 yyaxis right
ylabel('Magnetic Field (nT)')
%ylim([(min(W/3.5)) (max(W/3.5))])
 legend('Transformed','Actual','Magnetic Field (RHS)','location','southeast')

%MeanFreq = round(mean(instfrq),5)
toc

hold off
%plot(t,abs(z)) %plot amplitude


% 
% phase = 0;
% 
% s(1) = 0;
% 
% for i from 2 up to end
% 
%    phase  =  phase  +  2 * pi * frequency(ii) * sample_interval
% 
%    s(ii)  =  amplitude(ii) * sin(phase)
% 
% end


