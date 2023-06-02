%Reading audio files
[x1, fs] =audioread(uigetfile('.wav'));
sound(x1,fs)

N = length(x1); % Número de muestras de la señal.
Td = N/fs; % Tiempo de duración.
Ts = 1/fs; % Periodo de muestreo. 
NUM = round(Td/15.5,3);
duration_seg = NUM; %duración del segmento
nT_seg = duration_seg * fs;%Estimación números de muestras por segmento

total_seg = floor(length(x1) / nT_seg);%Numero total de segmentos

segmentos = reshape(x1(1:total_seg*nT_seg), nT_seg, total_seg);%Segmentación de la señal inicial (AUDIO)

disp('AUTORES:');
disp('Karen Juliana Jaime Lopez');
disp('Naryi Vanesa Medina Castelo Branco');

disp('Secuencia de números por posición: ');
for i = 1:total_seg
    figure (i)
    subplot(2, 1, 1);
    t = (0:nT_seg-1) / fs;
    plot(t, segmentos(:, i));
    xlabel('Tiempo (s)');
    ylabel('Amplitud');
    title(['Segmento ', num2str(i)]);

    subplot(2, 1, 2);
% the FFT of the signal segmentation.
    segmento_fft = fft(segmentos(:, i)) / nT_seg;
    f = (0:nT_seg-1) * (fs / nT_seg);
    stem(f, abs(segmento_fft), 'f');
    xlabel('Frecuencia (Hz)');
    ylabel('Magnitud');
    title('FFT del primer segmento');
    grid on;

% The low frequency with the greatest amplitude is found
magnitudes = abs(segmento_fft);
indice_baja_frecuencia = find(f <= 1000, 1, 'last');
[~, indice_max_baja_frecuencia] = max(magnitudes(1:indice_baja_frecuencia));
frecuencia_baja = f(indice_max_baja_frecuencia);

% The high frequency with the greatest amplitude is found
indice_alta_frecuencia = find(f >= 1000 , 1);
[~, indice_max_alta_frecuencia] = max(magnitudes(indice_alta_frecuencia:end));
indice_max_alta_frecuencia = indice_max_alta_frecuencia + indice_alta_frecuencia - 1;
frecuencia_alta = f(indice_max_alta_frecuencia);

% % Calculate the allowable frequency range for low and high tones
% variationLow = frecuencia_baja * variationPercentage / 100;
% variationHigh = frecuencia_alta * variationPercentage / 100;

% Define the DTMF tones and their corresponding frequencies
dtmfTones = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '*', '#'];
lowFreq = [ 697, 697, 697, 770, 770, 770, 852, 852, 852, 941, 941, 941 ];
highFreq = [ 1209, 1336, 1477, 1209, 1336, 1477, 1209, 1336, 1477, 1336, 1209, 1477 ];

for j = 1:length(dtmfTones)
 
% Calculate the allowable frequency range for low and high tones
lowRange = [lowFreq(j) - lowFreq(j)*0.015, lowFreq(j) + lowFreq(j)*0.015];
highRange = [highFreq(j) - highFreq(j)*0.015, highFreq(j) + highFreq(j)*0.015];

% Check if the number falls within the range
    if (frecuencia_baja >= lowRange(1) && frecuencia_baja <= lowRange(2)) && (frecuencia_alta >= highRange(1) && frecuencia_alta <= highRange(2))
       disp(['Secuencia posición ' num2str(i) ' =  ' dtmfTones(j)]); 
    end
end
% Imprimir las frecuencias encontradasdisp(['Baja frecuencia con mayor amplitud: ' num2str(frecuencia_baja) ' Hz' ]);
% disp(['Baja frecuencia con mayor amplitud: ' num2str(frecuencia_baja) ' Hz' ]);
% disp(['Alta frecuencia con mayor amplitud: ' num2str(frecuencia_alta) ' Hz' ]);
end