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
title('Señal m(n) muestreada')
xlabel('n')
ylabel('m_n')
grid on

figure(4)
stem(n,c_n)
title('Señal c(n) muestreada')
xlabel('n')
ylabel('c_n')
grid on

%Sacamos Transformada de Fourier 
M_filtro=fftshift(fft(m_n,N));
f=linspace(-fs/2, fs/2,N); 
figure(5)
plot(f,abs(M_filtro))
grid on
title('Espectro de |M(f)|')
xlabel('f');
ylabel('|M(f)|')
%Transformada de Fourier señal portadora 
C=fftshift(fft(c_n,N)); 
figure(6)
plot(f,abs(C))
grid on
title('Espectro de |C(f)|')
xlabel('f');
ylabel('|C(f)|')

%Obtenemos la señal modulada

y_n=m_n.*c_n; 
figure(7)
stem(n,y_n)
title('Señal modulada en tiempo discreto y(n)')
xlabel('n')
ylabel('y(n)')
grid on


Y=fftshift(fft(y_n,N)); 
figure(8)
plot(f,abs(Y))
grid on
title('Espectro de señal modulada |Y(f)|')
xlabel('f');
ylabel('|Y(f)|')

%---- DEMODULACIOn 

r_n=y_n.*c_n; 
figure(9)
stem(n,r_n)
title('Señal r(n)=y(n)c(n) en tiempo discreto')
xlabel('n')
ylabel('r(n)')
grid on


R=fftshift(fft(r_n,N)); 
figure(10)
plot(f,abs(R))
grid on
title('Espectro de señal |R(f)|')
xlabel('f');
ylabel('|R(f)|')

%Diseñamos el filtro FIR Simetrico con M=100
M_filtro = 100;
A = A(M_filtro);
H = [ones(1,16) 0.5 zeros(1,33)]';

h = inv(A)*H;

h=[h; flipud(h)];

figure(11)
stem(h);
w=-pi:0.001:pi;
Hr=0;
for n=0:M_filtro/2 - 1
   Hr = Hr + 2*h(n+1)*cos((((M_filtro-1)/2)-n)*w); 
end
figure(12)
plot(w, 20*log10(abs(Hr)));
title('Espectro de filtro FIR simetrico')
axis([-pi pi -120 10]);


%Recuperamos m2

m2=conv(r_n,h); 
figure(13)
stem(m2)
grid on
title('Señal recuperada m2(n)')

M2=fftshift(fft(m2,N)); 
figure(14)
plot(f,abs(M2))
grid on
title('Espectro de M2(n)')
