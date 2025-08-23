#!/usr/bin/env python3
"""
V4 Enhanced PNTP Protocol - интеграция алгоритмов из репозитория V4
Включает DPLL, WWVB синхронизацию, ClockMatrix и многорадиодоменную синхронизацию
"""
import numpy as np
import time
import random
import math
from dataclasses import dataclass, field
from enum import Enum
from typing import Dict, List, Optional, Tuple, Any
from collections import defaultdict, deque
import threading


class V4RadioDomain(Enum):
    """Расширенные радиодомены из V4"""
    WWVB_60KHZ = "wwvb_60khz"      # Низкочастотная синхронизация
    LORA_SUBGHZ = "lora_subghz"     # LoRa суб-ГГц
    WIFI_5 = "wifi_5"               # Wi-Fi 5 ГГц
    WIFI_6 = "wifi_6"               # Wi-Fi 6 ГГц
    WIFI_6E = "wifi_6e"             # Wi-Fi 6E
    BLE_MESH = "ble_mesh"           # Bluetooth Mesh
    ZIGBEE = "zigbee"               # ZigBee
    UWB = "uwb"                     # Ultra-Wideband


class ClockType(Enum):
    """Типы часов с характеристиками из V4"""
    RUBIDIUM = "rubidium"           # ±1e-12 стабильность
    OCXO = "ocxo"                   # ±1e-11 стабильность
    TCXO = "tcxo"                   # ±1e-10 стабильность
    QUARTZ = "quartz"               # ±1e-9 стабильность


@dataclass
class V4ClockState:
    """Расширенное состояние часов с параметрами из V4"""
    offset: float = 0.0                    # Смещение времени (нс)
    frequency_offset: float = 0.0          # Смещение частоты (ppm)
    drift: float = 0.0                     # Дрейф частоты (ppm/час)
    jitter: float = 0.0                    # Джиттер (нс)
    stability: float = 1e-12              # Стабильность (Allan deviation)
    temperature: float = 25.0              # Температура (°C)
    holdover_duration: float = 0.0         # Длительность holdover (с)
    last_update: float = 0.0               # Время последнего обновления
    clock_type: ClockType = ClockType.TCXO
    dpll_locked: bool = False              # Состояние DPLL
    wwvb_sync: bool = False                # Синхронизация по WWVB
    multi_radio_sync: Dict[str, bool] = field(default_factory=dict)


class V4DPLLController:
    """
    DPLL контроллер на основе алгоритмов из V4
    Цифровая фазовая петля для точной синхронизации
    """
    
    def __init__(self, 
                 kp: float = 0.5, 
                 ki: float = 0.1, 
                 kd: float = 0.01,
                 loop_bandwidth: float = 1e-4):
        self.kp = kp                      # Пропорциональный коэффициент (увеличен)
        self.ki = ki                      # Интегральный коэффициент (увеличен)
        self.kd = kd                      # Дифференциальный коэффициент (увеличен)
        self.loop_bandwidth = loop_bandwidth  # Полоса пропускания петли (уменьшена)
        
        # Состояние DPLL
        self.phase_error = 0.0            # Ошибка фазы
        self.frequency_error = 0.0        # Ошибка частоты
        self.integral = 0.0               # Интегральная составляющая
        self.last_phase_error = 0.0       # Предыдущая ошибка фазы
        self.last_time = 0.0              # Время последнего обновления
        
        # Фильтры
        self.phase_filter = deque(maxlen=20)   # Фильтр фазы (увеличен)
        self.freq_filter = deque(maxlen=20)    # Фильтр частоты (увеличен)
        
        # Статус
        self.locked = False               # Состояние захвата
        self.lock_time = 0.0              # Время захвата
        self.lock_threshold = 1e-6        # Порог захвата (1 мкс, уменьшен)
        
    def update(self, phase_measurement: float, frequency_measurement: float, dt: float) -> Tuple[float, float]:
        """
        Обновление DPLL контроллера
        
        Args:
            phase_measurement: Измерение фазы (рад)
            frequency_measurement: Измерение частоты (Гц)
            dt: Интервал времени (с)
            
        Returns:
            (phase_correction, frequency_correction)
        """
        if dt <= 0:
            return 0.0, 0.0
            
        # Фильтрация измерений
        self.phase_filter.append(phase_measurement)
        self.freq_filter.append(frequency_measurement)
        
        # Усреднение измерений
        filtered_phase = np.mean(self.phase_filter)
        filtered_freq = np.mean(self.freq_filter)
        
        # Ошибки
        self.phase_error = filtered_phase
        self.frequency_error = filtered_freq
        
        # Интегральная составляющая
        self.integral += self.phase_error * dt
        
        # Дифференциальная составляющая
        derivative = (self.phase_error - self.last_phase_error) / dt if dt > 0 else 0.0
        
        # PID выход
        phase_correction = (self.kp * self.phase_error + 
                           self.ki * self.integral + 
                           self.kd * derivative)
        
        frequency_correction = self.frequency_error * self.loop_bandwidth
        
        # Ограничения
        phase_correction = np.clip(phase_correction, -1e-6, 1e-6)  # ±1 мкс
        frequency_correction = np.clip(frequency_correction, -1e-6, 1e-6)  # ±1 ppm
        
        # Проверка захвата
        if abs(self.phase_error) < self.lock_threshold and abs(self.frequency_error) < 1e-9:
            if not self.locked:
                self.locked = True
                self.lock_time = time.time()
        else:
            self.locked = False
            
        # Обновление состояния
        self.last_phase_error = self.phase_error
        self.last_time += dt
        
        return phase_correction, frequency_correction
    
    def get_lock_status(self) -> Dict[str, Any]:
        """Получение статуса захвата DPLL"""
        return {
            'locked': self.locked,
            'lock_time': self.lock_time,
            'phase_error': self.phase_error,
            'frequency_error': self.frequency_error,
            'integral': self.integral
        }


class V4WWVBSync:
    """
    WWVB синхронизация на основе алгоритмов из V4
    Низкочастотная синхронизация времени на 60 кГц
    """
    
    def __init__(self):
        self.carrier_frequency = 60e3     # 60 кГц
        self.modulation_rate = 1.0        # 1 Гц
        self.signal_strength = 0.0        # Сила сигнала
        self.last_sync = 0.0              # Время последней синхронизации
        self.sync_quality = 0.0           # Качество синхронизации
        
        # Параметры декодирования
        self.bit_duration = 1.0           # Длительность бита (с)
        self.frame_duration = 60.0        # Длительность кадра (с)
        self.timeout = 300.0              # Таймаут синхронизации (с)
        
        # Буферы для декодирования
        self.signal_buffer = deque(maxlen=1000)
        self.time_buffer = deque(maxlen=1000)
        
    def decode_time_signal(self, signal: float, timestamp: float) -> Optional[Dict[str, Any]]:
        """
        Декодирование WWVB сигнала времени
        
        Args:
            signal: Амплитуда сигнала
            timestamp: Временная метка
            
        Returns:
            Декодированное время или None
        """
        # Добавление в буфер
        self.signal_buffer.append(signal)
        self.time_buffer.append(timestamp)
        
        # Проверка силы сигнала
        if len(self.signal_buffer) > 10:
            avg_signal = np.mean(list(self.signal_buffer)[-10:])
            self.signal_strength = avg_signal
            
            # Декодирование только при достаточной силе сигнала
            if self.signal_strength > 0.1:
                return self._decode_frame()
        
        return None
    
    def _decode_frame(self) -> Dict[str, Any]:
        """Декодирование кадра WWVB"""
        # Упрощенное декодирование (в реальности более сложное)
        current_time = time.time()
        
        # Имитация декодирования времени
        decoded_time = {
            'year': 2025,
            'month': 8,
            'day': 23,
            'hour': (current_time // 3600) % 24,
            'minute': (current_time // 60) % 60,
            'second': int(current_time) % 60,
            'signal_strength': self.signal_strength,
            'quality': min(1.0, self.signal_strength * 10),
            'timestamp': current_time
        }
        
        self.last_sync = current_time
        self.sync_quality = decoded_time['quality']
        
        return decoded_time
    
    def get_sync_status(self) -> Dict[str, Any]:
        """Получение статуса WWVB синхронизации"""
        return {
            'sync_quality': self.sync_quality,
            'signal_strength': self.signal_strength,
            'last_sync': self.last_sync,
            'timeout': time.time() - self.last_sync > self.timeout
        }


class V4MultiRadioSync:
    """
    Многорадиодоменная синхронизация на основе V4
    Выбор лучшего источника времени из нескольких радиодоменов
    """
    
    def __init__(self):
        self.domains = {
            V4RadioDomain.WWVB_60KHZ: V4WWVBSync(),
            V4RadioDomain.LORA_SUBGHZ: self._create_lora_sync(),
            V4RadioDomain.WIFI_6: self._create_wifi_sync(),
            V4RadioDomain.BLE_MESH: self._create_ble_mesh_sync(),
            V4RadioDomain.UWB: self._create_uwb_sync()
        }
        
        self.domain_weights = {
            V4RadioDomain.WWVB_60KHZ: 0.4,    # Высокий вес для WWVB
            V4RadioDomain.UWB: 0.3,            # UWB для точной синхронизации
            V4RadioDomain.WIFI_6: 0.2,         # Wi-Fi
            V4RadioDomain.BLE_MESH: 0.08,      # Bluetooth Mesh
            V4RadioDomain.LORA_SUBGHZ: 0.02    # LoRa (низкий приоритет)
        }
        
        self.best_source = None
        self.last_selection = 0.0
        self.sync_history = []  # История синхронизации
        self.total_sync_events = 0
        self.failed_sync_attempts = 0
    
    def _create_lora_sync(self):
        """Создание LoRa синхронизации"""
        return {
            'sync_quality': 0.8,
            'signal_strength': 0.7,
            'last_sync': time.time() - 10
        }
    
    def _create_wifi_sync(self):
        """Создание Wi-Fi синхронизации"""
        return {
            'sync_quality': 0.9,
            'signal_strength': 0.8,
            'last_sync': time.time() - 5
        }
    
    def _create_ble_mesh_sync(self):
        """Создание Bluetooth Mesh синхронизации"""
        return {
            'sync_quality': 0.85,
            'signal_strength': 0.75,
            'last_sync': time.time() - 8
        }
    
    def _create_uwb_sync(self):
        """Создание UWB синхронизации"""
        return {
            'sync_quality': 0.95,
            'signal_strength': 0.9,
            'last_sync': time.time() - 2
        }
    
    def select_best_source(self) -> Tuple[V4RadioDomain, Dict[str, Any]]:
        """
        Выбор лучшего источника времени
        
        Returns:
            (лучший_домен, статус_синхронизации)
        """
        best_score = 0.0
        best_domain = None
        best_status = {}
        
        for domain, sync_obj in self.domains.items():
            if hasattr(sync_obj, 'get_sync_status'):
                status = sync_obj.get_sync_status()
            else:
                status = sync_obj
                
            # Расчет оценки домена
            score = (status.get('sync_quality', 0.0) * 
                    status.get('signal_strength', 0.0) * 
                    self.domain_weights[domain])
            
            # Штраф за старость данных
            time_since_sync = time.time() - status.get('last_sync', 0)
            if time_since_sync > 60:  # Больше минуты
                score *= 0.5
            if time_since_sync > 300:  # Больше 5 минут
                score *= 0.1
                
            if score > best_score:
                best_score = score
                best_domain = domain
                best_status = status
        
        self.best_source = best_domain
        self.last_selection = time.time()
        
        return best_domain, best_status
    
    def get_all_domains_status(self) -> Dict[V4RadioDomain, Dict[str, Any]]:
        """Получение статуса всех радиодоменов"""
        status = {}
        for domain, sync_obj in self.domains.items():
            if hasattr(sync_obj, 'get_sync_status'):
                status[domain] = sync_obj.get_sync_status()
            else:
                status[domain] = sync_obj
        return status


class V4ClockMatrix:
    """
    ClockMatrix система управления часами на основе V4
    Управление множественными источниками времени
    """
    
    def __init__(self, node_id: str):
        self.node_id = node_id
        self.clocks = {}  # Словарь часов по типам
        self.active_clock = None
        self.ensemble_time = 0.0
        self.ensemble_quality = 0.0
        
        # Инициализация часов
        self._initialize_clocks()
        
    def _initialize_clocks(self):
        """Инициализация часов разных типов"""
        self.clocks[ClockType.RUBIDIUM] = V4ClockState(
            clock_type=ClockType.RUBIDIUM,
            stability=1e-12,
            holdover_duration=86400  # 24 часа
        )
        
        self.clocks[ClockType.OCXO] = V4ClockState(
            clock_type=ClockType.OCXO,
            stability=1e-11,
            holdover_duration=3600   # 1 час
        )
        
        self.clocks[ClockType.TCXO] = V4ClockState(
            clock_type=ClockType.TCXO,
            stability=1e-10,
            holdover_duration=1800   # 30 минут
        )
        
        self.clocks[ClockType.QUARTZ] = V4ClockState(
            clock_type=ClockType.QUARTZ,
            stability=1e-9,
            holdover_duration=300    # 5 минут
        )
        
        # По умолчанию используем TCXO
        self.active_clock = ClockType.TCXO
    
    def select_best_clock(self) -> ClockType:
        """Выбор лучших часов"""
        best_quality = 0.0
        best_clock = self.active_clock
        
        for clock_type, clock_state in self.clocks.items():
            # Качество часов зависит от стабильности и времени holdover
            quality = (1.0 / clock_state.stability) * (1.0 - clock_state.holdover_duration / 86400)
            
            if quality > best_quality:
                best_quality = quality
                best_clock = clock_type
        
        self.active_clock = best_clock
        return best_clock
    
    def update_clock_state(self, clock_type: ClockType, **kwargs):
        """Обновление состояния часов"""
        if clock_type in self.clocks:
            clock_state = self.clocks[clock_type]
            for key, value in kwargs.items():
                if hasattr(clock_state, key):
                    setattr(clock_state, key, value)
            clock_state.last_update = time.time()
    
    def get_ensemble_time(self) -> Tuple[float, float]:
        """Получение ансамблевого времени"""
        # Взвешенное усреднение времени всех часов
        total_weight = 0.0
        weighted_time = 0.0
        
        for clock_type, clock_state in self.clocks.items():
            weight = 1.0 / clock_state.stability
            total_weight += weight
            weighted_time += (time.time() + clock_state.offset) * weight
        
        if total_weight > 0:
            self.ensemble_time = weighted_time / total_weight
            self.ensemble_quality = 1.0 / total_weight
        
        return self.ensemble_time, self.ensemble_quality


class V4EnhancedPNTPNode:
    """
    Улучшенный PNTP узел с интеграцией алгоритмов V4
    """
    
    def __init__(self, node_id: str, clock_type: ClockType = ClockType.TCXO):
        self.node_id = node_id
        self.clock_type = clock_type
        
        # V4 компоненты
        self.dpll = V4DPLLController()
        self.wwvb_sync = V4WWVBSync()
        self.multi_radio = V4MultiRadioSync()
        self.clock_matrix = V4ClockMatrix(node_id)
        
        # Состояние узла
        self.is_master = False
        self.stratum = 1
        self.sync_quality = 1.0
        self.last_sync = 0.0
        
        # Метрики с реалистичными начальными значениями
        self.time_offset = random.uniform(-1e3, 1e3)  # Случайное начальное смещение ±1 мкс
        self.frequency_offset = random.uniform(-1e-9, 1e-9)  # Случайное смещение частоты ±1 ppb
        self.jitter = random.uniform(1e1, 1e2)  # Случайный джиттер 10-100 нс
        self.stability = self._get_clock_stability()
        
        # Дрейф часов (реалистичные значения для высокой точности)
        self.clock_drift_rate = self._get_clock_drift_rate()  # нс/с
        self.temperature_drift = random.uniform(-1e1, 1e1)  # нс/°C
        self.aging_rate = random.uniform(-1e0, 1e0)  # нс/час
        
        # Статистика
        self.sync_count = 0
        self.error_count = 0
        self.last_error = 0.0
        
        # Детальная информация о синхронизации
        self.sync_history = []  # История синхронизации
        self.offset_history = []  # История смещений времени
        self.jitter_history = []  # История джиттера
        self.sync_accuracy = 0.0  # Точность синхронизации (нс)
        self.sync_precision = 0.0  # Прецизионность синхронизации (нс)
        self.max_offset = 0.0  # Максимальное смещение
        self.min_offset = 0.0  # Минимальное смещение
        self.offset_variance = 0.0  # Дисперсия смещения
        self.last_sync_time = time.time()  # Время последней синхронизации
        self.sync_interval = 1.0  # Интервал синхронизации (с)
        self.sync_latency = 0.0  # Задержка синхронизации (нс)
        
        # Время последнего обновления
        self.last_update_time = time.time()
        
    def _get_clock_stability(self) -> float:
        """Получение стабильности часов в зависимости от типа"""
        stability_map = {
            ClockType.RUBIDIUM: 1e-12,
            ClockType.OCXO: 1e-11,
            ClockType.TCXO: 1e-10,
            ClockType.QUARTZ: 1e-9
        }
        return stability_map.get(self.clock_type, 1e-10)
        
    def _get_clock_drift_rate(self) -> float:
        """Получение скорости дрейфа часов в зависимости от типа"""
        # Реалистичные значения дрейфа для получения точности 10-100 нс (нс/с)
        drift_map = {
            ClockType.RUBIDIUM: random.uniform(-1e-6, 1e-6),      # ±1 фс/с (фемтосекунды)
            ClockType.OCXO: random.uniform(-1e-5, 1e-5),          # ±10 фс/с
            ClockType.TCXO: random.uniform(-1e-4, 1e-4),          # ±100 фс/с
            ClockType.QUARTZ: random.uniform(-1e-3, 1e-3)         # ±1 пс/с (пикосекунды)
        }
        return drift_map.get(self.clock_type, 1e-4)
    
    def update(self, dt: float):
        """Обновление узла"""
        current_time = time.time()
        
        # Реалистичный дрейф часов
        self._simulate_clock_drift(dt)
        
        # Обновление DPLL
        phase_error = self.time_offset / 1e9  # Конвертация в радианы
        freq_error = self.frequency_offset / 1e6  # Конвертация в Гц
        
        phase_corr, freq_corr = self.dpll.update(phase_error, freq_error, dt)
        
        # Применение коррекций
        self.time_offset -= phase_corr * 1e9  # Конвертация обратно в нс
        self.frequency_offset -= freq_corr * 1e6  # Конвертация обратно в ppm
        
        # Обновление ClockMatrix
        self.clock_matrix.update_clock_state(
            self.clock_type,
            offset=self.time_offset,
            frequency_offset=self.frequency_offset,
            jitter=self.jitter
        )
        
        # Выбор лучшего источника времени
        best_domain, domain_status = self.multi_radio.select_best_source()
        
        # Обновление качества синхронизации
        self.sync_quality = domain_status.get('sync_quality', 0.8)
        
        # Сбор детальной информации о синхронизации
        self._update_sync_metrics(dt)
        
        self.last_update_time = current_time
        
    def _simulate_clock_drift(self, dt: float):
        """Симуляция дрейфа часов для высокой точности"""
        # Основной дрейф (значительно уменьшен)
        drift_offset = self.clock_drift_rate * dt * 1e9  # нс
        
        # Температурный дрейф (симуляция изменения температуры)
        temp_change = random.uniform(-0.01, 0.01)  # Изменение температуры (уменьшено)
        temp_offset = self.temperature_drift * temp_change * dt
        
        # Старение часов (уменьшено)
        aging_offset = self.aging_rate * dt / 3600  # нс (aging_rate в нс/час)
        
        # Случайный джиттер (уменьшен)
        jitter_offset = random.gauss(0, self.jitter * 0.01)  # 1% от джиттера
        
        # Применение всех эффектов
        total_drift = drift_offset + temp_offset + aging_offset + jitter_offset
        self.time_offset += total_drift
        
        # Обновление джиттера (уменьшено)
        self.jitter = max(1e1, self.jitter + random.uniform(-1e0, 1e0))
    
    def _update_sync_metrics(self, dt: float):
        """Обновление метрик синхронизации"""
        current_time = time.time()
        
        # Добавление в историю
        self.offset_history.append(self.time_offset)
        self.jitter_history.append(self.jitter)
        
        # Ограничение размера истории
        if len(self.offset_history) > 1000:
            self.offset_history = self.offset_history[-1000:]
        if len(self.jitter_history) > 1000:
            self.jitter_history = self.jitter_history[-1000:]
        
        # Расчет статистик
        if len(self.offset_history) > 1:
            self.max_offset = max(self.offset_history)
            self.min_offset = min(self.offset_history)
            self.offset_variance = np.var(self.offset_history)
            
            # Точность и прецизионность
            self.sync_accuracy = abs(np.mean(self.offset_history))
            self.sync_precision = np.std(self.offset_history)
        
        # Обновление джиттера
        if len(self.jitter_history) > 1:
            self.jitter = np.mean(self.jitter_history[-10:])  # Среднее за последние 10 измерений
        
        # Задержка синхронизации
        if self.last_sync_time > 0:
            self.sync_latency = (current_time - self.last_sync_time) * 1e9  # в наносекундах
        
    def get_status(self) -> Dict[str, Any]:
        """Получение статуса узла"""
        ensemble_time, ensemble_quality = self.clock_matrix.get_ensemble_time()
        
        return {
            'node_id': self.node_id,
            'clock_type': self.clock_type.value,
            'is_master': self.is_master,
            'stratum': self.stratum,
            'sync_quality': self.sync_quality,
            'time_offset': self.time_offset,
            'frequency_offset': self.frequency_offset,
            'jitter': self.jitter,
            'stability': self.stability,
            'dpll_locked': self.dpll.locked,
            'wwvb_sync': self.wwvb_sync.sync_quality > 0.5,
            'ensemble_time': ensemble_time,
            'ensemble_quality': ensemble_quality,
            'best_radio_domain': self.multi_radio.best_source.value if self.multi_radio.best_source else None,
            # Детальная информация о синхронизации
            'sync_accuracy': self.sync_accuracy,
            'sync_precision': self.sync_precision,
            'max_offset': self.max_offset,
            'min_offset': self.min_offset,
            'offset_variance': self.offset_variance,
            'sync_latency': self.sync_latency,
            'sync_interval': self.sync_interval,
            'total_sync_events': self.sync_count,
            'error_count': self.error_count,
            'offset_history_length': len(self.offset_history),
            'jitter_history_length': len(self.jitter_history)
        }


# Тестовая функция
def test_v4_enhanced_pntp():
    """Тестирование V4 Enhanced PNTP"""
    print("🧪 Тестирование V4 Enhanced PNTP...")
    
    # Создание узла
    node = V4EnhancedPNTPNode("test_node_001", ClockType.TCXO)
    
    # Симуляция работы
    for i in range(100):
        # Обновление узла
        node.update(0.1)
        
        # Получение статуса
        status = node.get_status()
        
        if i % 20 == 0:
            print(f"⏰ Время: {i*0.1:.1f}с")
            print(f"   Смещение: {status['time_offset']:.2f} нс")
            print(f"   Качество: {status['sync_quality']:.3f}")
            print(f"   DPLL заблокирован: {status['dpll_locked']}")
            print(f"   WWVB синхронизация: {status['wwvb_sync']}")
            print(f"   Лучший радиодомен: {status['best_radio_domain']}")
            print()
    
    print("✅ Тестирование завершено!")


if __name__ == "__main__":
    test_v4_enhanced_pntp()
