addpath("./");

% Генерируем вэйвформу
[waveform, info] = generateNRWaveform();
Fs = info.ResourceGrids(1).Info.SampleRate;

% Частота оригинального сигнала
spectrum = spectrumAnalyzer('SampleRate', Fs, 'Name', 'Original Signal Spectrum');
spectrum(waveform);
release(spectrum);

% Спектрограмма оригинального сигнала
samplerate = info.ResourceGrids(1).Info.SampleRate;
nfft = info.ResourceGrids(1).Info.Nfft;
figure;
spectrogram(waveform(:,1), ones(nfft, 1), 0, nfft, 'centered', samplerate, 'yaxis', 'MinThreshold', -130);
title('Spectrogram of Original 5G Downlink Baseband Waveform');

% Расчет BER
M = 2; % BPSK
numBits = 1e6;

% Создаем вектор для хранения BER значений для различных уровней шума
EbNoRange = 0:1:30; % Диапазон Eb/No от 0 до 30
berValues = zeros(length(EbNoRange), 1);

% Многолучевое распространение (Рэлеевский канал)
rayleighChan = comm.RayleighChannel( ...
    'SampleRate',Fs, ...
    'MaximumDopplerShift',60);  % Доплеровский сдвиг 60 Гц (для примера)
%     'PathDelays',[0 1.5e-5 3.2e-5],... % Задержки лучей (если известны)
%     'AveragePathGains',[0 -3 -6],...% Средние усиления лучей (если известны)
%     );
%   Если PathDelays и AveragePathGains не заданы, используется
%   типичная модель с экспоненциальным затуханием.

for i = 1:length(EbNoRange)
    EbNo = EbNoRange(i); % Уровень шума

    % Расчет переданных данных
    txBits = randi([0 1], numBits, 1);
    modSig = pskmod(txBits, M); % модуляция BPSK

    % ---  ПРОПУСКАЕМ СИГНАЛ ЧЕРЕЗ КАНАЛ ---
    
     chanOut = rayleighChan(modSig);
     release(rayleighChan);

    % Добавляем шум
    % rxSig = awgn(chanOut, EbNo, 'measured');


    % Демодуляция
    % rxBits = pskdemod(rxSig, M);
    rxBits = pskdemod(chanOut, M);

    % Расчет BER
    [numErrors, ber] = biterr(txBits, rxBits);
    berValues(i) = ber; % Сохраняем значение BER
  
    fprintf('Eb/No: %d dB - Number of bit errors: %d - Bit Error Rate (BER): %.5f\n', EbNo, numErrors, ber);
end

% График BER в зависимости от Eb/No
figure;
semilogy(EbNoRange, berValues, '-o');
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate (BER)');
title(['BER vs. Eb/No (', channelModel, ' channel)']); % Добавили название модели канала
grid on;

% Группировка переданного сигнала (после канала и шума)
constDiagram = comm.ConstellationDiagram('Title', ['Received Signal Constellation (', channelModel, ' channel, Noisy)'], ...
                                        'XLimits', [-4 4], 'YLimits', [-4 4]); % Set axis limits for clearer visualization
constDiagram(rxSig);
release(constDiagram);

% Группировка оригинального сигнала
constDiagramOriginal = comm.ConstellationDiagram('Title', 'Original Signal Constellation', ...
                                                  'XLimits', [-2 2], 'YLimits', [-2 2]);
constDiagramOriginal(modSig);
release(constDiagramOriginal);