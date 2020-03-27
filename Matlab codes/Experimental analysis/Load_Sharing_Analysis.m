%% analyze the data of unequal load sharing among planets
%% ---------------------load data--------------------------------
% load('2.2Hz_Comparison.mat')
%% ---------------------Fourier transform -----------------------
fs=20480;
M=4;
f_c=2.1125/2*27.1085/28;
f_m=108*f_c;
[y0,~]=MyFFT(Equal_Share,fs);
[y,f]=MyFFT(Unequal_Share,fs);
%% ---------------------Plot figures ----------------------------
figure('Name','Load sharing comparison')
plot(f/f_c,y0,'b-');hold on;
plot(f/f_c/27.69*28,y,'r--');
xlabel('Carrier order');ylabel('Amplitude [m/s^2]')
%% -----------------------Annotations for natural frequency----------------------------------
% t=1/fs:1/fs:length(Equal_Share)/fs;
% f_n=250;% the fault natural frequency
% % f_n=380;% the normal natural frequency
% lambda=3*exp(-70*t).*sin(2*pi*f_n*t);%normal case
% [Amp_natural,f]=MyFFT(lambda,fs);
% plot(f/f_c,Amp_natural,'g-.');
% sigma_0=zeros(1,length(t));
% Theta=2*pi/M;
% sigma_0(t<=Theta)=50*exp(-1.0e2*abs(t(t<=Theta)-Theta/2));
% plot(f/f_c,MyFFT(sigma_0.*III(f_m*t),fs),'r:');
% xlim([0 500]);ylim([0 1e-3]);
% SetFigureProperties;
%% Annotation for normal case
figure;
Equal_Share=detrend(Equal_Share);
t=1/fs:1/fs:length(Equal_Share)/fs;
plot(t,Equal_Share,'b');hold on;
xlim([0 2]);ylim([-0.04 0.04]);
plot([0.2358, 1/f_c+0.2358],[0 ,0],'r');
xlabel('Time [s]');ylabel('Amplitude [m/s^2]');
SetFigureProperties;
% figure;
% xlim([18 34]);ylim([0 1e-5]);
% SetFigureProperties;
%% Annotation for fault case
figure;
Unequal_Share=detrend(Unequal_Share);
t=1/fs:1/fs:length(Unequal_Share)/fs;
plot(t,Unequal_Share,'b');hold on;
xlim([0 2]);
plot([0.2358, 1/f_c+0.2358],[0 ,0],'r');
xlabel('Time [s]');ylabel('Amplitude [m/s^2]');
SetFigureProperties;
figure;
xlim([18 34]);ylim([0 1.2e-5]);
legend('Normal','Fault');
SetFigureProperties;
