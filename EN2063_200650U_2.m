%-------------------------- index = 200650U -------------------------------
A = 6;
B = 5;
C = 0;
D = 0;
%therefore the IIR filter approximation method is Butterworth.

%----------- calculation of digital filter specifications -----------------

maxPassbandRipple = 0.1 + (0.01 * A); %dB
minStopbandAttenuation = 50 + B; %dB
lowerPassbandEdge = (C * 100) + 400; %rad/s
upperPassbandEdge = (C * 100) + 900; %rad/s
lowerStopbandEdge = (C * 100) + 100; %rad/s
upperStopbandEdge = (C * 100) + 1100; %rad/s
samplingFrequency = 2*((C * 100) + 1500); %rad/s

sampFreq = samplingFrequency/(2*pi); %sampling frequency in Hz

passbandEdges = [lowerPassbandEdge upperPassbandEdge]/(sampFreq); 
stopbandEdges = [lowerStopbandEdge upperStopbandEdge]/(sampFreq);

%prewarping the critical frequencies
passbandEdges = 2 / (1/sampFreq) * tan(passbandEdges/2);
stopbandEdges = 2 / (1/sampFreq) * tan(stopbandEdges/2);

[minimumOrder, cutoffFrequencies] = buttord(passbandEdges, stopbandEdges, maxPassbandRipple, minStopbandAttenuation, 's');
[numerator, denominator] = butter(minimumOrder, cutoffFrequencies, 's');

%Digital filter coefficients
[numeratorDiscrete, denominatorDiscrete] = bilinear(numerator, denominator, sampFreq);

%GUI which plots the digital filter
fvtool(numeratorDiscrete, denominatorDiscrete)

%computing the frequency response vector - "magnitude" and the corresponding angular frequency vector - "phase"
[magnitude,phase]=freqz(numeratorDiscrete,denominatorDiscrete);

%-------------------magnitude response in the passband---------------------
plot(phase, 20*log10(abs(magnitude)))
xlim([lowerPassbandEdge upperPassbandEdge]*(2*pi/samplingFrequency))
xlabel('Frequency(\omega) rad/sample')
ylabel('Magnitude response in the passband(dB)')
grid on