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
plot(freq500,abs(Y500),'bo--');
plot(freq499,abs(Y499),'ro--');
xlim([480,520]);
xlabel('Frequency [Hz]');
ylabel('Amplitude');
legend('500 Hz signal','499 Hz signal');
%% setup 1.2
clear all; clc; % clear everything
fs=10000; % sampling frequency
f0=25;
T=4;
s=0; % placeholder
for k = 0:4
    [t,c]=generate_sinusoid(1,2^k*f0,pi/2+k*pi/3,fs,4); % the cosinus inside the sum
    s=s+c; %final signal
end 
%% signal plot 1.2
figure
plot(t,s,'bo--')
hold on
grid on
xlim([0.8,0.9])
xlabel('Time [s]')
ylabel('Amplitude')
%% spectrum 1.2
[Y,freq]=make_spectrum(s,fs); %frequency spectrum for the signal
%% spectrum plot 1.2
figure
subplot(2,1,1)
hold on;
grid on;
plot(freq,abs(Y),'bo--');
xlim([0,8*f0+20]);
xlabel('Frequency [Hz]');
ylabel('Amplitude');
subplot(2,1,2)
hold on;
grid on;
plot(freq,angle(Y),'bo--');
xlim([0,8*f0+20]);
xlabel('Frequency [Hz]');
ylabel('Phase [rad]');
yticks([-pi,-2/3*pi,-pi/3,0,pi/3,2/3*pi,pi]);
yticklabels({'-\pi','','','0','','','\pi'});

%% spectrum semilog plot 1.2
figure
semilogx(freq,20*log10(abs(Y)),'bo--');
hold on
grid on
xlim([0,10^3]);
xlabel('Frequency [Hz]');
ylabel('Amplitude [dB]');
semilogx(25.12,-6.021,'ro'); %first peak at 0.125 Hz because of the spectral density
legend('Signal','First peak','Location','northwest')
%% Re and Im parts 1.2
figure
subplot(2,1,1)
hold on;
grid on;
plot(freq,imag(Y),'ro--');
xlim([-5,4*f0+5]);
yticks([-0.5,-0.25,0,0.25,0.5])
xlabel('Frequency [Hz]');
ylabel('Imaginary part');
subplot(2,1,2)
hold on;
grid on;
plot(freq,real(Y),'bo--');
xlim([-5,4*f0+5]);
yticks([-0.5,-0.25,0,0.25,0.5,0.75,1])
xlabel('Frequency [Hz]');
ylabel('Real part');

%% wav file 1.2
%16 bit depth results in clipping of the signal
%a fix could be normalising the amplitude
audiowrite('signal_1-2.wav',s./5,fs,'BitsPerSample',16);
%Or you could simply up the bit depth
%% comparison between original signal and wav file 1.2
s_read=audioread('signal_1-2.wav');
s_read=5.*s_read'; %part of the clipping fix
figure
plot(t,s,'bo')
hold on
plot(t,s_read,'ro')
grid on
xlim([0.85,0.925])
xlabel('Time [s]')
ylabel('Amplitude')
legend('Original signal','Loaded signal')




%% Hands on 2
clear all; clc;
Fs=10000; % sampling frequency
t=0:1/Fs:0.1; %time vector
N=21; % order of filter
ir=zeropad(1/N.*ones(1,N),length(t)-N); %impulse response of the filter
%% generating sinusoids
[t500,s500]=generate_sinusoid(1,500,0,Fs,1); %500 Hz sin
[t2200,s2200]=generate_sinusoid(1,2200,0,Fs,1); %2200 Hz sin
[t4050,s4050]=generate_sinusoid(1,4050,0,Fs,1); %4050 Hz sin

figure %% unfiltered signals plotted
plot(t500,s500,'ro--');
hold on
grid on
plot(t2200,s2200,'bo--');
plot(t4050,s4050,'go--');
plot(t,ir,'ko');
legend('500','2200','4050','ir');
xlabel('Time [s]');
ylabel('Amplitude');
xlim([0,0.003]);
ylim([-1.1,1.1]);
%% Filtering the signals with the impulse response 500 Hz
f500=conv(ir,s500); % filtered 500 Hz signal
figure
plot(t500,s500,'ro--');
hold on
plot(t500,f500(1:10001),'bo--');
grid on
xlabel('Time [s]');
ylabel('Amplitude');
legend('Unfiltered','Filtered');
xlim([0,0.005]);
ylim([-1.1,1.1]);
%% Filtering the signals with the impulse response 2200 Hz
f2200=conv(ir,s2200); % filtered 2200 Hz signal
figure
plot(t2200,s2200,'ro--');
hold on
plot(t2200,f2200(1:10001),'bo--');
grid on
xlabel('Frequency [Hz]');
ylabel('Amplitude');
legend('Unfiltered','Filtered');
xlim([0,0.01]);
ylim([-1.1,1.1]);
%% Filtering the signals with the impulse response 4050 Hz
f4050=conv(ir,s4050); % filtered 4050 Hz signal
figure
plot(t4050,s4050,'ro--');
hold on
plot(t4050,f4050(1:10001),'bo--');
grid on
xlabel('Frequency [Hz]');
ylabel('Amplitude');
legend('Unfiltered','Filtered');
xlim([0,0.01]);
ylim([-1.1,1.1]);
%% Filtering by filter-command
h=1/21*ones(1,21); % non-zeropadded impulse respons for the filter
fnew500=filter(h,1,s500); %the new filtered signal
figure
plot(t500,s500,'ro--');
hold on
plot(t500,fnew500(1:10001),'go--');
grid on
xlabel('Time [s]');
ylabel('Amplitude');
legend('Unfiltered','Filtered');
xlim([0,0.005]);
ylim([-1.1,1.1]);

%% The analytical case check (re-use of the filter code)
[t50,s50]=generate_sinusoid(1,10,0,50,0.5); %The duration of the sin is chosen to be 0.5 s.
rs=ones(1,5); %the impulse response of the running sum filter
f50=filter(rs,1,s50); %filtered signal

figure
plot(t50,s50,'ro--');
hold on
plot(t50,f50,'go--');
grid on
xlabel('Time [s]');
ylabel('Amplitude');
legend('Unfiltered','Filtered');