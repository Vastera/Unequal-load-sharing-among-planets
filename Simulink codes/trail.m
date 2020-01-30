M=10;% mass
k=25;% stifness constant part
b=2;% damper coeffecient
A=3;% amplitude of time-varying stiffness part
f_k=5;% frequency of time-varying stiffenss part
epsilon=0.05;% position of gear pinhole
NF=Resonant_frequency(M,k,b)/2/pi
fs=1000;
Draw(x_out.data,fs);
xlim([0.1,10]);


