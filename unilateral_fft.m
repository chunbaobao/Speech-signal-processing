function [f,P1]=unilateral_fft(y,Fs)%fft的单边谱
    %f为对应频率点
    %P1为单边谱幅度
    %y为输入的语音信号
    %Fs为语音信号采样频率
    L=length(y);
    yw=fft(y);
    P2 = abs(yw/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
end