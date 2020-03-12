%% Intial factors
fs=10000;% sampling frequency
t=1/fs:1/fs:10;% time seiries
N=61;%ring gear tooth number
f_c=3;
R_p=35*0.9e-3;% gear module is 0.9e-3
R_r=108*0.9e-3;% gear module is 0.9e-3
R_s=36*0.9e-3;% gear module is 0.9e-3
F=1;
%% unequal load sharing case
%% perfect case
% epsilon_i=[0,0,0,0];% position error of i-th planet
epsilon_i=[0,0.00/180*pi,0.00/180*pi,0.00/180*pi];% position error of i-th planet
M=length(epsilon_i);%planet number
a=0.1*2*pi*R_r/M;
%% configuration parameters
i=1:1:M;% planet sequential order
Theta_i=2*pi*(i-1)./M;%nominal position
phi=0.05*pi/180;% phase difference between sun and planet

%% 
e_i=2*(R_r-R_p)*sin(epsilon_i/2).*cos(epsilon_i/2);
k_e=1/(1/3.2e7+1/(1.67e8+2.57e8));
L_i=1/M*ones(1,M);
switch M
    case 4
        for j=1:M
            L_i(j)=1/M+k_e*R_s/2/M/30*circshift(e_i,-(j-1))*[1;-1;1;-1]; %Load sharing , the input torque is 30 N*m
        end
    case 5
        for j=1:M
             L_i(j)=1/M+k_e*R_s/2/M/30*circshift(e_i,-(j-1))*[2;-1.618;0.618;0.618;-1.618]; %Load sharing , the input torque is 30 N*m
        end
    case 6
        for j=1:M
            subscript=[mod(j,6),mod(j+1,6),mod(j+3,6),mod(j+5,6)];
            subscript(subscript==0)=6;
             L_i(j)=1/M+k_e*R_s/2/M/30*e_i(subscript)*[3;-2;1;-2]; %Load sharing , the input torque is 30 N*m
        end
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
[Amplitude,f]=MyFFT(x1,fs);
[~,f_c0]=III(f_m*t);
f_c0=fs/f_c0/N;% the actual carrier frequency in signal
plot(f/f_c0,Amplitude,'b');
[Amp_natural,f]=MyFFT(lambda,fs);
% Natural frequency envelope in spectrum
hold on;
plot(f/f_c0,Amp_natural*20,'g--');
% transfer path envelope in spectrum
sigma_0=zeros(1,length(t));
sigma_0(t<=Theta_i(2))=F*exp(-2*pi*R_r*f_c0*abs(t(t<=Theta_i(2))-Theta_i(2)/2)/a);
plot(f/f_c0,1.5e2*MyFFT(sigma_0.*III(f_m*t),fs),'r:');
legend('Synthesized signal','Natural vibration','Tranfer path effect','Location','northeast');
% figure property settings
switch M
case 4
    xlim([100 150]);
    ylim([0 1e-2])
case 5
    xlim([100 150]);
    ylim([0 1e-2]);
case 6
    xlim([100 150]);
    ylim([0 1e-2]);
end
ylabel('Amplitude');xlabel('Carrier order');
SetFigureProperties;