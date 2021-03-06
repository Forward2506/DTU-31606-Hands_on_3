%% setup 1.1
clear all; clc; %% clear everything
fs=44100; % sampling frequency
[t500,s500]=generate_sinusoid(1,500,0,fs,0.5); % 500 hz sin
[t499,s499]=generate_sinusoid(1,499,0,fs,0.5); % 499 hz sin
[Y500,freq500]=make_spectrum(s500,fs); %frequency spectrum 500 hz sin
[Y499,freq499]=make_spectrum(s499,fs); %frequency spectrum 499 hz sin
%% frequency spectrum plot 1.1 
figure(1) % fig 1
grid on;
stem(freq500,abs(Y500),'o');
hold on
stem(freq499,abs(Y499),'o');
hold off
xlim([480,520]);
xlabel('Frequency [Hz]');
ylabel('Amplitude');
legend('500 Hz signal','499 Hz signal');

saveFig(1,'fig/fig1.eps',150)
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
figure(2) % fig2
plot(t,s,'.')
grid on
xlim([0.8,0.9])
xlabel('Time [s]')
ylabel('Amplitude')


saveFig(2,'fig/fig2.eps',150)
%% spectrum 1.2
[Y,freq]=make_spectrum(s,fs); %frequency spectrum for the signal
%% spectrum plot 1.2
Y_nonoise=Y; %The phase of Y jitters around pi and -pi, so we have to
% cancel the noise, to get a phase plot that makes sense.
Y_nonoise(abs(Y)<max(abs(Y))/1000)=nan; %remove small values of Y
phaseY=angle(Y_nonoise);    % Angle of the "noiseless" Y
magniY=abs(Y_nonoise);      % Magnitude of the "noiseless" Y
figure(3) % fig3
subplot(2,1,1)
hold on;
grid on;
stem(freq,magniY);
xlim([0,16*f0+20]);
xlabel('Frequency [Hz]');
ylabel('Amplitude');
subplot(2,1,2)
hold on;
grid on;
stem(freq,phaseY);
xlim([0,16*f0+20]);
ylim([-1.2*pi, 1.2*pi]);
xlabel('Frequency [Hz]');
ylabel('Phase [rad]');
yticks([-pi,-2/3*pi,-pi/3,0,pi/3,2/3*pi,pi]);
yticklabels({'-\pi','','','0','','','\pi'});

saveFig(3,'fig/fig3.eps',300)
%% Re and Im parts 1.2
% We define two vectors of NaNs to omit all frequencies where the magnitude
% goes below the chosen threshold (0.001)
Y_real = NaN([1,length(Y)]);
Y_imag = NaN([1,length(Y)]);
Y_real(abs(Y) > 0.01) = real(Y(abs(Y) > 0.001));
Y_imag(abs(Y) > 0.01) = imag(Y(abs(Y) > 0.001));
figure(4) % fig4
subplot(2,1,1)
hold on;
grid on;
stem(freq,Y_imag);  
xlim([0,16*f0+20]);
yticks([-0.5,-0.25,0,0.25,0.5])
xlabel('Frequency [Hz]');
ylabel('Imaginary part');
ylim([-0.6,0.6]);
subplot(2,1,2)
hold on;
grid on;
stem(freq,Y_real);
xlim([0,16*f0+20]);
yticks([-0.5,-0.25,0,0.25,0.5])
ylim([-0.6,0.6]);
xlabel('Frequency [Hz]');
ylabel('Real part');


saveFig(4,'fig/fig4.eps',300)
%% spectrum semilog plot 1.2
figure(5) % fig5
semilogx(freq,20*log10(abs(Y)));
hold on
grid on
xlim([0,10^3]);
xlabel('Frequency [Hz]');
ylabel('Amplitude [dB]');
semilogx(25.12,-6.021,'o'); %first peak at 0.125 Hz because of the spectral density
legend('Signal','First peak','Location','northwest')

saveFig(5,'fig/fig5.eps',150)
%% wav file 1.2
%16 bit depth results in clipping of the signal
%a fix could be normalising the amplitude
audiowrite('signal_1-2.wav',s./5,fs,'BitsPerSample',16);
%Or you could simply up the bit depth
%% comparison between original signal and wav file 1.2
s_read=audioread('signal_1-2.wav');
s_read=5.*s_read'; %part of the clipping fix
d=abs(s_read-s); %difference between original an loaded signal
maxd=max(d); %maximum difference 
figure(6) % fig 6
plot(t,s)
hold on
plot(t,s_read)
grid on
xlim([0.85,0.925])
xlabel('Time [s]')
ylabel('Amplitude')
hold off

saveFig(6,'fig/fig6.eps',150)
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

% unfiltered signals plotted
figure(7) % fig7
plot(t500,s500,'+-');
hold on
grid on
plot(t2200,s2200,'*--');
plot(t4050,s4050,'x-.');
plot(t,ir,'ko');
legend('500','2200','4050','ir');
xlabel('Time [s]');
ylabel('Amplitude');
xlim([0,0.003]);
ylim([-1.1,1.1]);
hold off

saveFig(7,'fig/fig7.eps',150)
%% Filtering the signals with the impulse response 500 Hz
f500=conv(ir,s500); % filtered 500 Hz signal
figure(8) % fig8
stem(t500,s500);
hold on
stem(t500,f500(1:10000));
grid on
xlabel('Time [s]');
ylabel('Amplitude');
legend('Unfiltered','Filtered');
xlim([0,0.005]);
ylim([-1.1,1.1]);

saveFig(8,'fig/fig8.eps',150)
%% Filtering the signals with the impulse response 2200 Hz
f2200=conv(ir,s2200); % filtered 2200 Hz signal
figure(9) % fig9
stem(t2200,s2200);
hold on
stem(t2200,f2200(1:10000));
grid on
xlabel('Frequency [Hz]');
ylabel('Amplitude');
legend('Unfiltered','Filtered');
xlim([0,0.01]);
ylim([-1.1,1.1]);

saveFig(9,'fig/fig9.eps',150)
%% Filtering the signals with the impulse response 4050 Hz
f4050=conv(ir,s4050); % filtered 4050 Hz signal
figure(10) % fig10
stem(t4050,s4050);
hold on
stem(t4050,f4050(1:10000));
grid on
xlabel('Frequency [Hz]');
ylabel('Amplitude');
legend('Unfiltered','Filtered');
xlim([0,0.01]);
ylim([-1.1,1.1]);

saveFig(10,'fig/fig10.eps',150)
%% Amplitude test
figure(11) % fig11
plot(t500,f500(1:10000));
hold on
plot(t2200,f2200(1:10000));
plot(t4050,f4050(1:10000));
grid on
xlabel('Frequency [Hz]');
ylabel('Amplitude');
legend('500 Hz','2200 Hz','4050 Hz');
xlim([0,0.01]);

saveFig(11,'fig/fig11.eps',150)

max500=max(abs(f500(21:10000))); %max value of the 500 hz filtered sine, after the first period, and before the last
max2200=max(abs(f2200(21:10000))); %max value of the 2200 hz filtered sine, after the first period, and before the last
max4050=max(abs(f4050(21:10000))); %max value of the 4050 hz filtered sine, after the first period, and before the last

%% Filtering by filter-command
h=1/21*ones(1,21); % non-zeropadded impulse respons for the filter
fnew500=filter(h,1,s500); %the new filtered signal
figure(12)
stem(t500,s500);
hold on
stem(t500,fnew500(1:10000));
grid on
xlabel('Time [s]');
ylabel('Amplitude');
legend('Unfiltered','Filtered');
xlim([0,0.005]);
ylim([-1.1,1.1]);

saveFig(12,'fig/fig12.eps',150)

%% The analytical case check (re-use of the filter code)
[t50,s50]=generate_sinusoid(1,10,0,50,10); %The duration of the sin is chosen to be 10 s.
rs=ones(1,5); %the impulse response of the running sum filter
f50=filter(rs,1,s50); %filtered signal

figure(13)
plot(t50,s50,'o-');
hold on
plot(t50,f50,'o-');
grid on
xlim([0,0.5])
xlabel('Time [s]');
ylabel('Amplitude');
legend('Unfiltered','Filtered');

saveFig(13,'fig/fig13.eps',150)



%% saveFig(figure, pathToSaveTo, heightOfFigure
%
function saveFig(fig, path, height)
    s = load('exportstyle.mat');
    s = s.s;
    s.Height = height;
    hgexport(fig,'temp_dummy',s,'applystyle',true);
    saveas(fig,path,'epsc')
end