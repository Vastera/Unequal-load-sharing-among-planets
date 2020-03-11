%% Intial factors
fs=10000;% sampling frequency
t=1/fs:1/fs:10;% time seiries
M=4;%planet number
N=61;%ring gear tooth number
f_c=3;
R_p=35*0.9e-3;% gear module is 0.9e-3
R_r=108*0.9e-3;% gear module is 0.9e-3
R_s=36*0.9e-3;% gear module is 0.9e-3
F=1;
a=0.1*2*pi*R_r/M;
%% configuration parameters
i=1:1:M;% planet sequential order
Theta_i=2*pi*(i-1)./M;%nominal position
phi=0.05*pi/180;% phase difference between sun and planet
%% perfect case
% epsilon_i=[0,0,0,0];% position error of i-th planet
%% unequal load sharing case
epsilon_i=[0,0.01/180*pi,0,0];% position error of i-th planet
%% 
e_i=2*(R_r-R_p)*sin(epsilon_i/2).*cos(epsilon_i/2);
k_e=1/(1/3.2e7+1/(1.67e8+2.57e8));
L_i=0.25*ones(1,M);
for j=1:4
    L_i(j)=0.25+k_e*R_s/8/30*circshift(e_i,-(j-1))*[1;-1;1;-1]; %Load sharing , the input torque is 30 N*m
end
eta=exp(-2*R_p/a);%the amplitude factor between planet-ring and planet-sun
f_m=N*f_c;
f_s=f_m/36+f_c;
x=zeros(1,length(t));
l=zeros(M,length(t));
sigma_i=zeros(M,length(t));
for j=1:M
    T_ri=f_m*(t-(Theta_i(j)+epsilon_i(j))/(2*pi*f_c));% actual time sequence of planet-ring
    T_si=f_m*(t-(Theta_i(j)+epsilon_i(j))/(2*pi*f_s-2*pi*f_c))+phi/2/pi;% time sequence of planet-sun
    l(j,:)=Transfer_length(t,M,f_c,R_r,epsilon_i(j),Theta_i(j));
    sigma_i(j,:)=exp(-F*l(j,:)/a);% sigma_i is the time-varying transfer path effect
    x=L_i(j)*sigma_i(j,:).*(III(T_ri)+eta*III(T_si))+x;
end
%% Natural frequency
lambda=exp(-150*t).*sin(2*pi*300*t);%normal case

x1=conv(x,lambda,'same');
%% Fourier spectrum with natural frequency
Draw(x1,fs);
[Amp,f]=MyFFT(lambda,fs);
% Natural frequency envelope in spectrum
hold on;
plot(f,Amp*20,'g--');
% transfer path envelope in spectrum
sigma_0=zeros(1,length(t));
sigma_0(t<=Theta_i(2))=F*exp(-2*pi*R_r*f_c*abs(t(t<=Theta_i(2))-Theta_i(2)/2)/a);
plot(f,1.5e2*MyFFT(sigma_0.*III(f_m*t),fs),'r:');
%% substantiate the sigma_0 shape in spectrum
% plot(t,sigma_0);
% A1=fft(sigma_0)./length(sigma_0);
% A1=circshift(A1,length(A1)/2);
% f1=linspace(-fs/2,fs/2,length(sigma_0));
% plot(f1,abs(A1));
% xlim([-100,100]);
% Figure properties
legend('Synthesized signal','Natural vibration','Tranfer path effect');
xlim([0 500]);
ylabel('Amplitude');xlabel('Frequency [Hz]');
SetFigureProperties;