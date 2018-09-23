%% setup 1.1
clear all; clc; %% clear everything
fs=44100; % sampling frequency
[t500,s500]=generate_sinusoid(1,500,0,fs,0.5); % 500 hz sin
[t499,s499]=generate_sinusoid(1,499,0,fs,0.5); % 499 hz sin
[Y500,freq500]=make_spectrum(s500,fs); %frequency spectrum 500 hz sin
[Y499,freq499]=make_spectrum(s499,fs); %frequency spectrum 499 hz sin
%% frequency spectrum plot 1.1 
figure
hold on;
grid on;
plot(freq500,abs(Y500),'b');
plot(freq499,abs(Y499),'r');
xlim([480,520]);
xlabel('frequency [Hz]');
ylabel('amplitude');
%% setup 1.2
clear all; clc; %% clear everything
fs=10000; % sampling frequency
f0=25;
T=4;
s=0; %%placeholder
for k = 0:4
    [t,c]=generate_sinusoid(1,k*f0,pi/2+k*pi/3,fs,4); % cos
    s=s+c; %final signal
end 
%% signal plot 1.2
figure
plot(t,s,'bo')
hold on
grid on
xlim([0.8,0.9])
%% spectrum 1.2
[Y,freq]=make_spectrum(s,fs); %frequency spectrum 500 hz sin
%% spectrum plot 1.2
figure
subplot(2,1,1)
hold on;
grid on;
plot(freq,abs(Y),'b');
xlim([-5,4*f0+5]);
xlabel('frequency [Hz]');
ylabel('amplitude');
subplot(2,1,2)
hold on;
grid on;
plot(freq,angle(Y),'b');
xlim([-5,4*f0+5]);
xlabel('frequency [Hz]');
ylabel('phase [rad]');

%% spectrum semilog plot 1.2
figure
subplot(2,1,1)
hold on;
grid on;
semilogx(freq,abs(Y),'b'); %semilogx doesn't seem to be working
xlim([-5,4*f0+5]);
xlabel('frequency [Hz]');
ylabel('amplitude');
semilogx(0,1,'ro');
legend('signal','first peak')
subplot(2,1,2)
hold on;
grid on;
semilogx(freq,angle(Y),'b');
xlim([-5,4*f0+5]);
xlabel('frequency [Hz]');
ylabel('phase [rad]');

%% Re and Im parts 1.2
figure
subplot(2,1,1)
hold on;
grid on;
plot(freq,imag(Y),'r');
xlim([-5,4*f0+5]);
xlabel('frequency [Hz]');
ylabel('Imaginary part');
subplot(2,1,2)
hold on;
grid on;
plot(freq,real(Y),'b');
xlim([-5,4*f0+5]);
xlabel('frequency [Hz]');
ylabel('Real part');

%% wav file 1.2
audiowrite('signal_1-2.wav',s,fs,'BitsPerSample',16);
%16 bit depth results in clipping of the signal
%a fix could be
%audiowrite('signal_1-2.wav',s./5,fs,'BitsPerSample',16);
%Or you could simply up the bit depth
%% comparison between original signal and wav file
s_read=audioread('signal_1-2.wav');
s_read=s_read';
%s_read=5.*s_read'; %part of the clipping fix
figure
plot(t,s,'bo')
hold on
plot(t,s_read,'ro')
grid on
xlim([0.85,0.925])