function Hd = filter_30M_70_6_5m
%FILTER_30M_70_6_5M Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.1 and the DSP System Toolbox 9.3.
% Generated on: 09-Sep-2020 15:57:02

% Equiripple Lowpass filter designed using the FIRPM function.
% order =49
% All frequency values are in MHz.
Fs = 32.5;  % Sampling Frequency

Fpass = 5;                 % Passband Frequency
Fstop = 6.5;               % Stopband Frequency
Dpass = 0.057501127785;    % Passband Ripple
Dstop = 0.00031622776602;  % Stopband Attenuation
dens  = 20;                % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

% [EOF]
