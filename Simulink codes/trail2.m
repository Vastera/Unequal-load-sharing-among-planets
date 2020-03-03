%% Intial factors
fs=1000;% sampling frequency
t=1/fs:1/fs:10;% time seiries
M=4;%planet number
f_c=3.1;
%% configuration parameters
i=1:1:M;% planet sequential order
Theta_i=2*pi*(i-1)./M;%nominal position
epsilon_i=[0,0.1/pi*180,0,0];% position error of i-th planet


