clear all
close all 

fs=20000; %Frencuencia de muestreo digital
Fs=50*fs; %Frecuencia de muestreo señal analogica
fc=1800; %Frecuencia de portadora
ts=1/Fs; %ts señal digita
t=0:ts:0.04; %tiempo señal analogica

%construccion de señal analogica m
m=5*cos(2*pi*100*t)+2*cos(2*pi*200*t)+cos(2*pi*400*t); 

%la portadora 
c=cos(2*pi*fc*t); 

figure (1)
plot(t,m)
title('Señal m(t)'); 
xlabel('t')
ylabel('m(t)')
grid on 

figure(2)
plot(t,c)
title('Señal portadora c(t)')
xlabel('t')
ylabel('c(t)')
grid on

%Muestreamos las señales m(t) y c(t) 
n=0:800;
N=length(n);

%señal m muestreada
m_n=5*cos(2*pi*(100/fs)*n)+2*cos(2*pi*(200/fs)*n)+cos(2*pi*(400/fs)*n); 
%señal c muestreada
c_n=cos(2*pi*(fc/fs)*n);

figure(3)
stem(n,m_n)
title('Señal m(n)')
xlabel('n')
ylabel('m_n')
grid on

figure(4)
stem(n,c_n)
title('Señal c(n)')
xlabel('n')
ylabel('c_n')
grid on

%Sacamos Transformada de Fourier 
M_filtro=fftshift(fft(m_n,N));
f=linspace(-fs/2, fs/2,N); 
figure(5)
plot(f,abs(M_filtro),'r')
grid on
title('Espectro de la señal m(n) en Hertz')
xlabel('f');
ylabel('M(f)')

%Transformada de Fourier señal portadora 
C=fftshift(fft(c_n,N)); 
figure(6)
plot(f,abs(C),'r')
grid on
title('Espectro de la señal c(n) en Hertz')
xlabel('f');
ylabel('C(f)')

%Obtenemos la señal modulada
y_n=m_n.*c_n; 
figure(7)
stem(n,y_n)
title('Señal modulada en DSB-SC y(n)')
xlabel('n')
ylabel('y(n)')
grid on

%Transformada de Fourier de señal modulada en DSB-SC
Y=fftshift(fft(y_n,N)); 
figure(8)
plot(f,abs(Y),'r')
grid on
title('Espectro de señal modulada en DSB-SC y(n)')
xlabel('f');
ylabel('Y(f)')

%Demodulacion Coherente mediante Filtros FIR simétricos
r_n=y_n.*c_n; 
figure(9)
stem(n,r_n)
title('Señal r(n) = y(n)c(n)')
xlabel('n')
ylabel('r(n)')
grid on

%Espectro de señal demodulada r(n)
R=fftshift(fft(r_n,N)); 
figure(10)
plot(f,abs(R),'r')
grid on
title('Espectro de señal r(n)')
xlabel('f');
ylabel('R(f)')

%Diseñamos el filtro FIR Simetrico con M=100
M_filtro = 100;
A = A(M_filtro);
H = [ones(1,16) 0.5 zeros(1,33)]';
h = inv(A)*H;
h=[h; flipud(h)];

%Filtro FIR Simetrico
figure(11)
stem(h,'m');
grid on
title('Filtro FIR Simétrico en tiempo discreto')
xlabel('t');
ylabel('h(n)')

w=-pi:0.001:pi;
Hr=0;
for n=0:M_filtro/2 - 1
   Hr = Hr + 2*h(n+1)*cos((((M_filtro-1)/2)-n)*w); 
end

figure(12)
plot(w, 20*log10(abs(Hr)),'m');
title('Espectro de filtro FIR simetrico H')
xlabel('f');
ylabel('dBm')
axis([-pi pi -120 10]);


%Recuperamos m2
m2 = conv(r_n,h,'same'); 
figure(13)
stem(m2);
grid on
title('Señal recuperada m_2(n)')

%Transformada de Fourier para señal recuperada
M2=fftshift(fft(m2,N)); 
figure(14)
plot(f,abs(M2),'r')
grid on
title('Espectro de m_2(n)')

%Comparacion de gráficas
figure(15)
stem(n,m2);
hold on
stem(n,m_n)
title('Comparacion de señales recuperada y original')
grid on


