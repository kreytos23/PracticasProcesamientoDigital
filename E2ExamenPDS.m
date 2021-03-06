clear all
close all 

fs=20000; %Frencuencia de muestreo digital
Fs=50*fs; %Frecuencia de muestreo señal analogica
fc=1800; %Frecuencia de portadora
ts=1/Fs; %ts señal digital
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

%Diseñamos el filtro FIR Asmetrico con M=101

M_filtro = 101;
B = B(M_filtro);
H = [zeros(1,7) 0.2 0.8 ones(1,11) 0.8 0.2 zeros(1,28)]';
w = -pi:0.001:pi;
h = inv(B)*H;
h = [h;0;-flipud(h)];
figure(11)
stem(h);
axis([0 100 -0.25 0.25])
title ('Filtro asimetrico h(n)')
ylabel('n')
xlabel('h(n)')
grid on
H=0;
for n=0:((M_filtro-3)/2)
    H=H+2*h(n+1)*sin(((M_filtro-1)/2-n)*w);
end
figure(12)
plot(w,20*log10(abs(H)));
axis([-pi pi -100 20])
grid on;
title('Espectro de Filtro FIR ')
ylabel ('dB')
xlabel ('w')

%Obtenemos la señal SSB 
yssb=conv(y_n,h); 
figure (13)
stem(yssb)
title('Señal y_{ssb}(n)')
axis([0 300 -6 6])
ylabel('y_{ssb}(n)')
xlabel('n')
grid on; 

YSSB=fftshift(fft(yssb,N)); 
figure(14)
plot(f, abs(YSSB)); 
title('Espectro de magnitud de Y_{ssb}(f)')
xlabel('f[Hz]')
ylabel('|Y_{ssb}|')
grid on

%DEMODULACION 

r_n=yssb(50:850).*c_n; 
figure(15)
stem(r_n)
axis([0 200 -4 6])
title('Señal r(n)=y_{ssb}(n)c(n) en tiempo discreto')
xlabel('n')
ylabel('r(n)')
grid on


R=fftshift(fft(r_n,N)); 
figure(16)
plot(f,abs(R))
grid on
title('Espectro de señal |R(f)|')
xlabel('f');
ylabel('|R(f)|')
%Diseñamos el filtro FIR Simetrico con M=100
M_filtro2 = 100;
A = A(M_filtro2);
H = [ones(1,16) 0.5 zeros(1,33)]';

h = inv(A)*H;

h=[h; flipud(h)];

figure(17)
stem(h);
title('Filtro h(n)')
grid on
w=-pi:0.001:pi;
Hr=0;
for n=0:M_filtro2/2 - 1
   Hr = Hr + 2*h(n+1)*cos((((M_filtro2-1)/2)-n)*w); 
end
figure(18)
plot(w, 20*log10(abs(Hr)));
grid on
title('Espectro de filtro FIR simetrico')
axis([-pi pi -120 10]);


%Recuperamos m2

m2=conv(r_n,h); 
figure(19)
stem(m2)
grid on
title('Señal recuperada m2(n)')

M2=fftshift(fft(m2,N)); 
figure(20)
plot(f,abs(M2))
grid on
title('Espectro de M2(n)')
