%% Intial factors
fs=10000;% sampling frequency
t=1/fs:1/fs:10;% time seiries
N=61;%ring gear tooth number
f_c=3;
R_p=35*0.9e-3/2;% gear module is 0.9e-3
R_r=108*0.9e-3/2;% gear module is 0.9e-3
R_s=36*0.9e-3/2;% gear module is 0.9e-3
T_s=3e2;% input torque
F=T_s/300;
%% unequal load sharing case
%% perfect case
% epsilon_i=[0,0,0,0];% position error of i-th planet
epsilon_i=[0,0/180*pi,0/180*pi,0];% position error of i-th planet
M=length(epsilon_i);%planet number
a=0.1*2*pi*R_r/M;
%% configuration parameters
i=1:1:M;% planet sequential order
Theta_i=2*pi*(i-1)./M;%nominal position
phi=0.05*pi/180;% phase difference between sun and planet
%% 
e_i=2*(R_r-R_p)*sin(epsilon_i/2).*cos(epsilon_i/2);
%% Transfer path effect
eta=exp(-2*R_p/a);%the amplitude factor between planet-ring and planet-sun
f_m=N*f_c;
f_s=f_m/36+f_c;
x=zeros(1,length(t));
l=zeros(M,length(t));
sigma_i=zeros(M,length(t));
figure;hold on;
for j=1:M
    T_ri=f_m*(t-(Theta_i(j)+epsilon_i(j))/(2*pi*f_c));% actual time sequence of planet-ring
    T_si=f_m*(t-(Theta_i(j)+epsilon_i(j))/(2*pi*f_s-2*pi*f_c))+phi/2/pi;% time sequence of planet-sun
    l(j,:)=Transfer_length(t,M,f_c,R_r,epsilon_i(j),Theta_i(j));
    sigma_i(j,:)=F*exp(-l(j,:)/a);% sigma_i is the time-varying transfer path effect
    %%%%%%%%%%%%%%% transfer path effect i time domain %%%%%%%%%%%%%%
    plot(t,sigma_i(j,:));
end
xlim([0, 0.5]);
ylim([0 1.5]);
legend('planet 1','planet 2','planet 3','planet 4');
xlabel('Time [s]');ylabel('Amplitude');
SetFigureProperties;
%%%%%%%%%%% transfer path length %%%%%%%%%%%%%
figure;hold on;
for j=1:M
    plot(t,l(j,:));
end
xlim([0, 0.5]);
ylim([0 0.08]);
legend('planet 1','planet 2','planet 3','planet 4');
xlabel('Time [s]');ylabel('Amplitude');
SetFigureProperties;