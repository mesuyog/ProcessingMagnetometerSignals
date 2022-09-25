function [t,tout,freqTS,data,z,instfrq,magField,TSHeld] = HilbertFunction(fs,StopTime,FreqChg,BaseFreq,Regen)

%Hillbert transform function.
%inputs:    fs: sampling rate
%             StopTime: duration
%             FreqChg: number of times the input frequency will change 
%             BaseFreq: the centre frequency of the input signal
%             Regen: parameter to signal for regeneration of input signal

 dt = 1/fs; % seconds per sample 
 t = (0:dt:StopTime)'; % sampling vector 
 tout=t';

 % Do not regenrate signal if Regen = 0; allows for the changing of
 % sampling rate without creating new signal
if Regen == 0
    TSHeld = rand(1,FreqChg);
    freqTS = abs(interp1(linspace(t(1),t(end),FreqChg),0.25*BaseFreq+2*BaseFreq*TSHeld,t,'spline') );
else 
    freqTS = abs(interp1(linspace(t(1),t(end),FreqChg),0.25*BaseFreq+2*BaseFreq*Regen,t,'spline') );
end

%Prepare data
k = (BaseFreq/fs)*2*pi/BaseFreq;
data = sin(2*pi.*BaseFreq.*t + k*cumsum(freqTS-BaseFreq));
%Perform transformation
z = hilbert(data);
%solve for instantaneous frequency and magnetic field
instfrq = fs/(2*pi)*diff(unwrap(angle(z)));
magField = (fs/(2*pi)*diff(unwrap(angle(z))))./3.498572;


end