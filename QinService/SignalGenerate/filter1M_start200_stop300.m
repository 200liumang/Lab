function Hd = filter1M_start200_stop300
%FILTER1M_START200_STOP300 返回离散时间滤波器对象。

% MATLAB Code
% Generated by MATLAB(R) 9.8 and Signal Processing Toolbox 8.4.
% Generated on: 18-Dec-2020 15:09:57

% Equiripple Lowpass filter designed using the FIRPM function.

% All frequency values are in kHz.
Fs = 1000;  % Sampling Frequency

Fpass = 200;             % Passband Frequency
Fstop = 300;             % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.001;           % Stopband Attenuation
dens  = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

% [EOF]
