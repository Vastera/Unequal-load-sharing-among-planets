%% Intial factors
fs=10000;% sampling frequency
t=1/fs:1/fs:10;% time seiries
N=61;%ring gear tooth number
f_c=3;
R_p=35*0.9e-3/2;% gear module is 0.9e-3
R_r=108*0.9e-3/2;% gear module is 0.9e-3
R_s=36*0.9e-3/2;% gear module is 0.9e-3
T_s=30;% input torque
F=T_s/300;
%% unequal load sharing case
%% perfect case
% epsilon_i=[0,0,0,0];% position error of i-th planet
epsilon_i=[0,0,0,0/180*pi,0];% position error of i-th planet
M=length(epsilon_i);%planet number
a=0.1*2*pi*R_r/M;
%% configuration parameters
i=1:1:M;% planet sequential order
Theta_i=2*pi*(i-1)./M;%nominal position
phi=0.05*pi/180;% phase difference between sun and planet
%% 
e_i=2*(R_r-R_p)*sin(epsilon_i/2).*cos(epsilon_i/2);
k_e=1/(1/3.2e7+1/(1.67e8+2.57e8));
%% Calculate the load sharing coefficients L_i using tranlational analogy
L_i = Load_sharing_coef(epsilon_i,T_s,R_p,R_r,R_s,k_e);
%% compare with the closed form 
% switch M
%     case 4
%         for j=1:M
%             L_i(j)=1/M+k_e*R_s/2/M/T_s*circshift(e_i,-(j-1))*[1;-1;1;-1]; %Load sharing , the input torque is 30 N*m
%         end
%     case 5
%         for j=1:M
%              L_i(j)=1/M+k_e*R_s/2/M/T_s*circshift(e_i,-(j-1))*[2;-1.618;0.618;0.618;-1.618]; %Load sharing , the input torque is 30 N*m
%         end
%     case 6
%         for j=1:M
%             subscript=[mod(j,6),mod(j+1,6),mod(j+3,6),mod(j+5,6)];
%             subscript(subscript==0)=6;
%              L_i(j)=1/M+k_e*R_s/2/M/T_s*e_i(subscript)*[3;-2;1;-2]; %Load sharing , the input torque is 30 N*m
%         end
% end
%% when certain planets are unloaded
f_n=200+100*sum(L_i~=0);% f_n increases with the contacting planet number
%% Transfer path effect
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
    sigma_i(j,:)=F*exp(-l(j,:)/a);% sigma_i is the time-varying transfer path effect
    x=L_i(j)*sigma_i(j,:).*(III(T_ri)+eta*III(T_si))+x;
end
%% Natural vibration
lambda=exp(-150*t).*sin(2*pi*f_n*t);%normal case
x1=conv(x,lambda);x1=x1(1:length(t));
%% Fourier spectrum with natural frequency
[Amplitude,f]=MyFFT(x1,fs);
[~,f_c0]=III(f_m*t);
f_c0=fs/f_c0/N;% the actual carrier frequency in signal
figure('Name','Fourier spectrum');
plot(f/f_c0,Amplitude,'b');
[Amp_natura1,f]=MyFFT(lambda,fs);
% Natural frequency envelope in spectrum
hold on;
plot(f/f_c0,Amp_natura1*F*20,'g-.');
% transfer path envelope in spectrum
sigma_0=zeros(1,length(t));
sigma_0(t<=Theta_i(2))=F*exp(-2*pi*R_r*f_c0*abs(t(t<=Theta_i(2))-Theta_i(2)/2)/a);
plot(f/f_c0,1.5e2*MyFFT(sigma_0.*III(f_m*t),fs),'r:');
legend('Synthesized signal','Natural vibration','Tranfer path effect','Location','northeast');
% figure property settings
switch M
    case 3
        xlim([110 140]);
    case 4
        xlim([170 200]);
    case 5
        xlim([100 300]);%ylim([0 0.03]);
    case 6
        xlim([100 300]);ylim([0 0.02]);
end
ylabel('Amplitude');xlabel('Carrier order');
SetFigureProperties;
%% Annotations for frequency sample
% xlim([150 400]);
% plot([300,306],[0.0062,0.0062],'r');
% plot([360,366],[0.002,0.002],'r');
% plot([N*3,N*3],[0.0061,0.007],'r');
% plot([N*4,N*4],[0.0061,0.007],'r');
% plot([f_n/f_c,f_n/f_c],[0,0.01],'g--');
%% Annotations for shifted natural frequency
%--- epsilon_i=[0,0,1/180*pi,0,0]
%--- input torque T_s=300 or T_s=30
%--- planet number M =5
% xlim([0 500]);ylim([0 2e-2]);
% plot([f_n/f_c0,f_n/f_c0],[0,0.015],'g--')
% legend('3 contacting planets','5 contacting planets','Natural vibration','Tranfer path effect','Location','northeast');
% SetFigureProperties;
%% Time domain figure
figure('Name','Time domain');
plot(t*f_m,x1,'b');hold on;
xlim([0,80]);
xlabel('Gear meshing interval');
ylabel('Amplitude');
%% Annotations for time domain sample figure
% for j=1:M
%     plot(t*f_m,sigma_i(j,:)*L_i(j),'m--');
% end
% ylim([-0.3,0.6]);
% plot([40,40],[-0.09,-0.2],'r');
% plot([41,41],[-0.09,-0.2],'r');
% plot([71, 71],[0.18,0.3],'r');
% plot([10,71],[0.28,0.28],'r');
% plot([25,30.5],[0.16,0.16],'r');
% legend('Synthesized signal','Transfer path effect');
SetFigureProperties;

