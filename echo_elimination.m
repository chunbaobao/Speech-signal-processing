
clc;
clear;

filename='./data/man_voice.wav';
[y,Fs] = audioread(filename);%读取语音信号
T=1/Fs;
[f,P1]=unilateral_fft(y,Fs);
figure();
subplot(2,1,1);
plot([0:length(y)-1]/Fs,y);
xlabel('t(s)');
ylabel('y(t)');
title('原语音信号波形');
subplot(2,1,2);
plot(f,P1);
xlabel('f(Hz)');
ylabel('|P1(f)|');
title('原语音信号单边频谱');

t1=1;t2=3;
a1=0.26;a2=0.47;
y_echo=[y;zeros(Fs*t2,1)]+a1*[zeros(t1*Fs,1);y;zeros((t2-t1)*Fs,1)]+a2*[zeros(t2*Fs,1);y];%混有回声的语音信号
[f_echo,P1_echo]=unilateral_fft(y_echo,Fs);
figure();
subplot(2,1,1);
plot([0:length(y_echo)-1]/Fs,y_echo);
xlabel('t(s)');
ylabel('yecho(t)');
title('混有回声的语音信号波形');
subplot(2,1,2);
plot(f_echo,P1_echo);
xlabel('f(Hz)');
ylabel('|P1echo(f)|');
title('混有回声的语音信号单边频谱');

n1=t1*Fs;n2=t2*Fs;
a=[1,zeros(1,n1-1),a1,zeros(1,n2-n1-1),a2];
b=1;
[H,w]=freqz(b,a,2^9);
dbH=20*log10(abs(H)/max(abs(H)));
figure();
subplot(2,1,1);
plot(w/(2*pi)*Fs,dbH);
xlabel('f/Hz');
ylabel('dB');
title('滤波器相对频率特性');
% axis([0,2000,-120,0]);
subplot(2,1,2);
plot(w/(2*pi)*Fs,angle(H)/pi*180)
xlabel('f/Hz');
ylabel('\phi');
title('数字滤波器相位特性');
y_out=filter(b,a,y_echo);%滤波器滤波，消除回声
[f_out,P1_out]=unilateral_fft(y_out,Fs);
figure();
subplot(2,1,1);
plot([0:length(y_out)-1]/Fs,y_out);
xlabel('t(s)');
ylabel('yout(t)');
title('消除回声后语音信号波形');
subplot(2,1,2);
plot(f_out,P1_out);
xlabel('f(Hz)');
ylabel('|P1(f)|');
title('消除回声后语音信号单边频谱');
%计算表达式
syms z;
son=0;monther=0;
for indax=0:length(b)-1
    son=son+b(indax+1)*z^-indax;
end
for indax=0:length(a)-1
    monther=monther+a(indax+1)*z^-indax;
end
result=son/monther;
disp(vpa(result));

