function [Y, freq] = make_spectrum(signal, fs)
% Returns the complex spectrum Y from the input signal
% and sampling frequency, along with the correct frequency vector.

% compute spectrum (note: it will be complex-valued).
Y = fft(signal);
Y = fftshift(Y);
% The FFT needs to be scaled in order to give a physically plausible scaling.
Y = Y/(length(Y));
% NOTE: If you do an IFFT, this scaling must NOT be done.
% We’ll get to this in the lecture. If you are only interested
% in the positive frequencies, you need to scale by <length(Y)/2>.
% frequency vector
delta_f = fs/length(Y);
freq = -fs/2:delta_f:fs/2-delta_f;
% NOTE: The first element that comes out of the FFT is the DC offset
% (i.e., frequency 0). Each subsequent
% bin is spaced by the frequency resolution <delta_f> which you can
% calculate from the properties of the input signal. Remember the highest
% frequency you can get in a digitized signal....
% ...
% eof
end

