# Документация: Модель приема-передачи для 5G NR в MATLAB

## Описание программы
Программа реализует базовую модель передачи и приема сигнала 5G NR с использованием инструментов MATLAB. Основные этапы обработки сигнала включают:
1. Генерацию 5G NR вэйвформы.
2. Анализ исходного спектра сигнала.
3. Симуляцию передачи сигнала через Рэлеевский канал.
4. Добавление шума.
5. Демодуляцию принятого сигнала и расчет битовой ошибки (BER).
6. Построение графика зависимости BER от отношения сигнал/шум (Eb/No).

## Основные компоненты

### 1. Генерация 5G NR вэйвформы
```matlab
addpath("./");

% Генерируем вэйвформу
[waveform, info] = generateNRWaveform();
Fs = info.ResourceGrids(1).Info.SampleRate;
```
На этом этапе создается сигнал с использованием встроенной функции `generateNRWaveform()`. Получаем также частоту дискретизации `Fs`.

### 2. Анализ спектра оригинального сигнала
```matlab
spectrum = spectrumAnalyzer('SampleRate', Fs, 'Name', 'Original Signal Spectrum');
spectrum(waveform);
release(spectrum);
```
Используем анализатор спектра для визуализации исходного сигнала.

```matlab
samplerate = info.ResourceGrids(1).Info.SampleRate;
nfft = info.ResourceGrids(1).Info.Nfft;
figure;
spectrogram(waveform(:,1), ones(nfft, 1), 0, nfft, 'centered', samplerate, 'yaxis', 'MinThreshold', -130);
title('Spectrogram of Original 5G Downlink Baseband Waveform');
```
Дополнительно строится спектрограмма оригинального сигнала.

### 3. Расчет BER (Bit Error Rate)
```matlab
M = 2; % BPSK
numBits = 1e6;
EbNoRange = 0:1:30; % Диапазон Eb/No от 0 до 30
erValues = zeros(length(EbNoRange), 1);
```
BER рассчитывается для различных уровней шума.

### 4. Симуляция Рэлеевского канала
```matlab
rayleighChan = comm.RayleighChannel( ...
    'SampleRate',Fs, ...
    'MaximumDopplerShift',60);  % Доплеровский сдвиг 60 Гц
```
Создается канал Рэлея с доплеровским сдвигом 60 Гц.

### 5. Цикл оценки BER
```matlab
for i = 1:length(EbNoRange)
    EbNo = EbNoRange(i); % Уровень шума
    
    % Передача данных
    txBits = randi([0 1], numBits, 1);
    modSig = pskmod(txBits, M); % Модуляция BPSK
    
    % Пропускаем через канал
    chanOut = rayleighChan(modSig);
    release(rayleighChan);
    
    % Демодуляция
    rxBits = pskdemod(chanOut, M);
    
    % Расчет BER
    [numErrors, ber] = biterr(txBits, rxBits);
    berValues(i) = ber;
    
    fprintf('Eb/No: %d dB - Number of bit errors: %d - BER: %.5f\n', EbNo, numErrors, ber);
end
```
На каждом шаге:
- Генерируются случайные биты.
- Применяется BPSK-модуляция.
- Сигнал передается через канал.
- Выполняется демодуляция.
- Вычисляется BER.

### 6. График зависимости BER от Eb/No
```matlab
figure;
semilogy(EbNoRange, berValues, '-o');
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate (BER)');
title(['BER vs. Eb/No (channel)']);
grid on;
```
Строится логарифмический график BER.

### 7. Создание диаграммы созвездия
```matlab
constDiagram = comm.ConstellationDiagram('Title', 'Received Signal Constellation', ...
                                        'XLimits', [-4 4], 'YLimits', [-4 4]);
constDiagram(chanOut);
release(constDiagram);
```
Визуализируется созвездие принятого сигнала.

```matlab
constDiagramOriginal = comm.ConstellationDiagram('Title', 'Original Signal Constellation', ...
                                                  'XLimits', [-2 2], 'YLimits', [-2 2]);
constDiagramOriginal(modSig);
release(constDiagramOriginal);
```
Диаграмма созвездия оригинального сигнала.

## Вывод
Программа моделирует передачу 5G NR через Рэлеевский канал и оценивает BER. Реализованы генерация сигнала, передача через канал, анализ спектра, расчет BER и визуализация результатов.

