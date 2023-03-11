%-------------------------- index = 200650U -------------------------------
A = 6;
B = 5;
C = 0;

%----------- calculation of digital filter specifications -----------------

maxPassbandRipple = 0.1 + (0.01 * A); %dB
minStopbandAttenuation = 50 + B; %dB
lowerPassbandEdge = (C * 100) + 400; %rad/s
upperPassbandEdge = (C * 100) + 900; %rad/s
lowerStopbandEdge = (C * 100) + 100; %rad/s
upperStopbandEdge = (C * 100) + 1100; %rad/s
samplingFrequency = 2*((C * 100) + 1500); %rad/s

%----------------------------- question_1 ---------------------------------

sampFreq = samplingFrequency/(2*pi); %sampling frequency in Hz
frequencyEdges = [lowerStopbandEdge lowerPassbandEdge upperPassbandEdge upperStopbandEdge]/sampFreq;
magnitudes = [0 1 0];
deviations = [1/(10^(minStopbandAttenuation/20)) 1/(10^(maxPassbandRipple/20))  1/(10^(minStopbandAttenuation/20))];

[n, Wn, beta, ftype] = kaiserord(frequencyEdges, magnitudes, deviations, 2*pi);
filterCoefficients = fir1(n, Wn, ftype, kaiser(n+1,beta), 'noscale');

%GUI which plots the digital filter
fvtool(filterCoefficients, 1)

%computing the frequency response vector - "magnitude" and the corresponding angular frequency vector - "phase"
[magnitude, phase] = freqz(filterCoefficients, 1);

%------------------magnitude response in the passband----------------------
plot(phase, 20*log10(abs(magnitude)))
xlim([lowerPassbandEdge upperPassbandEdge]*(2*pi/samplingFrequency))
xlabel('Frequency(\omega) rad/sample')
ylabel('Magnitude response in the passband(dB)')
grid on