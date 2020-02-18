M=10;% mass
k=25;% stifness constant part
b=2;% damper coeffecient
A=3;% amplitude of time-varying stiffness part
f_k=5;% frequency of time-varying stiffenss part
N=10;
epsilon=0.05;% position of gear pinhole
NF=Resonant_frequency(M,k,b)/2/pi
fs=1000;
Draw(x_out.data,fs);
xlim([0.2,10]);
figure('Name','planet 1 and planet 3');
plot(planet_1);hold on; plot(planet_2);
legend('planet 1','planet 2');
figure('Name','Signal model');
plot(Sig);
Draw(Sig.data,fs); xlim([2,8]);
