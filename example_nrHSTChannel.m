%{
hst = nrHSTChannel; 
hst.ChannelProfile = 'HST' ;  

hst.Ds = 300;                    
hst.Dmin = 2;

hst.Velocity = 300;             
hst.MaximumDopplerShift = 750;

hst.SampleRate = 30.72e6;                   
T = hst.SampleRate * 1e-3; 
Nt = 1; 
txWaveform = complex(randn(T,Nt),randn(T,Nt));

rxWaveform = hst(txWaveform);

plot(abs(rxWaveform));
%}

%{Создание объекта канала HST в сети 5g%}
hst = nrHSTChannel( ...
    ChannelProfile='HST-SFN', ...
    NumReceiveAntennas=1);

hst.Ds = 400; %{ Расстояние между базовыми станциями%}
hst.Dmin = 20; %{  Минимальное расстояние от базовых станций до путей %}
hst.Velocity = 300; %{ скорость км/ч %}

%{ Максимальный доплеровский сдвиг, оценивается как SampleRate*Velocity/c, где c=3*10^8 м/с %}
hst.MaximumDopplerShift = 970;

%{ выключаем фильтрацию сигнала. Если true то в канал вносит искажение доплеревский сдвиг ... %}
hst.ChannelFiltering = false;
hst.SampleRate = 30.72e6; %{ Частота дискретизации сигнала  %}

%{ количество временных отсчётов умножаем на миллисекунду так как смотрим передачу данных в 5g %}
hst.NumTimeSamples = hst.SampleRate*1e-3;

hst.InitialTime = (hst.Ds/3)/(hst.Velocity/3.6); %{начальная задержку распространения сигнала в канале %}

pathGains = hst(); %{моделирование сигнала в канале (искажение его) %}
pathFilters = getPathFilters(hst); %{ Моделирует характеристики канала (используются фильтры данных) %}

offset = nrPerfectTimingEstimate(pathGains,pathFilters); %{  оценкв временного смещения %}

%{Пострение графика%}
plot(0:size(pathFilters,1)-1,pathFilters);
hold on %{Позволяет сохранять текущий график. При дальнейшем построении, график будет накладыватся на старый%}
%stem(repmat(offset,1,hst.NumTaps),pathFilters(1+offset,:),'k')
legend(["Многолучевой компонент " + (1:hst.NumTaps)]) % "Timing offset"])
xlabel('Отчеты (Задержка)') 
ylabel('Амплитуда')
title('Импульсная характеристика канала HST-SFN ')
