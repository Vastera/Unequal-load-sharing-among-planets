%% Intial factors
fs=10000;% sampling frequency
t=1/fs:1/fs:10;% time seiries
M=4;%planet number
N=61;%ring gear tooth number
f_c=3;
R_r=125;
F=1;
a=0.1*2*pi*R_r/M;
%% configuration parameters
i=1:1:M;% planet sequential order
Theta_i=2*pi*(i-1)./M;%nominal position
epsilon_i=[0,0.1/pi*180,0,0];% position error of i-th planet
f_m=N*f_c;
x=zeros(1,length(t));
l=zeros(M,length(t));
sigma_i=zeros(M,length(t));
for j=1:M
    T_ri=f_m*(t-Theta_i(j)/(2*pi*f_c));% actual time sequence of planet-ring
%     T_ti=t-Theta_i(j);% actual time sequence of transfer path
    l(j,:)=Transfer_length(t,j,M,f_c,R_r);
    sigma_i(j,:)=exp(-F*l(j,:)/a);% sigma_i is the time-varying transfer path effect
    figure(j);
    plot(t,III(T_ri));hold on;
    plot(t,sigma_i(j,:));
    x=III(T_ri).*sigma_i(j,:)+x;
end
Draw(x,fs);
xlim([0 500]);
ylabel('Amplitude');xlabel('Frequency [Hz]');
SetFigureProperties;