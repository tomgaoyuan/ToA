close all;
clear all;
%%
%s_a(t) = sin(2*pi*t) T=1 F=1 
T_s=1/20;
n = [0:1/(T_s)-1];
s = sin(2*pi*T_s*n);
%figure;
%stem(s);
%grid on;
S = fft([s zeros(1,128-length(s))]);
w = [0:127]/128*2;
%figure;
%stem(w,abs(S));
%xlabel('pi');
%grid on;
S_re = S;
S_re = [ S_re(length(S)/2+1 : end)  S_re(1:length(S)/2) ];
%figure;
%plot(w/T_s/2-1/T_s/2,abs(S_re));
%xlabel('Hz');
%grid on;
%%
%delay 0.5 chip
T_s_2 = T_s / 2;
n_2 = [0:1/(T_s_2)-1];
s_2 = sin(2*pi*T_s_2*n_2);
%figure;
%stem(s_2);
%grid on;
s_2 = [ 0 s_2];
s_2 = s_2(1:2:end);
%figure;
%stem(s_2);
%grid on;
S_2 = fft([s_2 zeros(1,128-length(s_2))]);
w = [0:127]/128*2;
%figure;
%stem(w,abs(S_2));
%xlabel('pi');
%grid on;
S_re_2 = S_2;
S_re_2 = [ S_re_2(length(S_2)/2+1 : end)  S_re_2(1:length(S_2)/2) ];
S_re_2 - S_re .* exp(-1i*[-64:63]/128*2*pi*0.5)
%%
%delay 1 chip 
s_3 = [0 s];
%figure;
%stem(s_3);
%grid on;
S_3 = fft([s_3 zeros(1,128-length(s_3))]);
%figure;
%stem(w,abs(S_3));
%xlabel('pi');
%grid on;
S_3 - S.* exp(-1i*[0:127]/128*2*pi*1); %DFT time delay 
S_re_3 = S_3;
S_re_3 = [ S_re_3(length(S_3)/2+1 : end)  S_re_3(1:length(S_3)/2) ];
S_re_3 - S_re .* exp(-1i*[-64:63]/128*2*pi*1)