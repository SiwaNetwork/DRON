"""
Алгоритмы синхронизации времени и фазы для роя
"""
import numpy as np
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass
from collections import deque


@dataclass
class TimeMessage:
    """Сообщение для синхронизации времени"""
    sender_id: str
    receiver_id: str
    timestamp_send: float  # Время отправки по часам отправителя
    timestamp_receive: float  # Время получения по часам получателя
    sequence_number: int


class TimeSynchronization:
    """
    Распределенная синхронизация времени
    
    Основана на алгоритме Berkeley и NTP с адаптацией для роя.
    Учитывает задержки передачи и дрейф часов.
    """
    
    def __init__(self, max_drift_rate: float = 1e-6, sync_period: float = 1.0):
        """
        Args:
            max_drift_rate: Максимальная скорость дрейфа часов (ppm)
            sync_period: Период синхронизации (с)
        """
        self.max_drift_rate = max_drift_rate
        self.sync_period = sync_period
        
        # Состояние часов каждого агента
        self.clock_offsets: Dict[str, float] = {}  # Смещение относительно глобального времени
        self.clock_drifts: Dict[str, float] = {}  # Скорость дрейфа
        self.last_sync_time: Dict[str, float] = {}
        
        # История измерений для фильтрации
        self.measurement_history: Dict[str, deque] = {}
        self.max_history_size = 10
        
        # Параметры фильтра Калмана
        self.kalman_states: Dict[str, np.ndarray] = {}  # [offset, drift]
        self.kalman_covariances: Dict[str, np.ndarray] = {}
    
    def initialize_agent(self, agent_id: str, initial_offset: float = 0.0):
        """
        Инициализация часов агента
        
        Args:
            agent_id: ID агента
            initial_offset: Начальное смещение часов
        """
        self.clock_offsets[agent_id] = initial_offset
        self.clock_drifts[agent_id] = np.random.uniform(
            -self.max_drift_rate, self.max_drift_rate
        )
        self.last_sync_time[agent_id] = 0.0
        self.measurement_history[agent_id] = deque(maxlen=self.max_history_size)
        
        # Инициализация фильтра Калмана
        self.kalman_states[agent_id] = np.array([initial_offset, 0.0])
        self.kalman_covariances[agent_id] = np.eye(2) * 0.1
    
    def get_local_time(self, agent_id: str, global_time: float) -> float:
        """
        Получение локального времени агента
        
        Args:
            agent_id: ID агента
            global_time: Глобальное время
            
        Returns:
            Локальное время агента
        """
        if agent_id not in self.clock_offsets:
            return global_time
        
        # Учет дрейфа
        time_since_sync = global_time - self.last_sync_time.get(agent_id, 0)
        drift = self.clock_drifts[agent_id] * time_since_sync
        
        return global_time + self.clock_offsets[agent_id] + drift
    
    def estimate_offset(self, agent1_id: str, agent2_id: str,
                       round_trip_time: float, 
                       time_difference: float) -> float:
        """
        Оценка смещения часов между агентами
        
        Args:
            agent1_id: ID первого агента
            agent2_id: ID второго агента
            round_trip_time: Время туда-обратно
            time_difference: Разница времен при обмене
            
        Returns:
            Оценка смещения часов
        """
        # Алгоритм Cristian: offset = time_difference - round_trip_time/2
        one_way_delay = round_trip_time / 2
        offset_estimate = time_difference - one_way_delay
        
        # Сохранение в историю
        self.measurement_history[agent1_id].append({
            'peer': agent2_id,
            'offset': offset_estimate,
            'rtt': round_trip_time,
            'confidence': 1.0 / (1.0 + round_trip_time)  # Меньше RTT - больше доверие
        })
        
        return offset_estimate
    
    def berkeley_algorithm(self, master_id: str, 
                          agent_times: Dict[str, float]) -> Dict[str, float]:
        """
        Алгоритм Berkeley для централизованной синхронизации
        
        Args:
            master_id: ID мастера
            agent_times: Локальные времена агентов
            
        Returns:
            Корректировки для каждого агента
        """
        if master_id not in agent_times:
            return {}
        
        # Вычисление среднего времени
        avg_time = np.mean(list(agent_times.values()))
        
        # Корректировки для каждого агента
        corrections = {}
        for agent_id, local_time in agent_times.items():
            corrections[agent_id] = avg_time - local_time
        
        return corrections
    
    def distributed_sync(self, agent_id: str,
                        neighbor_times: Dict[str, Tuple[float, float]]) -> float:
        """
        Распределенная синхронизация с соседями
        
        Args:
            agent_id: ID агента
            neighbor_times: Времена соседей {id: (local_time, rtt)}
            
        Returns:
            Корректировка времени
        """
        if not neighbor_times:
            return 0.0
        
        # Взвешенное усреднение с учетом RTT
        weighted_sum = 0.0
        weight_total = 0.0
        
        for neighbor_id, (neighbor_time, rtt) in neighbor_times.items():
            # Вес обратно пропорционален RTT
            weight = 1.0 / (1.0 + rtt)
            offset = self.estimate_offset(agent_id, neighbor_id, rtt, neighbor_time)
            weighted_sum += weight * offset
            weight_total += weight
        
        if weight_total > 0:
            avg_offset = weighted_sum / weight_total
            # Применение с коэффициентом сходимости
            convergence_rate = 0.5
            return avg_offset * convergence_rate
        
        return 0.0
    
    def kalman_update(self, agent_id: str, measurement: float, 
                     measurement_variance: float = 0.1):
        """
        Обновление оценки с помощью фильтра Калмана
        
        Args:
            agent_id: ID агента
            measurement: Измеренное смещение
            measurement_variance: Дисперсия измерения
        """
        if agent_id not in self.kalman_states:
            self.initialize_agent(agent_id)
        
        # Параметры фильтра
        dt = self.sync_period
        
        # Матрица перехода состояния
        F = np.array([[1, dt],
                     [0, 1]])
        
        # Матрица шума процесса
        Q = np.array([[dt**3/3, dt**2/2],
                     [dt**2/2, dt]]) * 1e-6
        
        # Матрица наблюдения
        H = np.array([[1, 0]])
        
        # Предсказание
        state_pred = F @ self.kalman_states[agent_id]
        cov_pred = F @ self.kalman_covariances[agent_id] @ F.T + Q
        
        # Обновление
        y = measurement - H @ state_pred  # Инновация
        S = H @ cov_pred @ H.T + measurement_variance  # Ковариация инновации
        K = cov_pred @ H.T / S  # Коэффициент Калмана
        
        self.kalman_states[agent_id] = state_pred + K * y
        self.kalman_covariances[agent_id] = (np.eye(2) - K @ H) @ cov_pred
        
        # Обновление смещения и дрейфа
        self.clock_offsets[agent_id] = self.kalman_states[agent_id][0]
        self.clock_drifts[agent_id] = self.kalman_states[agent_id][1]
    
    def get_sync_quality(self, agent_id: str) -> float:
        """
        Оценка качества синхронизации агента
        
        Args:
            agent_id: ID агента
            
        Returns:
            Качество синхронизации (0-1)
        """
        if agent_id not in self.measurement_history:
            return 0.0
        
        history = self.measurement_history[agent_id]
        if not history:
            return 0.0
        
        # Анализ стабильности измерений
        recent_offsets = [m['offset'] for m in list(history)[-5:]]
        if len(recent_offsets) < 2:
            return 0.5
        
        # Дисперсия смещений
        variance = np.var(recent_offsets)
        # Качество = 1 / (1 + variance)
        quality = 1.0 / (1.0 + variance)
        
        return min(1.0, quality)


class ClockSync:
    """
    Простая синхронизация часов для малых задержек
    """
    
    def __init__(self, alpha: float = 0.5):
        """
        Args:
            alpha: Коэффициент фильтрации (0-1)
        """
        self.alpha = alpha
        self.offsets: Dict[str, float] = {}
    
    def sync_pair(self, agent1_id: str, agent2_id: str,
                  t1_send: float, t2_receive: float,
                  t2_send: float, t1_receive: float) -> Tuple[float, float]:
        """
        Синхронизация пары агентов (алгоритм PTP)
        
        Args:
            agent1_id: ID первого агента
            agent2_id: ID второго агента
            t1_send: Время отправки от агента 1
            t2_receive: Время получения агентом 2
            t2_send: Время отправки от агента 2
            t1_receive: Время получения агентом 1
            
        Returns:
            (offset1, offset2) - корректировки для обоих агентов
        """
        # Расчет задержки и смещения
        delay = ((t1_receive - t1_send) + (t2_receive - t2_send)) / 2
        offset = ((t2_receive - t1_send) - (t1_receive - t2_send)) / 2
        
        # Фильтрация с предыдущими значениями
        if agent1_id in self.offsets:
            offset = self.alpha * offset + (1 - self.alpha) * self.offsets[agent1_id]
        
        self.offsets[agent1_id] = offset
        self.offsets[agent2_id] = -offset
        
        return offset, -offset


class PhaseSync:
    """
    Синхронизация фазы для координированных действий
    
    Основана на модели связанных осцилляторов Курамото.
    """
    
    def __init__(self, natural_frequency: float = 1.0,
                 coupling_strength: float = 0.5):
        """
        Args:
            natural_frequency: Естественная частота осциллятора (рад/с)
            coupling_strength: Сила связи между осцилляторами
        """
        self.omega = natural_frequency
        self.K = coupling_strength
        self.phases: Dict[str, float] = {}
        self.frequencies: Dict[str, float] = {}
    
    def initialize_oscillator(self, agent_id: str, 
                            initial_phase: float = None):
        """
        Инициализация осциллятора агента
        
        Args:
            agent_id: ID агента
            initial_phase: Начальная фаза (рад)
        """
        if initial_phase is None:
            initial_phase = np.random.uniform(0, 2 * np.pi)
        
        self.phases[agent_id] = initial_phase
        self.frequencies[agent_id] = self.omega
    
    def kuramoto_update(self, agent_id: str,
                       neighbor_phases: Dict[str, float],
                       dt: float) -> float:
        """
        Обновление фазы по модели Курамото
        
        dθ_i/dt = ω_i + (K/N) * Σ sin(θ_j - θ_i)
        
        Args:
            agent_id: ID агента
            neighbor_phases: Фазы соседей
            dt: Временной шаг
            
        Returns:
            Новая фаза
        """
        if agent_id not in self.phases:
            self.initialize_oscillator(agent_id)
        
        current_phase = self.phases[agent_id]
        
        if not neighbor_phases:
            # Свободное вращение
            new_phase = current_phase + self.omega * dt
        else:
            # Взаимодействие с соседями
            coupling_term = 0.0
            for neighbor_phase in neighbor_phases.values():
                coupling_term += np.sin(neighbor_phase - current_phase)
            
            coupling_term *= self.K / len(neighbor_phases)
            
            # Обновление фазы
            phase_derivative = self.frequencies[agent_id] + coupling_term
            new_phase = current_phase + phase_derivative * dt
        
        # Нормализация фазы к [0, 2π]
        new_phase = new_phase % (2 * np.pi)
        self.phases[agent_id] = new_phase
        
        return new_phase
    
    def get_order_parameter(self) -> Tuple[float, float]:
        """
        Расчет параметра порядка Курамото
        
        r * e^(iψ) = (1/N) * Σ e^(iθ_j)
        
        Returns:
            (r, psi) - амплитуда и средняя фаза
        """
        if not self.phases:
            return 0.0, 0.0
        
        # Комплексное представление
        z = np.mean([np.exp(1j * phase) for phase in self.phases.values()])
        
        r = np.abs(z)  # Степень синхронизации (0-1)
        psi = np.angle(z)  # Средняя фаза
        
        return r, psi
    
    def is_synchronized(self, threshold: float = 0.9) -> bool:
        """
        Проверка синхронизации роя
        
        Args:
            threshold: Порог синхронизации (0-1)
            
        Returns:
            True если рой синхронизован
        """
        r, _ = self.get_order_parameter()
        return r >= threshold
    
    def adaptive_coupling(self, current_sync: float, 
                         target_sync: float = 0.95):
        """
        Адаптивная настройка силы связи
        
        Args:
            current_sync: Текущий уровень синхронизации
            target_sync: Целевой уровень синхронизации
        """
        error = target_sync - current_sync
        
        # ПИ-регулятор для силы связи
        self.K += 0.1 * error  # P-составляющая
        self.K = np.clip(self.K, 0.0, 2.0)  # Ограничение
    
    def get_phase_coherence(self) -> float:
        """
        Расчет когерентности фаз
        
        Returns:
            Когерентность (0-1)
        """
        if len(self.phases) < 2:
            return 1.0
        
        phases_array = np.array(list(self.phases.values()))
        
        # Круговая дисперсия
        mean_vector = np.mean(np.exp(1j * phases_array))
        coherence = np.abs(mean_vector)
        
        return coherence
    
    def predict_sync_time(self, current_coherence: float) -> float:
        """
        Прогноз времени до полной синхронизации
        
        Args:
            current_coherence: Текущая когерентность
            
        Returns:
            Оценка времени до синхронизации (с)
        """
        if current_coherence >= 0.99:
            return 0.0
        
        # Эмпирическая оценка на основе силы связи
        if self.K > 0:
            # Время ~ 1/(K * (1 - r))
            sync_time = 10.0 / (self.K * (1.01 - current_coherence))
            return min(sync_time, 1000.0)  # Ограничение сверху
        
        return float('inf')