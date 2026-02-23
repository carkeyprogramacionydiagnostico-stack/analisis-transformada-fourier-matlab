function fourier_proyecto
%% =========================================================
%  PROYECTO: Simulación y análisis de señales con Fourier (FFT)
%  Herramienta: MATLAB (compatible con MATLAB Online)
%
%  Qué hace este programa:
%   1) Crea 3 señales en el tiempo:
%       - Pulso rectangular
%       - Escalón unitario
%       - Senoidal
%   2) Calcula la FFT de cada señal (con fft y fftshift)
%   3) Grafica:
%       - Señal en el tiempo
%       - Magnitud del espectro |X(f)|
%       - Fase del espectro ∠X(f)
%   4) Verifica propiedades:
%       - Linealidad
%       - Desplazamiento en el tiempo
%       - Escalamiento (tiempo/frecuencia)
%   5) Muestra cada gráfica en pantalla Y la guarda en outputs/
%
%  Importante:
%   - En MATLAB Online los archivos se guardan en /MATLAB Drive
% =========================================================

close all; clc;

%% ---------------------------------------------------------
% 1) Parámetros de muestreo (muy importantes)
% ---------------------------------------------------------
fs = 2000;          % frecuencia de muestreo (Hz) -> cuántas muestras por segundo
dt = 1/fs;          % periodo de muestreo (s) -> tiempo entre muestras
T  = 2.0;           % duración total de la señal (s)

% Vector de tiempo centrado en 0: desde -T/2 hasta T/2-dt
t = -T/2 : dt : (T/2 - dt);

% Número de muestras
N = length(t);

% Eje de frecuencia para graficar FFT centrada:
% Va de -fs/2 a fs/2 (aprox)
f = (-floor(N/2):ceil(N/2)-1) * (fs/N);

fprintf('Parámetros:\nfs=%d Hz, dt=%.6f s, T=%.2f s, N=%d\n\n', fs, dt, T, N);

%% ---------------------------------------------------------
% 2) Carpeta de salida
% ---------------------------------------------------------
outDir = fullfile('/MATLAB Drive', 'outputs');
if ~exist(outDir,'dir')
    mkdir(outDir);
end
disp(['Guardando imágenes en: ', outDir]);

%% ---------------------------------------------------------
% 3) Crear señales en el dominio del tiempo
% ---------------------------------------------------------

% 3.1 Pulso rectangular
tau = 0.2;  % ancho del pulso (s)
% x_rect = 1 cuando |t| <= tau/2, en otro caso 0
x_rect = double(abs(t) <= tau/2);

% 3.2 Escalón unitario
% x_step = 1 cuando t >= 0, en otro caso 0
x_step = double(t >= 0);

% 3.3 Senoidal
f0 = 50; % frecuencia (Hz)
x_sin = sin(2*pi*f0*t);

%% ---------------------------------------------------------
% 4) FFT: Transformada rápida de Fourier (discreta)
% ---------------------------------------------------------
% fft(x) calcula espectro, pero 0 Hz queda al inicio del vector.
% fftshift(...) centra 0 Hz en el medio para graficar mejor.
% Normalizamos /N para tener escala manejable.

Xrect = fftshift(fft(x_rect)) / N;
Xstep = fftshift(fft(x_step)) / N;
Xsin  = fftshift(fft(x_sin )) / N;

% Magnitud y fase
magRect = abs(Xrect);   phRect = angle(Xrect);
magStep = abs(Xstep);   phStep = angle(Xstep);
magSin  = abs(Xsin );   phSin  = angle(Xsin );

% Enmascarar fase en zonas con magnitud muy baja (evita "ruido" visual)
maskRatio = 0.02; % 2% del máximo
phRect(magRect < max(magRect)*maskRatio) = NaN;
phStep(magStep < max(magStep)*maskRatio) = NaN;
phSin (magSin  < max(magSin )*maskRatio) = NaN;

%% ---------------------------------------------------------
% 5) Graficar y guardar (MOSTRAR + GUARDAR)
% ---------------------------------------------------------
% Nota: "pause(1)" te deja ver la gráfica antes de que pase a la siguiente.

% ----------- Pulso rectangular: Tiempo -----------
figure('Name','Rectangular - Tiempo');
plot(t, x_rect, 'LineWidth', 1.2); grid on;
title('Pulso rectangular en el tiempo (\tau = 0.2 s)');
xlabel('Tiempo (s)'); ylabel('Amplitud');
xlim([-0.6 0.6]);
saveas(gcf, fullfile(outDir,'01_rect_time.png'));
pause(1);

% ----------- Pulso rectangular: Magnitud -----------
figure('Name','Rectangular - Magnitud');
plot(f, magRect, 'LineWidth', 1.2); grid on;
title('Magnitud del espectro |X(f)| - Pulso rectangular');
xlabel('Frecuencia (Hz)'); ylabel('|X(f)|');
xlim([-300 300]);
saveas(gcf, fullfile(outDir,'02_rect_mag.png'));
pause(1);

% ----------- Pulso rectangular: Fase -----------
figure('Name','Rectangular - Fase');
plot(f, phRect, 'LineWidth', 1.2); grid on;
title('Fase del espectro ∠X(f) - Pulso rectangular');
xlabel('Frecuencia (Hz)'); ylabel('Fase (rad)');
xlim([-300 300]);
saveas(gcf, fullfile(outDir,'03_rect_phase.png'));
pause(1);

% ----------- Escalón: Tiempo -----------
figure('Name','Escalón - Tiempo');
plot(t, x_step, 'LineWidth', 1.2); grid on;
title('Escalón unitario u(t) en el tiempo');
xlabel('Tiempo (s)'); ylabel('Amplitud');
xlim([-0.6 0.6]);
saveas(gcf, fullfile(outDir,'04_step_time.png'));
pause(1);

% ----------- Escalón: Magnitud -----------
figure('Name','Escalón - Magnitud');
plot(f, magStep, 'LineWidth', 1.2); grid on;
title('Magnitud del espectro |X(f)| - Escalón');
xlabel('Frecuencia (Hz)'); ylabel('|X(f)|');
xlim([-300 300]);
saveas(gcf, fullfile(outDir,'05_step_mag.png'));
pause(1);

% ----------- Escalón: Fase -----------
figure('Name','Escalón - Fase');
plot(f, phStep, 'LineWidth', 1.2); grid on;
title('Fase del espectro ∠X(f) - Escalón (enmascarada)');
xlabel('Frecuencia (Hz)'); ylabel('Fase (rad)');
xlim([-300 300]);
saveas(gcf, fullfile(outDir,'06_step_phase.png'));
pause(1);

% ----------- Senoidal: Tiempo -----------
figure('Name','Senoidal - Tiempo');
plot(t, x_sin, 'LineWidth', 1.2); grid on;
title('Senoidal (f0 = 50 Hz) en el tiempo');
xlabel('Tiempo (s)'); ylabel('Amplitud');
xlim([-0.2 0.2]);
saveas(gcf, fullfile(outDir,'07_sin_time.png'));
pause(1);

% ----------- Senoidal: Magnitud -----------
figure('Name','Senoidal - Magnitud');
plot(f, magSin, 'LineWidth', 1.2); grid on;
title('Magnitud del espectro |X(f)| - Senoidal');
xlabel('Frecuencia (Hz)'); ylabel('|X(f)|');
xlim([-300 300]);
saveas(gcf, fullfile(outDir,'08_sin_mag.png'));
pause(1);

% ----------- Senoidal: Fase -----------
figure('Name','Senoidal - Fase');
plot(f, phSin, 'LineWidth', 1.2); grid on;
title('Fase del espectro ∠X(f) - Senoidal');
xlabel('Frecuencia (Hz)'); ylabel('Fase (rad)');
xlim([-300 300]);
saveas(gcf, fullfile(outDir,'09_sin_phase.png'));
pause(1);

%% ---------------------------------------------------------
% 6) PROPIEDADES DE FOURIER
% ---------------------------------------------------------

% 6.1 Linealidad:
% FFT(a*x1 + b*x2) = a*FFT(x1) + b*FFT(x2)
a = 2.0; b = 0.5;
x_lin = a*x_rect + b*x_sin;

Xlin  = fftshift(fft(x_lin)) / N;
Xpred = a*Xrect + b*Xsin;

err = norm(Xlin - Xpred) / (norm(Xpred) + 1e-12);
fprintf('Linealidad: error relativo = %.2e (debe ser muy pequeño)\n', err);

figure('Name','Propiedad - Linealidad');
plot(f, abs(Xlin), 'LineWidth', 1.2); hold on;
plot(f, abs(Xpred), 'LineWidth', 1.2);
grid on;
legend('|FFT(a*x1+b*x2)|','|a*FFT(x1)+b*FFT(x2)|','Location','best');
title(sprintf('Linealidad (error relativo ~ %.2e)', err));
xlabel('Frecuencia (Hz)'); ylabel('|X(f)|');
xlim([-300 300]);
saveas(gcf, fullfile(outDir,'10_linearity_mag.png'));
pause(1);

% 6.2 Desplazamiento en el tiempo (retraso):
% Un retraso en tiempo cambia principalmente la fase,
% la magnitud del espectro casi no cambia.
t0 = 0.1;            % retraso en segundos
k  = round(t0*fs);   % retraso en muestras

x_shift = zeros(size(x_rect));
x_shift((k+1):end) = x_rect(1:end-k);

Xshift = fftshift(fft(x_shift)) / N;

figure('Name','Propiedad - Desplazamiento en tiempo');
plot(f, abs(Xrect), 'LineWidth', 1.2); hold on;
plot(f, abs(Xshift), 'LineWidth', 1.2);
grid on;
legend('|X(f)| original', sprintf('|X(f)| retrasada t0=%.2fs', t0), 'Location','best');
title('Desplazamiento en tiempo: magnitud casi no cambia');
xlabel('Frecuencia (Hz)'); ylabel('|X(f)|');
xlim([-300 300]);
saveas(gcf, fullfile(outDir,'11_timeshift_mag.png'));
pause(1);

% 6.3 Escalamiento en el tiempo:
% Si haces la señal MÁS ANGOSTA en tiempo (x(2t)),
% el espectro se hace MÁS ANCHO en frecuencia (ocupa más ancho de banda).
scale = 2.0;
x_scaled = double(abs(scale*t) <= tau/2);
Xscaled = fftshift(fft(x_scaled)) / N;

figure('Name','Propiedad - Escalamiento');
plot(f, abs(Xrect), 'LineWidth', 1.2); hold on;
plot(f, abs(Xscaled), 'LineWidth', 1.2);
grid on;
legend('rect(\tau=0.2)', 'rect(2t) (más angosta)', 'Location','best');
title('Escalamiento: más angosta en tiempo -> espectro más ancho');
xlabel('Frecuencia (Hz)'); ylabel('|X(f)|');
xlim([-600 600]);
saveas(gcf, fullfile(outDir,'12_scaling_mag.png'));
pause(1);

%% ---------------------------------------------------------
% 7) Mensaje final
% ---------------------------------------------------------
disp('==============================================');
disp('Listo. Se mostraron las gráficas y se guardaron en outputs.');
disp(['Ruta: ', outDir]);
disp('En MATLAB Online: ve a MATLAB Drive > outputs para ver los PNG.');
disp('==============================================');

end
