function l=Transfer_length(t,i,M,f_c,R_r)
% Copyright@ vastera@163.com
% General introduction:Calculate the length of the time varing transfer path
%% ====================== INPUT ========================
% t:          Type:vector
%                           t description:input time series
% i:          Type:integer
%                           i description: the planet order number
% M:          Type: integer
%                           M description: planet numbers
% f_c:        Type:number
%                           f_c description:carrier Frequency
% R_r:        Type: integer
%                           R_r description: ring gear radius
% ---------------------OPTIONAL:
% optional arg:              Type:
%                            description:
%% ====================== OUTPUT =======================
% l:          Type:vector with the same length of t
%                           l description: the time-varying length of transfer path
%% =====================================================
l=Inf*ones(1,length(t)); % otherwise occasion
n=0 ;% period of carrier roation
%% Compare first left boundary with zero
left= (2*i-3)/(2*M*f_c);
right= (2*i-1)/(2*M*f_c);
if left>0% if left bound is positive
    index=(t>=left & t<right);
    l(index) = 2*pi*R_r*f_c*abs(t(index)-(i-1)/(M*f_c));
else% if left bound is negative
    index=(t<right);
    l(index) = 2*pi*R_r*f_c*abs(t(index)-(i-1)/(M*f_c));
end
%% Residual n occassions 
n=1;
left= n/f_c+(2*i-3)/(2*M*f_c);
right= n/f_c+(2*i-1)/(2*M*f_c);
while right<=max(t)%% while the right bound is lower than the max time
    index=(t>=left & t<right);
    l(index) = 2*pi*R_r*f_c*abs(t(index)-n/f_c-(i-1)/(M*f_c));% the first piece function.
    n=n+1;
    left= n/f_c+(2*i-3)/(2*M*f_c);
    right= n/f_c+(2*i-1)/(2*M*f_c);
end
end